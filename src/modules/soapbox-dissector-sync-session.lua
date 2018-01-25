function setSyncSessionFields(buf, pkt, subtree)
  setCountField(buf,pkt,subtree)
  local bytePosIni =  4 + getIniSrv2PBytePos(buf,pkt)
  setTimeField(buf,subtree,bytePosIni)
  local cli_cli_type = detectDirection(pkt)
  bytePosIni =  15 + getIniSrv2PBytePos(buf,pkt)
  subtree:add(f_sb_session_id, buf(bytePosIni,4))
  subtree:add(f_sb_static_ff, buf(buf:len()-5,1))
  pkt.cols.protocol = 'SB-SYNC-S'
  pkt.cols.info = 'Sync Session Protocol ['..cli_cli_type..']'
end
