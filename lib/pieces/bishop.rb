require "pieces/piece"

class Bishop < Piece
	def find_legal_moves
		self.legal_moves = []	
		bishop_moves
	end

	def bishop_moves
		find_upper_left
		find_upper_right
		find_lower_left
		find_lower_right
	end

	def find_upper_left
		find { |a, b, offset| [a - offset, b + offset] }
	end

	def find_upper_right
		find { |a, b, offset| [a + offset, b + offset] }
	end

	def find_lower_left
		find { |a, b, offset| [a - offset, b - offset] }
	end

	def find_lower_right
		find { |a, b, offset| [a + offset, b - offset] }
	end

	def find
		(1..7).each do |offset|
			pair = yield(*position, offset)
			break if !pair.all? { |n| n.between?(1, 8) } || friendly?(*pair)
			legal_moves << pair
			break if enemy?(*pair)
		end
	end


end