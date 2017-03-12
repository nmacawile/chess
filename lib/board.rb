require "set"

class Board
	attr_accessor :grid, :kings, :captures, :pieces, :game

	def initialize(game = nil)
		@grid = Array.new(8) { Array.new(8) }
		@kings = {}
		@captures = Hash.new { |hsh, key| hsh[key] = [] }
		@pieces = Set.new
		@game = game
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
			when "n"
				Knight.new(self, piece.faction, x, y)
			else
				Queen.new(self, piece.faction, x, y)
			end
		end
	end

	def choose_promotion
		unless game.nil?
			game.active_player_puts "Choose a piece queen (default), [b]ishop, [r]ook or k[n]ight: "
			game.active_player_input
		else
			"q"
		end
	end

	def handle_castling(piece, x, y)
		if piece.class == King && piece.castling_cells.include?([x, y])

			if x == 7
				castle = get(8, y)				
				place(nil, 8, y)
				place(castle, 6, y)
			elsif x == 3
				castle = get(1, y)
				place(nil, 1, y)
				place(castle, 4, y)				
			end
		end
	end

	def update_captures(piece, x, y)
		if piece.class == Pawn && !piece.en_passant_cell.nil? && piece.en_passant_cell == [x, y]
			captures[piece.faction] << get(*piece.en_passant_capture_cell)
			place(nil, *piece.en_passant_capture_cell)
		else
			captures[piece.faction] << get(x, y) unless piece.nil? || get(x, y).nil?
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
		elsif piece.class == King && !piece.castling_cells.empty? && piece.castling_cells.include?([x, y])
			simulate_castling(piece, x, y)
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

	def simulate_castling(piece, x, y)
		initial_position = piece.position

		middle_cell = x == 7 ? [6, y] : [4, y]

		place(nil, *initial_position)
		place(piece, *middle_cell)	

		result1 = !checked?(piece.faction)

		place(nil, *middle_cell)
		place(piece, x, y)

		result2 = !checked?(piece.faction)

		place(nil, x, y)
		place(piece, *initial_position)

		result1 && result2 && !checked?(piece.faction)
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

	def no_moves?(faction)
		friendlies(faction).each do |piece|
			piece.find_legal_moves
			return false unless piece.safe_moves.empty?
		end
	end

	def checkmate?(faction)
		no_moves?(faction) && checked?(faction)
	end

	def stalemate?(faction)
		no_moves?(faction) && !checked?(faction)
	end

	def checked?(faction)
		enemy_moves(faction).include? kings[faction]
	end

	def occupied_cells
		pieces.map { |piece| piece.position }
	end

	def show
		show_captures(:black) + column_labels + rows_with_labels + div + column_labels + show_captures(:white)
	end

	def show_reversed
		show_captures(:white) + column_labels(true) + rows_with_labels(true) + div + column_labels(true) + show_captures(:black)
	end

	def show_captures(faction)		
		(captures[faction].map { |piece| piece.to_s }.sort.join(" ").prepend "  ") + "\n"
	end

	def div
		"   " + ("+" * 9).split(//).join("---") + "\n"
	end

	def column_labels(reversed = false)
		labels = ("A".."H").to_a
		labels.reverse! if reversed
		output = "  "
		labels.each { |column| output += "   #{column}" }
		output + "\n"
	end

	def rows_with_labels(reversed = false)
		labels = 8.downto(1).to_a
		labels.reverse! if reversed
		output = ""
		labels.each {  |row|	output += row_with_label(row, labels.reverse) }
		output
	end

	def row_with_label(row, order)
		output = "#{div} #{row} "
		order.each { |column| output += (get(column, row).nil? ? "|   " : "| #{get(column, row)} ")	}
		output + "| #{row}\n"
	end

end
