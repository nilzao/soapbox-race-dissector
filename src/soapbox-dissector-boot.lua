dofile(SOAPBOX_DISSECTOR_PATH.."soapbox-dissector-hello.lua")
dofile(SOAPBOX_DISSECTOR_PATH.."soapbox-dissector-id.lua")
dofile(SOAPBOX_DISSECTOR_PATH.."soapbox-dissector-pos.lua")
dofile(SOAPBOX_DISSECTOR_PATH.."soapbox-dissector-sync-keep-alive.lua")
dofile(SOAPBOX_DISSECTOR_PATH.."soapbox-dissector-sync-session.lua")
dofile(SOAPBOX_DISSECTOR_PATH.."soapbox-dissector-sync.lua")
dofile(SOAPBOX_DISSECTOR_PATH.."soapbox-packet-types.lua")

p_soapbox = Proto ("SOAPBOX","Soapbox-race ")

f_sb_pkt_orig_type = ProtoField.uint16("soapbox.pktorig", "Pkg Orig", base.BOOLEAN)
f_sb_count = ProtoField.uint16("soapbox.count", "Counter", base.HEX)
f_sb_time = ProtoField.uint16("soapbox.time", "Time", base.DEC)
f_sb_crc = ProtoField.uint16("soapbox.crc", "CRC", base.HEX)
f_sb_player = ProtoField.uint16("soapbox.player", "Player", base.DEC)
f_sb_session_id = ProtoField.uint16("soapbox.sessionid", "Session Id", base.DEC)
f_persona_name = ProtoField.string("soapbox.personaid", "Persona Name", base.UNIT_STRING)
f_persona_id = ProtoField.uint16("soapbox.personaid", "Persona Id", base.HEX)
f_sb_pkg_size = ProtoField.uint16("soapbox.pkgsize", "Pkg Size", base.DEC)
p_soapbox.fields = {--
  f_sb_count, --
  f_sb_time, --
  f_sb_pkt_orig_type, --
  f_sb_session_id, --
  f_sb_player, --
  f_persona_id, --
  f_persona_name, --
  f_sb_pkg_size,
  f_sb_crc --
}

function p_soapbox.init()
end

function p_soapbox.dissector (buf, pkt, root)
  if buf:len() == 0 then return end
  pkt.cols.protocol = "SOAPBOX"
  local subtree = root:add(p_soapbox, buf(0))
  subtree:add(f_sb_pkt_orig_type, buf(0,1)):append_text(" ["..detectCliSrvType(buf).."]")
  setCountField(buf,pkt,subtree)
  setFieldsFromType(buf, pkt, subtree)
  subtree:add(f_sb_crc, buf(buf:len()-4,4))
end

local udp_dissector_table = DissectorTable.get("udp.port")
dissector = udp_dissector_table:get_dissector(9998)
udp_dissector_table:add(9998, p_soapbox)
