-- ====================================
-- ==             stairs             ==
-- ====================================
--  Script to dig stairs up or down. --
-- Usage    : stairs {dir} {depth}   --
-- Example 1: stairs up 50           --
-- Example 2: stairs down 10         --

-- Constants --------------------------
local stepDepth = 4

-- General Purpose Functions ----------

-- Takes fuel from slot 1 if at 0 fuel.
local function fuelIfNeeded()
  if turtle.getFuelLevel() == 0 then
    turtle.select(1)
    if not turtle.refuel(1) then
      error("No fuel in slot 1!")
    end
  end
end

-- Digs while block in front is 
-- obstructed. (Handles gravel etc.)
local function digFwd()
  while turtle.detect() do
    assert(turtle.dig())
  end
end

---------------------------------------
-- Up-Specific Functions --------------
---------------------------------------

-- Helper for digging upwards:
-- Digs up while the block above
-- is obstructed, then moves there,
-- until the turtle is "h" above
-- start position.
local function digUpGoUp(h)
  for j=1, h do
    while turtle.detectUp() do
      assert(turtle.digUp())
    end
    assert(turtle.up())
  end
end

-- moves down h blocks
local function goDown(h)
  for k=1, h do
    assert(turtle.down())
  end
end

-- Creates a step from block A to B
-- from the block behind the A. 
-- Does this by digging forward,
-- then digging up, then moving down
-- and repeating this process for the
-- desired depth.
local function digStairsUp(depth)
  local i = 0
  while i < depth do
    fuelIfNeeded()
    digFwd()
    assert(turtle.forward())
    digUpGoUp(stepDepth)
    goDown(stepDepth - 1)
    i = i + 1
  end
end

---------------------------------------
-- Down-Specific Functions ------------
---------------------------------------

-- see digUpGoUp, this is the reverse
local function digDownGoDown(h)
  for j=1, h do
    while turtle.detectDown() do
      assert(turtle.digDown())
    end
    assert(turtle.down())
  end
end

-- moves up h blocks
local function goUp(h)
  for k=1, h do
    assert(turtle.up())
  end
end

local function digStairsDown(depth)
  local i = 0
  while i < depth do
    fuelIfNeeded()
    digFwd()
    assert(turtle.forward())
    digDownGoDown(stepDepth)
    goUp(stepDepth - 1)
    i = i + 1
  end
end

---------------------------------------
-- Point of Entry / Exec --------------
---------------------------------------
local args = {...}

local badArgs =
  not args[1]
  or not args[2]
  or not tonumber(args[2])

if badArgs then
  error(
    "Usage: stairs {up|down} {depth}"
  )
end

-- Make direction lowercase.
args[1] = string.lower(args[1])

-- Say what we are going to do.
local userH = tonumber(args[2])
print(string.format(
  "Digging stairs %s %d blocks.",
  args[1], userH
))

-- Branch for up/down
if args[1] == "up" then
  digStairsUp(userH)
elseif args[1] == "down" then
  digStairsDown(userH)
else
  error("{up|down} only, exiting.")
end

-- Return to solid ground....
-- Just in case we are up in the sky :)
local fall = 0
while fall < 100 do
  if not turtle.detectDown() then
    break
  end
  turtle.down()
  fall = fall + 1
end

print("Job complete!")