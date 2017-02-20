require "pieces/piece"

class King < Piece
	def find_legal_moves
		self.legal_moves = []
		[-1, 0, 1].repeated_permutation(2).each do |offset| 
			next if offset == [0, 0]
			cell = [position, offset].transpose.map { |x| x.reduce(:+) }
			legal_moves <<  cell if cell.all? { |n| n.between?(1, 8)} && !friendly?(*cell)
		end
	end
end