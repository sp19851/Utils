function IsCanHudShow() 
    Config.Hud.CanHudShow = true
    if (IsPauseMenuActive()) then Config.Hud.CanHudShow = false end
end

local function DrawText2(text)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextScale(0.0, 0.45)
	SetTextDropshadow(1, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	BeginTextCommandDisplayText("STRING")
	AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(0.45, 0.90)
end

exports("ShowHud", function (visible)
    print("exports ShowHud visible", visible)
    Config.Hud.isShow = visible
    if (not Config.Hud.CanHudShow) then 
        Config.Hud.isShow = false
    end
    
    SendNUIMessage({
        request = "hud.show", 
        visible = visible
    })
end)

function onShowHud(visible)
    --Config.Hud.isShow = visible
    --[[if (Config.Hud.CanHudShow == false) then 
        Config.Hud.isShow = false
    end]]
    
    SendNUIMessage({
        request = "hud.show", 
        visible = visible
    })
end


exports("SetChash", function (cash)
    SendNUIMessage({
        request = "hud.setcash", value = cash
    })
end)

exports("SetServerId", function (serverId)
    SendNUIMessage({
        request = "hud.setserverid", value = serverId
    })
end)

RegisterNetEvent('SetClock', function(day, month,  year,  hours,  minutes,  seconds)
    SendNUIMessage({
        request = "hud.setclock",
        day = day,
        month = month,
        year = year,
        hours = hours,
        minutes = minutes,
        seconds = seconds,
        canHudShow =  Config.Hud.CanHudShow
    })
end)

--[[exports("SetClock", function (day, month,  year,  hours,  minutes,  seconds)
    SendNUIMessage({
        request = "hud.setclock",
        day = day,
        month = month,
        year = year,
        hours = hours,
        minutes = minutes,
        seconds = seconds,
        canHudShow =  Config.Hud.CanHudShow
    })
end)]]


RegisterNetEvent('SetWeather', function(currentWeather)
   print('72 SetWeather', currentWeather)
    
    SendNUIMessage({
        request = "hud.setweather",
        weather = currentWeather,
        canHudShow =  Config.Hud.CanHudShow
    })
end)

--[[exports("SetWeather", function (currentWeather)
    SendNUIMessage({
        request = "hud.setweather",
        weather = currentWeather,
        canHudShow =  Config.Hud.CanHudShow
    })
end)]]

Citizen.CreateThread(function()
    while true do
        print("IsPauseMenuActive isShow", Config.Hud.isShow, "CanHudShow ", Config.Hud.CanHudShow)
        if (IsPauseMenuActive()) then 
            Config.Hud.CanHudShow = false 
            onShowHud(Config.Hud.CanHudShow)
        else 
            Config.Hud.CanHudShow = true 
            if (Config.Hud.isShow) then
                onShowHud(Config.Hud.isShow)
            end
        end
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        if (not Config.Hud.CanHudShow) then return end
        local ped = PlayerPedId()
        local health = GetEntityHealth(ped)
        local val = health - 100
        local armor = GetPedArmour(ped)
        local stamina = math.floor(GetPlayerStamina(PlayerId()))
        local oxygen = math.floor(GetPlayerUnderwaterTimeRemaining(PlayerId())) * 10
        local inwater = IsPedSwimmingUnderWater(ped)

        if (GetEntityModel(ped) == GetHashKey("mp_f_freemode_01")) then val = (health + 25) - 100 end
        local hunger = 80;
        local thirst = 50;
        IsCanHudShow()
        --Hud.SetCharacterStatus(health, armor, stamina, oxygen,  inwater, hunger, thirst);
        SendNUIMessage({
            request = "hud.statusupdate",
            health,
            armor,
            stamina,
            oxygen,
            inwater,
            hunger,
            thirst,
            --canHudShow = Config.Hud.CanHudShow
            
        })
         
        Citizen.Wait(0)
    end
end)