defmodule MissionControl.FlightSegment do
  defstruct ~w(distance fuel_used speed)a

  alias MissionControl.MissionPlan

  def calculate(%MissionPlan{distance: distance, speed: speed})
      when distance == 0
      when speed == 0 do
    %__MODULE__{distance: 0, fuel_used: 0, speed: 0}
  end

  def calculate(%MissionPlan{distance: distance, speed: speed, fuel_burn_rate: fuel_burn_rate})
      when is_integer(distance) and distance > 0 and
             is_integer(speed) and speed > 0 and
             is_integer(fuel_burn_rate) and fuel_burn_rate > 0 do
    distance_traveled = calculate_distance(distance, speed)
    fuel_used = calculate_fuel_needed(distance_traveled, speed, fuel_burn_rate)

    %__MODULE__{
      distance: distance_traveled,
      fuel_used: fuel_used,
      speed: speed,
    }
  end

  defp calculate_distance(distance, speed) do
    max_distance_possible = speed

    case max_distance_possible > distance do
      true -> distance
      false -> max_distance_possible
    end
  end

  defp calculate_fuel_needed(distance, speed, fuel_burn_rate) do
    ceil(fuel_burn_rate / speed * distance)
  end
end
