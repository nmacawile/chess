class Board
	attr_accessor :grid, :kings, :captures

	def initialize
		@grid = Array.new(8) { Array.new(8) }
		@kings = {}
		@captures = Hash.new { |hsh, key| hsh[key] = [] }
	end

	def get(x, y)
		grid[x - 1][y - 1]
	end

	def set(piece, x, y)
		self.kings[piece.faction] = [x, y] if piece.class == King		
		captures[piece.faction] << get(x, y) unless piece.nil?
		self.grid[x - 1][y - 1] = piece
	end
end
