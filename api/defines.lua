---Provides enumerations specific to Artisanal Reskins.
---Includes the Artisanal Reskins: Sprite Utils defines.
---
---### Examples
---```lua
---local _defines = require("__reskins-assets-api__.defines")
---```
---@class Reskins.Defines:Reskins.SpriteUtils.Defines
local _defines = require("__reskins-sprite-utils__.defines")

---Represents the different types of animated transport belt sprite sheets.
---@enum Reskins.Defines.BeltSprites
_defines.belt_sprites = {
	---Indicates standard belt sprites.
	---
	---Used for slower belt speeds, typically less than 30 items/s.
	standard = 1,
	---Indicates fast belt sprites.
	---
	---Used for faster belt speeds, typically between 30 items/s and 60 items/s.
	---Has twice as many frames as `defines.belt_sprites.standard` and larger spacing between arrows.
	fast = 2,
	---Indicates turbo belt sprites.
	---
	---Used for faster belt speeds, typically more than 75 items/s.
	---Has twice as many frames as `defines.belt_sprites.fast` and larger spacing between arrows. Used for fastest belt speeds.
	turbo = 3,
}

---Represents the different asset mods used to build the various graphics packs.
---@enum Reskins.Defines.Assets
_defines.assets = {
	---Factorio.
	base = "__base__",
	---Factorio: Space Age.
	space_age = "__space-age__",
	---Artisanal Reskins: Vanilla Assets.
	base_assets = "__reskins-assets-base__",
	---Artisanal Reskins: Bob's Assets.
	bobs_assets = "__reskins-assets-bobs__",
	---Artisanal Reskins: Angel's Assets.
	angels_assets = "__reskins-assets-angels__",
	---Artisanal Reskins: Assorted Assets.
	assorted_assets = "__reskins-assets-assorted__",
	---Artisanal Reskins: Space Age Assets.
	space_age_assets = "__reskins-assets-space-age__",
	---Angel's Refining Graphics.
	refining_graphics = "__angelsrefininggraphics__",
	---Angel's Smelting Graphics.
	smelting_graphics = "__angelssmeltinggraphics__",
	---Angel's Petrochemical Processing Graphics.
	petrochem_graphics = "__angelspetrochemgraphics__",
	---Angel's Bioprocessing Graphics.
	bioprocessing_graphics = "__angelsbioprocessinggraphics__",
	---Angel's Addons - Mass Transit - Crawler Graphics.
	mobility_crawler_graphics = "__angelsaddons-mobility-graphics-crawler__",
	---Angel's Addons - Mass Transit - Petrochemical Graphics.
	mobility_petrochem_graphics = "__angelsaddons-mobility-graphics-petro__",
	---Angel's Addons - Mass Transit - Smelting Graphics.
	mobility_smelting_graphics = "__angelsaddons-mobility-graphics-smelting__",
}

---@enum Reskins.Defines.Symbols
_defines.symbols = {
	area_drill = "area-drill",
	filter = "filter",
	shield = "shield",
}

---@enum Reskins.Defines.Letters
_defines.letters = {
	F = "F",
	H = "H",
	L = "L",
	M = "M",
	S = "S",
}

return _defines
