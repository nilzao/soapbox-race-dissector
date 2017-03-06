function detectCliSrvType(buf)
  if (buf(0):bytes():subset(0,1) == ByteArray.new("01")) then
    return "p2p"
  end
  return "srv2p"
end

function detectDirection(pkt)
  -- bug, when cli-to-cli-srv counter reach 0027 or 0073 mark a false srv-to-cli
  -- 0027 and 0073 are packet size, need to implement right detection
  -- local bytes = buf(0):bytes():subset(2,2)
  -- if (bytes == ByteArray.new("0027") or bytes == ByteArray.new("0073")) then

  -- quickfix with static port 9998, not nice...
  if pkt.dst_port == 9998 then
    return "cli->srv"
  end
  return "srv->cli"
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
    local cli_cli_type = detectDirection(pkt)
    local byteId = bytes:subset(10,1)
    if cli_cli_type == "srv->cli" then
      byteId = bytes:subset(8,1)
    end
    if (byteId == ByteArray.new("02")) then
      return "id"
    end
    return "pos"
      --    if (bytes:subset(10,1) == ByteArray.new("02")) then
      --      return "id"
      --    elseif bytes:subset(10,1) == ByteArray.new("12") or
      --      bytes:subset(10,1) == ByteArray.new("11") or
      --      bytes:subset(10,1) == ByteArray.new("10") then
      --      return "pos"
      --    end
  elseif (bytes:len() == 12 or bytes:len() == 75) then
    if (bytes:subset(4,1) == ByteArray.new("06")) then
      return "hello"
    end
  end
  return "hello"
end

function getFieldsFromType(buf, pkt, root)
  if (detectType(buf, pkt) == "hello") then
    return getHelloFields()
  elseif (detectType(buf, pkt) == "id") then
    return getIdFields()
  elseif (detectType(buf, pkt) == "pos") then
    return getPosFields()
  elseif (detectType(buf, pkt) == "sync-keep-alive") then
    return getSyncKeepAliveFields()
  elseif (detectType(buf, pkt) == "sync-session") then
    return getSyncSessionFields()
  elseif (detectType(buf, pkt) == "sync") then
    return getSyncFields()
  end
end

function setFieldsFromType(buf, pkt, root)
  if(detectType(buf, pkt) == "hello") then
    setHelloFields(buf,pkt,root)
  elseif (detectType(buf, pkt) == "id") then
    setIdFields(buf,pkt,root)
  elseif (detectType(buf, pkt) == "pos") then
    setPosFields(buf,pkt,root)
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
  end
end

function setTimeField(buf, subtree, pos_ini)
  subtree:add(f_sb_time, buf(pos_ini,2))
end

function setPlayerField(buf, subtree)
  subtree:add(f_sb_player, buf(1,1))
end

function setPacketSizeField(buf,pkt,subtree)
  local direction = detectDirection(pkt)
  if direction == "cli->srv" then
    subtree:add(f_sb_pkt_size, buf(2,2))
  end
end
