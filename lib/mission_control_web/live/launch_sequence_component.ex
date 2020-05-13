defmodule MissionControlWeb.LaunchSequenceComponent do
  use MissionControlWeb, :live_component

  alias MissionControl.LaunchSequence

  def mount(socket) do
    {:ok, assign(socket, :stage, LaunchSequence.initialize())}
  end

  def handle_event("step", _params, socket) do
    stage =
      socket.assigns.stage
      |> LaunchSequence.step()

    socket =
      stage
      |> case do
        :completed ->
          send(self(), :launch_sequence_completed)
          socket
        _ ->
          assign(socket, :stage, stage)
      end

    {:noreply, socket}
  end
end
