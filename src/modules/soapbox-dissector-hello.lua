function setHelloFields(buf, pkt, subtree)
  setCountField(buf,pkt,subtree)
  local cli_cli_type = detectDirection(pkt)
  if(cli_cli_type == 'srv->cli') then
    setTimeField(buf,subtree,4)
  end
  pkt.cols.protocol = 'SB-HELLO'
  pkt.cols.info = 'Hello Protocol ['..cli_cli_type..']'
end
