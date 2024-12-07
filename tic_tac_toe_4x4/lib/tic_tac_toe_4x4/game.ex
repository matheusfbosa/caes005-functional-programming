defmodule TicTacToe4x4.Game do
  @moduledoc """
  Core game logic for a 4x4 Tic Tac Toe game with three players: X, O, and S.
  """

  alias TicTacToe4x4.{Board, Display, Player}

  # Structure of the game state
  defstruct board: Board.initial_board(),
            current_player: :X,
            winner: nil,
            # {player, {row, col}, :erase | :place}
            last_move: nil,
            # Tracks consecutive erasures per player (e.g., %{X => true, O => false, S => false})
            erasures: %{},
            turn_number: 1

  @doc """
  Starts a new game with a friendly greeting and instructions.
  """
  def new do
    Display.welcome_message()

    game_loop(%TicTacToe4x4.Game{
      erasures: Map.new(Player.players(), fn player -> {player, false} end)
    })
  end

  # Game loop for when a winner is determined
  defp game_loop(%{winner: winner} = game) when not is_nil(winner) do
    Display.winner_message(winner)
    Display.board(game.board)
    Display.play_again_prompt()
  end

  # Game loop for ongoing game or draw
  defp game_loop(%{board: board} = game) do
    if Board.board_full?(board) do
      Display.draw_message()
      Display.board(board)
      Display.play_again_prompt()
    else
      Display.board(board)
      Display.current_player_prompt(game.current_player, game.turn_number)

      case Player.get_move() do
        {:ok, move} ->
          case make_move(game, move) do
            {:ok, new_game} ->
              game_loop(new_game)

            {:error, :anti_revenge_violation} ->
              Display.anti_revenge_violation_message()
              game_loop(game)

            {:error, :consecutive_erasure_forbidden} ->
              Display.consecutive_erasure_message()
              game_loop(game)

            {:error, :invalid_move} ->
              Display.invalid_move_message()
              game_loop(game)
          end

        :error ->
          Display.invalid_input_message()
          game_loop(game)
      end
    end
  end

  # Makes a move for the current player
  defp make_move(
         %TicTacToe4x4.Game{
           board: board,
           current_player: player,
           last_move: last_move,
           erasures: erasures,
           turn_number: _turn_number
         } = game,
         {row, col}
       ) do
    case Board.get_cell(board, row, col) do
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
         %{board: board, current_player: player, turn_number: turn_number} = game,
         {row, col},
         move_type
       ) do
    new_board = Board.update_board(board, row, col, player)

    new_game = %{
      game
      | board: new_board,
        current_player: Player.next_player(player),
        last_move: {player, {row, col}, move_type},
        erasures: update_erasures(game, player, move_type),
        turn_number: turn_number + 1
    }

    case Board.check_winner(new_board, player) do
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
end
