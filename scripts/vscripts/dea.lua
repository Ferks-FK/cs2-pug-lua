--SHITTY PUG PLUGIN BY DEAFPS
-- HC_ functions by NickFox007

require "libs.timers"
require "whitelist"
require "pug_cfg"

roundStarted = false
currentMvmntSettings = "VNL"

local adminPlayers = {
	--admins/constantly whitelisted
	"[U:1:146535711]", --dea
	"[U:1:214857343]", --mezel
	"[U:1:83116821]", --malek
	"[U:1:166331469]", --kuba
	"[U:1:55900622]", --tamas
}

local activeAdmins = {}

function HC_ReplaceColorCodes(text)
	text = string.gsub(text, "{white}", "\x01")
	text = string.gsub(text, "{darkred}", "\x02")
	text = string.gsub(text, "{purple}", "\x03")
	text = string.gsub(text, "{darkgreen}", "\x04")
	text = string.gsub(text, "{lightgreen}", "\x05")
	text = string.gsub(text, "{green}", "\x06")
	text = string.gsub(text, "{red}", "\x07")
	text = string.gsub(text, "{lightgray}", "\x08")
	text = string.gsub(text, "{yellow}", "\x09")
	text = string.gsub(text, "{orange}", "\x10")
	text = string.gsub(text, "{darkgray}", "\x0A")
	text = string.gsub(text, "{blue}", "\x0B")
	text = string.gsub(text, "{darkblue}", "\x0C")
	text = string.gsub(text, "{gray}", "\x0D")
	text = string.gsub(text, "{darkpurple}", "\x0E")
	text = string.gsub(text, "{lightred}", "\x0F")
	return text
end

function HC_PrintChatAll(text)		
	ScriptPrintMessageChatAll(" " .. HC_ReplaceColorCodes(chatPrefix .. text))
end

function tableContains(table, value)
    for _, v in pairs(table) do
        if v == value then
            return true
        end
    end
    return false
end


function checkWL(event)
    local steamId = tostring(event.networkid)
	local username = tostring(event.name)

	if tableContains(adminPlayers, steamId) then
		table.insert(adminIDs, { ["Name"] = event.name, ["UserID"] = event.userid, ["SteamID3"] = event.networkid })
	end

	if tableContains(allowedPlayers, steamId) or tableContains(adminPlayers, steamId) then
		print("[Whitelist] " .. username .. " is allowed on this server")
	else
		print("[Whitelist] " .. username .. " not on whitelist, kicking...")
		SendToServerConsole("kickid " .. event.userid .. " You have been kicked from this server!")
	end  
end

function mvmntSettings(setting)
	if setting == "kz" then
		SendToServerConsole("sv_accelerate 6.5")
		SendToServerConsole("sv_accelerate_use_weapon_speed 0")
		SendToServerConsole("sv_airaccelerate 100.0")
		SendToServerConsole("sv_air_max_wishspeed 30.0")
		SendToServerConsole("sv_enablebunnyhopping 1")
		SendToServerConsole("sv_friction 5.0")
		SendToServerConsole("sv_gravity 800.0")
		SendToServerConsole("sv_jump_impulse 301.993377")
		SendToServerConsole("sv_ladder_scale_speed 1.0")
		SendToServerConsole("sv_ledge_mantle_helper 0.0")
		SendToServerConsole("sv_maxspeed 320.0")
		SendToServerConsole("sv_maxvelocity 2000.0")
		SendToServerConsole("sv_staminajumpcost 0.0")
		SendToServerConsole("sv_staminalandcost 0.0")
		SendToServerConsole("sv_staminamax 0.0")
		SendToServerConsole("sv_staminarecoveryrate 0.0")
		SendToServerConsole("sv_standable_normal 0.7")
		SendToServerConsole("sv_timebetweenducks 0.0")
		SendToServerConsole("sv_walkable_normal 0.7")
		SendToServerConsole("sv_wateraccelerate 10.0")
		SendToServerConsole("sv_water_movespeed_multiplier 0.8")
		SendToServerConsole("sv_water_swim_mode  0.0")
		SendToServerConsole("sv_weapon_encumbrance_per_item 0.0")
		SendToServerConsole("sv_weapon_encumbrance_scale 0.0")
		currentMvmntSettings = "KZ"
	end
	
	if setting == "vnl" then
		SendToServerConsole("sv_accelerate 5.5")
		SendToServerConsole("sv_accelerate_use_weapon_speed 1")
		SendToServerConsole("sv_airaccelerate 12.0")
		SendToServerConsole("sv_air_max_wishspeed 30.0")
		SendToServerConsole("sv_enablebunnyhopping 0")
		SendToServerConsole("sv_friction 5.2")
		SendToServerConsole("sv_gravity 800.0")
		SendToServerConsole("sv_jump_impulse 301.993377")
		SendToServerConsole("sv_ladder_scale_speed 0.78")
		SendToServerConsole("sv_ledge_mantle_helper 0.0")
		SendToServerConsole("sv_maxspeed 320.0")
		SendToServerConsole("sv_maxvelocity 3500.0")
		SendToServerConsole("sv_staminajumpcost 0.08")
		SendToServerConsole("sv_staminalandcost 0.05")
		SendToServerConsole("sv_staminamax 80.0")
		SendToServerConsole("sv_staminarecoveryrate 60.0")
		SendToServerConsole("sv_standable_normal 0.7")
		SendToServerConsole("sv_timebetweenducks 0.4")
		SendToServerConsole("sv_walkable_normal 0.7")
		SendToServerConsole("sv_wateraccelerate 10.0")
		SendToServerConsole("sv_water_movespeed_multiplier 0.8")
		SendToServerConsole("sv_water_swim_mode  0.0")
		SendToServerConsole("sv_weapon_encumbrance_per_item 0.85")
		SendToServerConsole("sv_weapon_encumbrance_scale 0.0")
		currentMvmntSettings = "VNL"
	end
	
end

function StartWarmup()
	
	if tableContains(activeAdmins, user) then
	
		SendToServerConsole("bot_kick")
		
		if warmupEndless == true then
			SendToServerConsole("mp_warmup_pausetimer 1")
		end
		
		SendToServerConsole("mp_warmuptime " .. warmupTime)
		
		if kzsettingsinwarmup == true then
			mvmntSettings("kz")
		end
		
		if kzsettingsinwarmup == false then
			mvmntSettings("vnl")
		end
	end
end

function RestartWarmup()
	local user = Convars:GetCommandClient()
	
	if tableContains(activeAdmins, user) then
	
		SendToServerConsole("mp_warmup_start")
		HC_PrintChatAll("{green} Restarting Warmup...")
		HC_PrintChatAll("{green} Restarting Warmup...")
		HC_PrintChatAll("{green} Restarting Warmup...")
		HC_PrintChatAll("{green} Restarting Warmup...")
		HC_PrintChatAll("{green} Restarting Warmup...")
		HC_PrintChatAll("{green} Restarting Warmup...")
		HC_PrintChatAll("{green} Restarting Warmup...")
		HC_PrintChatAll("{green} Restarting Warmup...")
		
		if kzsettingsinwarmup == true then
			mvmntSettings("kz")
		end
		
		if kzsettingsinwarmup == false then
			mvmntSettings("vnl")
		end
		
		roundStarted = false
	end
end

function StartPug()
	local user = Convars:GetCommandClient()
	
	if (roundStarted == false) and tableContains(activeAdmins, user) then
	
		seconds = 10
		roundStarted = true
		
		Timers:CreateTimer("startingpug_timer", {
						callback = function()
							HC_PrintChatAll("{green} Starting Pug in: " .. seconds)
							seconds = seconds - 1
							if seconds == 0 then
								Timers:RemoveTimer(startingpug_timer)
							end
							return 1.0
						end,
		})
		
		Timers:CreateTimer({
		useGameTime = false,
		endTime = 10, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
		callback = function()
			SendToServerConsole("mp_warmup_end")
			HC_PrintChatAll("{green} Starting Pug...")
			HC_PrintChatAll("{green} Starting Pug...")
			HC_PrintChatAll("{green} Starting Pug...")
			HC_PrintChatAll("{green} Starting Pug...")
			HC_PrintChatAll("{green} Starting Pug...")
			HC_PrintChatAll("{green} Starting Pug...")
			HC_PrintChatAll("{green} Starting Pug...")
			
		
			if kzsettings == true then
				mvmntSettings("kz")
			else 
				mvmntSettings("vnl")
			end
			
			HC_PrintChatAll("{green} Movement Settings: [" .. currentMvmntSettings .. "]")
		end
		})
	end
end

function ScrambleTeams()
	if tableContains(activeAdmins, user) then
		SendToServerConsole("mp_scrambleteams")
		HC_PrintChatAll("{green} Scrambling Teams...")
		HC_PrintChatAll("{green} Scrambling Teams...")
		HC_PrintChatAll("{green} Scrambling Teams...")
		HC_PrintChatAll("{green} Scrambling Teams...")
		HC_PrintChatAll("{green} Scrambling Teams...")
		HC_PrintChatAll("{green} Scrambling Teams...")
		HC_PrintChatAll("{green} Scrambling Teams...")
		HC_PrintChatAll("{green} Scrambling Teams...")
	end
end

function RestartPug()
	if tableContains(activeAdmins, user) then
		SendToServerConsole("mp_restartgame 1")
		HC_PrintChatAll("{green} Restarting Pug...")
		HC_PrintChatAll("{green} Restarting Pug...")
		HC_PrintChatAll("{green} Restarting Pug...")
		HC_PrintChatAll("{green} Restarting Pug...")
		HC_PrintChatAll("{green} Restarting Pug...")
		HC_PrintChatAll("{green} Restarting Pug...")
		HC_PrintChatAll("{green} Restarting Pug...")
		HC_PrintChatAll("{green} Movement Settings: [" .. currentMvmntSettings .. "]")
	end
end


function PrintWaitingforPlayers(event)
	
	if not warmupTimerStarted then
		warmupTimerStarted = true
		if not Timers:TimerExists(warmup_timer) then
			Timers:CreateTimer("warmup_timer", {
					callback = function()
						if not roundStarted then		
							HC_PrintChatAll("{green} Waiting for players")
							ScriptPrintMessageCenterAll("[DEAFPS PUG] Waiting for players")
						end
						return 2
					end,
			})
		end
	end
	
end

function addAdmin(activeAdmins, admin)
    for _, existingAdmin in ipairs(activeAdmins) do
        if existingAdmin == admin then
            print("admin already logged in")
            return
        end
    end

    table.insert(activeAdmins, admin)
end

Convars:RegisterCommand( "adminlogin" , function (_, pw)
        local password = tostring (pw) or  30
        
	if password == adminPassword then
		local admin = Convars:GetCommandClient()
		addAdmin(activeAdmins, admin)
		print("admin logged in")
	end
end, nil , FCVAR_PROTECTED)

Convars:RegisterCommand( "startpug", StartPug, nil, FCVAR_PROTECTED )
Convars:RegisterCommand( "scramble", ScrambleTeams, nil, FCVAR_PROTECTED )
Convars:RegisterCommand( "restartpug", RestartPug, nil, FCVAR_PROTECTED )
Convars:RegisterCommand( "rewarmup", RestartWarmup, nil, FCVAR_PROTECTED )

StartWarmup()

function Whitelist()
	if enableWhitelist then
		ListenToGameEvent("player_connect", checkWL, nil)
	end
end

ListenToGameEvent("player_spawn", PrintWaitingforPlayers, nil)

Whitelist()

print("[DEAFPS PUG] Plugin loaded!")
