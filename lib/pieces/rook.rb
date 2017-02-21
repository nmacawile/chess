require "pieces/piece"

class Rook < Piece

	def find_legal_moves
		self.legal_moves = []	
		rook_moves	
	end

	def rook_moves
		find_rook_moves(:updown)
		find_rook_moves(:leftright)
	end

	Patterns = { 
			updown: Proc.new { |a, b, offset| [a, offset] },
			leftright: Proc.new { |a, b, offset| [offset, b] }
		}

	def find_rook_moves(direction)
		add = Proc.new do |offset|
			pair = Patterns[direction].call(*position, offset)
			return if friendly?(*pair)
			legal_moves << pair
			return if enemy?(*pair)
		end
		a, b = *position
		case direction	
		when :updown
			(b + 1).upto(8, &add)
			(b - 1).downto(1, &add)
 		when :leftright
			(a - 1).downto(1, &add)
			(a + 1).upto(8, &add)
		end
	end

end
