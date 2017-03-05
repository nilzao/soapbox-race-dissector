function setSyncFields(buf, pkt, subtree)
  setCountField(buf, subtree, 2)
  setTimeField(buf,subtree,4)
  pkt.cols.protocol = 'SB-SYNC'
  pkt.cols.info = 'Sync Protocol'
end
