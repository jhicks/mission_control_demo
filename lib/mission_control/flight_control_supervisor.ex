defmodule MissionControl.FlightControlSupervisor do
  use DynamicSupervisor

  alias MissionControl.{FlightControl, MissionPlan}

  def start_link(init_args \\ nil) do
    DynamicSupervisor.start_link(__MODULE__, init_args, name: __MODULE__)
  end

  def start_child(%MissionPlan{} = mission_plan) do
    spec = {
      FlightControl,
      plan: mission_plan,
    }
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  @impl true
  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end

