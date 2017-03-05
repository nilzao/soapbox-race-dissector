function setIdFields(buf, pkt, subtree)
  local cli_cli_type = detectDirection(pkt)
  setPlayerField(buf, subtree)
  setCountFieldCliCli(buf, subtree, cli_cli_type)
  pkt.cols.protocol = 'SB-ID'
  pkt.cols.info = 'ID Protocol ['..cli_cli_type..']'
end
