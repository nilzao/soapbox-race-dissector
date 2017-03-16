function setPlayerFields(buf, pkt, subtree)
  local cli_cli_type = detectDirection(pkt)
  setPacketSizeField(buf,pkt,subtree)
  setCountField(buf,pkt,subtree)
  setBeforeHandShakeField(buf,pkt,subtree)
  setUnknownP2PEnum(8, buf, pkt, subtree)
  setSubPacketSize(9, buf, pkt, subtree)
  local packetSize = setSubPacket(9, buf, pkt, subtree)
  packetSize = packetSize + 10
  setUnknownP2PEnum(packetSize, buf, pkt, subtree)
  packetSize = packetSize + 1
  setSubPacketSize(packetSize, buf, pkt, subtree)
  packetSize = packetSize + 1
  --packetSize = setSubPacket(packetSize, buf, pkt, subtree)

  setPacketField(buf,pkt,subtree)

  pkt.cols.protocol = 'SB-PLAYER'
  pkt.cols.info = 'Player Protocol ['..cli_cli_type..']'
end
