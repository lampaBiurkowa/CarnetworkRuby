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
            puts "a #{message}"
            message = decode(message, 2)
            puts "b #{message}"
            message = message["CLID: ".length .. -2]
            begin
                id = message[0 .. message.index(" ") - 1]
                content = message[message.index(" ") + 1 .. -1]
            rescue
                id = nil
                content = nil
            end
            @lastMessage = MessageData.new(id, content)
        end

        def decode(data, coder)
            if coder < 0 || coder >= 128
                puts "Coder must be between 0 and 127, decoding disabled"
                coder = 0
            end
            for i in 0..data.length - 1
                asciiNo = data[i].ord
                asciiNo -= coder
                if asciiNo < 0
                    asciiNo += 128;
                end
                data[i] = asciiNo.chr
            end
            return data
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