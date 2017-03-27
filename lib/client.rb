require "socket"

class Client
  def initialize( server )
    @server = server
    listen
  end

  def listen
    loop do
      msg = @server.gets
      msg.chomp! if msg.match(/:\s+$/)

      break if msg == "ENDSESSION\n"

      if msg == "INPUT\n" then @server.puts( $stdin.gets.chomp )
      else print "#{msg}" end
    end
  end

end

server = TCPSocket.open( "localhost", 3000 )
Client.new( server )
