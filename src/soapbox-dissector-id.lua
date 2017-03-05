function setIdFields(buf, pkt, subtree)
  --  subtree:add(f_command, buf(0,2)):append_text(" [Command text]")
  --  subtree:append_text(", Hello World!")
  pkt.cols.protocol = 'SB-ID'
  pkt.cols.info = 'ID Protocol'
end
