--SHITTY PUG PLUGIN BY DEAFPS
-- HC_ functions by NickFox007

require "libs.timers"
require "whitelist"
require "banlist"
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
local connectedPlayers = {}
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

function checkBanlist(event)
	local steamId = tostring(event.networkid)
	local username = tostring(event.name)
	
	if tableContains(bannedPlayers, steamId) then
		print("[Banlist] " .. username .. " isnt allowed on this server")
		SendToServerConsole("kickid " .. event.userid .. " You have been banned!")
	end
end

function checkWL(event)
	local steamId = tostring(event.networkid)
	local username = tostring(event.name)

	if tableContains(allowedPlayers, steamId) or tableContains(adminPlayers, steamId) then
		print("[Whitelist] " .. username .. " is allowed on this server")
	else
		print("[Whitelist] " .. username .. " not on whitelist, kicking...")
		SendToServerConsole("kickid " .. event.userid .. " You are not on the whitelist!")
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

function setGeneralSettings()
	SendToServerConsole("bot_kick")
	SendToServerConsole("mp_ignore_round_win_conditions 0")
	SendToServerConsole("mp_limitteams " .. teamSize )
	SendToServerConsole("mp_team_timeout_max " .. timeoutsPerTeam )
	SendToServerConsole("mp_team_timeout_time " .. timeoutDuration )
	
	if useCustomCFG == true then
		SendToServerConsole("exec " .. customCFG )
	end
end

function StartWarmup()
	SendToServerConsole("mp_warmup_start")
	setGeneralSettings()
	
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

Convars:RegisterCommand("rewarmup", function()
	local user = Convars:GetCommandClient()
	
	if tableContains(activeAdmins, user) then
	
		SendToServerConsole("mp_warmup_start")
		setGeneralSettings()
		
		if warmupEndless == true then
			SendToServerConsole("mp_warmup_pausetimer 1")
		end
		
		SendToServerConsole("mp_warmuptime " .. warmupTime)
		
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
end, nil, 0)

function StartPug(reason)
	
	if (roundStarted == false) then
	
		seconds = 10
		roundStarted = true
		
		Timers:CreateTimer("startingpug_timer", {
						callback = function()
							HC_PrintChatAll("{white}" .. reason .. " {green} Starting Pug in: " .. seconds)
							seconds = seconds - 1
							if seconds == 0 then
								Timers:RemoveTimer(startingpug_timer)
							end
							return 1.0
						end,
		})
		
		Timers:CreateTimer({
		useGameTime = false,
		endTime = 10,
		callback = function()
			SendToServerConsole("mp_warmup_end")
			setGeneralSettings()
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
			
			HC_PrintChatAll("{white}" .. reason .. "{green} Movement Settings: [" .. currentMvmntSettings .. "]")
		end
		})
	end
end	

Convars:RegisterCommand("startpug", function()
	local user = Convars:GetCommandClient()
	print(user)
	
	if (roundStarted == false) and tableContains(activeAdmins, user) then
		StartPug("[Admin]")
	end
end, nil, 0)

Convars:RegisterCommand("scramble", function()
	local user = Convars:GetCommandClient()
	
	if tableContains(activeAdmins, user) then
		setGeneralSettings()
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
end, nil, 0)

Convars:RegisterCommand("pausepug", function()
	local user = Convars:GetCommandClient()
	
	if tableContains(activeAdmins, user) then
		SendToServerConsole("mp_pause_match")
		HC_PrintChatAll("{green} Pausing Pug...")
		HC_PrintChatAll("{green} Pausing Pug...")
		HC_PrintChatAll("{green} Pausing Pug...")
		HC_PrintChatAll("{green} Pausing Pug...")
		HC_PrintChatAll("{green} Pausing Pug...")
		HC_PrintChatAll("{green} Pausing Pug...")
		HC_PrintChatAll("{green} Pausing Pug...")
		HC_PrintChatAll("{green} Pausing Pug...")
	end
end, nil, 0)

Convars:RegisterCommand("unpausepug", function()
	local user = Convars:GetCommandClient()
	
	if tableContains(activeAdmins, user) then
		SendToServerConsole("mp_unpause_match")
		HC_PrintChatAll("{green} Unpausing Pug...")
		HC_PrintChatAll("{green} Unpausing Pug...")
		HC_PrintChatAll("{green} Unpausing Pug...")
		HC_PrintChatAll("{green} Unpausing Pug...")
		HC_PrintChatAll("{green} Unpausing Pug...")
		HC_PrintChatAll("{green} Unpausing Pug...")
		HC_PrintChatAll("{green} Unpausing Pug...")
		HC_PrintChatAll("{green} Unpausing Pug...")
	end
end, nil, 0)

Convars:RegisterCommand("restartpug", function()
	local user = Convars:GetCommandClient()
	if tableContains(activeAdmins, user) then
		if kzsettings == true then
				mvmntSettings("kz")
			else 
				mvmntSettings("vnl")
		end
		
		SendToServerConsole("mp_restartgame 1")
		setGeneralSettings()
		HC_PrintChatAll("{green} Restarting Pug...")
		HC_PrintChatAll("{green} Restarting Pug...")
		HC_PrintChatAll("{green} Restarting Pug...")
		HC_PrintChatAll("{green} Restarting Pug...")
		HC_PrintChatAll("{green} Restarting Pug...")
		HC_PrintChatAll("{green} Restarting Pug...")
		HC_PrintChatAll("{green} Restarting Pug...")
		HC_PrintChatAll("{green} Movement Settings: [" .. currentMvmntSettings .. "]")
	end
end, nil, 0)

function KickAllPlayers()
    for userid, _ in pairs(connectedPlayers) do
        SendToServerConsole("kickid " .. userid .. " server is changing map, please reconnect")
    end
end

Convars:RegisterCommand("changemap", function (_, map)
	local mmap = tostring (map) or  30
	local user = Convars:GetCommandClient()
	
	if tableContains(activeAdmins, user) then
	
		seconds = 10
		roundStarted = true
		Timers:CreateTimer("startingpug_timer", {
						callback = function()
							HC_PrintChatAll("{green} Changing Map in: " .. seconds)
							seconds = seconds - 1
							if seconds == 0 then
								Timers:RemoveTimer(startingpug_timer)
							end
							return 1.0
						end,
		})

		if autokickOnMapChange == true then
			Timers:CreateTimer({
			useGameTime = false,
			endTime = 10,
			callback = function()
				KickAllPlayers()
					
			end
			})
		end
				
		Timers:CreateTimer({
		useGameTime = false,
		endTime = 15,
		callback = function()
			SendToServerConsole("map " .. mmap)
				
		end
		})
	end
end, nil, 0)

Convars:RegisterCommand( "pugkick" , function (_, id)
        local userid = tostring (id)
        local user = Convars:GetCommandClient()
	
	if tableContains(activeAdmins, user) then
		SendToServerConsole("kickid " .. userid .. " kicked by server admin")
		print(userid .. " kicked from the server")
	end
end, nil , FCVAR_PROTECTED)

Convars:RegisterCommand( "pugkickall" , function ()
    local user = Convars:GetCommandClient()
	
	if tableContains(activeAdmins, user) then
		KickAllPlayers()
	end
end, nil , FCVAR_PROTECTED)

local playersThatVoted = {}

wfpDelay = 0

function PrintWaitingforPlayers(event)
	
	if not warmupTimerStarted then
		warmupTimerStarted = true
		if not Timers:TimerExists(warmup_timer) then
			Timers:CreateTimer("warmup_timer", {
					callback = function()
						if not roundStarted then		
							
							if wfpDelay == waitingForPlayerMsgInterval then
								HC_PrintChatAll("{green} Waiting for players {lightgray}[Players ready: " .. #playersThatVoted .. "/" .. 2 * teamSize .. "]")
								wfpDelay = 0
							else
								wfpDelay = wfpDelay + 1
							end
								
							if votingEnabled then
								ScriptPrintMessageCenterAll("Waiting for players [Ready: " .. #playersThatVoted .. "/" .. 2 * teamSize .. "]     Use Ping to ready up!")
							else
								ScriptPrintMessageCenterAll("Waiting for Admin to start the pug!")
							end
						end
						return 1
					end,
			})
		end
	end
	
end

function removeFromVoted(userid)
    for index, id in ipairs(playersThatVoted) do
        if id == userid then
            table.remove(playersThatVoted, index)
            return
        end
    end
end

function GetPlayerName(userid)
    local playerData = connectedPlayers[userid]
    if playerData then
        return playerData.name
    else
        return "unknown"
    end
end

function PlayerVotes(event)
	if (roundStarted == false) and votingEnabled == true then
		
		local readyNeeded = 2 * teamSize
		
		if tableContains(playersThatVoted, event.userid) then
			removeFromVoted(event.userid)
			if autokickOnMapChange == true then
				HC_PrintChatAll( " {lightgray}" .. tostring(GetPlayerName(event.userid)) .. " is ready! {green} Players voted: " .. #playersThatVoted)
			end
		elseif not tableContains(playersThatVoted, event.userid) then
			table.insert(playersThatVoted, event.userid)
			if autokickOnMapChange == true then
				HC_PrintChatAll( " {lightgray}" .. tostring(GetPlayerName(event.userid)) .. " is not ready! {green} Players voted: " .. #playersThatVoted)
			end
		end
	
		if #playersThatVoted == readyNeeded then
			StartPug("[Ready]")
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

function OnPlayerConnect(event)
	if enableWhitelist == true then
		checkWL(event)
	end
	
	if enableWhitelist == false then
		checkBanlist(event)
	end
	
	local playerData = {
		name = event.name,
		userid = event.userid,
		networkid = event.networkid,
		address = event.address
	}
	connectedPlayers[event.userid] = playerData
end

function OnPlayerDisconnect(event)
	removeFromVoted(event.userid)
	connectedPlayers[event.userid] = nil
end

StartWarmup()

ListenToGameEvent("player_connect", OnPlayerConnect, nil)
ListenToGameEvent("player_spawn", PrintWaitingforPlayers, nil)
ListenToGameEvent("player_ping", PlayerVotes, nil)
ListenToGameEvent("player_disconnect", OnPlayerDisconnect, nil)

print("[DEAFPS PUG] Plugin loaded!")
