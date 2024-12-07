defmodule TicTacToe4x4.Player do
  @moduledoc """
  Handles player-related operations for the 4x4 Tic Tac Toe game.
  """

  @players [:X, :O, :S]
  @board_size 4

  @doc """
  Returns the list of players.
  """
  def players, do: @players

  @doc """
  Determines the next player in the game.
  """
  def next_player(current_player) do
    current_index = Enum.find_index(@players, fn p -> p == current_player end)
    next_index = rem(current_index + 1, length(@players))
    Enum.at(@players, next_index)
  end

  @doc """
  Prompts the user to input their move (row and column).
  """
  def get_move do
    IO.puts("Enter your move (row and column) separated by a space (e.g. 1 2):")
    input = IO.gets("> ") |> String.trim()

    case String.split(input) do
      [row_str, col_str] ->
        with {row, ""} <- Integer.parse(row_str),
             {col, ""} <- Integer.parse(col_str),
             true <- row in 1..@board_size,
             true <- col in 1..@board_size do
          {:ok, {row, col}}
        else
          _ -> :error
        end

      _ ->
        :error
    end
  end
end
