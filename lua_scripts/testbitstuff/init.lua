  -- all pins are set to low
pinsA = {0,0,0,0,0,0,0,0}
pinsB = {0,0,0,0,0,0,0,0}

function changePinState(pinNr, state) 
  pinsA[pinNr] = state
  valForReg = 0x00;
  for pinIdx = 1, 8 do
    valForReg = bit.bor(bit.rshift(valForReg,pinIdx) ,pinsA[pinIdx]) 
  end
  print(valForReg);
end
changePinState(1,0x1)
changePinState(8,0x1)
 --local pinState = bit.band(bit.rshift(gpio,pin),0x1) 