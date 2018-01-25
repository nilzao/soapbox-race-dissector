function setStatePosFields(start, buf, pkt, subtree)
  --local cli_cli_type = detectDirection(pkt)
  --if(cli_cli_type == 'cli->srv') then
    setTimeField(buf, subtree, start + 2)
  --end
end
