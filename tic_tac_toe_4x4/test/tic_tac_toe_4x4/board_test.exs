defmodule TicTacToe4x4.BoardTest do
  use ExUnit.Case
  doctest TicTacToe4x4.Board

  alias TicTacToe4x4.Board

  describe "initial_board/0" do
    test "creates a 4x4 board filled with empty cells" do
      board = Board.initial_board()

      assert length(board) == 4
      assert Enum.all?(board, fn row -> length(row) == 4 end)
      assert Enum.all?(board, fn row -> Enum.all?(row, fn cell -> cell == :empty end) end)
    end
  end

  describe "get_cell/3" do
    test "retrieves the correct cell value" do
      board = [
        [:empty, :X, :O, :empty],
        [:S, :empty, :X, :O],
        [:empty, :X, :O, :S],
        [:X, :O, :S, :empty]
      ]

      assert Board.get_cell(board, 1, 2) == :X
      assert Board.get_cell(board, 2, 1) == :S
      assert Board.get_cell(board, 4, 3) == :S
    end
  end

  describe "update_board/4" do
    test "updates the board with the correct player symbol" do
      board = Board.initial_board()
      updated_board = Board.update_board(board, 2, 3, :X)

      assert Board.get_cell(updated_board, 2, 3) == :X
      assert Board.get_cell(updated_board, 2, 2) == :empty
    end
  end

  describe "board_full?/1" do
    test "returns true when board is completely filled" do
      full_board = [
        [:X, :O, :S, :X],
        [:O, :S, :X, :O],
        [:S, :X, :O, :S],
        [:X, :O, :S, :X]
      ]

      assert Board.board_full?(full_board) == true
    end

    test "returns false when board has empty cells" do
      partial_board = [
        [:X, :O, :S, :X],
        [:O, :empty, :X, :O],
        [:S, :X, :O, :S],
        [:X, :O, :S, :X]
      ]

      assert Board.board_full?(partial_board) == false
    end
  end

  describe "check_winner/2" do
    test "detects winner in a row" do
      row_winner_board = [
        [:X, :X, :X, :X],
        [:empty, :empty, :empty, :empty],
        [:empty, :empty, :empty, :empty],
        [:empty, :empty, :empty, :empty]
      ]

      assert Board.check_winner(row_winner_board, :X) == true
      assert Board.check_winner(row_winner_board, :O) == false
    end

    test "detects winner in a column" do
      column_winner_board = [
        [:X, :empty, :empty, :empty],
        [:X, :empty, :empty, :empty],
        [:X, :empty, :empty, :empty],
        [:X, :empty, :empty, :empty]
      ]

      assert Board.check_winner(column_winner_board, :X) == true
      assert Board.check_winner(column_winner_board, :O) == false
    end

    test "detects winner in diagonals" do
      diagonal1_winner_board = [
        [:X, :empty, :empty, :empty],
        [:empty, :X, :empty, :empty],
        [:empty, :empty, :X, :empty],
        [:empty, :empty, :empty, :X]
      ]

      diagonal2_winner_board = [
        [:empty, :empty, :empty, :X],
        [:empty, :empty, :X, :empty],
        [:empty, :X, :empty, :empty],
        [:X, :empty, :empty, :empty]
      ]

      assert Board.check_winner(diagonal1_winner_board, :X) == true
      assert Board.check_winner(diagonal2_winner_board, :X) == true
    end

    test "returns false when no winner" do
      no_winner_board = [
        [:X, :O, :S, :X],
        [:O, :S, :X, :O],
        [:S, :X, :O, :S],
        [:O, :S, :X, :O]
      ]

      assert Board.check_winner(no_winner_board, :X) == false
      assert Board.check_winner(no_winner_board, :O) == false
      assert Board.check_winner(no_winner_board, :S) == false
    end
  end
end
