function setPosFields(buf, pkt, subtree)
  --  subtree:add(f_command, buf(0,2)):append_text(" [Command text]")
  --  subtree:append_text(", Hello World!")
  cli_cli_type = detectCliCliType(buf)
  setPlayerField(buf, subtree)
  setCountFieldCliCli(buf, subtree, cli_cli_type)
  pkt.cols.protocol = 'SB-POS'
  pkt.cols.info = 'Position Protocol ['..cli_cli_type..']'
end
