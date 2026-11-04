---@using data

---@namespace Reskins.Assets

local V = require("__reskins-sprite-utils__.validation")

---Provides methods for assigning the fields of one table to another table.
---
---#### Examples
---```lua
---local Assignment = require("__reskins-assets-api__.api.assignment")
---```
---@class Assignment
local _assignment = {}

local check_safe_assign = V.signature("safe_assign", {
	{ "target", V.table() },
	{ "source", V.table() },
	{ "field_names", V.array(V.string()) },
})

---Assigns each field named in `field_names` that `source` defines to `target`, in place.
---
---Each value is copied. A field that `source` does not define is not modified on `target`, and a field of `source` that
---is not named in `field_names` is not assigned.
---
---#### Parameters
---@param target table The table to which the fields are assigned.
---@param source table The table from which the fields are taken.
---@param field_names string[] The names of the fields to assign.
---
---#### Examples
---```lua
----- Assign the circuit connector of a sprite set to a prototype, when the sprite set defines one.
---local Assignment = require("__reskins-assets-api__.api.assignment")
---
---local set = { circuit_connector = circuit_connector }
---Assignment.safe_assign(prototype, set, { "circuit_connector", "integration_patch" })
----- The `circuit_connector` of `prototype` is a copy of `circuit_connector`. The `integration_patch` of `prototype` is
----- not modified.
---```
---@throws When `target` or `source` is not a table.
---@throws When `field_names` is not an array of strings.
function _assignment.safe_assign(target, source, field_names)
	check_safe_assign(target, source, field_names)

	for _, field_name in pairs(field_names) do
		local value = source[field_name]
		if value ~= nil then
			target[field_name] = util.copy(value)
		end
	end
end

return _assignment
