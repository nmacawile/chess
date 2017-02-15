class Board

	attr_accessor :grid

	def initialize
		@grid = Array.new(8) { Array.new(8) }
	end

	def at(x, y)
		grid[x - 1][y - 1]
	end

end
