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

-- Constants
local balanceFile = "traderBalance.txt"

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
    print(string.format(
      "%-12s | Min: %4d | Max: %4d | Today: %4d",
      commodity.name, commodity.min, 
      commodity.max, price
    ))
  end
end

-------------------------------------------------
-- Point of Entry -------------------------------
-------------------------------------------------
printPriceTable()