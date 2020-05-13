defmodule MissionControl.LaunchSequence do
  @stages ~w(
    initialized engines_engaged support_structures_released cross_checks_performed completed
  )a

  @transitions [
    initialized: :engines_engaged,
    engines_engaged: :support_structures_released,
    support_structures_released: :cross_checks_performed,
    cross_checks_performed: :completed
  ]

  def initialize(), do: :initialized

  def step(:completed), do: :completed

  def step(stage) when stage in @stages do
    Keyword.fetch!(@transitions, stage)
  end
end
