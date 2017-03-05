# soapbox-race-dissector
wireshark protocol lua dissector

to configure in wireshark:

- edit init.lua file

- declare SOAPBOX_DISSECTOR_PATH variable with the soapbox-dissector-boot.lua base path
- dofile() on soapbox-dissector-boot.lua file             
example:

    SOAPBOX_DISSECTOR_PATH = "/home/user/soapbox-dissector-files/"
    dofile(SOAPBOX_DISSECTOR_PATH.."soapbox-dissector-boot.lua")

