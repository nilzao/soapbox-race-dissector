local debug   = require "debug"

function script_path()
  str = debug.getinfo(1, "S").source:sub(2)
  return str:match("(.*/)")
end

SOAPBOX_DISSECTOR_PATH = script_path() .."src/modules/"
__DIR_SEPARATOR__ = package.path:match( "(%p)%?%." )

dofile(SOAPBOX_DISSECTOR_PATH.."soapbox-dissector-boot.lua")
