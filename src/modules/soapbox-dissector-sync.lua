function setSyncFields(buf, pkt, subtree)
  setCountField(buf,pkt,subtree)
  local bytePosIni =  4 + getIniSrv2PBytePos(buf,pkt)
  setTimeField(buf,subtree,bytePosIni)
  local cli_cli_type = detectDirection(pkt)
  subtree:add(f_sb_static_ff, buf(buf:len()-5,1))
  pkt.cols.protocol = 'SB-SYNC'
  pkt.cols.info = 'Sync Protocol ['..cli_cli_type..']'
end
