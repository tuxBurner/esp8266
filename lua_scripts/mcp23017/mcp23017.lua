------------------------------------------------------------------------------
-- MCP23017_module
--
-- LICENCE: http://opensource.org/licenses/MIT
-- Sebastian Hardt
-----------------------------------------------------------------------------
local moduleName = ... 
local M = {}
_G[moduleName] = M 

  -- CONSTANTS
  local MCP23017_ADDRESS = 0x20
  -- OLAT BANKS REG
  local MCP23017_OLATA=0x14
  local MCP23017_OLATB=0x15
  -- DIRECTIONS REG
  local MCP23017_IODIRA=0x00
  local MCP23017_IODIRB=0x01

  local id=0

  -- writes to the given register address
  local write_reg = function(bankAddr, reg_val)
    i2c.start(id)
    i2c.address(id, MCP23017_ADDRESS, i2c.TRANSMITTER)    
    i2c.write(id, bankAddr)
    i2c.write(id, reg_val)
    i2c.stop(id)
  end

  -- function for reading from the given bank
  local read_reg = function(bankAddr)
    i2c.start(id)
    i2c.address(id, MCP23017_ADDRESS, i2c.TRANSMITTER)    
    i2c.write(id, bankAddr)
    i2c.stop(id)
    i2c.start(id)
    i2c.address(id, MCP23017_ADDRESS,i2c.RECEIVER)
    local c=i2c.read(id,1)
    i2c.stop(id)
    local val=string.byte(c)
    return val
  end


  -- sets the pin to the val on the given bank  
  local setPinOnBank = function(bank,pin,val)
    local bankVal=read_reg(bank)
    local n = pin-1
    if n>7 or n < 0 then
      return
    end
    if val == 0 then
      bankVal = bit.clear(bankVal, n)
    end
    if val == 1 then
      bankVal = bit.set(bankVal, n)
    end  
    write_reg(bank,bankVal)
  end

  -- gets the value from the given pin
  local getPinOnBank = function(bank,pin)
    local bankVal=read_reg(bank)
    local pinState = bit.band(bit.rshift(bankVal,pin-1),0x1)
    return pinState
  end

  -- gets the current val at the bank
  M.getPin =  function(pin,val)
    local bank = MCP23017_OLATA
    if pin > 8 then
      pin = pin - 8
      bank = MCP23017_OLATB
    end
    return getPinOnBank(bank,pin)
  end

  -- set the val on the given pin
  M.setPin =  function(pin,val)
    local bank = MCP23017_OLATA
    if pin > 8 then
      pin = pin - 8
      bank = MCP23017_OLATB
    end
    setPinOnBank(bank,pin,val)
  end

  -- function for setup
  M.init = function(sda,scl)
    i2c.setup(id, sda, scl, i2c.SLOW)
    write_reg(MCP23017_IODIRA, 0x00) -- set bank A to output
    write_reg(MCP23017_IODIRB, 0x00) -- set bank B to output
    write_reg(MCP23017_OLATA,0x00) -- all to low on A
    write_reg(MCP23017_OLATB,0x00) --all to low on B
  end

return M 
