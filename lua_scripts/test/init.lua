id=0
sda=3
scl=4
dev_addr=0x20
i2c.setup(id,sda,scl,i2c.SLOW)
bankA=0x14
bankB=0x15
function write_reg(reg_addr, reg_val)
  i2c.start(id)
  i2c.address(id, dev_addr, i2c.TRANSMITTER)
  i2c.write(id, reg_addr)
  i2c.write(id, reg_val)
  i2c.stop(id)
end
function read_reg(reg_addr)
  i2c.start(id)
  i2c.address(id, dev_addr ,i2c.TRANSMITTER)
  i2c.write(id,reg_addr)
  i2c.stop(id)
  i2c.start(id)
  i2c.address(id, dev_addr,i2c.RECEIVER)
  local c=i2c.read(id,1)
  i2c.stop(id)
  local val=string.byte(c)
  return val
end
function setPinOnBank(bank,pin,val)
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
function setPin(pin,val)
  local bank = bankA
  if pin > 8 then
    pin = pin - 8
    bank = bankB
  end
  setPinOnBank(bank,pin,val)
end
write_reg(0x00, 0x00) -- set bank A to output
write_reg(0x01, 0x00) -- set bank B to output
write_reg(bankA,0x00) -- all to low
write_reg(bankB,0x00) --all to low