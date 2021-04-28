defmodule Helpers do
  def format_planalto_coordinates(coordinates) when is_list(coordinates) do
    cond do
      length(coordinates) == 2 ->
        [x, y] = coordinates
        x = String.to_integer(x)
        y = String.to_integer(y)
        coordinate = %Models.Coordinate{x: x, y: y}
        {:ok, %Models.Planalto{top_limit: coordinate}}

      true -> {:error, "coordenada do planalto precisa de 2 parâmetros"}
    end
  end

  def format_sonda_coordinates(coordinates, planalto) when is_struct(planalto, Models.Planalto) and is_list(coordinates) do
    cond do
      length(coordinates) == 3 ->
        [x, y, direction] = coordinates
        x = String.to_integer(x)
        y = String.to_integer(y)
        
        {result_valid_coordinates, msg_valid_coordinates} = validate_sonda_coordinates(planalto, x, y)
        {result_valid_direction, msg_valid_direction} = validate_direction(direction)

        cond do
          result_valid_coordinates == :error -> {:error, msg_valid_coordinates}
          result_valid_direction == :error -> {:error, msg_valid_direction}
          true -> 
            {:ok, %Models.Sonda{
              current_position: %{
                direction: direction,
                coordinate: %Models.Coordinate{x: x, y: y}
              }
            }}
        end

      true -> {:error, "coordenada da sonda precisa de 3 parâmetros"}
    end
  end

  def format_sonda_moviments(moviments) when is_binary(moviments) do
    case verify_sonda_moviments(moviments) do
      {:ok, value} -> {:ok, value}
      {:error, reason} -> {:error, reason}
    end
  end

  defp verify_sonda_moviments(moviments) when is_binary(moviments) do
    moviments_list = String.split(moviments, "", trim: true)
    result = Enum.any?(moviments_list, fn moviment ->
      {result, _} = validate_moviment(moviment)
      result == :error
    end)

    if result do
      {:error, "movimento inválido"}
    else
      {:ok, moviments_list}
    end
  end

  defp validate_sonda_coordinates(planalto, x, y) when is_struct(planalto, Models.Planalto) and is_integer(x) and is_integer(x) do
    cond do
      x > planalto.top_limit.x || x < planalto.bottom_limit.x -> {:error, "coordenada X está fora do planalto"}
      y > planalto.top_limit.y || y < planalto.bottom_limit.y -> {:error, "coordenada Y está fora do planalto"}
      true -> {:ok, :success}
    end
  end

  defp validate_direction(direction) when direction in ["N", "W", "S", "E"], do: {:ok, direction}
  defp validate_direction(direction), do: {:error, "direção inválida #{direction}"}

  defp validate_moviment(moviment) when moviment in ["M", "L", "R"], do: {:ok, moviment}
  defp validate_moviment(_), do: {:error, "movimento inválido"}
end