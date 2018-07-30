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

            end
        end

        def handleNewClients
            while @connected do
                @client.push(@server.accept)
                puts @clients.length
            end
        end

    end
end