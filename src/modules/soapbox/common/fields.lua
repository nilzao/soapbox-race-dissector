p_soapbox = Proto ("SBRW","Soapbox-race-world ")

f_sb_pkt_orig_type = ProtoField.uint16("soapbox.pktorig", "Pkg Orig", base.BOOLEAN)
f_sb_count = ProtoField.uint16("soapbox.count", "Counter", base.DEC)
f_sb_srv_pkt_type = ProtoField.bytes("soapbox.srvtype", "Srv Pkt Type", base.HEX)
f_sb_time = ProtoField.uint16("soapbox.time", "Time", base.DEC)
f_sb_fr_cli_hello_time = ProtoField.uint16("soapbox.clihellotime", "Cli Hello Time", base.DEC)
f_sb_fr_frag_count = ProtoField.uint16("soapbox.fragcount", "Fragmented counter", base.DEC)
f_sb_before_handshake = ProtoField.uint16("soapbox.beforehs", "Before HandShake", base.HEX)
f_sb_unknown = ProtoField.bytes("soapbox.unknown", "Uknown", base.HEX)
f_sb_fr_slot = ProtoField.bytes("soapbox.frslot", "Freeroam Slot")
f_sb_unknown_seq = ProtoField.uint16("soapbox.unknownseq", "Uknown Seq", base.HEX)
f_sb_unknown_enum = ProtoField.uint16("soapbox.unknownenum", "SubPkt Type", base.HEX)
f_sb_static_ff = ProtoField.uint16("soapbox.staticff", "Static 0xFF", base.HEX)
f_sb_static_02 = ProtoField.uint16("soapbox.static02", "Static 0x02", base.HEX)
f_sb_hello_sync = ProtoField.uint16("soapbox.hellosync", "Hello Sync", base.HEX)
f_sb_crc = ProtoField.uint16("soapbox.crc", "CRC", base.HEX)
f_sb_player = ProtoField.uint16("soapbox.playeridx", "Player idx", base.DEC)
f_sb_session_id = ProtoField.uint16("soapbox.sessionid", "Session Id", base.HEX)
f_persona_name = ProtoField.string("soapbox.personaid", "Persona Name", base.UNIT_STRING)
f_persona_id = ProtoField.uint16("soapbox.personaid", "Persona Id", base.HEX)
f_sb_pkt_size = ProtoField.uint16("soapbox.pktsize", "Pkt Size", base.DEC)
f_sb_pkt = ProtoField.bytes("soapbox.pkt", "Pkt")
f_sb_pkt_end = ProtoField.uint16("soapbox.pktend", "Packet End", base.HEX)
f_sb_sub_pkt_size = ProtoField.uint16("soapbox.subpktsize", "SubPkt Size", base.DEC)
f_sb_sub_pkt = ProtoField.bytes("soapbox.subpkt", "SubPkt")
f_sb_crypto_ticket = ProtoField.bytes("soapbox.cryptotkt", "Crypto Ticket", base.HEX)
f_sb_ticket_iv = ProtoField.bytes("soapbox.ticketiv", "Ticket IV", base.HEX)
f_sb_chan_info = ProtoField.string("soapbox.channel", "Channel", base.UNIT_STRING)
f_sb_flying = ProtoField.bool("soapbox.notflying", "fly bit", 16,{"ground","flying"},8)
f_sb_y = ProtoField.uint32("soapbox.cary", "car Y ", base.DEC, null, 524284)
f_sb_z = ProtoField.uint32("soapbox.carz", "car Z ", base.DEC, null, 262080)
f_sb_z2 = ProtoField.uint32("soapbox.carz", "car Z+", base.DEC, null, 131040)
f_sb_x = ProtoField.uint32("soapbox.carx", "car X ", base.DEC, null, 4194288)
f_sb_x2 = ProtoField.uint32("soapbox.carx", "car X+", base.DEC, null, 2097144)
f_sb_mp_pkt_owner = ProtoField.bytes("soapbox.mpowner", "Mp Pkt Type", base.HEX)
f_sb_unkown_count = ProtoField.uint16("soapbox.unknowncount", "Unkown Counter", base.DEC)

p_soapbox.fields = {--
  f_sb_count, --
  f_sb_srv_pkt_type, --
  f_sb_time, --
  f_sb_fr_cli_hello_time, --
  f_sb_fr_frag_count, --
  f_sb_unknown, --
  f_sb_fr_slot, --
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
  f_sb_crc, --
  f_sb_crypto_ticket, --
  f_sb_ticket_iv, --
  f_sb_chan_info, --
  f_sb_flying, --
  f_sb_y, --
  f_sb_z, --
  f_sb_z2, --
  f_sb_x, --
  f_sb_x2, --
  f_sb_mp_pkt_owner, --
  f_sb_unkown_count --
}

function p_soapbox.init()
end
