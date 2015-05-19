------------------------------------------------------------------------------
-- MCP23017_module
--
-- LICENCE: http://opensource.org/licenses/MIT
-- Vladimir Dronnikov <dronnikov@gmail.com>
--
-- Example:
-- dofile("irsend.lua").nec(4, 0x00ff00ff)
-----------------------------------------------------------------------------
local moduleName = ... 
local M = {}
_G[moduleName] = M 

  -- const 
  local MCP23017_ADDRESS = 0x20
  -- OLAT BANKS REG
  local MCP23017_OLATA=0x14
  local MCP23017_OLATB=0x15
  -- DIRECTIONS REG
  local MCP23017_IODIRA=0x00
  local MCP23017_IODIRB=0x01

  -- function for setup
  begin = function(pinSDA,pinSCL)
    i2c.setup(id,pinSDA,pinSCL,i2c.SLOW)
    write_reg(MCP23017_IODIRA, 0x00) -- set bank A to output
    write_reg(MCP23017_IODIRB, 0x00) -- set bank B to output
    write_reg(MCP23017_OLATA,0x00) -- all to low on A
    write_reg(MCP23017_OLATB,0x00) --all to low on B
  end

return M 