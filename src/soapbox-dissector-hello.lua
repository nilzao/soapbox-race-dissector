function setHelloFields(buf, pkt, subtree)
  --  subtree:add(f_command, buf(0,2)):append_text(" [Command text]")
  --  subtree:append_text(", Hello World!")
  pkt.cols.protocol = 'SB-HELLO'
  pkt.cols.info = 'Hello Protocol'
end
