local drive = peripheral.find("tape_drive")
if not drive then
  return nil
end

local play = drive.play

drive.getSamplerate = function()
  local label = drive.getLabel()
  if label:sub(-7) == "(96000)" then
    return 96000
  elseif label:sub(-7) == "(48000)" then
    return 48000
  else
    return nil
  end
end

drive.play = function()
  local label = drive.getLabel()
  if label:sub(-7) == "(96000)" then
    drive.setSpeed(2)
    play()
  elseif label:sub(-7) == "(48000)" then
    drive.setSpeed(1)
    play()
  else
    play()
  end
end

return drive