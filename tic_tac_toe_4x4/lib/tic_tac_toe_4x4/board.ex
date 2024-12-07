defmodule TicTacToe4x4.Board do
  @moduledoc """
  Handles board-related operations for the 4x4 Tic Tac Toe game.
  """

  @board_size 4

  @doc """
  Creates an initial empty board.
  """
  def initial_board do
    for _ <- 1..@board_size, do: for(_ <- 1..@board_size, do: :empty)
  end

  @doc """
  Gets the cell value at the specified row and column.
  """
  def get_cell(board, row, col) do
    Enum.at(Enum.at(board, row - 1), col - 1)
  end

  @doc """
  Updates the board with a new move.
  """
  def update_board(board, row, col, player) do
    List.update_at(board, row - 1, fn r ->
      List.update_at(r, col - 1, fn _ -> player end)
    end)
  end

  @doc """
  Checks if the board is full (no empty spaces).
  """
  def board_full?(board) do
    Enum.all?(board, fn row -> Enum.all?(row, fn cell -> cell != :empty end) end)
  end

  @doc """
  Checks if a player has won the game.
  """
  def check_winner(board, player) do
    check_rows(board, player) ||
      check_columns(board, player) ||
      check_diagonals(board, player)
  end

  # Checks if the rows contain a winner
  defp check_rows(board, player), do: Enum.any?(board, &check_line(&1, player))

  # Checks if the columns contain a winner
  defp check_columns(board, player), do: Enum.any?(transpose(board), &check_line(&1, player))

  # Checks if any diagonal contains a winner
  defp check_diagonals(board, player) do
    diagonal1 = for i <- 0..3, do: Enum.at(Enum.at(board, i), i)
    diagonal2 = for i <- 0..3, do: Enum.at(Enum.at(board, i), 3 - i)
    check_line(diagonal1, player) || check_line(diagonal2, player)
  end

  # Checks if a given line (row, column, or diagonal) has the same player in all positions
  defp check_line(line, player) do
    Enum.chunk_every(line, 4, 1, :discard)
    |> Enum.any?(fn chunk -> Enum.all?(chunk, &(&1 == player)) end)
  end

  # Transposes the board (columns become rows)
  defp transpose(board), do: Enum.zip(board) |> Enum.map(&Tuple.to_list/1)
end
