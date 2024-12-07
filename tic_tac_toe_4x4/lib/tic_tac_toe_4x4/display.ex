defmodule TicTacToe4x4.Display do
  @moduledoc """
  Handles display and messaging for the 4x4 Tic Tac Toe game.
  """

  @doc """
  Displays the welcome message and game instructions.
  """
  def welcome_message do
    IO.puts("\n================================================================================")
    IO.puts("Welcome to 4x4 Tic Tac Toe!")
    IO.puts("Players: X, O, and S. Each player takes turns to place or erase their symbol.")
    IO.puts("To make a move, type the row and column (1-4), separated by a space (e.g., '1 2').")
    IO.puts("Good luck and have fun!")
    IO.puts("================================================================================")
  end

  @doc """
  Displays the current game board.
  """
  def board(board) do
    IO.puts("\nBoard:")

    for row <- board do
      row
      |> Enum.map(fn
        :empty -> "."
        :X -> "X"
        :O -> "O"
        :S -> "S"
      end)
      |> Enum.join(" ")
      |> IO.puts()
    end
  end

  @doc """
  Displays the current player's turn prompt with turn number.
  """
  def current_player_prompt(player, turn_number) do
    IO.puts("\n[Turn #{turn_number}] Player #{player} (#{player})'s turn. Your move!")
  end

  @doc """
  Displays the winner message.
  """
  def winner_message(winner) do
    IO.puts("\nCongratulations, Player #{winner} wins the game!")
  end

  @doc """
  Displays the draw message.
  """
  def draw_message do
    IO.puts("\nIt's a draw! No winners this time.")
    IO.puts("Better luck next time!")
  end

  @doc """
  Prompts the user to play again.
  """
  def play_again_prompt do
    IO.puts("\nWould you like to play again? (y/n)")
    play_again = IO.gets("> ") |> String.trim()

    if String.downcase(play_again) == "y" do
      TicTacToe4x4.Game.new()
    else
      IO.puts("Goodbye!")
    end
  end

  @doc """
  Displays error messages
  """
  def anti_revenge_violation_message do
    IO.puts(
      "Anti-Revenge Rule violation! You cannot erase the symbol just erased by the previous player."
    )
  end

  def consecutive_erasure_message do
    IO.puts("You can't erase another symbol in consecutive turns.")
  end

  def invalid_move_message do
    IO.puts("Oops! That square is already taken. Try a different one.")
  end

  def invalid_input_message do
    IO.puts("Invalid input. Please enter a valid move in the format 'row column' (e.g., '1 2').")
  end
end
