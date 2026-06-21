local AudioFister = {}
local tape = peripheral.find("tape_drive")

function AudioFister.write(filePath, trackName)
    local w, h = term.getSize()
    local progressY = h - 4

    local dfpwm = fs.open(filePath, "rb")
    if not dfpwm then
		dfpwm = AudioFister.getData(filePath)
		if not dfpwm then
			return false
		end
    end

    local buffer = {}
    local totalBytes = 0
    local chunkSize = 16384

    while true do
        local chunk = dfpwm.read(chunkSize)
        if not chunk then
            break
        end
        table.insert(buffer, chunk)
        totalBytes = totalBytes + #chunk
    end

    dfpwm.close()

    local tapeSize = tape.getSize()
    if totalBytes > tapeSize then
        term.setCursorPos(1, progressY - 2)
        term.clearLine()
        print("Audio sz > tape capacity", progressY - 2)
        print(
            string.format("Tape: %.2f MB | Audio: %.2f MB", tapeSize / 1024 / 1024, totalBytes / 1024 / 1024),
            progressY - 1
        )
        sleep(2)
        return false
    end

    tape.stop()
    tape.seek(-tapeSize)

    local startTime = os.epoch("local")
    local writtenBytes = 0
    for i, chunk in ipairs(buffer) do
        tape.write(chunk)
        writtenBytes = writtenBytes + #chunk
        if i % 10 == 0 then
            --Gui.drawProgressBar(5, progressY, w - 10, writtenBytes, totalBytes)
        end
    end

    local writeTime = (os.epoch("local") - startTime) / 1000
   -- term.setCursorPos(1, progressY - 2)
   -- term.clearLine()
    --Gui.centerText(string.format("Write took (%.1f seconds)", writeTime), progressY - 2)
    --term.setCursorPos(1, progressY)
    --term.clearLine()

    tape.setLabel(trackName.." (48000)")

    tape.seek(-tapeSize)
    sleep(0.5)
    return true
end

function AudioFister.getData(url)
  local response = http.get(url, nil, true)

  if response then
      return response
  end
end

function AudioFister.get(url,name)
  local filePath = name

  local response = http.get(url, nil, true)

  if response then
      local data = response.readAll()
      response.close()

      local file = fs.open(filePath, "wb")
      file.write(data)
      file.close()
  end
end
return AudioFister