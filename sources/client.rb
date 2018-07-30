require 'socket'

module CarnetworkRuby
    class Client

        @messagesToSend = nil
        @client = nil
        @connected = nil
        @id = nil
        @sendingThread = nil

        def initialize(server, port)
            @messagesToSend = Array.new
            @client = TCPSocket.new(server, port)
            @connected = true
            @sendingThread = Thread.new { handleSend }
            handleId
        end

        def receive
            return @client.gets
        end

        def send(message)
            @messagesToSend.push(message)
        end

        def handleSend(timeout = 1)
            while @connected do
                if @messagesToSend > 0
                    send(@messagesToSend[0])
                    @messagesToSend = @messagesToSend.pop(@messagesToSend.length - 2)
                    sleep(timeout)
                end
            end
        end

        def handleId
            data = @client.gets
            @id = data["CLID: ".length .. -1]
        end

        def disconnect
            @connected = false
            @client.close
        end

        attr_reader :messagesToSend

    end
end