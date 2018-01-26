function setStatePosFields(start, buf, pkt, subtree)
  setTimeField(buf, subtree, start + 2)
  subtree:add(f_sb_flying, buf(start + 4, 1))
  local notflying = buf:range(start + 4, 1):bitfield(4)
  if(notflying == 1) then
    subtree:add(f_sb_y, buf(start + 5, 3))
    local yHeader = buf:range(start + 5, 3):bitfield(4,10)
    if(yHeader < 971) then
      subtree:add(f_sb_z, buf(start + 7, 3))
      subtree:add(f_sb_x, buf(start + 9, 3))
    else
      subtree:add(f_sb_z2, buf(start + 7, 3))
      subtree:add(f_sb_x2, buf(start + 9, 3))
    end

  end
end
