local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vrp_warn")
MySQL = module("vrp_mysql", "MySQL")
MySQL.createCommand("vRP/addWarn","UPDATE vrp_users set warns = warns + 1 WHERE id = @id")
MySQL.createCommand ("vRP/warnInit","ALTER TABLE `vrp_users` ADD IF NOT EXISTS `warns` INT NOT NULL")
MySQL.createCommand("vRP/removeWarn", "UPDATE vrp_users SET warns = warns - 1 WHERE id = @id")
MySQL.createCommand("vRP/checkWarns", "SELECT warns FROM vrp_users WHERE id = @id")
MySQL.query("vRP/warnInit")
RegisterCommand("warns",function(source,args)
  local id = vRP.getUserId({source})
  local source2 = vRP.getUserSource({id})
  MySQL.query("vRP/checkWarns", {id = id}, function(rows)
    local warns = rows[1].warns
    vRPclient.notify(source2, {"[~r~WARN~w~] Ai ~r~" .. warns .. " ~w~warnuri"})
end)
end)
local function ch_snnaplesWARNPLAYER(player,choice)
   sourcePlayer = vRP.getUserSource({player})
  user_id = vRP.getUserId({sourcePlayer})
  playerName = GetPlayerName(sourcePlayer)
vRP.prompt({sourcePlayer,"ID:","", function(player,targetID)
   target = tonumber(targetID)
   sourceTarget = vRP.getUserSource({target})
   vRP.prompt({sourcePlayer,"Motiv Warn:","", function(player,warnReason1)
     
         sourceWarn = vRP.getUserSource({player})
        warnReason = tostring(warnReason1)
        if warnReason == nil then
          vRPclient.notify(sourceWarn,{"[~r~WARN~w~] Motivul nu poate sa fie gol!"})
        else
          MySQL.query("vRP/addWarn", {id = target})
          TriggerClientEvent("chatMessage", -1,"[^1WARN^0] Adminul " .. GetPlayerName(sourceWarn) .. " ^1i-a dat un warn lui ^0" .. GetPlayerName(sourceTarget) .. "\n ^1Motiv: ^0" .. warnReason)
        end
    end})
end})
end

local function ch_snnaplesUNWARNPLAYER(player,choice)
  sourcePlayer = vRP.getUserSource({player})
 user_id = vRP.getUserId({sourcePlayer})
 playerName = GetPlayerName(sourcePlayer)
vRP.prompt({sourcePlayer,"ID:","", function(player,targetID)
  target = tonumber(targetID)
  sourceTarget = vRP.getUserSource({target})
if target ~= nil then

 MySQL.query("vRP/removeWarn", {id = target})
 TriggerClientEvent("chatMessage", -1,"[^1WARN^0] Adminul " .. GetPlayerName(sourceWarn) .. " ^1i-a scos un warn lui ^0" .. GetPlayerName(sourceTarget))
  vRPclient.notify(sourceWarn,{"[~r~WARN~w~] I-ai scos un warn lui " .. GetPlayerName(sourceTarget)})

else
  vRPclient.notify(sourceWarn,{"[~r~WARN~w~] ID-ul nu este corect!"})


    end
end})
end
local function ch_snnaplesWARN(player,choice)
  vRP.buildMenu({"⚠️ Warn", {player = player}, function(menu)
    menu.name = "⚠️ Warn"
    menu.css={top="75px",header_color="rgba(200,0,0,0.75)"}
          menu.onclose = function(player) vRP.closeMenu({player}) end
          menu["Warn Player"] = {ch_snnaplesWARNPLAYER}
          menu["Scoate Warn"] = {ch_snnaplesUNWARNPLAYER}

  vRP.openMenu({player,menu})
end})
end
vRP.registerMenuBuilder({"admin", function(add, data)
local user_id = vRP.getUserId({data.player})
if user_id ~= nil then
  local choices = {}
  if(vRP.hasPermission({user_id, "admin.tickets"}))then
    choices["⚠️ Warn"] = {ch_snnaplesWARN}
  end
  add(choices)
end
end})
