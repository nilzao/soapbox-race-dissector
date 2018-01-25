local debug   = require "debug"

function script_path()
  str = debug.getinfo(1, "S").source:sub(2)
  return str:match("(.*/)")
end

__DIR__ = script_path() .."src"
__DIR_SEPARATOR__ = package.path:match( "(%p)%?%." )

_G['protbuf_dissector'] = {
  ["__DIR__"] = __DIR__,
  ["__DIR_SEPARATOR__"] = __DIR_SEPARATOR__,
}

package.prepend_path("modules")
require "soapbox.boot"
