require_relative "piece"

module RookMoveSet
	def rook_moves
		find_up
		find_down
		find_left
		find_right
	end

	def find_up
		a, b = *position
		find_rook_moves(b + 1, 8, 1, &Patterns[:updown])
	end

	def find_down
		a, b = *position
		find_rook_moves(b - 1, 1, -1, &Patterns[:updown])
	end

	def find_left
		a, b = *position
		find_rook_moves(a + 1, 8, 1, &Patterns[:leftright])
	end

	def find_right
		a, b = *position
		find_rook_moves(a - 1, 1, -1, &Patterns[:leftright])
	end

	Patterns = { 
			updown: Proc.new { |a, b, offset| [a, offset] },
			leftright: Proc.new { |a, b, offset| [offset, b] }
		}

	def find_rook_moves(initial, final, increment)
		(initial).step(final, increment) do |offset|
			pair = yield(*position, offset)
			break if friendly?(*pair)
			self.legal_moves << pair
			break if enemy?(*pair)
		end
	end
end

class Rook < Piece
	include RookMoveSet

	def find_legal_moves
		self.legal_moves = []	
		rook_moves	
	end	

	def to_s
		case faction
		when :white
			"\u2656"
		else
			"\u265C"
		end
	end
end
