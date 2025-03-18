function realsleep(num)
  local start_time = os.epoch("local") / 1000
  while true do
    local fucktimeout = tostring({}) os.queueEvent(fucktimeout) os.pullEvent(fucktimeout)
    local current_time = os.epoch("local") / 1000
    local elapsed_time = current_time - start_time
    if elapsed_time >= num then
    return
    end
  end
end

realsleep(5)
