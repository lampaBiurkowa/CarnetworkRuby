require 'socket'

class Client

    def initialize
        @client = TCPSocket.new('', )
    end

    def receive
        return @client.gets
    end

    def send (message)
        @client.puts(message)
    end

    def disconnect
        @client.close
    end

end