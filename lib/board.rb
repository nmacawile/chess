require "set"

class Board
	attr_accessor :grid, :kings, :captures, :pieces

	def initialize
		@grid = Array.new(8) { Array.new(8) }
		@kings = {}
		@captures = Hash.new { |hsh, key| hsh[key] = [] }
		@pieces = Set.new
	end

	def get(x, y)
		grid[x - 1][y - 1]
	end

	def set(piece, x, y)
		captures[piece.faction] << get(x, y) unless piece.nil?
		place(piece, x, y)
	end

	def place(piece, x, y)
		update_pieces(piece, x, y)
		piece.position = [x, y] unless piece.nil?
		self.kings[piece.faction] = [x, y] if piece.class == King		
		self.grid[x - 1][y - 1] = piece
	end

	def update_pieces(piece, x, y)
		pieces << piece unless piece.nil?
		pieces.delete(get(x, y)) unless get(x, y).nil?
	end

	def simulate_move(piece, x, y)
		a, b = *piece.position
		replaced = get(x, y)
		place(piece, x, y)
		place(nil, a, b)
		result = !checked?(piece.faction)
		place(replaced, x, y)
		place(piece, a, b)
		result
	end

	def enemies(faction)
		pieces.reject { |piece| piece.faction == faction }
	end

	def friendlies(faction)
		pieces.select { |piece| piece.faction == faction }
	end

	def enemy_moves(faction)
		enemies(faction).reduce(Set.new) { |moves, piece| moves += piece.show_legal_moves }
	end

	def friendly_moves(faction)
		friendlies(faction).reduce(Set.new) { |moves, piece| moves += piece.show_legal_moves }
	end

	def checked?(faction)
		enemy_moves(faction).include? kings[faction]
	end

	def occupied_cells
		pieces.map { |piece| piece.position }
	end
end
