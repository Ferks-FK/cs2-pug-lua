roundStarted = false

SendToServerConsole('alias "startpug" "sv_cheats 1; script_reload_code startpug; sv_cheats 0"')
SendToServerConsole('alias "scramble" "sv_cheats 1; script_reload_code scrambleteams; sv_cheats 0"')
SendToServerConsole('alias "restartpug" "sv_cheats 1; script_reload_code restartpug; sv_cheats 0"')


local allowedPlayers = {
	--admins/constantly whitelisted
	"[U:1:146535711]", --dea
	"[U:1:214857343]", --mezel
	"[U:1:83116821]", --malek
	"[U:1:166331469]", --kuba
	"[U:1:55900622]", --tamas
	--additional pug players here:
	"[U:1:00000000]", --example
  "[U:1:00000000]", --example
}

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
	ScriptPrintMessageChatAll(" " .. HC_ReplaceColorCodes(text))
end

function checkWL(event)
    local steamId = tostring(event.networkid)
	local username = tostring(event.name)

    if tableContains(allowedPlayers, steamId) then
        print("[Whitelist] " .. username .. " is allowed on this server")
    else
        print("[Whitelist] " .. username .. " not on whitelist, kicking...")
		SendToServerConsole("kickid " .. event.userid .. " You have been kicked from this server!")
    end  
end

function tableContains(table, value)
    for _, v in pairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

function ConvarListener(event)
	
	if event.cvarname == startpug and event.cvarvalue == 1 then
		StartPug()
	end
	
	if event.cvarname == restartpug and event.cvarvalue == 1 then
		RestartPug()
	end
	
	if event.cvarname == scramble and event.cvarvalue == 1 then
		ScrambleTeams()
	end
end

function StartWarmup()
	SendToServerConsole("bot_kick")
	SendToServerConsole("mp_warmuptime 234124235")
end

function StartPug()
	SendToServerConsole("mp_warmup_end")
	HC_PrintChatAll("{red} [DEAFPS Pug Plugin] {green} Starting Pug...")
	roundStarted = true
end

function ScrambleTeams()
    SendToServerConsole("mp_scrambleteams")
    HC_PrintChatAll("{red} [DEAFPS Pug Plugin] {green} Scrambling Teams...")
end

function RestartPug()
    SendToServerConsole("mp_restartgame 1")
    HC_PrintChatAll("{red} [DEAFPS Pug Plugin] {green} Restarting Pug...")
end

function PrintWaitingforPlayers()
    if not roundStarted then
		HC_PrintChatAll("{red} [DEAFPS Pug Plugin] {green} Waiting for players")
	end
end


ListenToGameEvent("player_footstep", PrintWaitingforPlayers, nil)
ListenToGameEvent("player_connect", checkWL, nil)
StartWarmup()

print("[DEAFPS Pug Plugin] Plugin loaded!")