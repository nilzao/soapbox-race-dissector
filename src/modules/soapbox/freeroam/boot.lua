require "soapbox.common.fields"
require "soapbox.dissector-hello"
require "soapbox.dissector-player"
require "soapbox.dissector-statepos"
require "soapbox.dissector-id"
require "soapbox.dissector-pos"
require "soapbox.dissector-sync-keep-alive"
require "soapbox.dissector-sync-session"
require "soapbox.dissector-sync"
require "soapbox.packet-types"

p_soapbox_freeroam = Proto ("SB-FREEROAM","Soapbox-freeroam ")

function p_soapbox_freeroam.init()
end

function p_soapbox_freeroam.dissector(buf, pkt, root)
  if buf:len() == 0 then return end
  pkt.cols.protocol = "SB-FREEROAM"
  local subtree = root:add(p_soapbox, buf(0))
  local cli_cli_type = detectDirection(pkt)
  subtree:add(f_sb_count, buf(0,2))
  subtree:add(f_sb_srv_pkt_type, buf(2, 1))
  if(cli_cli_type == 'cli->srv') then
    if buf(2,1):int() == 6 then
      pkt.cols.protocol = "SB-HELLO"
      subtree:add(f_sb_crypto_ticket, buf(3, 32))
      subtree:add(f_sb_ticket_iv, buf(35, 16))
      setUnknown(buf, subtree, 51, 1)
      setCliHelloTime(buf, subtree, 52)
    elseif buf(2,1):int() == 7 then
      subtree:add(f_sb_srv_pkt_type, buf(3, 1))
      setTimeField(buf, subtree, 4)
      subtree:add(f_sb_unknown_seq, buf(6, 2))
      subtree:add(f_sb_count, buf(8, 2))
      setUnknown(buf, subtree, 10, 6)
      setSubPackets(16, buf, pkt, subtree)
      subtree:add(f_sb_pkt_end, buf(buf:len()-5,1))
    end
  else
    setTimeField(buf, subtree, 3)
    setCliHelloTime(buf, subtree, 5)
    if buf(2,1):int() == 1 then
      pkt.cols.protocol = "SB-HELLO"
    elseif buf(2,1):int() == 2 then
      setFragCount(buf, subtree, 7)
      setUnknown(buf, subtree, 9, 3)
      setFreeroamSlots(buf, subtree, 12, pkt);
    end
  end
  subtree:add(f_sb_crc, buf(buf:len()-4,4))
  pkt.cols.info = 'FreeRoam Protocol ['..cli_cli_type..']'
end

local udp_dissector_table = DissectorTable.get("udp.port")
udp_dissector_table:add(9999, p_soapbox_freeroam)
