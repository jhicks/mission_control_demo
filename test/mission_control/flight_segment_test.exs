defmodule MissionControl.FlightSegmentTest do
  use ExUnit.Case, async: true

  alias MissionControl.{MissionPlan, FlightSegment}

  test "goes nowhere when distance to travel is 0" do
    plan = %MissionPlan{distance: 0, speed: 1_000, fuel_burn_rate: 15}

    segment = FlightSegment.calculate(plan)

    assert segment.distance == 0
    assert segment.fuel_used == 0
  end

  test "goes nowhere when flight speed is 0" do
    plan = %MissionPlan{distance: 1_000, speed: 0, fuel_burn_rate: 15}

    segment = FlightSegment.calculate(plan)

    assert segment.distance == 0
    assert segment.fuel_used == 0
  end

  test "calculates a segment of the mission" do
    plan = %MissionPlan{distance: 1_000, speed: 300, fuel_burn_rate: 15}

    segment = FlightSegment.calculate(plan)

    assert segment.distance == 300
    assert segment.fuel_used == 15
  end

  test "supports finishing when distance to travel is less than the distance possible" do
    plan = %MissionPlan{distance: 100, speed: 300, fuel_burn_rate: 15}

    segment = FlightSegment.calculate(plan)

    assert segment.distance == 100
    assert segment.fuel_used == 5
  end
end
