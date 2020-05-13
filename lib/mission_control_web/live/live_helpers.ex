defmodule MissionControlWeb.LiveHelpers do
  @prompts [
    initialized: "Engage engines",
    engines_engaged: "Release support structures",
    support_structures_released: "Perform cross checks",
    cross_checks_performed: "Launch"
  ]

  def launch_sequence_prompt(stage) do
    Keyword.fetch!(@prompts, stage)
  end
end
