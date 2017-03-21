require_relative "piece"

class Pawn < Piece
	attr_accessor :starting_position, :two_step_cell, :en_passant_cell, :en_passant_capture_cell

	Direction = { bottom: 1, top: -1 }

	def initialize(board, faction, x, y, moved = false)
		@starting_position = faction == :white ? :bottom : :top
		@two_step_cell = nil
		@en_passant_cell = nil
		@en_passant_capture_cell
		super
	end

	def copy_to(another_board)
		copy = self.class.new(another_board, faction, *position, moved?)
		copy_special_attributes_to(copy)		
		copy
	end

	def copy_special_attributes_to(copy)
		copy.two_step_cell = two_step_cell
		copy.en_passant_cell = en_passant_cell
		copy.en_passant_capture_cell = en_passant_capture_cell
	end

	def find_legal_moves
		self.legal_moves = []
		pawn_moves
	end

	def proceed(x, y)
		super
		trigger_enemy_en_passant(x, y) if [x, y] == two_step_cell
	end

	def trigger_enemy_en_passant(x, y)	
		[-1, 1].each do |offset|
			side = x + offset
			next unless side.between?(1, 8)
			if !board.get(side, y).nil? && board.get(side, y).class == Pawn && enemy?(side, y)
				board.get(side, y).trigger_en_passant(x, y - Direction[starting_position], y)
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
	 	add_two_step_cell(cell_in_front, target_cell)
	 	
	end

	def add_two_step_cell(cell_in_front, target_cell)
		if board.get(*cell_in_front).nil? && board.get(*target_cell).nil? && !moved?
			self.legal_moves << target_cell
			self.two_step_cell = target_cell
		end
	end

	def capture
		a, b = *position
		[-1, 1].each do |n|
			x, y = a + n, b + Direction[starting_position]
			target_cell = [x, y]
			next unless x.between?(1, 8)
			self.legal_moves << target_cell if enemy?(*target_cell) 
		end
	end

	def en_passant
		self.legal_moves << en_passant_cell unless en_passant_cell.nil?
	end

	def to_s
		case faction
		when :white
			"\u2659"
		else
			"\u265F"
		end
	end
end