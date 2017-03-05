function detectCliSrvType(buf)
  if (buf(0):bytes():subset(0,1) == ByteArray.new("01")) then
    return "cli-to-cli"
  end
  return "srv"
end

function detectCliCliType(buf)
  -- bug, when cli-to-cli-srv counter reach 0027 or 0073 mark a false srv-to-cli
  --  0027 and 0073 are packet size, need to implement right detection
  local bytes = buf(0):bytes():subset(2,2)
  if (bytes == ByteArray.new("0027") or bytes == ByteArray.new("0073")) then
    return "cli-to-srv"
  end
  return "srv-to-cli"
end


function detectType(buf)
  local bytes = buf(0):bytes()
  if ( bytes:len() == 18 or bytes:len() == 17) then
    return "sync-keep-alive"
  elseif bytes:len() == 26 or bytes:len() == 25  then
    return "sync-session"
  elseif bytes:len() == 22 or bytes:len() == 21 then
    return "sync"
  elseif (bytes:subset(0,1) == ByteArray.new("01") )then
    if (bytes:subset(9,1) == ByteArray.new("02") or bytes:subset(10,1) == ByteArray.new("02")) then
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
  if (detectType(buf) == "hello") then
    return getHelloFields()
  elseif (detectType(buf) == "id") then
    return getIdFields()
  elseif (detectType(buf) == "pos") then
    return getPosFields()
  elseif (detectType(buf) == "sync-keep-alive") then
    return getSyncKeepAliveFields()
  elseif (detectType(buf) == "sync-session") then
    return getSyncSessionFields()
  elseif (detectType(buf) == "sync") then
    return getSyncFields()
  end
end

function setFieldsFromType(buf, pkt, root)
  if(detectType(buf) == "hello") then
    setHelloFields(buf,pkt,root)
  elseif (detectType(buf) == "id") then
    setIdFields(buf,pkt,root)
  elseif (detectType(buf) == "pos") then
    setPosFields(buf,pkt,root)
  elseif (detectType(buf) == "sync-keep-alive") then
    setSyncKeepAliveFields(buf,pkt,root)
  elseif (detectType(buf) == "sync-session") then
    setSyncSessionFields(buf,pkt,root)
  elseif (detectType(buf) == "sync") then
    setSyncFields(buf,pkt,root)
  end
end


function setCountField(buf, subtree, pos_ini)
  subtree:add(f_sb_count, buf(pos_ini,2))
end

function setCountFieldCliCli(buf, subtree, cli_cli_type)
  if cli_cli_type == "srv-to-cli" then
    setCountField(buf, subtree, 2)
  else
    subtree:add(f_sb_pkg_size, buf(2,2))
  end
end

function setPlayerField(buf, subtree)
  subtree:add(f_sb_player, buf(1,1))
end
