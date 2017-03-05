function setPosFields(buf, pkt, subtree)
  cli_cli_type = detectCliCliType(pkt)
  setPlayerField(buf, subtree)
  setCountFieldCliCli(buf, subtree, cli_cli_type)
  pkt.cols.protocol = 'SB-POS'
  pkt.cols.info = 'Position Protocol ['..cli_cli_type..']'
end
