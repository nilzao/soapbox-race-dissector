function setPosFields(buf, pkt, subtree)
  local cli_cli_type = detectDirection(pkt)
  setPlayerField(buf, subtree)
  setCountField(buf,pkt,subtree)
  pkt.cols.protocol = 'SB-POS'
  pkt.cols.info = 'Position Protocol ['..cli_cli_type..']'
end
