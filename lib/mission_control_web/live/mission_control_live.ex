defmodule MissionControlWeb.MissionControlLive do
  use MissionControlWeb, :live_view


  alias MissionControlWeb.FlightLogComponent

  def mount(_params, _session, socket) do
    {:ok, apply_action(socket, :flight_log)}
  end

  defp apply_action(socket, :flight_log) do
    plan = %MissionControl.MissionPlan{name: "Test", distance: 27, speed: 4, fuel_burn_rate: 3}
    {:ok, _pid} = MissionControl.FlightControlSupervisor.start_child(plan, self())
    socket
    |> assign(:component, FlightLogComponent)
    |> assign(:component_options, flight_log_options())
  end

  def handle_info({:flight_updated, segment, distance_remaining}, socket) do
    flight_status = {DateTime.utc_now, segment, distance_remaining}
    socket = assign(socket, :component_options, flight_log_options(flight_status))
    {:noreply, socket}
  end

  def handle_info(:flight_completed, socket) do
    socket = assign(socket, :component_options, flight_log_options())
    {:noreply, socket}
  end

  defp flight_log_options(flight_status \\ nil) do
    [id: FlightLogComponent, flight_status: flight_status]
  end
end
