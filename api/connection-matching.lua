---@using data

---@namespace Reskins.Assets

---Provides methods for matching graphics to a fluid box, heat energy source, or heat buffer by the directions and
---positions of its connections.
---
---#### Examples
---```lua
---local ConnectionMatching = require("__reskins-assets-api__.api.connection-matching")
---```
---@class ConnectionMatching
local _connection_matching = {}

local V = require("__reskins-sprite-utils__.validation")

-- The greatest distance, in tiles, between the position of a connection and the position given by its graphics.
local position_tolerance = 0.5

---Defines the fields of `PipeConnectionGraphics` and `HeatConnectionGraphics` by which a connection is matched.
---@alias MatchableConnectionGraphics PipeConnectionGraphics|HeatConnectionGraphics

---Defines the fields of `PipeConnectionDefinition` and `HeatConnectionDefinition` by which graphics are matched.
---@alias MatchableConnection PipeConnectionDefinition|HeatConnectionDefinition

---Gets the x and y coordinates of the given `position`, in either the named or the array form.
---@param position MapPosition
---@return double x
---@return double y
local function get_coordinates(position)
	return position.x or position[1] or 0, position.y or position[2] or 0
end

---Gets the rank of the match between the given `connection_graphics` and the given `connection`.
---
---The rank is 2 when the directions and positions match, and 1 when the directions match and `connection_graphics` has
---no position. Otherwise, the rank is 0.
---@param connection_graphics MatchableConnectionGraphics
---@param connection MatchableConnection
---@return integer
local function rank_connection(connection_graphics, connection)
	if connection.direction == nil or connection.direction ~= connection_graphics.direction then
		return 0
	end

	if connection_graphics.position == nil then
		return 1
	end

	if connection.position == nil then
		return 0
	end

	local graphics_x, graphics_y = get_coordinates(connection_graphics.position)
	local x, y = get_coordinates(connection.position)
	local distance = math.sqrt((x - graphics_x) ^ 2 + (y - graphics_y) ^ 2)

	return distance <= position_tolerance and 2 or 0
end

---Gets the entry of the given `connection_graphics` that best matches the given `connection`, without validating the
---arguments.
---@generic T : MatchableConnectionGraphics
---@param connection_graphics T[]
---@param connection MatchableConnection
---@return T?
---@return integer
local function find_best_connection_graphics(connection_graphics, connection)
	local best, best_rank = nil, 0

	for _, entry in pairs(connection_graphics) do
		local rank = rank_connection(entry, connection)
		if rank > best_rank then
			best, best_rank = entry, rank
		end
	end

	return best, best_rank
end

local check_find_connection_graphics = V.signature("find_connection_graphics", {
	{ "connection_graphics", V.array(V.table()) },
	{ "connection", V.table() },
})

---Gets the entry of the given `connection_graphics` that best matches the given `connection`, if found.
---
---An entry that matches by direction and position is preferred over an entry that matches by direction alone. Of
---entries with the same rank, the first is used.
---
---#### Parameters
---@generic T : MatchableConnectionGraphics
---@param connection_graphics T[] The graphics of each connection.
---@param connection MatchableConnection The connection to match.
---
---#### Returns
---@return T? # The entry that best matches `connection`, if found.
---@return integer # The rank of the match, between 0 and 2.
---
---@throws When `connection_graphics` is not an array of tables.
---@throws When `connection` is not a table.
---@nodiscard
function _connection_matching.find_connection_graphics(connection_graphics, connection)
	check_find_connection_graphics(connection_graphics, connection)

	return find_best_connection_graphics(connection_graphics, connection)
end

local check_find_graphics = V.signature("find_graphics", {
	{ "graphics", V.array(V.table()) },
	{ "connections_field", V.one_of({ "pipe_connections", "connections" }) },
	{ "connections", V.array(V.table()) },
})

---Gets a copy of the entry of the given `graphics` that best matches the given `connections`, if found.
---
---An entry with connection graphics in `connections_field` that match one of `connections` by direction and position
---is preferred, then an entry with connection graphics that match by direction alone, then an entry with no
---`connections_field`. Of entries with the same rank, the first is used.
---
---#### Parameters
---@generic T : table
---@param graphics T[] The graphics from which an entry is selected.
---@param connections_field "pipe_connections"|"connections" The field of each entry that lists its connection graphics.
---@param connections MatchableConnection[] The connections of the fluid box, heat energy source, or heat buffer.
---
---#### Returns
---@return T? # A copy of the matching entry, if found.
---
---@throws When `graphics` is not an array of tables.
---@throws When `connections_field` is not `"pipe_connections"` or `"connections"`.
---@throws When `connections` is not an array of tables.
---@nodiscard
function _connection_matching.find_graphics(graphics, connections_field, connections)
	check_find_graphics(graphics, connections_field, connections)

	local best, best_rank = nil, 0

	for _, entry in pairs(graphics) do
		local rank = 0
		local connection_graphics = entry[connections_field]

		if connection_graphics == nil then
			rank = 1
		else
			for _, connection in pairs(connections) do
				local _, connection_rank = find_best_connection_graphics(connection_graphics, connection)
				-- A match by connection ranks above the entries with no connection graphics.
				rank = math.max(rank, connection_rank > 0 and connection_rank + 1 or 0)
			end
		end

		if rank > best_rank then
			best, best_rank = entry, rank
		end
	end

	return best and util.copy(best)
end

return _connection_matching
