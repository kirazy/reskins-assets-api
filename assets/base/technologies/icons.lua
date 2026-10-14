---@namespace Reskins.Assets.Base.Technologies

local IconBuilderFactory = require("api.icon-builder-factory")

local technologies = IconBuilderFactory:create({
	folder = "__reskins-assets-base__/graphics/technology",
	defaults_type = "technology",
})

---Provides the reskinned technology icons from the base game.
---@class Icons
local _icons = {
	research_speed = technologies:tinted("research-speed"):build(),
}

return _icons
