defmodule MissionControlWeb.FlightLogComponent do
  use MissionControlWeb, :live_component

  def mount(socket) do
    socket = assign(socket, flight_log: [], temporary_assigns: [flight_log: []])
    {:ok, socket}
  end

  def update(assigns, socket) do
    socket =
      case assigns.flight_status do
        nil ->
          assign(socket, :flight_log, [])
        :completed ->
          assign(socket, :flight_log, [])
        flight_status ->
          assign(socket, :flight_log, [flight_status])
      end
    {:ok, socket}
  end
end

