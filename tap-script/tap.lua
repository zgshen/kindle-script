-- 用法: lua tap.lua <x> <y>
local x = tonumber(arg[1])
local y = tonumber(arg[2])

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
  return string.char(0,0,0,0, 0,0,0,0) .. u16(evtype) .. u16(code) .. s32(value)
end

local EV_SYN, EV_ABS = 0, 3
local SYN_REPORT = 0
local ABS_MT_SLOT, ABS_MT_TRACKING_ID = 47, 57
local ABS_MT_POSITION_X, ABS_MT_POSITION_Y, ABS_MT_PRESSURE = 53, 54, 58

local f = io.open("/dev/input/event1", "wb")
if not f then os.exit(1) end

f:write(event(EV_ABS, ABS_MT_TRACKING_ID, 1))
f:write(event(EV_ABS, ABS_MT_POSITION_X, x))
f:write(event(EV_ABS, ABS_MT_POSITION_Y, y))
f:write(event(EV_ABS, ABS_MT_PRESSURE, 95))
f:write(event(EV_SYN, SYN_REPORT, 0))
f:flush()

-- os.execute("sleep 0.1")

f:write(event(EV_ABS, ABS_MT_TRACKING_ID, -1))
f:write(event(EV_SYN, SYN_REPORT, 0))
f:flush()
f:close()
