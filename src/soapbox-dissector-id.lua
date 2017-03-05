function setIdFields(buf, pkt, subtree)
  cli_cli_type = detectCliCliType(pkt)
  setPlayerField(buf, subtree)
  setCountFieldCliCli(buf, subtree, cli_cli_type)
  pkt.cols.protocol = 'SB-ID'
  pkt.cols.info = 'ID Protocol ['..cli_cli_type..']'
end
