require "board"

class Piece
	attr_accessor :board, :position, :faction, :legal_moves

	def initialize(board, faction, x, y)
		@board = board
		@position = [x, y]		
		@faction = faction
		@legal_moves = []
		board.set(self, x, y)
	end

	def move(x, y)
		find_legal_moves
		return false unless legal_moves.include? [x, y]
		proceed(x, y)
		true	
	end

	def proceed(x, y)		
		board.set(nil, *position)
		self.position = [x, y]
		board.set(self, x, y)
	end

	def find_legal_moves
		self.legal_moves = []
		(1..8).to_a.repeated_permutation(2) do |pair|
			legal_moves << pair
		end
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