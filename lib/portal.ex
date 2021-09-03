defmodule Portal do
  defstruct [:left, :right]

  def shoot(color) do
    Portal.Door.start_link(color)
  end

  def transfer(left_door, right_door, data) do
    for item <- data do
      Portal.Door.push(left_door, item)
    end

    %Portal{left: left_door, right: right_door}
  end

  def push_right(portal) do
    case Portal.Door.pop(portal.left) do
      :error   -> :ok
      {:ok, h} -> Portal.Door.push(portal.right, h)
    end

    portal
  end

  def close(portal) do
    Portal.Door.stop(portal.left)
    Portal.Door.stop(portal.right)
    :ok
  end

end
