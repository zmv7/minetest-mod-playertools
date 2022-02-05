--[[ privs ]]
if(minetest.setting_getbool("enable_damage") == true) then
	minetest.register_privilege("heal", {
		description = "Allows set player's health and breath with /sethp, and /setbreath",
		give_to_singleplayer = false
	})
end
minetest.register_privilege("physics", {
	description = "Allows set player's gravity, jump height and movement speed with /gravity, /jump and /speed",
	give_to_singleplayer = false
})
minetest.register_privilege("psize", {
	description = "Allows set player's to set size with /size",
	give_to_singleplayer = false
})
minetest.register_privilege("hotbar", {
	description = "Allows set the number of slots of the hotbar with /hotbar",
	give_to_singleplayer = false
})

--[[ info commands ]]
minetest.register_chatcommand("whoami", {
	params = "",
	description = "Shows your player name",
	privs = {},
	func = function(name)
		minetest.chat_send_player(name, "Your player name is "..name)
	end,
})

minetest.register_chatcommand("ip", {
	params = "[<playername>]",
	description = "Shows your or another player's IP address",
	privs = {},
	func = function(name, param)
	if param == "" then
		minetest.chat_send_player(name, "Your IP address is "..minetest.get_player_ip(name))
	else
		if not minetest.check_player_privs(name, "server") then
			return false, "You are not have server priv"
		end
		local pname = minetest.get_player_by_name(param)
		if pname then
		minetest.chat_send_player(name, "IP address of "..param.." is "..minetest.get_player_ip(param))
		else return false, "Invalid player"
		end
	end
end
})

--[[ HUD commands ]]
minetest.register_chatcommand("hotbar", {
	params = "<size>",
	privs = {hotbar=true},
	description = "Set hotbar size",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, "No player."
		end
		local size = tonumber(param)
		if not size then
			return false, "Missing or incorrect size parameter!"
		end
		local ok = player:hud_set_hotbar_itemcount(size) player:hud_set_hotbar_image("")
		if ok then
			return true
		else
			return false, "Invalid item count!"
		end
	end,
})

--[[ health and breath commands ]]

if(minetest.setting_getbool("enable_damage") == true) then
	minetest.register_chatcommand("sethp", {
	params = "[<playername>] <hp>",
	privs = {heal=true},
	description = "Set your or another player's health",
	func = function(name, param)
		local nick, hp = param:match("^(%S+)%s(.+)$")
		if not nick then
		nick, hp = name, param
		end
		local player = minetest.get_player_by_name(nick)
		if not player then
			return false, "Invalid player"
		end
		
		if type(tonumber(hp)) ~= "number" then
			return false, "Missing or incorrect hp parameter"
		end
		player:set_hp(hp)
		return true
	end,
})
	minetest.register_chatcommand("setbreath", {
	params = "[<breath number>]",
	description = "Set your or another player's breath points",
	privs = {heal=true},
	func = function(name, param)
		local nick, breath = param:match("^(%S+)%s(.+)$")
		if not nick then
		nick, breath = name, param
		end
			local player = minetest.get_player_by_name(nick)
			if not player then return false, "Invalid player" end
			if breath == "" then
				return false, 'Your current breath is '..player:get_breath()
			end
			if type(tonumber(breath)) ~= "number" then
				return false, "This is not a number."
			end
			local bp = math.max(0, tonumber(breath))
			player:set_breath(bp)
		end,
	})

	minetest.register_chatcommand("killme", {
		params = "",
		description = "Kills yourself",
		func = function(name, param)
			local player = minetest.get_player_by_name(name)
			if not player then
				return
			end
			player:set_hp(0)
		end,
	})
end

--[[ Player physics commands ]]

minetest.register_chatcommand("speed", {
	params = "[<playername>] [<speed>]",
	description = "Sets your or another player's movement speed to <speed> (default: 1)",
	privs={physics=true},
	func = function(name, param)
		local nick, speed = param:match("^(%S+)%s(.+)$")
		if not nick then
		nick, speed = name, param
		end
		local player = minetest.get_player_by_name(nick)
		if not player then
			return false, "Invalid player" end
		if speed == "" then
			speed=1
		end
		if type(tonumber(speed)) ~= "number" then
			return false, "This is not a number." end
		player:set_physics_override(speed, nil, nil)
	end,
})

minetest.register_chatcommand("jump", {
	params = "[<playername>] [<height>]",
	description = "Sets your or another player's jump height to <height> (default: 1)",
	privs = {physics=true},
	func = function(name, param)
		local nick, jump_height = param:match("^(%S+)%s(.+)$")
		if not nick then
		nick, jump_height = name, param
		end
		local player = minetest.get_player_by_name(nick)
		if not player then return false, "Invalid player"
		end
		if jump_height == "" then
			jump_height=1
		end
		if type(tonumber(jump_height)) ~= "number" then
			return false, "This is not a number." end
		player:set_physics_override(nil, jump_height, nil)
	end,
})

minetest.register_chatcommand("gravity", {
	params = "[<playername>] [<gravity>]",
	description = "Sets your or another player's gravity to <gravity> (default: 1)",
	privs={physics=true},
	func = function(name, param)
		local nick, gravity = param:match("^(%S+)%s(.+)$")
		if not nick then
		nick, gravity = name, param
		end
		local player = minetest.get_player_by_name(nick)
		if not player then return false, "Invalid player"
		end
		if gravity == "" then
			gravity=1
		end
		if type(tonumber(gravity)) ~= "number" then
			return false, "This is not a number."
		end
		player:set_physics_override(nil, nil, gravity)
	end,
})

--[[ Punishment cmds ]]

minetest.register_chatcommand("stun", {
	params = "<playername>",
	description = "Disable player's movement",
	privs={physics=true},
	func = function(name, param)
		local player = minetest.get_player_by_name(param)
		if not player then
			return false, "Invalid player" end
		player:set_physics_override(0, 0, nil)
		return true, "# "..param.." stunned"
	end,
})

minetest.register_chatcommand("unstun", {
	params = "<playername>",
	description = "Restore player's movement",
	privs={physics=true},
	func = function(name, param)
		local player = minetest.get_player_by_name(param)
		if not player then
			return false, "Invalid player" end
		player:set_physics_override(1, 1, nil)
		return true, "# "..param.." unstunned"
	end,
})

minetest.register_chatcommand("xkill", {
  params = "<playername>",
  privs = {ban=true},
  description = "Set player's hp to 0 until rejoin (even with admin armor)",
  func = function(name, param)
local player = minetest.get_player_by_name(param)
if not player then return false, "Invalid player" end
player:set_properties({hp_max="0"})
player:set_hp(0)
end})

minetest.register_chatcommand("xres", {
  params = "<playername>",
  privs = {ban=true},
  description = "Resurrect player with 0 hp",
  func = function(name, param)
local player = minetest.get_player_by_name(param)
if not player then return false, "Invalid player" end
player:set_properties({hp_max="20"})
player:set_hp(20)
end})


--[[ Player size command ]]

minetest.register_chatcommand("size", {
  description = "Change your or another player's size. Range: 0.06 - 30",
  params = "[<playername>] <size>",
  privs = {psize=true},
  func = function(name, param)
local nick, size = param:match("^(%S+)%s(.+)$")
if not nick then
nick, size = name, param
end
local player = minetest.get_player_by_name(nick)
if not player then return false, "Invalid player" end
local chk = tonumber(size)
if not chk or chk < 0.06 or chk > 30 then return false, "Incorrect value / Out of bounds" end
 player:set_properties({
	collisionbox={-size*0.3, 0.0, -size*0.3, size*0.3, size*1.7, size*0.3},
	selectionbox={-size*0.3, 0.0, -size*0.3, size*0.3, size*1.7, size*0.3},
	eye_height=size*1.47,
	visual_size={x=size,y=size,z=size}})
if size < "1" then
 player:set_physics_override(math.sqrt(size), 1, nil)
else
 player:set_physics_override(math.sqrt(size), math.sqrt(size), nil)
end
end})

--[[ Pulverize cmd ]]

minetest.register_chatcommand("pulverizeall", {
	params = "[<playername>]",
	description = "Remove all items in your or player's inventory and crafting grid",
	func = function(name, param)
	if param == "" then
		local player = minetest.get_player_by_name(name)
		if not player then
			return
		end
		local inv = player:get_inventory()
		inv:set_list("main", {})
		inv:set_list("craft", {})
		return true, "# Your stuff pulverized"
	else
		if not minetest.check_player_privs(name, "server") then
			return minetest.chat_send_player(name,"You are not have server priv")
		end
  local pname = minetest.get_player_by_name(param)
		if pname then
		local inv = pname:get_inventory()
		inv:set_list("main", {})
		inv:set_list("craft", {})
		return true, "# Pulverized "..param.."'s stuff"
		else
		return false, "Invalid player"
		end
  end
	end,
})
