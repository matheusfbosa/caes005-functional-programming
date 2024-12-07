# Tic-Tac-Toe 4x4

A game similar to Tic-Tac-Toe, but involving 3 players, 3 symbols, and the ability for one player to erase another's symbol (by overwriting it). The board is 4x4.

## Objective

Be the first player to align 4 consecutive symbols (horizontally, vertically, or diagonally) on the 4x4 board.

## Rules

1. Number of Players: 3 players.
2. Symbols: Each player selects a unique symbol (e.g., X, O, #).
3. Board: A 4x4 grid, initially empty.

4. Turns:
   - The game is played in rotating turns: Player 1 → Player 2 → Player 3 → back to Player 1.
  - On their turn, a player can:
    - Place their symbol in an empty cell.
    - Erase an opponent’s symbol by overwriting it (replacing the symbol).

5. Winner:
   - The first player to align 4 of their symbols consecutively (horizontally, vertically, or diagonally) wins.
   - If the board is filled without a winner, the game ends in a draw.

6. Anti-Revenge Rule:
   - A player cannot erase the symbol that was just played in the previous turn by another player who erased their symbol. This prevents "instant revenge."

7. Symbol Erasure Rule:
   - A player can erase another player’s symbol by overwriting it.
   - Limitation: A player cannot erase symbols in two consecutive turns.
     - If a player erased another's symbol on the previous turn, they must play in an empty cell on the current turn.

## Example of Initial Board Representation:

```
.  .  .  .
.  .  .  .
.  .  .  .
.  .  .  .
```

Where `.` represents empty cells.

## Example 1

1. Player 1 places X in a cell.
2. Player 2 places O in another cell.
3. Player 3 can:
   - Place # in an empty cell.
   - Overwrite X or O with # (following the rules).

## Example 2

1. Turn 1: Player 1 places X on the board.
2. Turn 2: Player 2 places O.
3. Turn 3: Player 3 erases X and places #.
4. Turn 4: Player 1 cannot erase Player 3’s # because they erased in the previous turn. They must play in an empty cell.

## Implementation

You can use a script or `mix task`.
