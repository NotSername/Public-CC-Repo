## **Some DFPWM related code since i cba to explain it a million times.**

![image](https://github.com/NotSername/Public-CC-Repo/blob/main/images/7.jpg?raw=false)

Here some example code

**AudioFister.lua**

```lua
local AudioFister = dofile("AudioFister.lua")
local url = "https://whocares.com" -- url to dropbox or whatever you use for the file
local path = "whatever.dfpwm" -- the file path
local trackname = "whatever" -- whatever you wanna call the tape
local samplerate = "48000"

AudioFister.write(path, trackname, samplerate) -- this will write a local dfpwm file to the tape

AudioFister.get(url,path) -- to download the song from whatever source

AudioFister.write(url, trackname, samplerate) -- skips everything and just puts the file straight on the tape without saving the file
```

**DurationChecker**

```md
DurationChecker requires a bit more knowledge to get to work.
(or just change every mention of tape.getSamplerate() to 48000 or whatever your samplerate is.)
```

```lua
	local Duration = dofile("DurationChecker.lua")

	local function sleepless()
		local myEvent = tostring({})
		os.queueEvent(myEvent)
		os.pullEvent(myEvent)
	end

	while true do
		local totalSeconds = math.floor((tape.getPosition() / 6000) / (tape.getSamplerate()/48000))
		local minutes = math.floor(totalSeconds / 60)
		local seconds = totalSeconds % 60
		sleepless()
		term.setCursorPos(x,y+2)
		print(string.format("%d:%02d / %d:%02d", minutes, seconds, Duration.minutes, Duration.seconds+1))
			if minutes >= Duration.minutes and seconds >= Duration.seconds+1 then
				tape.seek(-tape.getSize())
			end
    end
```

**TapeHandler.lua**

```md
The TapeHandler is where i add custom functions to the tape drive. This includes tape.getSamplerate(). 
But it also makes sure that tape.play() always uses the right speed for the supported samplerates
The handler will find the tape drive automatically so there is no need to wrap it yourself.
```

```lua
local tape = dofile("TapeHandler.lua")

print(tape.getSamplerate())

```

**Crack Converter.exe**
```md
Crack Converter is a fork of LionRay, tweaked to do more. 
Fair warning: it's a shady looking .jar file.
trust it or don't, your call.

It converts `.wav` files to `.dfpwm` for use with ComputerCraft/Computronics speakers.

Pick your input and output files, then set a sample rate - 48000 is the default. 
Checking **High Quality** runs the audio through a cleanup chain before encoding and bumps the sample rate to 96000, 
but you can still type in 48000 (or any rate) afterward if you want the quality improvements without the trouble of tape.setspeed().

Picking the right tape size: `size = song duration (seconds) * (sample rate / 48000)`
```
