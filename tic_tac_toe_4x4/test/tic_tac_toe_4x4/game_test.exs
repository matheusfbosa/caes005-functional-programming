defmodule TicTacToe4x4.GameTest do
  use ExUnit.Case
  doctest TicTacToe4x4.Game

  alias TicTacToe4x4.{Game, Board, Player}

  describe "initial game state" do
    test "creates a new game with default values" do
      game = %Game{
        erasures: Map.new(Player.players(), fn player -> {player, false} end)
      }

      assert game.board == Board.initial_board()
      assert game.current_player == :X
      assert game.winner == nil
      assert game.turn_number == 1
      assert game.erasures == %{X: false, O: false, S: false}
    end
  end
end
