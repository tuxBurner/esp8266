id=0
sda=3
scl=4

-- initialize i2c, set pin1 as sda, set pin0 as scl
i2c.setup(id,sda,scl,i2c.SLOW)

-- user defined function: read from reg_addr content of dev_addr
function read_reg(dev_addr, reg_addr)
  i2c.start(id)
  i2c.address(id, dev_addr ,i2c.TRANSMITTER)
  i2c.write(id,reg_addr)
  i2c.stop(id)
  i2c.start(id)
  i2c.address(id, dev_addr,i2c.RECEIVER)
  c=i2c.read(id,1)
  i2c.stop(id)
  return c
end

function write_reg(dev_addr, reg_addr, reg_val)
  i2c.start(id)
  i2c.address(id, dev_addr, i2c.TRANSMITTER)
  i2c.write(id, reg_addr)
  i2c.write(id, reg_val)
  i2c.stop(id)
end

-- get content of register 0xAA of device 0x77
write_reg(0x20, 0x00, 0x00) -- set bank A to output
write_reg(0x20, 0x01, 0x00) -- set bank B to output

--for i=0,255 do
--  print("Setting bank A to value " .. i)
  --write_reg(0x20, 0x12, i)
--  write_reg(0x20, 0x13, i)
--  tmr.delay(100000)
--  tmr.wdclr()
--end

-- write bank A
write_reg(0x20, 0x12, 8)

--wrie bank B
write_reg(0x20, 0x13, 255)
