defmodule Input do
  def get_sondas_count(msg) do
    get(msg)
  end

  def set_planalto_coordinate(coordinate) when is_binary(coordinate) do
    coordinate
    |> get
    |> String.split(" ")
    |> Helpers.format_planalto_coordinates()
    |> case do
      {:ok, planalto} -> {:ok, planalto}
      {:error, reason} -> {:error, reason}
      _ -> {:error, "coordenadas inválidas"}
    end
  end

  def set_sonda_coordinate(coordinate, planalto) when is_struct(planalto, Models.Planalto) and is_binary(coordinate) do
    coordinate
    |> get
    |> String.split(" ")
    |> Helpers.format_sonda_coordinates(planalto)
    |> case do
      {:ok, moviment} -> {:ok, moviment}
      {:error, reason} -> {:error, reason}
      _ -> {:error, "coordenadas inválidas"}
    end
  end

  def set_sonda_moviment(moviment) when is_binary(moviment) do
    moviment
    |> get
    |> Helpers.format_sonda_moviments()
    |> case do
      {:ok, sonda} -> {:ok, sonda}
      {:error, reason} -> {:error, reason}
      _ -> {:error, "movimentos inválidos"}
    end
  end

  
  defp get(message) when is_binary(message) do
    message
    |> IO.gets()
    |> String.replace("\n", "")
  end
end