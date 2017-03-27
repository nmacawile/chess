require "yaml"
require_relative "board"
require_relative "player"
require_relative "pieces/rook"
require_relative "pieces/knight"
require_relative "pieces/bishop"
require_relative "pieces/queen"
require_relative "pieces/king"
require_relative "pieces/pawn"

class Game
	attr_accessor :board, :active_turn, :players
	attr_writer :draw_accepted, :resigned

	def initialize(p1_class, p1name, p2_class, p2name)
		@board = Board.new(self)
		@players = { white: p1_class.new(self, p1name, :white), black: p2_class.new(self, p2name, :black) }
		@active_turn = :white	
		setup_board
	end

	def switch_turn
		self.active_turn = inactive_turn
	end

	def setup_board
		place_pieces(:white, 1)
		place_pieces(:black, 8)
		place_pawns(:white, 2)
		place_pawns(:black, 7)
	end

	def place_pawns(faction, row)
		(1..8).each do |column|
			Pawn.new(board, faction, column, row)
		end
	end

	def place_pieces(faction, row)
		place_rooks(faction, row)
		place_knights(faction, row)
		place_bishops(faction, row)
		place_king_and_queen(faction, row)		
	end

	def place_rooks(faction, row)
		[1, 8].each { |column| Rook.new(board, faction, column, row) }
	end

	def place_knights(faction, row)
		[2, 7].each { |column| Knight.new(board, faction, column, row) }
	end

	def place_bishops(faction, row)
		[3, 6].each { |column| Bishop.new(board, faction, column, row) }
	end

	def place_king_and_queen(faction, row)		
		King.new(board, faction, 5, row)
		Queen.new(board, faction, 4, row)
	end

	def play		
		catch(:stop) { manage_turns }
		show_board
		show_result
		end_online_session
	end

	def manage_turns
		loop do
			show_board
			player_turn			
			over? ? break : switch_turn
		end
	end

	def show_result
		if draw_accepted? then both_puts "Both players have agreed to a draw!"
		elsif resigned? then both_puts "#{active_player} resigns. #{other_player} wins!"
		elsif only_kings_remain? then both_puts "It's a draw!"
		elsif stalemate? then both_puts "Stalemate! It's a draw!" 
		elsif checkmate? then both_puts "Checkmate! #{active_player} wins!"
		end
	end

	def end_online_session
		players.each { |side, player| player.end_session if player.class == NetworkPlayer }
	end

	def player_turn
		if active_player.class == ComputerPlayer then computer_player_turn
		else human_player_turn
		end
	end

	def human_player_turn
		loop do
			input = active_player.turn
			next if command?(input) || invalid?(input)
			break if move_success?(input)
		end
	end

	def computer_player_turn
		piece_position, target_cell = active_player.turn
		board.get(*piece_position).move(*target_cell)
	end

	def move_success?(input)
		move = convert_move(input.scan /[a-h][1-8]/)
		piece = board.get(move[0], move[1])
		return true if piece.move(move[2], move[3])
		puts "That move is illegal."
		false
	end

	def invalid?(input)
		move = input.scan /[a-h][1-8]/
		return true unless move = convert_move_show_message_on_failure(move)		
		return true if empty_cell_selected?(move)
		return true unless mine?(move)
	end

	def empty_cell_selected?(move)
		piece = board.get(move[0], move[1])
		return false unless piece.nil?
		active_player_puts "Empty cell."
		true
	end

	def mine?(move)
		piece = board.get(move[0], move[1])
		return true if !piece.nil? && piece.faction == active_turn		
		active_player_puts "That's not your piece."
		false
	end

	def convert_move_show_message_on_failure(move)
		converted = convert_move(move)
		return converted if converted
		active_player_puts "Please follow this format: a2b3"
		false
	end

	def command?(input)
		case input
		when "draw" then confirm_draw; when "resign" then confirm_resign; when "quit" then confirm_quit; when "save" then confirm_save
		end
	end

	def confirm_draw
		confirm_draw_message
		accept_draw_offer if other_player.input == "y"
		true
	end

	def accept_draw_offer
		self.draw_accepted = true
		throw :stop
	end

	def confirm_draw_message
		other_player_puts "#{active_player} offers a draw."
		other_player_puts "#{other_player}, do you accept? Y/N?"
	end

	def confirm_resign
		active_player_puts "#{active_player}, do you really want to resign? Y/N?"
		resign if active_player.input == "y"
		true
	end

	def resign
		self.resigned = true
		throw :stop
	end

	def confirm_quit
		self.resigned = true
		throw :stop
	end

	def confirm_save
		if online_match? then active_player_puts "You can't save an online game."
		else prompt_save			
		end
		true
	end

	def prompt_save
		active_player_puts "Save and quit game? Y/N?"
		save if active_player.input == "y"
	end

	def online_match?
		players[:white].class == NetworkPlayer || players[:black].class == NetworkPlayer 
	end

	def save
		save_folder = "save"
		Dir.mkdir(save_folder) unless Dir.exists?(save_folder)
		File.open(save_folder + "/game.yml", "w") { |file| file.write(self.to_yaml) }
		throw :stop
	end

	def convert_move(move)
		return unless move.size == 2
		move.map! { |pair| pair.split(//) }
		move.map! { |pair| [letter_to_number(pair.first), pair.last.to_i] }
		move.flatten
	end

	def letter_to_number(letter)
		("a".."h").to_a.unshift(nil).find_index(letter)
	end

	def show_board
		if  offline_match? then shared_view
		else individual_views
		end
	end

	def offline_match?
		players[:white].class == Player && players[:black].class == Player
	end

	def shared_view
		print white_side_board if active_turn == :white
		print black_side_board if active_turn == :black
	end

	def individual_views
		[:white, :black].each do |faction|
			player_print(faction, white_side_board) if faction == :white
			player_print(faction, black_side_board) if faction == :black
		end
	end

	def black_side_board
		board.show_reversed
	end

	def white_side_board
		board.show
	end

	def show_captures(faction)		
		board.captures[faction].map { |piece| piece.to_s }.sort.join(" ").prepend "  "
	end

	def over?
		stalemate? || only_kings_remain? || checkmate?
	end

	def only_kings_remain?
		board.only_kings_remain?
	end

	def stalemate?
		return true if board.stalemate?(inactive_turn)
		false
	end

	def checkmate?
		return true if board.checkmate?(inactive_turn)
		false		
	end

	def draw_accepted?
		@draw_accepted
	end

	def resigned?
		@resigned
	end

	def active_player
		players[active_turn]
	end

	def other_player
		players[inactive_turn]
	end

	def inactive_turn
		self.active_turn == :white ? :black : :white
	end	

	def active_player_input
		active_player.input
	end

	def other_player_input
		other_player.input
	end

	def active_player_puts(message)
		active_player.puts_to_screen message
	end

	def other_player_puts(message)
		other_player.puts_to_screen message
	end

	def active_player_print(message)
		active_player.print_to_screen message
	end

	def other_player_print(message)
		other_player.print_to_screen message
	end

	def player_print(faction, message)
		players[faction].print_to_screen message
	end

	def player_puts(faction, message)
		players[faction].puts_to_screen message
	end

	def both_puts(message)
		if offline_match? then puts message
		else [:white, :black].each { |faction| player_puts(faction, message) }
		end
	end	
end
