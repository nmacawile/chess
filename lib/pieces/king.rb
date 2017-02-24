require_relative "piece"

class King < Piece
	attr_accessor :castling_cells

	def initialize(board, faction, x, y)
		@castling_cells = []
		super		
	end

	def find_legal_moves
		self.legal_moves = []
		self.castling_cells = []
		king_moves
	end

	def king_moves
		surrounding_cells
		castling
	end

	def surrounding_cells
		[-1, 0, 1].repeated_permutation(2).each do |offset| 
			next if offset == [0, 0]
			cell = [position, offset].transpose.map { |x| x.reduce(:+) }
			legal_moves <<  cell if cell.all? { |n| n.between?(1, 8)} && !friendly?(*cell)
		end 
	end

	def castling
		castle_king_side
		castle_queen_side
	end

	def castle_conditions(rook_corner, safe_range, free_range)
		_, b = *position
		!board.get(rook_corner, b).nil? &&
		board.get(rook_corner, b).class == Rook &&
		friendly?(rook_corner, b) &&
		!board.get(rook_corner, b).moved? &&
		!self.moved? &&
		safe_range.none? { |x| board.enemy_moves(self.faction).include? [x, b] } &&
		free_range.all? { |x| board.get(x, b).nil? }
	end

	def castle_king_side
		_, b = *position
		if castle_conditions(8, (5..7), (6..7))
			self.legal_moves << [7, b]
			self.castling_cells << [7, b]
		else
			self.castling_cells.delete [7, b]
		end
	end

	def castle_queen_side
		_, b = *position
		if castle_conditions(1, (3..5), (2..4))
			self.legal_moves << [3, b]
			self.castling_cells << [3, b]
		else
			self.castling_cells.delete [3, b]
		end
	end

	def to_s
		case faction
		when :white
			"\u2654"
		else
			"\u265A"
		end
	end

end