function setIdFields(buf, pkt, subtree)
  local cli_cli_type = detectDirection(pkt)
  setPlayerField(buf, subtree)
  setCountField(buf,pkt,subtree)
  setPacketSizeField(buf,pkt,subtree)
  if(cli_cli_type == 'srv->cli') then
    subtree:add(f_persona_name, buf(11,32))
  else
    subtree:add(f_persona_name, buf(13,32))
    subtree:add(f_persona_id, buf(45,4))
  end
  pkt.cols.protocol = 'SB-ID'
  pkt.cols.info = 'ID Protocol ['..cli_cli_type..']'
end
