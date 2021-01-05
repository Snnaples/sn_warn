local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
-- CREATE TABLE `s33_zedd`.`snnaples_warns` ( `id` INT NOT NULL , `reason` TEXT NOT NULL ) ENGINE = InnoDB;


vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vrp_warn")
MySQL = module("vrp_mysql", "MySQL")
MySQL.createCommand("snnaples/addWarn","INSERT IGNORE INTO snnaples_warns(id,reason) VALUES(@id,@reason)")
MySQL.createCommand("snnaples/checkWarns", "SELECT id from snnaples_warns WHERE id = @id")

RegisterCommand("warns",function(source,args)

  local id = vRP.getUserId({source})
  local source2 = vRP.getUserSource({id})

  MySQL.query("snnaples/checkWarns", {id = id}, function(rows)
    
    vRPclient.notify(source2, {"[~r~WARN~w~] Ai "} .. #rows[1] .. " ~r~warnuri")
  
  
  
  
  
  
  
  end)


end)

local function ch_snnaplesWARNPLAYER(player,choice)
   sourcePlayer = vRP.getUserSource({player})
  user_id = vRP.getUserId({sourcePlayer})
     playerName = GetPlayerName(sourcePlayer)
 
vRP.prompt({sourcePlayer,"ID:","", function(player,targetID)

  local target = tonumber(targetID)
  local sourceTarget = vRP.getUserSource({targetID})

  vRP.prompt({sourcePlayer,"Motiv warn:","", function(player,reason)
    
    warnReason = tostring(reason)
    if string.len(warnReason) == 0 then
      vRPclient.notify(sourcePlayer,"[~r~WARN~w~] Motivul nu poate sa fie gol!")
    else
      MySQL.query("snnaples/addWarn", {id = target, reason = warnReason})
      TriggerClientEvent("chatMessage", -1,"~w~Adminul " .. GetPlayerName(sourcePlayer) .. " ~r~i-a dat un warn lui " .. GetPlayerName(sourceTarget) .. "\n Motiv: " .. warnReason

    end
  end)}


end)}
end

local function ch_snnaplesWARN(player,choice)
  vRP.buildMenu({"⚠️ Warn", {player = player}, function(menu)
    menu.name = "⚠️ Warn"
    menu.css={top="75px",header_color="rgba(200,0,0,0.75)"}
          menu.onclose = function(player) vRP.closeMenu({player}) end
          menu["Warn Player"] = {ch_snnaplesWARNPLAYER}

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