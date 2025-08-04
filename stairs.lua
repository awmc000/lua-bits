-- ====================================
-- ==             stairs             ==
-- ====================================
--  Script to dig stairs up or down. --
-- Usage    : stairs {dir} {depth}   --
-- Example 1: stairs up 50           --
-- Example 2: stairs down 10         --

-- General Purpose Functions ----------

-- Takes fuel from slot 1 if at 0 fuel.
local function fuelIfNeeded()
  turtle.select(1)
  if not turtle.refuel() then
    error("Slot 1 out of fuel!")
  end
end

-- Digs while block in front is 
-- obstructed. (Handles gravel etc.)
local function digFwd()
  while turtle.detect() do
    assert(turtle.dig())
  end
end

-- Returns true if we are in the air.
local function inAir()
  return turtle.dete
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

-- moves down to desired height
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
    digUpGoUp(3)
    goDown(2)
    i = i + 1
  end
end

---------------------------------------
-- Down-Specific Functions ------------
---------------------------------------

local function digDownGoDown(h)
  for j=1, h do
    while turtle.detectDown() do
      assert(turtle.digDown())
    end
    assert(turtle.down())
  end
end

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
    digDownGoDown(3)
    goUp(2)
    i = i + 1
  end
end

---------------------------------------
-- Point of Entry / Exec --------------
---------------------------------------
-- Grab arguments
local args = {...}

local badArgs =
  not args[1]
  or not args[2]
  or not tonumber(args[2])

if badArgs then
  error("Usage: stairs {up|down} {depth}")
end

local userH = tonumber(args[2])
print("Digging stairs up: ")
print(userH)

-- Branch for up/down
if args[1] == "up" then
  digStairsUp(userH)
end
if args[1] == "down" then
  digStairsDown(userH)
end

print("Stairs complete!")