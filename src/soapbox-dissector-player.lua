function setPlayerFields(buf, pkt, subtree)
  local cli_cli_type = detectDirection(pkt)
  setPlayerField(buf, subtree)
  setPacketSizeField(buf,pkt,subtree)
  setCountField(buf,pkt,subtree)
  setBeforeHandShakeField(buf,pkt,subtree)
  setStaticFFp2pField(buf,pkt,subtree)
  local unknownEnum = setUnknownP2PEnum(8, buf, pkt, subtree)
  local packetSize = 0
  setSubPacketSize(9, buf, pkt, subtree)
  --setUnknownP2PSequence(buf, pkt, subtree, 10)
  if(unknownEnum == 2) then
    setIdFields(buf,pkt,subtree)
  end
  packetSize = setSubPacket(9, buf, pkt, subtree)
  packetSize = packetSize + 10
  unknownEnum = setUnknownP2PEnum(packetSize, buf, pkt, subtree)
  local packetPos =0
  if(unknownEnum ~= -1) then
    packetPos = packetSize + 1
    setSubPacketSize(packetPos, buf, pkt, subtree)
    packetSize = setSubPacket(packetPos, buf, pkt, subtree) + 1
    unknownEnum = setUnknownP2PEnum(packetSize, buf, pkt, subtree)
  end
  setPacketField(buf,pkt,subtree)

  pkt.cols.protocol = 'SB-PLAYER'
  pkt.cols.info = 'Player Protocol ['..cli_cli_type..']'..packetPos
end
