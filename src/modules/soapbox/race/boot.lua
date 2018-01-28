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

p_soapbox_race = Proto ("SB-RACE","Soapbox-race ")

function p_soapbox_race.init()
end

function p_soapbox_race.dissector (buf, pkt, root)
  if buf:len() == 0 then return end
  pkt.cols.protocol = "SB-RACE"
  local subtree = root:add(p_soapbox, buf(0))
  local cli_cli_type = detectDirection(pkt)
  subtree:add(f_sb_mp_pkt_owner, buf(0, 1))
  if(cli_cli_type == 'cli->srv') then
    if (buf(0, 1):int() == 0) then
      subtree:add(f_sb_count, buf(1,2))
      subtree:add(f_sb_srv_pkt_type, buf(3, 1))
      if(buf(3, 1):int() == 6) then
        pkt.cols.protocol = "SB-HELLO"
        subtree:add(f_sb_crypto_ticket, buf(4, 32))
        subtree:add(f_sb_ticket_iv, buf(36, 32))
        setUnknown(buf, subtree, 68, 1)
        setCliHelloTime(buf, subtree, 69)
      elseif (buf(3, 1):int() == 7) then
        subtree:add(f_sb_srv_pkt_type, buf(4, 1))
        setTimeField(buf,subtree, 5)
        subtree:add(f_sb_count_5sec, buf(7,2))
        if(buf():len() == 26) then
          pkt.cols.protocol = "SB-SYNC-START"
          setUnknown(buf, subtree, 9, 7)
          subtree:add(f_sb_session_id, buf(16,4))
          setUnknown(buf, subtree, 20, 2)
        elseif(buf():len() == 22) then
          pkt.cols.protocol = "SB-SYNC"
          setUnknown(buf, subtree, 9, 9)
        elseif(buf():len() == 18) then
          pkt.cols.protocol = "SB-KEEP-ALIVE"
          setUnknown(buf, subtree, 9, 5)
        end
      end
      subtree:add(f_sb_crc, buf(buf:len()-4,4))
    elseif (buf(0, 1):int() == 1) then
      setUnknown(buf, subtree, 1, 2)
      subtree:add(f_sb_pkt_size, buf(3,1))
      setUnknown(buf, subtree, 4, 6)
      setSubPackets(10, buf, pkt, subtree)
      subtree:add(f_sb_crc, buf(buf:len()-5,4))
      subtree:add(f_sb_pkt_end, buf(buf:len()-1,1))
    end
  else
    if (buf(0, 1):int() == 0) then
      subtree:add(f_sb_count, buf(1,2))
      subtree:add(f_sb_srv_pkt_type, buf(3, 1))
      setTimeField(buf,subtree, 4)
      if(buf(3,1):int() == 1) then
        pkt.cols.protocol = "SB-HELLO"
      elseif (buf(3,1):int() == 2) then
        subtree:add(f_sb_count_5sec, buf(6,2))
        if(buf():len() == 25) then
          pkt.cols.protocol = "SB-SYNC-START"
          setUnknown(buf, subtree, 8, 7)
          subtree:add(f_sb_session_id, buf(15,4))
          setUnknown(buf, subtree, 19, 2)
        elseif(buf():len() == 21) then
          pkt.cols.protocol = "SB-SYNC"
          setUnknown(buf, subtree, 8, 9)
        elseif(buf():len() == 17) then
          pkt.cols.protocol = "SB-KEEP-ALIVE"
          setUnknown(buf, subtree, 8, 5)
        end
      end
    elseif (buf(0, 1):int() == 1) then
      subtree:add(f_sb_player, buf(1,1))
      subtree:add(f_sb_count, buf(2,2))
      subtree:add(f_sb_unkown_count, buf(4,2))
      setUnknown(buf, subtree, 6, 2)
      setSubPackets(8, buf, pkt, subtree)
    end
    subtree:add(f_sb_crc, buf(buf:len()-4,4))
  end
end

local udp_dissector_table = DissectorTable.get("udp.port")
dissector = udp_dissector_table:get_dissector(9998)
udp_dissector_table:add(9998, p_soapbox_race)
