defmodule MissionControl.FlightControl do
  use GenServer, restart: :transient

  alias MissionControl.{MissionPlan, FlightSegment}

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  #### Callbacks ####

  @impl true
  def init(args) do
    %MissionPlan{} = plan = Keyword.fetch!(args, :plan)

    state = %{
      plan: plan,
      distance_remaining: plan.distance
    }

    enqueue_tick()

    {:ok, state}
  end

  def handle_info(:tick, %{distance_remaining: distance_remaining} = state)
      when distance_remaining == 0 do
    {:stop, :normal, state}
  end

  @impl true
  def handle_info(:tick, %{plan: plan, distance_remaining: distance_remaining} = state) do
    enqueue_tick()

    new_plan = %{plan | distance: distance_remaining}
    segment = FlightSegment.calculate(new_plan)
    state = %{state | distance_remaining: distance_remaining - segment.distance}

    {:noreply, state}
  end

  defp enqueue_tick() do
    Process.send_after(self(), :tick, 1_000)
  end
end
