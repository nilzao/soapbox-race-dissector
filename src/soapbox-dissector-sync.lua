function setSyncFields(buf, pkt, subtree)
  if(cli_cli_type == 'srv->cli') then
    setCountField(buf, subtree, 2)
    setTimeField(buf,subtree,4)
  end
  pkt.cols.protocol = 'SB-SYNC'
  pkt.cols.info = 'Sync Protocol'
end
