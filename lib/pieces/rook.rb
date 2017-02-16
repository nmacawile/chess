require "pieces/piece"

class Rook < Piece

	attr_writer :legal_moves

    def legal_moves
    	@legal_moves ||= []
    end

	def move(x, y)
		find_legal_moves
		return false unless legal_moves.include? [x, y]
		board.set(nil, *position)
		self.position = [x, y]
		board.set(self, x, y)
		true
	end

	def find_legal_moves
		self.legal_moves = []
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