function setIdFields(buf, pkt, subtree)
  local cli_cli_type = detectDirection(pkt)
  if(cli_cli_type == 'srv->cli') then
    subtree:add(f_persona_name, buf(11,32))
  else
    subtree:add(f_persona_name, buf(13,32))
    subtree:add(f_persona_id, buf(45,4))
  end
end
