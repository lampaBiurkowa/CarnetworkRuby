require 'socket'

module CarnetworkRuby
    class Server

        @client = nil
        @server = nil

        def initialize(server, port)
            @server = TCPServer.new(server, port)
            loop do
                @client = @server.accept
                if @client != nil
                    puts "wow"
                end
                @client.puts "Hello !"
            end
        end

    end
end