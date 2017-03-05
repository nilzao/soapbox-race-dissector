function setSyncSessionFields(buf, pkt, subtree)
  if(cli_cli_type == 'srv->cli') then
    setCountField(buf, subtree, 2)
    setTimeField(buf,subtree,4)
  end
  pkt.cols.protocol = 'SB-SYNC-S'
  pkt.cols.info = 'Sync Session Protocol'
end
