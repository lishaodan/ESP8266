pin1 = 4
gpio.mode(pin1, gpio.OUTPUT)
pin2 = 3
gpio.mode(pin2, gpio.OUTPUT)

wifi.setmode(wifi.STATIONAP)
cfg={}
cfg.ssid="DANBAO"
cfg.pwd="12345678"
wifi.ap.config(cfg)

sv = net.createServer(net.TCP, 30)

if sv then
  sv:listen(9000, function(conn)
    print(conn:getaddr())
    conn:on("receive", function(sck, data)
        print(data)
        --conn:send(data)
        --print(a)
        if (data == "open\n") then
            print("pin is open")
            conn:send("ECHO： pin is open\n")
            gpio.write(pin1, gpio.HIGH)
            gpio.write(pin2, gpio.HIGH)
        elseif (data == "close\n") then
            print("pin is close")
            conn:send("ECHO： pin is close\n")
            gpio.write(pin1, gpio.LOW)
            gpio.write(pin2, gpio.LOW)
        end
    end)
    conn:send("hello world")
  end)
end
