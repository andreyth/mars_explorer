Code.require_file("models/coordinate.exs")
Code.require_file("models/planalto.exs")
Code.require_file("models/sonda.exs")
Code.require_file("lib/helpers.exs")
Code.require_file("lib/input.exs")
Code.require_file("lib/service.exs")

defmodule Boot do
  def exec do
    help()

    sondas_count = Input.get_sondas_count("0 - Quantas sondas ?\n")
    |> String.to_integer

    if sondas_count <= 0 do
      shutdown("quantidade insuficiente")
    else
      planalto = get_planalto_coordinate()
      result = main(sondas_count, planalto)
      IO.puts result
    end
  end

  def main(sondas_count, planalto) when is_struct(planalto, Models.Planalto) do
    count = sondas_count-1
    Enum.map(0..count, fn i ->
      sonda = get_sonda_coordinate(planalto, i+1)
      moviment = get_sonda_moviment(i+1)

      result = Service.run(planalto, sonda, moviment)
      current_position = result.current_position
      "\n#{current_position.coordinate.x} #{current_position.coordinate.y} #{current_position.direction}"
    end)
  end

  defp get_planalto_coordinate() do
    Input.set_planalto_coordinate("1 -> Quais as coordenadas máximas X e Y do planalto ? \n")
    |> case do
      {:ok, planalto} -> planalto
      {:error, reason} -> shutdown(reason)
    end
  end

  defp get_sonda_coordinate(planalto, sonda_number) when is_struct(planalto, Models.Planalto) and is_integer(sonda_number) do
    Input.set_sonda_coordinate("2 -> Quais as coordenadas x, y e direção da sonda #{sonda_number} ? \n", planalto)
    |> case do
      {:ok, sonda} -> sonda
      {:error, reason} -> shutdown(reason)
    end
  end

  defp get_sonda_moviment(sonda_number) when is_integer(sonda_number) do
    Input.set_sonda_moviment("3 -> Quais os movimentos da sonda #{sonda_number} ? \n")
    |> case do
      {:ok, moviment} -> moviment
      {:error, reason} -> shutdown(reason)
    end
  end

  defp help do
    IO.puts """
      Exemplo:
      0 -> 2
      1 -> 5 6
      2 -> 1 3 N { N, W, S, E }
      3 -> LMRMRMM
    """
  end

  defp shutdown(reason) do
    IO.puts(reason)
    exit(:shutdown)
  end
end

Boot.exec()