-- ==============================================
-- ==                  trader                  ==
-- ==============================================
-- ComputerCraft Tweaked script.     --
-- * Speculate on commodities in an  implemen- --
-- tation of Dopewars with fully interactive & -- 
-- colour UI.  --
-- * Send & receive items through a  --
-- chest connected to your terminal. --
-- * Uses emeralds as the currency   --
-- so u can trade w/ villagers too.  --
-- * Fully local, no network use.    --
-- * Usage: $ trader                 --

-- Constants and Globals
local BALANCE_FILE = "traderBalance.txt"

local commandBlock = nil

-- X = 50 => 50 ems for one X.
-- Y = -50 => 50 Y for one em.
local commodities = {
  copper_ingot = {
    name = "Copper Ingot",
    min = -64,  -- 64 copper for 1 emerald
    max = -48,  -- 48 copper for 1 emerald
  },
  iron_ingot = {
    name = "Iron Ingot",
    min = -48,
    max = -32,
  },
  gold_ingot = {
    name = "Gold Ingot",
    min = -32,
    max = -16,
  },
  diamond = {
    name = "Diamond",
    min = 10,   -- 10 emeralds for 1 diamond
    max = 20,
  },
  obsidian = {
    name = "Obsidian",
    min = -5,   -- 5 obsidian for 1 emerald
    max = 5,    -- 5 emeralds for 1 obsidian
  },
  slime_ball = {
    name = "Slime Ball",
    min = -20,
    max = -10,
  },
  sugar = {
    name = "Sugar",
    min = -12,
    max = -8,
  },
  painting = {
    name = "Painting",
    min = -4,
    max = -2,
  },
  arrow = {
    name = "Arrow",
    min = -5,
    max = -1,
  },
  oak_log = {
    name = "Oak Log",
    min = -8,
    max = -4,
  },
  nether_wart = {
    name = "Nether Wart",
    min = -15,
    max = -5,
  },
  wheat = {
    name = "Wheat",
    min = -18,
    max = -10,
  },
  wheat_seeds = {
    name = "Wheat Seeds",
    min = -16,
    max = -8,
  },
}

-- Deterministically computes a price
-- given an item with {name,min,max}
-- and an ingame day. Prices change
-- day to day only.
local function getPrice(item)
  -- Simple hash: turn string into num
  -- and mix with others
  local hash = 0
  for i = 1, #item.name do
    hash = (hash * 31 + item.name:byte(i)) % 2^31
  end
  
  -- Mix the numbers into the hash
  hash = (hash + item.min * 73856093) % 2^31
  hash = (hash + item.max * 19349663) % 2^31
  hash = (hash + os.day("ingame") * 83492791) % 2^31
  
  math.randomseed(hash)
  return math.random(item.min, item.max)
end

-- prints prices formatted nicely
local function printPriceTable()
  for key, commodity in pairs(commodities) do
    local price = getPrice(commodity)
    local priceStr = nil
    if price < 0 then
      priceStr = string.format("%d\t\t%s\t\t1e.",
        math.abs(price), commodity.name
      )
    elseif price > 0 then
      priceStr = string.format("1\t\t%s\t\t%de.",
        commodity.name, math.abs(price)
      )
    end
    print(priceStr)
  end
end

local function setUpCommandBlock()
  local peripheralCbs = peripheral.find("command")

  -- Handle no command block.
  if peripheralCbs == nil or peripheralCbs.length == 0 then 
    error("Trade requires a command block.")
  end
  commandBlock = peripheral.wrap("top")
  commandBlock.setCommand(
    '/tellraw @a {"text":"trader: CB Online","color":"green"}'
  )
  commandBlock.runCommand()
end

-- Returns true if the command block peripheral is
-- set up.
local function commandBlockOnline()
  -- check for nil CB
  if commandBlock == nil then return false end

  -- check for invalid CB
  -- if type(commandBlock[runCommand]) ~= "function" then
  --   return false
  -- end

  -- checks passed 
  return true
end

local function take(item, qty)
  print(string.format("TODO: take %d of %s from player", qty, item))

  -- Check if command block is online.
  if not commandBlockOnline() then
    error("Command block must be online.")
  end

  -- Set command to "clear" with appropriate player, item, and qty.
  local cmd = string.format(
    "/clear %s %s %d",
    username, item, qty
  )
  commandBlock.setCommand(cmd)

  -- Execute command.
  commandBlock.runCommand()
end

local function give(item, qty)
  print(string.format("TODO: give %d of %s to player", qty, item))

  -- Check if command block is online.
  if not commandBlockOnline() then
    error("Command block must be online.")
  end

  -- Set command to "give" with appropriate player, item, and qty.
  local cmd = string.format(
    "/give %s %s %d",
    username, item, qty
  )
  commandBlock.setCommand(cmd)

  -- Execute command.
  commandBlock.runCommand()
end

-------------------------------------------------
-- Point of Entry -------------------------------
-------------------------------------------------
local username = ...
print("Trading for player: " .. username)
setUpCommandBlock()

-- As a test, give player a gift:)
give("wheat", 1)

-- Main loop: Draw, parse command, execute command, repeat.
local command = "starting"
while command ~= "exit" do
  term.clear()
  printPriceTable()
  write("(buy/sell/exit) > ")
  command = read()
  if command == "exit" then 
    term.setTextColour(colours.blue)
    print("Exiting trade terminal!")
  end
end

