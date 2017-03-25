require "socket"

class Player
	attr_accessor :game, :name, :faction

	def initialize(game, name, faction)
		@game = game
		@name = name
		@faction = faction
	end

	def to_s
		"[#{faction.capitalize}]#{name}"
	end

	def input
		print_to_screen "#{self} : "
		get_input
	end

	def turn
		show_turn_message
		get_input
	end

	def get_input
		gets.chomp.downcase
	end

	def puts_to_screen(message)
		puts message
	end

	def print_to_screen(message)
		print message
	end

	def show_turn_message
		message = "#{self}'s turn. "
		message += "You are checked! " if game.board.checked?(faction)
		message += ": "
		print_to_screen message
	end

end

class NetworkPlayer < Player
	attr_accessor :server, :player

	def initialize(game, name, faction)
		super
		start_server
		wait_for_player
	end

	def start_server
		self.server = TCPServer.open("localhost", 3000)
	end

	def wait_for_player
		print "Waiting for player..."
		self.player = server.accept
		puts "player connected"
	end

	def get_input
		input = player.gets.chomp
		input
	end

	def print_to_screen(message)
		player.puts message
	end	

	def puts_to_screen(message)
		player.puts "#{message}\n"
	end	
	
end

class ComputerPlayer < Player

	def input
		print_to_screen "#{self} : "
		get_input
	end

	def turn
		move_hash = game.board.available_moves(faction)
		piece_position = move_hash.keys.sample
		destination = move_hash[piece_position].sample
		[piece_position, destination]
	end

	def get_input
		"n"
	end

	def puts_to_screen(message)

	end

	def print_to_screen(message)

	end

	def show_turn_message
		
	end
end
