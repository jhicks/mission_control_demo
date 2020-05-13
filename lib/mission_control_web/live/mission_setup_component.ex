defmodule MissionControlWeb.MissionSetupComponent do
  use MissionControlWeb, :live_component

  alias MissionControlWeb.MissionSetupForm

  def mount(socket) do
    changeset = MissionSetupForm.changeset()
    {:ok, assign(socket, changeset: changeset)}
  end

  def handle_event("validate", %{"mission_setup_form" => params}, socket) do
    changeset =
      params
      |> MissionSetupForm.changeset()
      |> Map.put(:action, :insert)
    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("begin", %{"mission_setup_form" => params}, socket) do
    changeset =
      params
      |> MissionSetupForm.changeset()
      |> Map.put(:action, :insert)

    socket =
      case changeset.valid? do
        true ->
          plan =
            changeset
            |> Ecto.Changeset.apply_changes()
            |> MissionSetupForm.to_plan()

          send(self(), {:mission_setup_completed, plan})
          socket
        false ->
          assign(socket, :changeset, changeset)
      end

    {:noreply, socket}
  end
end
