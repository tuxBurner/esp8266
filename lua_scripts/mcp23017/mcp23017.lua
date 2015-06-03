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
  local MCP23017_OLATA=0x12
  local MCP23017_OLATB=0x13
  -- DIRECTIONS REG
  local MCP23017_IODIRA=0x00
  local MCP23017_IODIRB=0x01
  -- PULLUP REG
  local MCP23017_GPPUA=0x0C
  local MCP23017_GPPUB=0x0D
  
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
  local writeValToBank = function(bank,pin,val)
    local bankVal=read_reg(bank)
    if val == 1 then
      bankVal = bit.set(bankVal, pin)
    else  
      bankVal = bit.clear(bankVal, pin)
    end  
    write_reg(bank,bankVal)
  end
  -- gets the value from the given pin
  local getPinOnBank = function(bank,pin)
    local bankVal=read_reg(bank)
    local pinState = bit.band(bit.rshift(bankVal,pin),0x1)
    return pinState
  end
  local getPinBankReg = function(pin,bankAReg,bankBreg)
    local bank = bankAReg
    if pin > 8 then
      bank = bankBreg
      pin = pin - 8
    end
    return pin-1,bank
  end
  local writeDataToPin = function(pin,val,a_reg,b_reg)
    local bankPin,bank = getPinBankReg(pin,a_reg,b_reg)
    writeValToBank(bank,bankPin,val)
  end
  -- gets the current val at the bank
  M.getPin =  function(pin)
    local bankPin,bank = getPinBankReg(pin,MCP23017_OLATA,MCP23017_OLATB)
    return getPinOnBank(bank,bankPin)
  end
  -- function for setting a pin to input or output
  M.setUpPin = function(pin,dir,pu)
    writeDataToPin(pin,dir,MCP23017_IODIRA,MCP23017_IODIRB)
    writeDataToPin(pin,pu,MCP23017_GPPUA,MCP23017_GPPUB)
  end
  -- set the val on the given pin
  M.setPin =  function(pin,val)
    writeDataToPin(pin,val,MCP23017_OLATA,MCP23017_OLATB)
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