defmodule Service do
  def run(planalto, sonda, moviments)
    when is_struct(planalto, Models.Planalto) and is_struct(sonda, Models.Sonda) and is_list(moviments) do
    result = Enum.reduce(moviments, sonda, fn moviment, data ->
      move(data, moviment)
    end)

    result
  end
  
  defp move(%Models.Sonda{ current_position: %{direction: "N", coordinate: coordinate}} = sonda, "M"), do:
    Models.Sonda.set_current_position(sonda, coordinate.x, coordinate.y + 1)

  defp move(%Models.Sonda{ current_position: %{direction: "W", coordinate: coordinate}} = sonda, "M"), do:
    Models.Sonda.set_current_position(sonda, coordinate.x - 1, coordinate.y)

  defp move(%Models.Sonda{ current_position: %{direction: "S", coordinate: coordinate}} = sonda, "M"), do:
    Models.Sonda.set_current_position(sonda, coordinate.x, coordinate.y - 1)

  defp move(%Models.Sonda{ current_position: %{direction: "E", coordinate: coordinate}} = sonda, "M"), do:
    Models.Sonda.set_current_position(sonda, coordinate.x + 1, coordinate.y)

  defp move(%Models.Sonda{ current_position: %{direction: "N" }} = sonda, "L"), do:
    Models.Sonda.set_direction(sonda, "W")

  defp move(%Models.Sonda{ current_position: %{direction: "W" }} = sonda, "L"), do:
    Models.Sonda.set_direction(sonda, "S")

  defp move(%Models.Sonda{ current_position: %{direction: "S" }} = sonda, "L"), do:
    Models.Sonda.set_direction(sonda, "E")
  
  defp move(%Models.Sonda{ current_position: %{direction: "E" }} = sonda, "L"), do:
    Models.Sonda.set_direction(sonda, "N")

  defp move(%Models.Sonda{ current_position: %{direction: "N" }} = sonda, "R"), do:
    Models.Sonda.set_direction(sonda, "E")

  defp move(%Models.Sonda{ current_position: %{direction: "W" }} = sonda, "R"), do:
    Models.Sonda.set_direction(sonda, "N")

  defp move(%Models.Sonda{ current_position: %{direction: "S" }} = sonda, "R"), do:
    Models.Sonda.set_direction(sonda, "W")
  
  defp move(%Models.Sonda{ current_position: %{direction: "E" }} = sonda, "R"), do:
    Models.Sonda.set_direction(sonda, "S")
end