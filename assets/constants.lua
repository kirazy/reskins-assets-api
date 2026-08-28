local _constants = {}

function _constants.get_status_colors()
	return {
		no_power = { 0, 0, 0, 0 }, -- If no_power is not specified or is nil, it defaults to clear color {0,0,0,0}
		idle = { 1, 0, 0, 1 }, -- If idle is not specified or is nil, it defaults to white.
		no_minable_resources = { 1, 0, 0, 1 }, -- If no_minable_resources, disabled, insufficient_input or full_output are not specified or are nil, they default to idle color.
		insufficient_input = { 1, 0, 0, 1 },
		full_output = { 1, 1, 0, 1 },
		disabled = { 1, 1, 0, 1 },
		working = { 0, 1, 0, 1 }, -- If working is not specified or is nil, it defaults to white.
		low_power = { 1, 1, 0, 1 }, -- If low_power is not specified or is nil, it defaults to working color.
	}
end

return _constants
