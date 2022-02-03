--[[ privileges ]]
if(minetest.setting_getbool("enable_damage") == true) then
	minetest.register_privilege("heal", {
		description = "Allows player to set own health and breath with /sethp, and /setbreath",
		give_to_singleplayer = false
	})
end
minetest.register_privilege("physics", {
	description = "Allows player to set own gravity, jump height and movement speed with /setgravity, /setjump and /setspeed, respectively",
	give_to_singleplayer = false
})
minetest.register_privilege("hotbar", {
	description = "Allows player to set the number of slots of the hotbar with /hotbar",
	give_to_singleplayer = false
})

--[[ informational commands ]]
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
			return minetest.chat_send_player(name,"You are not have server priv")
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


minetest.register_chatcommand("zoomfov", {
	params = "[<FOV>]",
	privs = {physics=true},
	description = "Set or display your zoom_fov",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, "No player."
		end
		if param == "" then
			local fov = player:get_properties().zoom_fov
			return true, "zoom_fov = "..tostring(fov)
		end
		local fov = tonumber(param)
		if not fov then
			return false, "Missing or incorrect zoom_fov parameter!"
		end
		player:set_properties({zoom_fov = fov})
		fov = player:get_properties().zoom_fov
		return true, "zoom_fov = "..tostring(fov)
	end,
})

--[[ health and breath commands ]]

if(minetest.setting_getbool("enable_damage") == true) then
	minetest.register_chatcommand("sethp", {
	params = "<hp>",
	privs = {heal=true},
	description = "Set your health",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, "No player."
		end
		local hp = tonumber(param)
		if not hp then
			return false, "Missing or incorrect hp parameter!"
		end
		player:set_hp(hp)
		return true
	end,
})
	minetest.register_chatcommand("setbreath", {
		params = "<breath number>",
		description = "Sets your breath to specified breath points",
		privs = {heal=true},
		func = function(name, breath)
			local player = minetest.get_player_by_name(name)
			if not player then
				return
			end
			if breath == "" then
				minetest.chat_send_player(name, "You did not specify the parameter.")
				return
			end
			if type(tonumber(breath)) ~= "number" then
				minetest.chat_send_player(name, "This is not a number.")
				return
			end
			local bp = math.max(0, tonumber(breath)) -- ensure minimum value of 0
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

-- speed
minetest.register_chatcommand("setspeed", {
	params = "[<speed>]",
	description = "Sets your movement speed to <speed> (default: 1)",
	privs={physics=true},
	func = function(name, speed)
		local player = minetest.get_player_by_name(name)
		if not player then
			return
		end
		if speed == "" then
			speed=1
		end
		if type(tonumber(speed)) ~= "number" then
			minetest.chat_send_player(name, "This is not a number.")
			return
		end

		player:set_physics_override(tonumber(speed), nil, nil)
	end,
})

-- gravity
minetest.register_chatcommand("setgravity", {
	params = "[<gravity>]",
	description = "Sets your gravity to <gravity> (default: 1)",
	privs={physics=true},
	func = function(name, gravity)
		local player = minetest.get_player_by_name(name)
		if not player then
			return
		end
		if gravity == "" then
			gravity=1
		end
		if type(tonumber(gravity)) ~= "number" then
			minetest.chat_send_player(name, "This is not a number.")
			return
		end
		player:set_physics_override(nil, nil, tonumber(gravity))
	end,
})

-- jump height
minetest.register_chatcommand("setjump", {
	params = "[<height>]",
	description = "Sets your jump height to <height> (default: 1)",
	privs = {physics=true},
	func = function(name, jump_height)
		local player = minetest.get_player_by_name(name)
		if not player then
			return
		end
		if jump_height == "" then
			jump_height=1
		end
		if type(tonumber(jump_height)) ~= "number" then
			minetest.chat_send_player(name, "This is not a number.")
			return
		end
		player:set_physics_override(nil, jump_height, nil)
	end,
})

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
		return true, "Your stuff pulverized"
	else
		if not minetest.check_player_privs(name, "server") then
			return minetest.chat_send_player(name,"You are not have server priv")
		end
  local pname = minetest.get_player_by_name(param)
		if pname then
		local inv = pname:get_inventory()
		inv:set_list("main", {})
		inv:set_list("craft", {})
		return true, "Pulverized "..param.."'s stuff"
		else
		return false, "Invalid player"
		end
  end
	end,
})