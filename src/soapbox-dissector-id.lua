function setIdFields(buf, pkt, subtree)
  local cli_cli_type = detectDirection(pkt)
  setPlayerField(buf, subtree)
  setCountFieldCliCli(buf, subtree, cli_cli_type)
  if(cli_cli_type == 'cli->srv') then
    subtree:add(f_persona_name, buf(13,32))
    subtree:add(f_persona_id, buf(45,4))
    --subtree:add(f_persona_id, buf(45,4)):append_text(' ['..persona_id_decimal..']')
  end
  pkt.cols.protocol = 'SB-ID'
  pkt.cols.info = 'ID Protocol ['..cli_cli_type..']'
end
