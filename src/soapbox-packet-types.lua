function detectCliSrvType(buf)
  if (bytes:subset(0,1) == ByteArray.new("01")) then
    return "cli-to-cli"
  end
  return "srv"
end

function detectType(buf)
  bytes = buf(0):bytes()
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
