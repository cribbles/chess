# Ruby Chess Suite

## Summary

This is a two-player Chess and Checkers game suite written in Ruby and played over command line. It makes use of a hand-rolled module, [ChessUtils](/lib/chess_utils), that encapsulates shared logic between the games and provides an API for developing similar ones.

I wrote this with a strong focus on [Sandy Metz](http://www.poodr.com/)-style OOP principles.

## How to Play

Simply download, navigate to the root folder and run `./chess.rb` or `./checkers.rb`. If that doesn't work, try running `chmod +x ./chess.rb`.

## Features

### Chess

- Move validation system allows full range of piece trajectories
- Fully playable, with notifications for check and checkmate
- Pieces make use of multi-level class inheritance system for DRY code

### Checkers

- Play against a friend, a computer AI, or watch two computer opponents face off against each other
- Accepts notation for multi-jump sequences - e.g. `a4, c6, e8`
- Human and computer players share the same API with duck-typing

### ChessUtils

- `Renderable`
  - Provides full-color GUI for pieces and board
- `Notatable`
  - Translates user input from algebraic chess notation to array coordinates
  - Uses regex and error handling to validate user input
- `Traversable`
  - Provides utility methods for calculating delta coordinates in a 2d positional grid

## Checkers AI

The [computer AI](lib/checkers/computer_player.rb) is definitely one of the coolest features of the application. Here's how it works:

- Computer AI performs a breadth-first search using the game's move-validation system to determine the best move
 - If there are any jump sequences available, it picks the longest one possible (i.e. it claims as many pieces as it can)
 - If there are no possible jump moves, it picks the safest slide possible (i.e. it plays defensively)
 - Otherwise, it makes a random move - unless it's landlocked and can't move, then it forfeits

## Future polishing touches (TBD)

- Chess AI
- Load and save games
- More extensive chess moves - e.g. castling, en passant, etc.
- Expand Checkers AI move algorithm to take kinging into consideration
- Log and display notated user input on game completion

## License

Ruby Chess Suite is released under the [MIT License](/LICENSE).

---
Developed by [Chris Sloop](http://github.com/cribbles)
