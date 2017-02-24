require_relative "piece"
require_relative "bishop"
require_relative "rook"

class Queen < Piece
	include BishopMoveSet
	include RookMoveSet

	def find_legal_moves
		self.legal_moves = []
		bishop_moves
		rook_moves
	end

	def to_s
		case faction
		when :white
			"\u2655"
		else
			"\u265B"
		end
	end
end