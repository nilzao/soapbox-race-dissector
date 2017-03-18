function setIdFields(start, buf, pkt, subtree)
  local cli_cli_type = detectDirection(pkt)
  subtree:add(f_persona_name, buf(start + 3,32))
  if(cli_cli_type == 'cli->srv') then
    subtree:add(f_persona_id, buf(start +35,4))
  end
end
