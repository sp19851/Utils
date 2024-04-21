local timerDead = 10
local isDieTimer = false
local NeedHideHud = false
local isCallDoctor = true
local timerDeadStarted = false

local deadAnimDict = 'dead'
local deadAnim = 'dead_a'

local inBedDict = 'anim@gangops@morgue@table@'
local inBedAnim = 'body_search'

local function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

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

exports("DoctorAlredyCalled", function ()
    local ped = PlayerPedId()
    local health = GetEntityHealth(ped)
    if (timerDeadStarted && health >0) then return end
        isCallDoctor = false
        local huditems = {
        isCallDoctor = isCallDoctor,
        isNeedHospital = false,
        timerDeath = timerDead,
        keyCall_Doctor = "G",
        keyRespawn = "E",
        priceRespawn = 350,
    }
    SendNUIMessage({
        request = "hud.death.show",
        huditems = huditems
    })
end)

exports("ResetTimerDeadStarted", function ()
    print("ResetTimerDeadStarted")
    timerDeadStarted = false
    AnimpostfxStop("PauseMenuIn")
end)

function onShowHud(visible)
    SendNUIMessage({
        request = "hud.show", 
        visible = visible
    })
end



--[[function StartDoctorCallContol()
    local sleep = 0
    local needtick = true
    Citizen.CreateThread(function()
        while needtick do
            if (IsControlJustReleased(0, 47))  then --G
                --сделать затухание экрана
                print("TriggerServerEvent(Alert.DoctorCalling)")
                TriggerServerEvent("Alert.DoctorCalling")
                isCallDoctor = false
                local huditems = {
                    isCallDoctor = isCallDoctor,
                    isNeedHospital = false,
                    timerDeath = timerDead,
                    keyCall_Doctor = "G",
                    keyRespawn = "E",
                    priceRespawn = 350,
                }
                SendNUIMessage({
                    request = "hud.death.show",
                    huditems = huditems
                })
            end  
            Citizen.Wait(sleep)
        end
        TerminateThisThread()
    end)
end]]
function StartDieScreen()
    if (timerDeadStarted) then return end
    local sleep = 1000
    local needtick = true
    isDieTimer = true
    NeedHideHud = true
    TriggerEvent("Doctor.PedCall911", false)
    --StartDoctorCallContol()    
    Citizen.CreateThread(function()
        while needtick do
            DisableAllControlActions(0)
            EnableControlAction(0, 1, true)
            EnableControlAction(0, 2, true)
            EnableControlAction(0, 245, true)
            EnableControlAction(0, 38, true)
            EnableControlAction(0, 0, true)
            EnableControlAction(0, 322, true)
            EnableControlAction(0, 288, true)
            EnableControlAction(0, 213, true)
            EnableControlAction(0, 249, true)
            EnableControlAction(0, 46, true)
            EnableControlAction(0, 47, true)
            if IsPedInAnyVehicle(ped, false) then
                loadAnimDict('veh@low@front_ps@idle_duck')
                if not IsEntityPlayingAnim(ped, 'veh@low@front_ps@idle_duck', 'sit', 3) then
                    TaskPlayAnim(ped, 'veh@low@front_ps@idle_duck', 'sit', 1.0, 1.0, -1, 1, 0, 0, 0, 0)
                end
            else
                local isInHospitalBed = false
                local ped = PlayerPedId()
                if isInHospitalBed then
                    if not IsEntityPlayingAnim(ped, inBedDict, inBedAnim, 3) then
                        loadAnimDict(inBedDict)
                        TaskPlayAnim(ped, inBedDict, inBedAnim, 1.0, 1.0, -1, 1, 0, 0, 0, 0)
                    end
                else
                    if not IsEntityPlayingAnim(ped, deadAnimDict, deadAnim, 3) then
                        loadAnimDict(deadAnimDict)
                        TaskPlayAnim(ped, deadAnimDict, deadAnim, 1.0, 1.0, -1, 1, 0, 0, 0, 0)
                    end
                end
            end


            local huditems = {
                isCallDoctor = isCallDoctor,
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
             
            if (timerDead < 0) then
                timerDead = 0
                needtick = false
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
    AnimpostfxPlay("PauseMenuIn", 1000, true);   
    Citizen.CreateThread(function()
        while needtick do
            DisableAllControlActions(0)
            EnableControlAction(0, 1, true)
            EnableControlAction(0, 2, true)
            EnableControlAction(0, 245, true)
            EnableControlAction(0, 38, true)
            EnableControlAction(0, 0, true)
            EnableControlAction(0, 322, true)
            EnableControlAction(0, 288, true)
            EnableControlAction(0, 213, true)
            EnableControlAction(0, 249, true)
            EnableControlAction(0, 46, true)
            EnableControlAction(0, 47, true)
            local huditems = {
                isCallDoctor = isCallDoctor,
                isNeedHospital = true,
                timerDeath = timerDead,
                keyCall_Doctor = "G",
                keyRespawn = "E",
                priceRespawn = 350,
            }
            SendNUIMessage({
                request = "hud.death.show",
                huditems = huditems
            })
            if (IsControlJustReleased(0, 47) and isCallDoctor)  then --G
                --сделать затухание экрана
                print("TriggerServerEvent(Alert.DoctorCalling)")
                TriggerServerEvent("Alert.DoctorCalling")
                isCallDoctor = false
                local huditems = {
                    isCallDoctor = isCallDoctor,
                    isNeedHospital = false,
                    timerDeath = timerDead,
                    keyCall_Doctor = "G",
                    keyRespawn = "E",
                    priceRespawn = 350,
                }
                SendNUIMessage({
                    request = "hud.death.show",
                    huditems = huditems
                })
            end  
            if (IsControlJustReleased(0, 38))  then --E
              --сделать затухание экрана
              TriggerEvent("Doctor.RespawnToHospital")
              AnimpostfxStop("PauseMenuIn")
              print("TriggerEvent(Doctor.RespawnToHospital)")
              NeedHideHud = false
              isDieTimer = false 
              needtick = false
              SendNUIMessage({
                request = "hud.death.hide",
              })
              Citizen.Wait(5000)
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
        --print("IsPauseMenuActive isShow", Config.Hud.isShow, "CanHudShow ", Config.Hud.CanHudShow, "IsPauseMenuActive()", IsPauseMenuActive(), "NeedHideHud", NeedHideHud)
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
        --print("231", "Config.Hud.CanHudShow", Config.Hud.CanHudShow, "isDieTimer", isDieTimer)
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
                
                --print("292 здоровье 0 поэтому NeedHideHud = true")
                
                --[[//отключить худ
                //отключить метоболизм
                //отключить все уведомления
                ]]
                
                StartDieScreen()
                timerDeadStarted = true
            else
                Config.Hud.CanHudShow = true  
            end
    
        end
        Citizen.Wait(0)
    end
end)

