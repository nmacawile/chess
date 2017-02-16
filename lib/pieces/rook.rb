require "pieces/piece"

class Rook < Piece

	def find_legal_moves
		self.legal_moves = []	
		rook_moves	
	end

	def rook_moves
		find_up
		find_down
		find_left
		find_right
	end

	def find_up
		a, b = *position
		(b + 1).upto(8) { |b_|
			break if friendly?(a, b_)
			legal_moves << [a, b_]
			break if enemy?(a, b_)
		}
	end

	def find_down
		a, b = *position
		(b - 1).downto(1) { |b_|
			break if friendly?(a, b_)
			legal_moves << [a, b_]
			break if enemy?(a, b_)
		}
	end

	def find_left
		a, b = *position
		(a - 1).downto(1) { |a_|
			break if friendly?(a_, b)
			legal_moves << [a_, b]
			break if enemy?(a_, b)
		}
	end

	def find_right
		a, b = *position
		(a + 1).upto(8) { |a_|
			break if friendly?(a_, b)
			legal_moves << [a_, b]
			break if enemy?(a_, b)
		}
	end
end
