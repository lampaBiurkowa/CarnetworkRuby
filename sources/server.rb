require "ostruct"
require "socket"

module CarnetworkRuby
    class Server

        @clients = nil
        @connected = nil
        MessageData = Struct.new(:id, :content)
        @newClientsThread = nil
        @lastMessage = nil
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
                    handleReceivedMessage(client.gets)
                end
            end
        end

        def handleReceivedMessage(message)
            message = message["CLID: ".length .. -1] #123 sddsada
            id = message[0 .. message.index(" ") - 1]
            content = message[message.index(" ") + 1 .. -1]
            @lastMessage = MessageData.new(id, content)
            puts @lastMessage.id
            puts @lastMessage.content
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