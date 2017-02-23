require "pieces/piece"

class Pawn < Piece
	attr_accessor :starting_position, :two_step_cell, :en_passant_cell, :en_passant_capture_cell

	Direction = { bottom: 1, top: -1 }

	def initialize(board, faction, x, y)
		@starting_position = y > 4 ? :top : :bottom
		@two_step_cell = nil
		@en_passant_cell = nil
		@en_passant_capture_cell
		super
	end

	def find_legal_moves
		self.legal_moves = []
		pawn_moves
	end

	def proceed(x, y)
		self.moved = true
		board.set(nil, *position)
		board.set(self, x, y)

		trigger_enemy_en_passant(x, y) if [x, y] == two_step_cell
		self.en_passant_cell = nil
		self.two_step_cell = nil
	end

	def trigger_enemy_en_passant(x, y)	
		[-1, 1].each do |side|
			if !board.get(x + side, y).nil? && board.get(x + side, y).class == Pawn && enemy?(x + side, y)
				board.get(x + side, y).trigger_en_passant(x, y - Direction[starting_position], y)
			end				
		end
	end

	def trigger_en_passant(x, y, capture_y)
		self.en_passant_cell = [x, y]
		self.en_passant_capture_cell = [x, capture_y]
	end

	def pawn_moves		
		one_step
		two_steps
		capture
		en_passant
	end

	def one_step
		a, b = *position
		target_cell = [a, b + Direction[starting_position]]
		self.legal_moves << target_cell if board.get(*target_cell).nil?
	end

	def two_steps
		a, b = *position
		target_cell = [a, b + 2 * Direction[starting_position]]
	 	cell_in_front = [a, b + Direction[starting_position]]

	 	if board.get(*cell_in_front).nil? && board.get(*target_cell).nil? && !moved?
			self.legal_moves << target_cell
			self.two_step_cell = target_cell
		end
	end

	def capture
		a, b = *position
		[-1, 1].each do |n| 
			target_cell = [a + n, b + Direction[starting_position]]
			self.legal_moves << target_cell if enemy?(*target_cell) 
		end
	end

	def en_passant
		self.legal_moves << en_passant_cell unless en_passant_cell.nil?
	end


end