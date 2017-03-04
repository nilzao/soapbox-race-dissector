function getSyncFields()
  local f_command = ProtoField.uint16("soapbox.command", "Command", base.HEX)
  local f_data = ProtoField.string("soapbox.data", "Data", FT_STRING)
  return {f_command}
end

function setSyncFields(buf, pkt, root)
  subtree = root:add(p_soapbox, buf(0))
  subtree:add(f_command, buf(0,2)):append_text(" [Command text]")
  subtree:append_text(", Hello World!")
  pkt.cols.protocol = 'SB-SYNC'
  pkt.cols.info = 'Sync Protocol'
end
