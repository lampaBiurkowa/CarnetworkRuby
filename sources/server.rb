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
                @clients.push(@server.accept)
                sendGreetMessage
            end
        end

        def sendGreetMessage
            @clients[-1].puts("CLID: #{@clients.length - 1}")
        end

    end
end