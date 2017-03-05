function setSyncKeepAliveFields(buf, pkt, subtree)
  setCountField(buf, subtree, 2)
  setTimeField(buf,subtree,4)
  pkt.cols.protocol = 'SB-SYNC-KA'
  pkt.cols.info = 'Sync Keep Alive Protocol'
end
