function detectCliSrvType(buf)
  if (buf(0):bytes():subset(0,1) == ByteArray.new("01")) then
    return "p2p"
  end
  return "srv2p"
end

function detectDirection(pkt)
  -- quickfix with static port 9998 and 9999, not nice...
  if pkt.dst_port == 9998 or pkt.dst_port == 9999 then
    return "cli->srv"
  end
  return "srv->cli"
end

function getIniP2PBytePos(buf, pkt)
  local direction = detectDirection(pkt)
  if direction == "srv->cli" then
    return 0
  else
    return 2
  end
end

function getIniSrv2PBytePos(buf, pkt)
  local direction = detectDirection(pkt)
  if direction == "srv->cli" then
    return 0
  else
    return 1
  end
end

function detectType(buf, pkt)
  local bytes = buf(0):bytes()
  if ( bytes:len() == 18 or bytes:len() == 17) then
    return "sync-keep-alive"
  elseif bytes:len() == 26 or bytes:len() == 25  then
    return "sync-session"
  elseif bytes:len() == 22 or bytes:len() == 21 then
    return "sync"
  elseif (bytes:subset(0,1) == ByteArray.new("01") )then
    return "player"
  elseif (bytes:len() == 12 or bytes:len() == 75) then
    if (bytes:subset(4,1) == ByteArray.new("06")) then
      return "hello"
    end
  end
  return "hello"
end

function setFieldsFromType(buf, pkt, root)
  if(detectType(buf, pkt) == "hello") then
    setHelloFields(buf,pkt,root)
  elseif(detectType(buf, pkt) == "player") then
    setPlayerFields(buf, pkt, root)
  elseif (detectType(buf, pkt) == "sync-keep-alive") then
    setSyncKeepAliveFields(buf,pkt,root)
  elseif (detectType(buf, pkt) == "sync-session") then
    setSyncSessionFields(buf,pkt,root)
  elseif (detectType(buf, pkt) == "sync") then
    setSyncFields(buf,pkt,root)
  end
end

function setCountField(buf, pkt, subtree)
  local cli_srv_type = detectCliSrvType(buf)
  local direction = detectDirection(pkt)
  if direction == "srv->cli" then
    if cli_srv_type == "srv2p" then
      subtree:add(f_sb_count, buf(1,2))
    else
      subtree:add(f_sb_count, buf(2,2))
    end
  else
    if cli_srv_type == "srv2p" then
      subtree:add(f_sb_count, buf(1,2))
    else
      subtree:add(f_sb_count, buf(4,2))
    end
  end
end

function setTimeField(buf, subtree, pos_ini)
  subtree:add(f_sb_time, buf(pos_ini,2))
end

function setCliHelloTime(buf, subtree, pos_ini)
  subtree:add(f_sb_fr_cli_hello_time, buf(pos_ini,2))
end

function setFragCount(buf, subtree, pos_ini)
  subtree:add(f_sb_fr_frag_count, buf(pos_ini,2))
end

function setUnknown(buf, subtree, pos_ini,size)
  subtree:add(f_sb_unknown, buf(pos_ini,size))
end



function setPlayerField(buf, subtree)
  subtree:add(f_sb_player, buf(1,1))
end

function setPacketSizeField(buf,pkt,subtree)
  local direction = detectDirection(pkt)
  if direction == "cli->srv" then
    subtree:add(f_sb_pkt_size, buf(3,1))
  end
end

function setPacketField(buf,pkt,subtree)
  local direction = detectDirection(pkt)
  if direction == "cli->srv" then
    local packetSize = buf(3,1):int()
    subtree:add(f_sb_pkt, buf(4,packetSize))
  end
end

function setStaticFFp2pField(buf,pkt,subtree)
  local direction = detectDirection(pkt)
  local byteStart = 6 + getIniP2PBytePos(buf,pkt)
  subtree:add(f_sb_static_ff, buf(byteStart,2))
end

function setBeforeHandShakeField(buf, pkt, subtree)
  local byteStart = 4 + getIniP2PBytePos(buf,pkt)
  local direction = detectDirection(pkt)
  local bytes = buf(0):bytes()
  local staticFF = ByteArray.new("FFFF")
  if bytes:subset(byteStart,2) == staticFF then
    subtree:add(f_sb_before_handshake, buf(byteStart,2))
  else
    subtree:add(f_sb_unknown_seq, buf(byteStart,2))
  end
end

function setSubPackets(start, buf, pkt, subtree)
  local position = start
  subtree:add(f_sb_unknown_enum, buf(position,1))
  position = position + 1
  local pktSize = buf(position,1):int()
  subtree:add(f_sb_sub_pkt_size, buf(position,1))
  position = position + 1
  local subPacketTree = subtree:add( f_sb_sub_pkt, buf(position,pktSize) )
  --  subtree:add(f_sb_sub_pkt, buf(position,pktSize))
  setSubPacketDetails(start, buf, pkt, subPacketTree)
  position = position + pktSize
  if buf(position,1):int() ~= -1 then
    setSubPackets(position, buf, pkt, subtree)
  elseif buf(position+1,1):int() == 0 then
    subtree:add(f_sb_pkt_end, buf(position,1))
  end
end

function setSubPacketDetails(start, buf, pkt, subtree)
  local unknownEnum = buf(start,1):bytes()
  if unknownEnum == ByteArray.new("00") then
  -- freeroam channel
  elseif unknownEnum == ByteArray.new("01") then
    -- freeroam player id
    subtree:add(f_persona_name, buf(start + 3,32))
    subtree:add(f_persona_id, buf(start + 43, 4))
  elseif unknownEnum == ByteArray.new("02") then
    -- race player id
    setIdFields(start, buf, pkt, subtree)
  elseif unknownEnum == ByteArray.new("10") then
  --
  elseif unknownEnum == ByteArray.new("11") then
  --
  elseif unknownEnum == ByteArray.new("12") then
    setStatePosFields(start,buf,pkt,subtree)
  end
end

function getSubPacketSizeOnce(start, buf)
  if buf:len() < (start + 1) then
    return 0
  end
  local pktSize = buf(start + 1,1):int()
  if(pktSize <= 0) then
    return 0
  end
  return pktSize +2
end

function getSubPacketSize(start, buf)
  local pktSize = getSubPacketSizeOnce(start, buf)
  local position = 0

  position = start + pktSize
  pktSize = pktSize + getSubPacketSizeOnce(position, buf)

  position = start + pktSize
  pktSize = pktSize + getSubPacketSizeOnce(position, buf)

  return pktSize +2
end

function setFreeroamSlots(buf, subtree, pos_ini, pkt)
  local slotsEnd = buf:len()-4
  local i = pos_ini
  local size = 2
  while i < slotsEnd  do
    if(buf(i,1):int() == -1) then
      size = i - pos_ini + 1
      if ((buf(pos_ini,1):int() == -1) or (buf(pos_ini,1):int() == 0)) then
        if (buf(pos_ini+1,1):int() == -1) then
          local freeroamSlotTree = subtree:add( f_sb_fr_slot, buf(pos_ini, size) )
        elseif (buf(pos_ini,1):int() == 0) then
          size = getSubPacketSize(pos_ini+1, buf)
          if(buf():len() < pos_ini + size)then
            size = buf():len() - pos_ini - 4
          end
          local freeroamSlotTree = subtree:add( f_sb_fr_slot, buf(pos_ini, size) )
          setSubPackets(pos_ini+1, buf, pkt, freeroamSlotTree)
        end
      end
      pos_ini = i+1
      i= i+1
    end
    i= i+1
  end
end

