require "soapbox.dissector-hello"
require "soapbox.dissector-player"
require "soapbox.dissector-statepos"
require "soapbox.dissector-id"
require "soapbox.dissector-pos"
require "soapbox.dissector-sync-keep-alive"
require "soapbox.dissector-sync-session"
require "soapbox.dissector-sync"
require "soapbox.packet-types"

p_soapbox = Proto ("SB-RACE","Soapbox-race ")
p_soapbox_freeroam = Proto ("SB-FREEROAM","Soapbox-freeroam ")

f_sb_pkt_orig_type = ProtoField.uint16("soapbox.pktorig", "Pkg Orig", base.BOOLEAN)
f_sb_count = ProtoField.uint16("soapbox.count", "Counter", base.DEC)
f_sb_time = ProtoField.uint16("soapbox.time", "Time", base.DEC)
f_sb_before_handshake = ProtoField.uint16("soapbox.beforehs", "Before HandShake", base.HEX)
f_sb_unknown_seq = ProtoField.uint16("soapbox.unknownseq", "Uknown Seq", base.HEX)
f_sb_unknown_enum = ProtoField.uint16("soapbox.unknownenum", "Uknown Enum", base.HEX)
f_sb_static_ff = ProtoField.uint16("soapbox.staticff", "Static 0xFF", base.HEX)
f_sb_static_02 = ProtoField.uint16("soapbox.static02", "Static 0x02", base.HEX)
f_sb_hello_sync = ProtoField.uint16("soapbox.hellosync", "Hello Sync", base.HEX)
f_sb_crc = ProtoField.uint16("soapbox.crc", "CRC", base.HEX)
f_sb_player = ProtoField.uint16("soapbox.player", "Player", base.DEC)
f_sb_session_id = ProtoField.uint16("soapbox.sessionid", "Session Id", base.DEC)
f_persona_name = ProtoField.string("soapbox.personaid", "Persona Name", base.UNIT_STRING)
f_persona_id = ProtoField.uint16("soapbox.personaid", "Persona Id", base.HEX)
f_sb_pkt_size = ProtoField.uint16("soapbox.pktsize", "Pkt Size", base.DEC)
f_sb_pkt = ProtoField.bytes("soapbox.pkt", "Pkt")
f_sb_pkt_end = ProtoField.uint16("soapbox.pktend", "Packet End", base.HEX)
f_sb_sub_pkt_size = ProtoField.uint16("soapbox.subpktsize", "SubPkt Size", base.DEC)
f_sb_sub_pkt = ProtoField.bytes("soapbox.subpkt", "SubPkt")

p_soapbox.fields = {--
  f_sb_count, --
  f_sb_time, --
  f_sb_unknown_seq, --
  f_sb_unknown_enum, --
  f_sb_before_handshake, --
  f_sb_static_ff, --
  f_sb_static_02, --
  f_sb_hello_sync, --
  f_sb_pkt_orig_type, --
  f_sb_session_id, --
  f_sb_player, --
  f_persona_id, --
  f_persona_name, --
  f_sb_pkt_size, --
  f_sb_pkt, --
  f_sb_pkt_end, --
  f_sb_sub_pkt_size, --
  f_sb_sub_pkt, --
  f_sb_crc --
}

function p_soapbox.init()
end

function p_soapbox_freeroam.init()
end

function p_soapbox.dissector (buf, pkt, root)
  if buf:len() == 0 then return end
  pkt.cols.protocol = "SB-RACE"
  local subtree = root:add(p_soapbox, buf(0))
  subtree:add(f_sb_pkt_orig_type, buf(0,1)):append_text(" ["..detectCliSrvType(buf).."]")
  setFieldsFromType(buf, pkt, subtree)
  local cli_cli_type = detectDirection(pkt)
  if(cli_cli_type == 'srv->cli') then
    subtree:add(f_sb_crc, buf(buf:len()-4,4))
  end
end

function p_soapbox_freeroam.dissector(buf, pkt, root)
  if buf:len() == 0 then return end
  pkt.cols.protocol = "SB-FREEROAM"
  local subtree = root:add(p_soapbox, buf(0))
  local cli_cli_type = detectDirection(pkt)
  subtree:add(f_sb_count, buf(0,2))
  if(cli_cli_type == 'cli->srv') and buf(2,1):bytes() == ByteArray.new("07") then
    setTimeField(buf, subtree, 4)
    if buf:len() > 15 then
      setSubPackets(16,buf,pkt,subtree)
    end
  elseif cli_cli_type == 'srv->cli' and buf:len() > 12 then
    subtree:add(f_sb_static_02, buf(2,1))
    setTimeField(buf, subtree, 3)
    subtree:add(f_sb_hello_sync, buf(5,2))
    subtree:add(f_sb_unknown_seq, buf(7,2))
    setSubPackets(13,buf,pkt,subtree)
  end
  subtree:add(f_sb_crc, buf(buf:len()-4,4))
  pkt.cols.info = 'FreeRoam Protocol ['..cli_cli_type..']'
end

local udp_dissector_table = DissectorTable.get("udp.port")
dissector = udp_dissector_table:get_dissector(9998)
udp_dissector_table:add(9998, p_soapbox)
udp_dissector_table:add(9999, p_soapbox_freeroam)