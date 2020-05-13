defmodule MissionControlWeb.MissionControlLive do
  use MissionControlWeb, :live_view

  alias MissionControlWeb.FlightLogComponent

  @impl true
  def mount(_params, _session, socket) do
    {:ok, apply_action(socket, :mission_setup)}
  end

  defp apply_action(socket, :mission_setup) do
    socket
    |> assign(:component, MissionControlWeb.MissionSetupComponent)
    |> assign(:component_options, [id: MissionControlWeb.MissionSetupComponent])
  end

  defp apply_action(socket, :launch_sequence) do
    socket
    |> assign(:component, MissionControlWeb.LaunchSequenceComponent)
    |> assign(:component_options, [id: MissionControlWeb.LaunchSequenceComponent])
  end

  defp apply_action(socket, :flight_log) do
    {:ok, _pid} = MissionControl.FlightControlSupervisor.start_child(socket.assigns.plan, self())
    socket
    |> assign(:component, FlightLogComponent)
    |> assign(:component_options, flight_log_options())
  end

  @impl true
  def handle_info({:mission_setup_completed, plan}, socket) do
    socket =
      socket
      |> assign(:plan, plan)
      |> apply_action(:launch_sequence)

    {:noreply, socket}
  end

  @impl true
  def handle_info(:launch_sequence_completed, socket) do
    {:noreply, apply_action(socket, :flight_log)}
  end

  @impl true
  def handle_info({:flight_updated, segment, distance_remaining}, socket) do
    flight_status = {DateTime.utc_now, segment, distance_remaining}
    socket = assign(socket, :component_options, flight_log_options(flight_status))
    {:noreply, socket}
  end

  @impl true
  def handle_info(:flight_completed, socket) do
    socket = assign(socket, :component_options, flight_log_options())
    {:noreply, socket}
  end

  defp flight_log_options(flight_status \\ nil) do
    [id: FlightLogComponent, flight_status: flight_status]
  end
end
