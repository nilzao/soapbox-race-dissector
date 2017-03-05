dofile(SOAPBOX_DISSECTOR_PATH.."soapbox-dissector-hello.lua")
dofile(SOAPBOX_DISSECTOR_PATH.."soapbox-dissector-id.lua")
dofile(SOAPBOX_DISSECTOR_PATH.."soapbox-dissector-pos.lua")
dofile(SOAPBOX_DISSECTOR_PATH.."soapbox-dissector-sync-keep-alive.lua")
dofile(SOAPBOX_DISSECTOR_PATH.."soapbox-dissector-sync-session.lua")
dofile(SOAPBOX_DISSECTOR_PATH.."soapbox-dissector-sync.lua")
dofile(SOAPBOX_DISSECTOR_PATH.."soapbox-packet-types.lua")

p_soapbox = Proto ("SOAPBOX","Soapbox-race ")

f_command = ProtoField.uint16("soapbox.command", "Command", base.HEX)
f_data = ProtoField.string("soapbox.data", "Data", FT_STRING)
f_sb_clisrv_type = ProtoField.uint16("soapbox.clisrvtype", "CliSrv", base.BOOLEAN)
f_sb_crc = ProtoField.uint16("soapbox.f_sb_crc", "CRC", base.HEX)
p_soapbox.fields = {f_command, f_data, f_sb_clisrv_type, f_sb_crc}

function p_soapbox.init()
end

function p_soapbox.dissector (buf, pkt, root)
  if buf:len() == 0 then return end
  pkt.cols.protocol = "SOAPBOX"
  subtree = root:add(p_soapbox, buf(0))
  setFieldsFromType(buf, pkt, subtree)
  subtree:add(f_sb_clisrv_type, buf(0,1)):append_text(" ["..detectCliSrvType(buf).."]")
  subtree:add(f_sb_crc, buf(buf:len()-4,4))
end

local udp_dissector_table = DissectorTable.get("udp.port")
dissector = udp_dissector_table:get_dissector(9998)
udp_dissector_table:add(9998, p_soapbox)
