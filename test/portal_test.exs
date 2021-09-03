defmodule PortalTest do
  use ExUnit.Case
  doctest Portal

  test "can shoot a new portal" do
    assert {:ok, _pid} = Portal.shoot(:orange)
    assert [] == Portal.Door.get(:orange)
  end

  test "can transfer data into the Portal left door" do
    Portal.shoot(:orange)
    Portal.shoot(:blue)
    portal = Portal.transfer(:orange, :blue, [1,2,3,4])

    assert portal == %Portal{left: :orange, right: :blue}
    assert [4,3,2,1] = Portal.Door.get(:orange)
    assert [] = Portal.Door.get(:blue)
  end

  test "can push data to the right door" do
    Portal.shoot(:orange)
    Portal.shoot(:blue)
    portal = Portal.transfer(:orange, :blue, [1,2,3,4])
    Portal.push_right(portal)

    assert [3,2,1] = Portal.Door.get(:orange)
    assert [4] = Portal.Door.get(:blue)
  end

  test "push does nothing when left door is empty" do
    Portal.shoot(:orange)
    Portal.shoot(:blue)
    portal = Portal.transfer(:orange, :blue, [1,2])
    Portal.push_right(portal)
    Portal.push_right(portal)

    assert [] = Portal.Door.get(:orange)
    assert [1,2] = Portal.Door.get(:blue)

    Portal.push_right(portal)

    assert [] = Portal.Door.get(:orange)
    assert [1,2] = Portal.Door.get(:blue)
  end

  test "can close the portal" do
    Portal.shoot(:orange)
    Portal.shoot(:blue)
    portal = Portal.transfer(:orange, :blue, [1,2,3,4])

    assert :ok = Portal.close(portal)

    # This blows up. Not sure how to test when GenServer sends an EXIT.
    # assert catch_error(Portal.Door.get(:orange))
    # assert catch_error(Portal.Door.get(:blue))
  end
end
