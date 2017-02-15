require "board"

class Piece
	attr_accessor :board
	def initialize(board, x, y)
		@board = board
		board.grid[x - 1][y - 1] = self
	end
end