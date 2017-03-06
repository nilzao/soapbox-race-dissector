function setSyncSessionFields(buf, pkt, subtree)
  local cli_cli_type = detectDirection(pkt)
  if(cli_cli_type == 'srv->cli') then
    setTimeField(buf,subtree,4)
    subtree:add(f_sb_session_id, buf(15,4))
  else
    subtree:add(f_sb_session_id, buf(16,4))
  end
  pkt.cols.protocol = 'SB-SYNC-S'
  pkt.cols.info = 'Sync Session Protocol ['..cli_cli_type..']'
end
