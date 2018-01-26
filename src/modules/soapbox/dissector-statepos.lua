function setStatePosFields(start, buf, pkt, subtree)
  setTimeField(buf, subtree, start + 2)
  subtree:add(f_sb_flying, buf(start + 4, 1))
  local notflying = buf:range(start + 4, 1):bitfield(4)
  if(notflying == 1) then
    --parse (works only if /myposition Y > 2515
    subtree:add(f_sb_y, buf(start + 5, 3))
    subtree:add(f_sb_z, buf(start + 7, 3))
    subtree:add(f_sb_x, buf(start + 9, 3))
  end
end
