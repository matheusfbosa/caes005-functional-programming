defmodule TicTacToe4x4.Game do
  @moduledoc """
  Core game logic for a 4x4 Tic Tac Toe game with three players: X, O, and S.
  """

  # Constants
  @initial_board for _ <- 1..4, do: for(_ <- 1..4, do: :empty)
  @players [:X, :O, :S]

  # Structure of the game state
  defstruct board: @initial_board,
            current_player: :X,
            winner: nil,
            # {player, {row, col}, :erase | :place}
            last_move: nil,
            # Tracks consecutive erasures per player (e.g., %{X => true, O => false, S => false})
            erasures: %{}

  @doc """
  Starts a new game with a friendly greeting and instructions.
  """
  def new do
    IO.puts("\nWelcome to 4x4 Tic Tac Toe!")
    IO.puts("Players: X, O, and S. Each player takes turns to place or erase their symbol.")
    IO.puts("To make a move, type the row and column (1-4), separated by a space (e.g., '1 2').")
    IO.puts("The Anti-Revenge Rule prevents you from erasing the symbol just placed by the previous player.")
    IO.puts("Good luck and have fun!\n")

    play(%TicTacToe4x4.Game{
      erasures: Map.new(@players, fn player -> {player, false} end)
    })
  end

  # Main game loop
  defp play(%{winner: winner} = game) when not is_nil(winner) do
    IO.puts("\nCongratulations, Player #{winner} wins the game!")
    display_board(game.board)
    IO.puts("\nThanks for playing! Would you like to play again? (y/n)")
    play_again = IO.gets("> ") |> String.trim()
    if String.downcase(play_again) == "y", do: new(), else: IO.puts("Goodbye!")
  end

  defp play(%{board: board} = game) do
    if board_full?(board) do
      IO.puts("\nIt's a draw! No winners this time.")
      display_board(board)
      IO.puts("\nBetter luck next time!")
      IO.puts("Would you like to play again? (y/n)")
      play_again = IO.gets("> ") |> String.trim()
      if String.downcase(play_again) == "y", do: new(), else: IO.puts("Goodbye!")
    else
      display_board(board)
      IO.puts("\nPlayer #{game.current_player} (#{game.current_player})'s turn. Your move!")

      case get_move() do
        {:ok, move} ->
          case make_move(game, move) do
            {:ok, new_game} -> play(new_game)
            {:error, :anti_revenge_violation} ->
              IO.puts("Anti-Revenge Rule violation! You cannot erase the symbol just erased by the previous player.")
              play(game)
            {:error, :consecutive_erasure_forbidden} ->
              IO.puts("You can't erase another symbol in consecutive turns.")
              play(game)
            {:error, :invalid_move} ->
              IO.puts("Oops! That square is already taken. Try a different one.")
              play(game)
          end
        :error ->
          IO.puts("Invalid input. Please enter a valid move in the format 'row column' (e.g., '1 2').")
          play(game)
      end
    end
  end

  # Makes a move for the current player
  defp make_move(
         %TicTacToe4x4.Game{
           board: board,
           current_player: player,
           last_move: last_move,
           erasures: erasures
         } = game,
         {row, col}
       ) do
    case Enum.at(Enum.at(board, row - 1), col - 1) do
      :empty ->
        enforce_rules_and_place(game, {row, col}, :place)

      other_player when other_player != player ->
        cond do
          erasures[player] ->
            {:error, :consecutive_erasure_forbidden}

          anti_revenge_violation?(player, last_move, {row, col}) ->
            {:error, :anti_revenge_violation}

          true ->
            enforce_rules_and_place(game, {row, col}, :erase)
        end

      _ ->
        {:error, :invalid_move}
    end
  end

  # Enforces game rules and places a symbol on the board or erases it
  defp enforce_rules_and_place(
         %{board: board, current_player: player} = game,
         {row, col},
         move_type
       ) do
    new_board = update_board(board, row, col, player)

    new_game = %{
      game
      | board: new_board,
        current_player: next_player(player),
        last_move: {player, {row, col}, move_type},
        erasures: update_erasures(game, player, move_type)
    }

    case check_winner(new_board, player) do
      true -> {:ok, %{new_game | winner: player}}
      false -> {:ok, new_game}
    end
  end

  # Checks if the previous move violates the anti-revenge rule
  defp anti_revenge_violation?(
         _current_player,
         {_prev_player, {prev_row, prev_col}, :erase},
         {row, col}
       ) do
    prev_row == row and prev_col == col
  end

  defp anti_revenge_violation?(_current_player, _last_move, _current_move), do: false

  # Updates the erasure state of a player
  defp update_erasures(%{erasures: erasures}, player, :erase), do: Map.put(erasures, player, true)

  defp update_erasures(%{erasures: erasures}, player, :place),
    do: Map.put(erasures, player, false)

  # Updates the game board with a new move
  defp update_board(board, row, col, player) do
    List.update_at(board, row - 1, fn r ->
      List.update_at(r, col - 1, fn _ -> player end)
    end)
  end

  # Determines the next player in the game
  defp next_player(current_player) do
    current_index = Enum.find_index(@players, fn p -> p == current_player end)
    next_index = rem(current_index + 1, length(@players))
    Enum.at(@players, next_index)
  end

  # Checks if a player has won the game
  defp check_winner(board, player) do
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

  # Displays the game board in a readable format
  defp display_board(board) do
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

  # Prompts the user to input their move (row and column)
  defp get_move do
    IO.puts("Enter your move (row and column) separated by a space (e.g. 1 2):")
    input = IO.gets("> ") |> String.trim()

    case String.split(input) do
      [row_str, col_str] ->
        with {row, ""} <- Integer.parse(row_str),
             {col, ""} <- Integer.parse(col_str),
             true <- row in 1..4,
             true <- col in 1..4 do
          {:ok, {row, col}}
        else
          _ -> :error
        end

      _ ->
        :error
    end
  end

  # Checks if the board is full (no empty spaces)
  defp board_full?(board) do
    Enum.all?(board, fn row -> Enum.all?(row, fn cell -> cell != :empty end) end)
  end
end
