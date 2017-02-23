require "pieces/piece"

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

	def castle_king_conditions
		_, b = *position
		!board.get(8, b).nil? &&
		board.get(8, b).class == Rook &&
		friendly?(8, b) &&
		!board.get(8, b).moved? &&
		!self.moved? &&
		(5..7).none? { |x| board.enemy_moves(self.faction).include? [x, b] } &&
		(6..7).all? { |x| board.get(x, b).nil? }
	end

	def castle_queen_conditions
		_, b = *position
		!board.get(1, b).nil? &&
		board.get(1, b).class == Rook &&
		friendly?(1, b) &&
		!board.get(1, b).moved? &&
		!self.moved? &&
		(3..5).none? { |x| board.enemy_moves(self.faction).include? [x, b] } &&
		(2..4).all? { |x| board.get(x, b).nil? }
	end

	def castle_king_side
		_, b = *position
		if castle_king_conditions
			self.legal_moves << [7, b]
			self.castling_cells << [7, b]
		else
			self.castling_cells.delete [7, b]
		end
	end

	def castle_queen_side
		_, b = *position
		if castle_queen_conditions
			self.legal_moves << [3, b]
			self.castling_cells << [3, b]
		else
			self.castling_cells.delete [3, b]
		end
	end

end