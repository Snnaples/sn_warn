local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vrp_warn") 
RegisterCommand("warns",function(source,args)
  local id = vRP.getUserId({source})
  local source2 = vRP.getUserSource({id})
 exports['GHMattiMySQL']:QueryResultAsync("SELECT warns FROM vrp_users WHERE id = @id", {id = id}, function(rows)
vRPclient.notify(source2, {"[~r~WARN~w~] Ai ~r~" .. rows[1].warns .. " ~w~warnuri"})

end)
end)

local function ch_snnaplesWARNPLAYER(player,choice)
   

  user_id = vRP.getUserId({player})
 sourcePlayer = vRP.getUserSource({user_id})
 playerName = GetPlayerName(sourcePlayer)
vRP.prompt({sourcePlayer,"ID:","", function(player,targetID)
   target = parseInt(targetID)
   sourceTarget = vRP.getUserSource({target})
   
   vRP.prompt({sourcePlayer,"Motiv Warn:","", function(player,warnReason1)
        warnReason = tostring(warnReason1)
        if warnReason == nil then
          vRPclient.notify(sourcePlayer,{"[~r~WARN~w~] Motivul nu poate sa fie gol!"})
        else
          exports['GHMattiMySQL']:QueryAsync("UPDATE vrp_users SET warns = warns + 1 WHERE id = @id", {id = target}, function()
           TriggerClientEvent("chatMessage", -1,"[^1WARN^0] Adminul " .. playerName .. " ^1i-a dat un warn lui ^0" .. GetPlayerName(sourceTarget) .. "\n ^1Motiv: ^0" .. warnReason)
           end)
          end
    end})
end})
end

local function ch_snnaplesUNWARNPLAYER(player,choice)
 
 user_id = vRP.getUserId({player})
 sourcePlayer = vRP.getUserSource({user_id})
 playerName = GetPlayerName(sourcePlayer)
vRP.prompt({sourcePlayer,"ID:","", function(player,targetID)
  target = parseInt(targetID)
  idSource = vRP.getUserId({target})
   sourceTarget = vRP.getUserSource({idSource})
if target ~= nil then
 exports['GHMattiMySQL']:QueryAsync("UPDATE vrp_users SET warns = warns - 1 WHERE id = @id", {id = target}, function()end)
 TriggerClientEvent("chatMessage", -1,"[^1WARN^0] Adminul " .. playerName .. " ^1i-a scos un warn lui ^0" .. GetPlayerName(sourceTarget))
  vRPclient.notify(sourcePlayer,{"[~r~WARN~w~] I-ai scos un warn lui " .. GetPlayerName(sourceTarget)})
else
  vRPclient.notify(sourcePlayer,{"[~r~WARN~w~] ID-ul nu este corect!"})
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
