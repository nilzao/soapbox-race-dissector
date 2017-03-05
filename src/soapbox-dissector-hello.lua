function setHelloFields(buf, pkt, subtree)
  pkt.cols.protocol = 'SB-HELLO'
  pkt.cols.info = 'Hello Protocol'
end
