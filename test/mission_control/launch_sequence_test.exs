defmodule MissionControl.LaunchSequenceTest do
  use ExUnit.Case, async: true

  alias MissionControl.LaunchSequence, as: SUT

  test "starts at initialized" do
    stage = SUT.initialize()
    assert stage == :initialized
  end

  test "transitions from initialized to engines engaged" do
    stage = SUT.initialize() |> SUT.step()
    assert stage == :engines_engaged
  end

  test "transitions from engines engaged to support structures released" do
    stage = SUT.step(:engines_engaged)
    assert stage == :support_structures_released
  end

  test "transitions from support structures released to cross checks performed" do
    stage = SUT.step(:support_structures_released)
    assert stage == :cross_checks_performed
  end

  test "transitions from cross checks performed to completed" do
    stage = SUT.step(:cross_checks_performed)
    assert stage == :completed
  end

  test "transitions from completed to completed" do
    stage = SUT.step(:completed)
    assert stage == :completed
  end

  test "raises FunctionClauseError on invalid stage" do
    assert_raise FunctionClauseError, fn ->
      SUT.step(:invalid)
    end
  end
end
