local timerDead = 30
local isDieTimer = false
local NeedHideHud = false

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
    --print("onShowHud", visible)
    SendNUIMessage({
        request = "hud.show", 
        visible = visible
    })
end

function StartDieScreen()
    local sleep = 1000
    local needtick = true
    AnimpostfxPlay("PauseMenuIn", 1000, true);        
    Citizen.CreateThread(function()
        while needtick do
            
            NeedHideHud = true
            local huditems = {
                isCallDoctor = true,
                timerDeath = timerDead,
                keyCall_Doctor = "G",
                keyRespawn = "E",
                priceRespawn = 350,
            }
            SendNUIMessage({
                request = "hud.death.show",
                huditems = huditems
            })
            timerDead = timerDead - 1
            if (IsControlJustReleased(0, 47))  then --G
                --сделать затухание экрана
                TriggerClientEvent("Alert.DoctorCalling")
                local huditems = {
                    isNeedHospital = true,
                    timerDeath = timerDead,
                    keyCall_Doctor = "G",
                    keyRespawn = "E",
                    priceRespawn = 350,
                }
                
            end   
                  
              
           
            if (timerDead < 0) then
                timerDead = 0
                needtick = false;
                StartRespawnScreen()
            end
            Citizen.Wait(sleep)
        end
        TerminateThisThread()
    end)
end

function StartRespawnScreen()
    local sleep = 0
    local needtick = true
    AnimpostfxStop("PauseMenuIn")
    Citizen.CreateThread(function()
     
        while needtick do
            NeedHideHud = true
            local huditems = {
                isCallDoctor = false,
                timerDeath = timerDead,
                keyCall_Doctor = "G",
                keyRespawn = "E",
                priceRespawn = 350,
            }
            SendNUIMessage({
                request = "hud.death.show",
                huditems = huditems
            })
            if (IsControlJustReleased(0, 38))  then --E
              --сделать затухание экрана
              TriggerClientEvent("Doctor.RespawnToNeerHospital")
              print("TriggerClientEvent(Doctor.RespawnToNeerHospital)")
              NeedHideHud = false
              SendNUIMessage({
                request = "hud.death.hide",
                huditems = huditems
                
            })
            end
            Citizen.Wait(sleep)
        end
        TerminateThisThread()
    end)
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
        --print("IsPauseMenuActive isShow", Config.Hud.isShow, "CanHudShow ", Config.Hud.CanHudShow)
        if (IsPauseMenuActive() or NeedHideHud) then 
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
        --print("isDieTimer", isDieTimer)
        --print("Config.Hud.CanHudShow", Config.Hud.CanHudShow)
        if (NeedHideHud) then
            DisplayRadar(false)
        else
            if (IsRadarHidden()) then DisplayRadar(true) end
        end
        if (isDieTimer == false and Config.Hud.CanHudShow == true) then 
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
            --проверяем не умерли мы
            if (health <= 0 ) then
                --print("Мы помираем.....", IsPedDeadOrDying(ped, true), IsEntityDead(ped))
                isDieTimer = true
                NeedHideHud = true
                --[[//отключить худ
                //отключить метоболизм
                //отключить все уведомления
                ]]
                TriggerEvent("Doctor.PedCall911", false)
                StartDieScreen()
            else
                Config.Hud.CanHudShow = true  
            end
    
        end
        Citizen.Wait(0)
    end
end)

