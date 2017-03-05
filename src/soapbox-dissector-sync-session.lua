function setSyncSessionFields(buf, pkt, subtree)
  setCountField(buf, subtree, 2)
  pkt.cols.protocol = 'SB-SYNC-S'
  pkt.cols.info = 'Sync Session Protocol'
end
