---@namespace Reskins.Assets.Base.Technologies

local IconCatalog = require("api.icon-catalog")

local technologies = IconCatalog:create({
	folder = "__reskins-assets-base__/graphics/technology",
	defaults_type = "technology",
})

---The technology icons Artisanal Reskins draws for the base game.
---@class Icons
local _icons = {
	research_speed = technologies:tinted("research-speed"):build(),
}

return _icons
