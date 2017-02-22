require "pieces/piece"

class Pawn < Piece
	def find_legal_moves
		self.legal_moves = []
	end
end