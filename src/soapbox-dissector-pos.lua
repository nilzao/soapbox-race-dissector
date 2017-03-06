function setPosFields(buf, pkt, subtree)
  local cli_cli_type = detectDirection(pkt)
  setPlayerField(buf, subtree)
  setPacketSizeField(buf,pkt,subtree)
  setCountField(buf,pkt,subtree)
  setBeforeHandShakeField(buf,pkt,subtree)
  setStaticFFp2pField(buf,pkt,subtree)
  setUnknownP2PEnum(buf, pkt, subtree)
  setSubPacketSize(buf, pkt, subtree)
  setUnknownP2PSequence(buf, pkt, subtree, 10)
  pkt.cols.protocol = 'SB-POS'
  pkt.cols.info = 'Position Protocol ['..cli_cli_type..']'
end
