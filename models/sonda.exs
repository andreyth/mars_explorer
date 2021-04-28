defmodule Models.Sonda do
  defstruct current_position: %{direction: nil, coordinate: %Models.Coordinate{x: 0, y: 0}}
  
  def set_current_position(self, x, y) when is_struct(self, Models.Sonda) and is_integer(x) and is_integer(y)  do
    %{self | current_position: %{direction:  self.current_position.direction, coordinate: %Models.Coordinate{x: x, y: y}}}
  end

  def set_direction(self, direction) when is_struct(self, Models.Sonda) and is_binary(direction) do
    current_coordinate = self.current_position.coordinate
    %{self | current_position: %{direction: direction, coordinate: current_coordinate}}
  end
end