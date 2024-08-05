local RADIO = {}
RADIO.id = 166
RADIO.fields = {
             { "rxerrors", "<I2" },
             { "fixed", "<I2" },
             { "rssi", "<B" },
             { "remrssi", "<B" },
             { "txbuf", "<B" },
             { "noise", "<B" },
             { "remnoise", "<B" },
             }
return RADIO
