class Board

	attr_accessor :grid

	def initialize
		@grid = Array.new(8) { Array.new(8) }
	end

	def get(x, y)
		grid[x - 1][y - 1]
	end

	def set(piece, x, y)
		self.grid[x - 1][y - 1] = piece
	end

end
