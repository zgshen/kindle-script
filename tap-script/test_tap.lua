local function u16(n)
  n = n % 65536
  return string.char(n % 256, math.floor(n/256) % 256)
end

local function s32(n)
  if n < 0 then n = n + 4294967296 end
  local b1 = n % 256; n = math.floor(n/256)
  local b2 = n % 256; n = math.floor(n/256)
  local b3 = n % 256; n = math.floor(n/256)
  local b4 = n % 256
  return string.char(b1, b2, b3, b4)
end

local function event(evtype, code, value)
  -- tv_sec=0, tv_usec=0
  return string.char(0,0,0,0, 0,0,0,0) .. u16(evtype) .. u16(code) .. s32(value)
end

local EV_SYN = 0
local EV_ABS = 3
local SYN_REPORT = 0
local ABS_MT_SLOT = 47
local ABS_MT_TRACKING_ID = 57
local ABS_MT_POSITION_X = 53
local ABS_MT_POSITION_Y = 54
local ABS_MT_PRESSURE = 58

local f = io.open("/dev/input/event1", "wb")
if not f then
  print("fail,not auth��写入")
  os.exit(1)
end

print("try击 (50,50) ...")

-- 手指按下
f:write(event(EV_ABS, ABS_MT_SLOT, 0))
f:write(event(EV_ABS, ABS_MT_TRACKING_ID, 1))
f:write(event(EV_ABS, ABS_MT_POSITION_X, 50))
f:write(event(EV_ABS, ABS_MT_POSITION_Y, 50))
f:write(event(EV_ABS, ABS_MT_PRESSURE, 50))
f:write(event(EV_SYN, SYN_REPORT, 0))
f:flush()

os.execute("sleep 0.1")

-- 手指抬起
f:write(event(EV_ABS, ABS_MT_SLOT, 0))
f:write(event(EV_ABS, ABS_MT_TRACKING_ID, -1))
f:write(event(EV_SYN, SYN_REPORT, 0))
f:flush()

f:close()
print("complete��幕有没有反应")
