require "board"

class Piece
	attr_accessor :board, :position
	def initialize(board, x, y)
		@board = board
		@position = [x, y]
		board.set(self, x, y)
	end

	def move(x, y)
		return false unless x.between?(1, 8) && y.between?(1, 8)
		board.set(nil, *position)
		self.position = [x, y]
		board.set(self, x, y)
		true	
	end
end