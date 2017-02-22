require "pieces/piece"

class Knight < Piece
	def find_legal_moves
		self.legal_moves = []
		knight_moves
	end

	Offsets = 
	[[-1, -2], [-1, 2], [1, -2], [1, 2], [-2, -1], [-2, 1], [2, -1], [2, 1]]

	def knight_moves
		self.legal_moves = 
		find_knight_moves.select do |pair|
			pair.all? { |ordinate| ordinate.between?(1, 8) } &&
			!friendly?(*pair)
		end		
	end

	def find_knight_moves
		Offsets.map do |offset|
			[position, offset].transpose.map { |x| x.reduce(:+) }
		end
	end
end