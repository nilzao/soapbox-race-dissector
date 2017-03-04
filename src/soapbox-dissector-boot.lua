dofile(SOAPBOX_DISSECTOR_PATH.."soapbox-dissector-hello.lua")
dofile(SOAPBOX_DISSECTOR_PATH.."soapbox-dissector-id.lua")
dofile(SOAPBOX_DISSECTOR_PATH.."soapbox-dissector-pos.lua")
dofile(SOAPBOX_DISSECTOR_PATH.."soapbox-dissector-sync-keep-alive.lua")
dofile(SOAPBOX_DISSECTOR_PATH.."soapbox-dissector-sync-session.lua")
dofile(SOAPBOX_DISSECTOR_PATH.."soapbox-dissector-sync.lua")
dofile(SOAPBOX_DISSECTOR_PATH.."soapbox-packet-types.lua")

p_soapbox = Proto ("SOAPBOX","Soapbox-race ")

function p_soapbox.dissector (buf, pkt, root)
  if buf:len() ==0 then return end
  p_soapbox.fields = getFieldsFromType(buf,pkt,root)
  setFieldsFromType(buf, pkt, root)
end

local udp_dissector_table = DissectorTable.get("udp.port")
dissector = udp_dissector_table:get_dissector(9998)
udp_dissector_table:add(9998, p_soapbox)
