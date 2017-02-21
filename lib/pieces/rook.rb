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
		pair = Proc.new { |a, b, offset| [a, offset] }
		find(pair, :up)
	end

	def find(pattern, direction)
		add = Proc.new do |offset|
			pair = pattern.call(*position, offset)
			return if friendly?(*pair)
			legal_moves << pair
			return if enemy?(*pair)
		end

		a, b = *position
		
		(b + 1).upto(8, &add) 
	end

	def find_up2
		a, b = *position
		(b + 1).upto(8) { |offset|
			break if friendly?(a, offset)
			legal_moves << [a, offset]
			break if enemy?(a, offset)
		}
	end

	def find_down
		a, b = *position
		(b - 1).downto(1) { |offset|
			break if friendly?(a, offset)
			legal_moves << [a, offset]
			break if enemy?(a, offset)
		}
	end

	def find_left
		a, b = *position
		(a - 1).downto(1) { |offset|
			break if friendly?(offset, b)
			legal_moves << [offset, b]
			break if enemy?(offset, b)
		}
	end

	def find_right
		a, b = *position
		(a + 1).upto(8) { |offset|
			break if friendly?(offset, b)
			legal_moves << [offset, b]
			break if enemy?(offset, b)
		}
	end
end
