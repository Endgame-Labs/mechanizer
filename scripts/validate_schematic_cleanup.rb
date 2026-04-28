#!/usr/bin/env ruby
# frozen_string_literal: true

require "json"
require "date"
require "pathname"
require "psych"

ROOT = Pathname.new(__dir__).join("..").expand_path
SCHEMATICS = ROOT.join("schematics")

ADAPTERS = %w[
  n8n
  zapier
  tray
  make
  workato
  agentic
  claude-routines
  claw-like
].freeze

OLD_ADAPTERS = %w[
  n8n
  zapier
  tray
  make
  agentic
  claude-routines
  claw-like
].freeze

REQUIRED_FILES = [
  "machine.yaml",
  "README.md",
  "diagram.svg",
  "claw-like/HEARTBEAT.md",
  "workato/recipe.json"
].freeze

MACHINE_YAML_KEYS = %w[
  machine_id
  version
  owners
  objective
  kpis
  triggers
  inputs
  outputs
  slo
].freeze

RUNTIME_LABELS = ADAPTERS.freeze
EVENT_RE = /\b[a-z][a-z0-9_]*\.[a-z][a-z0-9_]*(?:\.[a-z][a-z0-9_]*)*\b/
TERMINAL_NOISE_RE = /(duplicate|ignored|skipped|contract|schema|gtm_event|trace|subject|event_id|event_type)/
NON_EVENT_SUFFIXES = %w[com md svg json yaml yml url].freeze
TERMINAL_SUFFIXES = %w[
  applied
  blocked
  completed
  created
  deferred
  delivered
  executed
  failed
  findings_posted
  generated
  ready
  remediated
  routed
  scored
  writeback_applied
].freeze
SUSPICIOUS_TERMINAL_SUFFIX_GROUPS = [
  %w[completed executed],
  %w[blocked deferred]
].freeze

Failure = Struct.new(:path, :message, keyword_init: true)

def rel(path)
  Pathname.new(path).expand_path.relative_path_from(ROOT).to_s
end

def machine_dirs
  SCHEMATICS.children
            .select { |path| path.directory? && !path.basename.to_s.start_with?("_") }
            .sort_by { |path| path.basename.to_s }
end

def parse_yaml(path, failures)
  Psych.safe_load(path.read, permitted_classes: [Date, Time, Symbol], aliases: true)
rescue Psych::Exception => e
  failures << Failure.new(path: rel(path), message: "YAML parse failed: #{e.message}")
  nil
end

def parse_json(path, failures)
  JSON.parse(path.read)
rescue JSON::ParserError => e
  failures << Failure.new(path: rel(path), message: "JSON parse failed: #{e.message}")
  nil
end

def heading_section(markdown, heading)
  lines = markdown.lines
  start_index = lines.index { |line| line.match?(/^##\s+#{Regexp.escape(heading)}\s*$/) }
  return "" unless start_index

  section = []
  lines[(start_index + 1)..]&.each do |line|
    break if line.match?(/^##\s+/)

    section << line
  end
  section.join
end

def event_strings(text)
  text.scan(EVENT_RE)
      .reject { |event_type| NON_EVENT_SUFFIXES.include?(event_type.split(".").last) }
      .uniq
      .sort
end

def trigger_event_types(machine_yaml)
  Array(machine_yaml&.dig("triggers")).flat_map { |trigger| Array(trigger["event_types"]) }.uniq
end

def terminal_events_for_readme(readme_text, trigger_events)
  event_strings(readme_text)
    .reject { |event_type| trigger_events.include?(event_type) }
    .reject { |event_type| event_type.match?(TERMINAL_NOISE_RE) }
end

def terminal_family(event_type)
  parts = event_type.split(".")
  parts.length >= 3 ? parts[0..-2].join(".") : parts.first
end

def check_required_shape(machine_dir, failures)
  ADAPTERS.each do |adapter|
    adapter_dir = machine_dir.join(adapter)
    next if adapter_dir.directory?

    failures << Failure.new(path: rel(adapter_dir), message: "Required adapter directory is missing")
  end

  REQUIRED_FILES.each do |required_file|
    path = machine_dir.join(required_file)
    next if path.file?

    failures << Failure.new(path: rel(path), message: "Required file is missing")
  end
end

def check_machine_yaml(machine_dir, failures)
  path = machine_dir.join("machine.yaml")
  return nil unless path.file?

  machine_yaml = parse_yaml(path, failures)
  return nil unless machine_yaml.is_a?(Hash)

  MACHINE_YAML_KEYS.each do |key|
    next if machine_yaml.key?(key)

    failures << Failure.new(path: rel(path), message: "machine.yaml missing required key: #{key}")
  end

  terminal_event_types = machine_yaml.dig("outputs", "terminal_event_types")
  unless terminal_event_types.is_a?(Array) && terminal_event_types.any?
    failures << Failure.new(path: rel(path), message: "outputs.terminal_event_types must list canonical terminal events")
  end

  expected_id = machine_dir.basename.to_s
  actual_id = machine_yaml["machine_id"]
  return machine_yaml if actual_id == expected_id

  failures << Failure.new(
    path: rel(path),
    message: "machine_id #{actual_id.inspect} does not match directory #{expected_id.inspect}"
  )
  machine_yaml
end

def check_readme(machine_dir, machine_yaml, root_readme, failures)
  path = machine_dir.join("README.md")
  return unless path.file?

  readme = path.read
  machine_id = machine_dir.basename.to_s

  unless root_readme.include?("schematics/#{machine_id}/diagram.svg")
    failures << Failure.new(
      path: "README.md",
      message: "Root README missing diagram reference for #{machine_id}"
    )
  end

  %w[Adapter\ Notes ChatGPT\ Workspace\ Agents\ Support].each do |heading|
    next if readme.match?(/^##\s+#{Regexp.escape(heading)}\s*$/)

    failures << Failure.new(path: rel(path), message: "Missing ## #{heading} section")
  end

  adapter_notes = heading_section(readme, "Adapter Notes")
  RUNTIME_LABELS.each do |runtime|
    next if adapter_notes.include?(runtime)

    failures << Failure.new(path: rel(path), message: "Adapter Notes does not mention #{runtime}")
  end

  trigger_events = trigger_event_types(machine_yaml)
  terminal_events_for_readme(readme, trigger_events)
end

def check_diagram(machine_dir, failures)
  path = machine_dir.join("diagram.svg")
  return unless path.file?

  diagram = path.read
  has_old_set = OLD_ADAPTERS.all? { |adapter| diagram.include?(adapter) }
  has_workato = diagram.downcase.include?("workato")
  return unless has_old_set && !has_workato

  failures << Failure.new(
    path: rel(path),
    message: "Diagram lists the old adapter set without Workato"
  )
end

def check_json_files(machine_dir, failures)
  Dir.glob(machine_dir.join("**/*.json")).sort.each do |json_file|
    parse_json(Pathname.new(json_file), failures)
  end
end

def check_workato_recipe(machine_dir, failures)
  path = machine_dir.join("workato/recipe.json")
  return unless path.file?

  recipe = parse_json(path, failures)
  return unless recipe.is_a?(Hash)

  terminal_events = recipe["terminal_events"]
  unless terminal_events.is_a?(Hash) && terminal_events["success"]
    failures << Failure.new(path: rel(path), message: "Missing terminal_events metadata")
  end

  emit = Array(recipe["steps"]).find { |step| step["id"] == "emit_terminal_event" }
  body = emit && emit["body"]
  unless body.is_a?(Hash) && body["event_id"] && body["event_type"]
    failures << Failure.new(path: rel(path), message: "emit_terminal_event body must include event_id and event_type")
  end
end

def check_yaml_files(machine_dir, failures)
  Dir.glob(machine_dir.join("**/*.{yaml,yml}")).sort.each do |yaml_file|
    parse_yaml(Pathname.new(yaml_file), failures)
  end
end

def check_terminal_event_mismatches(machine_dir, machine_yaml, canonical_events, failures)
  trigger_events = trigger_event_types(machine_yaml)
  events_by_family = Hash.new { |hash, key| hash[key] = Hash.new { |suffix_hash, suffix| suffix_hash[suffix] = [] } }

  canonical_events.each do |event_type|
    suffix = event_type.split(".").last
    next unless TERMINAL_SUFFIXES.include?(suffix)

    events_by_family[terminal_family(event_type)][suffix] << rel(machine_dir.join("README.md"))
  end

  ADAPTERS.each do |adapter|
    adapter_dir = machine_dir.join(adapter)
    next unless adapter_dir.directory?

    Dir.glob(adapter_dir.join("**/*.{md,json}")).sort.each do |file|
      path = Pathname.new(file)
      events = event_strings(path.read)
               .reject { |event_type| trigger_events.include?(event_type) }
               .reject { |event_type| event_type.match?(TERMINAL_NOISE_RE) }

      events.each do |event_type|
        suffix = event_type.split(".").last
        next unless TERMINAL_SUFFIXES.include?(suffix)

        events_by_family[terminal_family(event_type)][suffix] << rel(path)
      end
    end
  end

  events_by_family.each do |family, suffix_paths|
    SUSPICIOUS_TERMINAL_SUFFIX_GROUPS.each do |suffix_group|
      present = suffix_group.select { |suffix| suffix_paths.key?(suffix) }
      next unless present.length > 1

      locations = present.flat_map { |suffix| suffix_paths[suffix] }.uniq.sort.join(", ")
      failures << Failure.new(
        path: rel(machine_dir),
        message: "Possible terminal event mismatch for #{family}: found #{present.join(" and ")} variants in #{locations}"
      )
    end
  end
end

def main
  failures = []
  root_readme_path = ROOT.join("README.md")
  root_readme = root_readme_path.file? ? root_readme_path.read : ""
  failures << Failure.new(path: "README.md", message: "Root README.md is missing") unless root_readme_path.file?

  machines = machine_dirs
  failures << Failure.new(path: "schematics", message: "No machine directories found") if machines.empty?

  machines.each do |machine_dir|
    check_required_shape(machine_dir, failures)
    machine_yaml = check_machine_yaml(machine_dir, failures)
    check_yaml_files(machine_dir, failures)
    check_json_files(machine_dir, failures)
    check_workato_recipe(machine_dir, failures)
    check_diagram(machine_dir, failures)
    canonical_events = check_readme(machine_dir, machine_yaml, root_readme, failures) || []
    check_terminal_event_mismatches(machine_dir, machine_yaml, canonical_events, failures)
  end

  if failures.empty?
    puts "schematic cleanup validation passed (#{machines.length} machines)"
    exit 0
  end

  puts "schematic cleanup validation failed (#{failures.length} issues)"
  failures.each do |failure|
    puts "- #{failure.path}: #{failure.message}"
  end
  exit 1
end

main
