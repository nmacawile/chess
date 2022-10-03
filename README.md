# Ruby Chess

The [final project](http://www.theodinproject.com/courses/ruby-programming/lessons/ruby-final-project) for [The Odin Project](http://www.theodinproject.com)'s online Ruby course. It is a CLI-based chess game developed using test-driven methodology. The game can be played by one player against computer, two players on a shared screen, or two players on LAN.

![screenshot1](https://github.com/nmacawile/chess/blob/master/img/chess_01.PNG?raw=true "First Screenshot")

## Launching

Run `$ ruby lib/main.rb` or `$ rake play` from the game's root directory.

## How to play

### Game mode selection
```
RUBY CHESS
Select a game mode: 
	[1] vs Computer
	[2] vs Player(Offline)
	[3] vs Player(LAN)
	[4] load a saved game
	[0] exit
game mode > 1
```
The player is prompted to select a game mode from the options shown above. The game accepts input values between `1` and `4`. Anything else results in the termination of the app.

#### Game modes

* `vs Computer` - Sets up a game against the computer. The computer selects a random move from a list of all available legal moves.
* `vs Player(Offline)` - Sets up a game vs another human player on the same terminal window. Players will have to switch turns with the keyboard.
* `vs Player(LAN)` - Sets up a game vs another human player on the LAN. The player has to choose if he wants to create a server or to join an already created one.
* `load a saved game` - Loads and resumes a previously saved game. A game can only be loaded once and disappears right after. Only one game can be saved at a time. Saving a game overwrites another previously saved game file. To save a game, the player must input `save` command during his turn.

### Player name
```
Player, please enter your name: 
```
After selecting a game mode, the player is asked to enter his name. This is optional. Hitting `Enter` without typing anything sets the Player's name to default, `Player`.

### Choosing a side
```
Player, choose a side: 
	[0] Random(default)
	[1] White
	[2] Black
side > 0
```
The player is asked to choose a side. Entering values other than `1` or `2`, or simply hitting `Enter` assigns the player to a random side.

### Moving a piece

To move a piece, the player must type in the position of the square the piece is on, followed by the position of the target square in the same line, as such:
```
[White]Player's turn. : d2d4
```
This will move the pawn in square D2 to square D4.

This is also valid:
```
[White]Player's turn. : d2 d4
```
And this one:
```
[White]Player's turn. : d2-d4
```
Even this one:
```
[White]Player's turn. : fdafD2@#$d4$@#
```

#### Illegal moves
```
[White]Player's turn. : a2d2
That move is illegal.
[White]Player's turn. : 
```
The move fails if:
 * The input string does not contain two square positions
 * The destination square is outside of the selected piece's attack pattern
 * The destination square is out of bounds
 * It exposes the player's own king
 * An empty cell has been selected
 * An enemy piece has been selected

When a move fails, the game returns an error message specifying the problem with the last input and prompts the user again for another until it succeeds.

#### Special moves

All special moves are supported: [en passant](https://en.wikipedia.org/wiki/En_passant), [castling](https://en.wikipedia.org/wiki/Castling), and [pawn promotion](https://en.wikipedia.org/wiki/Promotion_(chess)).

### Commands
In addition to being able to move pieces around, the player is allowed to execute commands during his turn.
```
[White]Player's turn. : resign
[White]Player, do you really want to resign? Y/N?
[White]Player : y
```
#### Available commands

* `resign` - ends the game, results in an automatic loss (requires confimation)
* `draw` - offers draw to the opponent, opponent must agree to end the game
* `quit` - ends the game instantly, results in an automatic loss
* `save` - saves the game, and exits to the main menu (requires confirmation, does not work in online sessions)


### Victory conditions

To win the game, a player must force the opponent to a [checkmate](https://en.wikipedia.org/wiki/Checkmate) or a [resignation](https://en.wikipedia.org/wiki/Glossary_of_chess#Resign).

Checkmate:
```
Checkmate! [White]Player wins!
```
White resigns:
```
[White]Player resigns. [Black]Computer wins!
```

** A chess clock is not implemented in this app, so it is not possible to win by [time control](https://en.wikipedia.org/wiki/Time_control).

### Draw conditions


A draw is declared if it satisfies any of the following conditions:

* [Both players have agreed](https://en.wikipedia.org/wiki/Draw_by_agreement)
```
Both players have agreed to a draw!
```
* [Dead position](https://en.wikipedia.org/wiki/Glossary_of_chess#dead_draw) (A checkmate is impossible)
 ```
It's a draw!
```
* [Stalemate](https://en.wikipedia.org/wiki/Stalemate) (A player whose turn it is to move is not checked but does not have any legal moves)
```
Stalemate! It's a draw!
```
** [Threefold repetition rule](https://en.wikipedia.org/wiki/Threefold_repetition) and [fifty-move rule](https://en.wikipedia.org/wiki/Fifty-move_rule) are not implemented in this app.

## Not implemented

* Fifty-move rule
* Threefold repetition
* Chess clock
* Smart AI (Minimax + Alpha-beta pruning + Quiescence search)
* Algebraic Notation game log
* Colored pieces and board