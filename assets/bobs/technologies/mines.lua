---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Technologies

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local technologies = IconBuilderFactory:create({
	folder = _defines.assets_source.bobs_assets .. "/graphics/technology/mines",
	defaults_type = "technology",
})

---Provides methods for getting the technology icons in the `mines` folder, such as `mines/distractor-mine.png`.
---
---#### Examples
---```lua
---local Mines = require("__reskins-assets-api__.assets.bobs.technologies.mines")
---```
---@class Mines
local M = {}

local distractor_mine = technologies:flat("distractor-mine")

---Gets the technology icon for the distractor mine.
M.get_distractor_mine_icon = distractor_mine:build("get_distractor_mine_icon")

---Gets the technology icon for the distractor mine as an `IconComposition`.
M.get_distractor_mine_icon_composition = distractor_mine:build_composition("get_distractor_mine_icon_composition")

local poison_mine = technologies:flat("poison-mine")

---Gets the technology icon for the poison mine.
M.get_poison_mine_icon = poison_mine:build("get_poison_mine_icon")

---Gets the technology icon for the poison mine as an `IconComposition`.
M.get_poison_mine_icon_composition = poison_mine:build_composition("get_poison_mine_icon_composition")

local slowdown_mine = technologies:flat("slowdown-mine")

---Gets the technology icon for the slowdown mine.
M.get_slowdown_mine_icon = slowdown_mine:build("get_slowdown_mine_icon")

---Gets the technology icon for the slowdown mine as an `IconComposition`.
M.get_slowdown_mine_icon_composition = slowdown_mine:build_composition("get_slowdown_mine_icon_composition")

return M
