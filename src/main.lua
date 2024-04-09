local signal = require("posix.signal")
local socket = require("socket")
local string = require("string")
local dictionary = require("src/dictionary")

-- create a TCP socket and bind it to the local host, at any port
local server = assert(socket.bind("127.0.0.1", 12345))
local ip, port = server:getsockname()

print(string.format("telnet %s %s", ip, port))

local running = 1

-- local function stop(sig)
--     running = 0
--     return 0
-- end

-- Interrupt
signal.signal(signal.SIGINT, nil)

while 1 == running do
    local client = server:accept()
    client:settimeout(9)

    local message, err = client:receive()
    while not err and "quit" ~= message do
      local command = string.sub(message, 1, 1)
      if command == '0' then -- 接続切断
        running = 0
        break
      elseif command == '1' then -- 変換結果を返す
        local yomi =  string.sub(message, 2, #message)
        local candidates = dictionary[yomi]
        client:send(candidates)
        client:send("\n")
        -- response = get(connection, line)
        -- if response
        --   write(socket, response)
        -- else 
        --   write(socket, "$(line)\n")
        -- end
      elseif command == '2' then -- サーバーのバージョンを返す
        client:send("0.1.0")
        client:send("\n")
      elseif command == '3' then -- サーバーのホスト名とアドレスを返す
        client:send(string.format("%s:%s", ip, port))
        client:send("\n")
      elseif command == '4' then -- サーバーから補完された見出し候補一覧を返す
        client:send("未実装")
        client:send("\n")
        -- write(socket, "4$(line[1:end])\n")
      else
        error(string.format("unknown request: %s", message))
        break
      end

        -- print(string.format("received: %s", message))
        -- client:send(message)
        -- client:send("\n")
      message, err = client:receive()
    end
    client:close()
end
server:close()
