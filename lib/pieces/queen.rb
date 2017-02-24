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
end