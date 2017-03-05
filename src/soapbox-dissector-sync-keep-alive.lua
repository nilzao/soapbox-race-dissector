function setSyncKeepAliveFields(buf, pkt, subtree)
  local cli_cli_type = detectDirection(pkt)
  if(cli_cli_type == 'srv->cli') then
    setCountField(buf, subtree, 2)
    setTimeField(buf,subtree,4)
  end
  pkt.cols.protocol = 'SB-SYNC-KA'
  pkt.cols.info = 'Sync Keep Alive Protocol ['..cli_cli_type..']'
end
