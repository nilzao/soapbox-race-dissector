function setSyncKeepAliveFields(buf, pkt, subtree)
  --  subtree:add(f_command, buf(0,2)):append_text(" [Command text]")
  --  subtree:append_text(", Hello World!")
  pkt.cols.protocol = 'SB-SYNC-KA'
  pkt.cols.info = 'Sync Keep Alive Protocol'
end
