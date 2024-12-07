defmodule TicTacToe4x4.PlayerTest do
  use ExUnit.Case
  doctest TicTacToe4x4.Player

  alias TicTacToe4x4.Player

  describe "players/0" do
    test "returns the correct list of players" do
      assert Player.players() == [:X, :O, :S]
    end
  end

  describe "next_player/1" do
    test "cycles through players in order" do
      assert Player.next_player(:X) == :O
      assert Player.next_player(:O) == :S
      assert Player.next_player(:S) == :X
    end
  end
end
