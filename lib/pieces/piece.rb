require "board"

class Piece
	attr_accessor :board, :position
	def initialize(board, x, y)
		@board = board
		@position = [x, y]
		board.set(self, x, y)
	end

	def move(x, y)
		board.set(self, x, y)
		board.set(nil, *position)
	end
end