require "board"

class Piece
	attr_accessor :board, :position, :faction
	def initialize(board, faction, x, y)
		@board = board
		@position = [x, y]
		board.set(self, x, y)
		@faction = faction
	end

	def move(x, y)
		return false unless x.between?(1, 8) && y.between?(1, 8)
		board.set(nil, *position)
		self.position = [x, y]
		board.set(self, x, y)
		true	
	end

	def friendly?(x, y)
		return false if board.get(x, y).nil?
		board.get(x, y).faction == faction
	end

	def enemy?(x, y)
		return false if board.get(x, y).nil?
		board.get(x, y).faction != faction
	end
end