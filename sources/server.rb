require 'socket'

module CarnetworkRuby
    class Server

        @clients = nil
        @connected = nil
        @newClientsThread = nil
        @server = nil

        def initialize(server, port)
            @clients = Array.new
            @server = TCPServer.new(server, port)
            @connected = true
            @newClientsThread = Thread.new { handleNewClients }
            update
        end

        def update
            while @connected do
                @clients.each do |client|
                    puts client.gets
                end
            end
        end

        def handleNewClients
            while @connected do
                @clients.push(@server.accept)
                sendGreetMessage
            end
        end

        def sendGreetMessage
            @clients[-1].puts("CLID: #{@clients.length - 1}")
        end

        def receive
            return @server.gets
        end

    end
end