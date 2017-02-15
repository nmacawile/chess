require "board"

class Piece
	attr_accessor :board
	def initialize(board, x, y)
		@board = board
		self.board.set(self, x, y)
	end
end