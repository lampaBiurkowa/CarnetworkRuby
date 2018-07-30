require 'socket'

module CarserverRuby
    class Client

        @messagesToSend = nil
        @client = nil
        @connected = nil
        @sendingThread = nil

        def initialize
            @messagesToSend = Array.new
            @client = TCPSocket.new('', )
            @connected = true
            @sendingThread = Thread.new { handleSend } 
        end

        def receive
            return @client.gets
        end

        def send(message)
            @messagesToSend.push(message)
        end

        def handleSend(timeout = 1)
            while @connected
                if @messagesToSend > 0
                    send(@messagesToSend[0])
                    @messagesToSend = @messagesToSend.pop(@messagesToSend.length - 2)
                    sleep(timeout)
                end
            end
        end

        def disconnect
            @connected = false
            @client.close
        end

    end
end