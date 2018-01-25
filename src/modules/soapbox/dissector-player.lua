function setPlayerFields(buf, pkt, subtree)
  local cli_cli_type = detectDirection(pkt)
  setPlayerField(buf, subtree)
  setPacketSizeField(buf,pkt,subtree)
  setCountField(buf,pkt,subtree)
  setBeforeHandShakeField(buf,pkt,subtree)
  setStaticFFp2pField(buf,pkt,subtree)
  if cli_cli_type == 'cli->srv' then
    setSubPackets(10,buf,pkt,subtree)
  else
    setSubPackets(8,buf,pkt,subtree)
  end
  pkt.cols.protocol = 'SB-PLAYER'
  pkt.cols.info = 'Player Protocol ['..cli_cli_type..']'
end
