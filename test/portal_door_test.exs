defmodule PortalDoorTest do
  use ExUnit.Case
  doctest Portal.Door

  test "start_link creates a portal process with a name" do
    assert {:ok, _pid} = Portal.Door.start_link(:pink)
  end

  test "can create and get a new portal by name" do
    Portal.Door.start_link(:pink)

    assert [] == Portal.Door.get(:pink)
  end

  test "can not re-use the same name" do
    Portal.Door.start_link(:blue)

    assert {:error, _reason} = Portal.Door.start_link(:blue)
  end

  test "can push some values to a portal" do
    Portal.Door.start_link(:orange)
    Portal.Door.push(:orange, 1)
    Portal.Door.push(:orange, 2)

    assert [2,1] = Portal.Door.get(:orange)
  end

  test "can pop last value from a portal" do
    Portal.Door.start_link(:blue)
    Portal.Door.push(:blue, 1)
    Portal.Door.push(:blue, 2)

    assert {:ok, 2} = Portal.Door.pop(:blue)
    assert [1] = Portal.Door.get(:blue)
  end

  test "can not pop an empty portal" do
    Portal.Door.start_link(:blue)
    Portal.Door.push(:blue, 1)
    Portal.Door.pop(:blue)

    assert :error = Portal.Door.pop(:blue)
  end

  test "can stop the portal agent" do
    Portal.Door.start_link(:red)
    assert :ok = Portal.Door.stop(:red)

    # This blows up. Not sure how to test when GenServer sends an EXIT.
    # assert catch_error(Portal.Door.get(:red))
  end
end
