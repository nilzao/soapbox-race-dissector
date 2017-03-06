function setSyncKeepAliveFields(buf, pkt, subtree)
  setCountField(buf,pkt,subtree)
  local bytePosIni =  4 + getIniSrv2PBytePos(buf,pkt)
  setTimeField(buf,subtree,bytePosIni)
  local cli_cli_type = detectDirection(pkt)
  pkt.cols.protocol = 'SB-SYNC-KA'
  pkt.cols.info = 'Sync Keep Alive Protocol ['..cli_cli_type..']'
end
