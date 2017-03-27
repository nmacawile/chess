require_relative "game"
require_relative "client"
require 'yaml'

def show_game_modes
	puts
	puts "RUBY CHESS"
	puts "Select a game mode: "
	puts "	[1] vs Computer"
	puts "	[2] vs Player(Offline)"
	puts "	[3] vs Player(LAN)"
	puts "	[4] load a saved game"
	puts "	[0] exit"
	print "game mode > "
end

def game_mode_selection
	show_game_modes
	gamemode(gets.to_i)
	game_mode_selection
end

def gamemode(selected)
	case selected
	when 1 then	vscomputer
	when 2 then vslocalplayer
	when 3 then vsonlineplayer
	when 4 then load
	else exit
	end
end

def vscomputer
	player = [Player, changename("Player")]
	computer = [ComputerPlayer, "Computer"]
	Game.new(*choose_sides(player, computer)).play
end

def vslocalplayer
	player1 = [Player, changename("Player1")]
	player2 = [Player, changename("Player2")]
	Game.new(*choose_sides(player1, player2)).play
end

def changename(current)
	print "#{current}, please enter your name: "
	name = gets.chomp
	name.match(/^\s*$/)? current : name
end

def show_sides_codes(player)
	puts
	puts "#{player}, choose a side: "
	puts "	[0] Random(default)"
	puts "	[1] White"
	puts "	[2] Black"
	print "side > "
end

def choose_sides(player1, player2)
	show_sides_codes(player1[1])
	assign_players(gets.to_i, player1, player2)
end

def assign_players(code, player1, player2)	
	case code
	when 1 then [*player1, *player2]
	when 2 then [*player2, *player1]
	else [player1, player2].shuffle.flatten
	end
end

def vsonlineplayer
	show_lan_options
	case gets.to_i
	when 1 then create_lan_game
	when 2 then join_lan_game
	end	
end

def create_lan_game
	begin
		name = changename("Player1")
		player = [Player, name]
		remote_player = [NetworkPlayer, "Player2"]
		Game.new(*choose_sides(player, remote_player)).play
	rescue
		puts "An error has been encountered."
	end
end

def join_lan_game
	begin
		print "Enter the server's IP address to join: "
		ip = gets.chomp.match(/^(\d{1,3}\.){3}\d{1,3}$/) ? ip : "localhost"
		server = TCPSocket.open(ip, 3000)
		Client.new(server)
	rescue
		puts "An error has been encountered."
	end
end

def show_lan_options
	puts
	puts "LAN game"
	puts "	[1] create session"
	puts "	[2] join session"
	puts "	[0] go back"
	print "create or join? > "
end

def load
	save_file = "save/game.yml"
	if File.exists?(save_file)
		puts "Game loaded."
		YAML::load_file(save_file).play			
		File.delete(save_file)
	else
		puts "No save file found."
	end
end

game_mode_selection