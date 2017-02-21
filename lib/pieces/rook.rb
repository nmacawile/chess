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
		find(:up, Proc.new { |a, b, offset| [a, offset] })
	end

	def find_down
		find(:down, Proc.new { |a, b, offset| [a, offset] })
	end

	def find_left
		find(:left, Proc.new { |a, b, offset| [offset, b] })
	end

	def find_right
		find(:right, Proc.new { |a, b, offset| [offset, b] })
	end

	def find(direction, pattern)
		add = Proc.new do |offset|
			pair = pattern.call(*position, offset)
			return if friendly?(*pair)
			legal_moves << pair
			return if enemy?(*pair)
		end

		a, b = *position	
		(b + 1).upto(8, &add) if direction == :up
		(b - 1).downto(1, &add) if direction == :down
		(a - 1).downto(1, &add) if direction == :left
		(a + 1).upto(8, &add) if direction == :right
	end
	
end
