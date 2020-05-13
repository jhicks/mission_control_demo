defmodule MissionControlWeb.MissionSetupForm do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :name, :string
    field :distance, :integer
    field :speed, :integer
    field :fuel_burn_rate, :integer
  end

  def changeset(params \\ %{}) do
    %__MODULE__{}
    |> cast(params, [:name, :distance, :speed, :fuel_burn_rate])
    |> validate_required([:name, :distance, :speed, :fuel_burn_rate])
    |> validate_length(:name, min: 2, max: 20)
    |> validate_number(:distance, greater_than: 0, less_than: 1_000_000)
    |> validate_number(:speed, greater_than: 0, less_than: 1_000)
    |> validate_number(:fuel_burn_rate, greater_than: 0, less_than: 11)
  end

  def to_plan(%__MODULE__{} = form) do
    data = Map.from_struct(form)
    struct(MissionControl.MissionPlan, data)
  end
end
