wifi.setmode(wifi.STATIONAP)
cfg={}
cfg.ssid="DANBAO"
cfg.pwd="12345678"
wifi.ap.config(cfg)

pin = 4
sv = net.createServer(net.TCP, 30)

if sv then
  sv:listen(9000, function(conn)
    print(conn:getaddr())
    conn:on("receive", function(sck, data)
        print(data)
        conn:send(data)
        if (data == "send\n") then
        -------------------------------------
            status, temp, humi, temp_dec, humi_dec = dht.read(pin)
            if status == dht.OK then
                -- Integer firmware using this example
                text_data=string.format("DHT Temperature:%d.%03d;Humidity:%d.%03d\r\n",
                      math.floor(temp),
                      temp_dec,
                      math.floor(humi),
                      humi_dec
                      )    
                print(text_data)
            elseif status == dht.ERROR_CHECKSUM then
                print( "DHT Checksum error." )
            elseif status == dht.ERROR_TIMEOUT then
                print( "DHT timed out." )
            end
            ------------------------------------------     
            conn:send(text_data)
        end
    end)
    conn:send("hello world")
  end)
end
