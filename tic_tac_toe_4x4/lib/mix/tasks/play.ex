defmodule Mix.Tasks.Play do
  @moduledoc """
  This Mix task starts a 4x4 Tic-Tac-Toe game with three players: X, O, and S.

  Usage:
    mix play
  """

  use Mix.Task

  @shortdoc "Starts the Tic-Tac-Toe 4x4 game."

  def run(_) do
    TicTacToe4x4.Game.new()
  end
end
