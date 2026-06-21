local function sleepless()
	local myEvent = tostring({})
	os.queueEvent(myEvent)
	os.pullEvent(myEvent)
end

local tape = dofile("/Utils/Tapehandler.lua")

tape.stop()

local size = tape.getSize()
local low = 0
local high = size - 1
local lastNonZero = -1

while low <= high do
sleepless()
  local mid = math.floor((low + high) / 2)

  tape.seek(-tape.getPosition())
  tape.seek(mid)

  local byte = tape.read()

  if byte ~= 170 then
    lastNonZero = mid
    low = mid + 1
  else
    high = mid - 1
  end
end

if lastNonZero == -1 then
  return "Empty"
end

local finalPos = lastNonZero
local totalSeconds = math.ceil((finalPos / 6000) / (tape.getSamplerate()/48000))
local minutes = math.floor(totalSeconds / 60)
local seconds = totalSeconds % 60

local data = {
  minutes = minutes,
  seconds = seconds,
  finalPos = finalPos
}

return data