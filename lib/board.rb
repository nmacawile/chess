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
		update_captures(piece, x, y)
		place(piece, x, y)
		handle_promotion(piece, x, y)
		handle_castling(piece, x, y)
		disable_en_passant
	end

	def handle_promotion(piece, x, y)
		if piece.class == Pawn && [1, 8].include?(y)
			place(nil, x, y)
			selection = choose_promotion			
			case selection
			when "r"
				Rook.new(self, piece.faction, x, y)
			when "b"
				Bishop.new(self, piece.faction, x, y)
			when "k"
				Knight.new(self, piece.faction, x, y)
			else
				Queen.new(self, piece.faction, x, y)
			end
		end
	end

	def choose_promotion
		print "Choose a piece [q]ueen, [b]ishop, [r]ook or k[n]ight: "
		gets.chomp.downcase
	end

	def handle_castling(piece, x, y)
		if piece.class == King && piece.castling_cells.include?([x, y])
			if x == 7
				place(get(8, y), 6, y)
				place(nil, 8, y)
			elsif x == 3
				place(get(1, y), 4, y)
				place(nil, 1, y)
			end
		end
	end

	def update_captures(piece, x, y)
		if piece.class == Pawn && !piece.en_passant_cell.nil? && piece.en_passant_cell == [x, y]
			captures[piece.faction] << get(*piece.en_passant_capture_cell)
			place(nil, *piece.en_passant_capture_cell)
		else
			captures[piece.faction] << get(x, y) unless piece.nil?
		end		
	end

	def disable_en_passant
		pieces.select { |piece| piece.class == Pawn }.each do |pawn|  
			pawn.en_passant_cell = nil
		end
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
		if piece.class == Pawn && !piece.en_passant_cell.nil? && piece.en_passant_cell == [x, y]
			simulate_en_passant(piece, x, y)
		else
			simulate_ordinary_move(piece, x, y)
		end
	end

	def simulate_ordinary_move(piece, x, y)
		initial_position = piece.position
		replaced = get(x, y)
		place(piece, x, y)
		place(nil, *initial_position)
		result = !checked?(piece.faction)
		place(replaced, x, y)
		place(piece, *initial_position)
		result
	end

	def simulate_en_passant(piece, x, y)
		initial_position = piece.position
		replaced = get(*piece.en_passant_capture_cell)
		place(nil, *piece.en_passant_capture_cell)	
		place(nil, *initial_position)	
		place(piece, *piece.en_passant_cell)
		result = !checked?(piece.faction)
		place(piece, *initial_position)
		place(replaced, *piece.en_passant_capture_cell)
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
