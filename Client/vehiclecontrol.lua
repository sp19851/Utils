--Вывод данных худа ТС
local inCar = false
local DamageEngine = 75
exports("ShowVehicleHud", function (bool)
    --if (inCar == false) then return end
    inCar= bool
end)

local function GetVehEngineHealth(veh)
        return (GetVehicleEngineHealth(veh) / 1000) * 100;
end
        --[[public float GetVehBodyHealth(CitizenFX.Core.Vehicle veh)
        {
            return (veh.BodyHealth / 1000f) * 100f;
        }
        public float GetVehHealth(CitizenFX.Core.Vehicle veh)
        {
            return (veh.HealthFloat / veh.MaxHealthFloat) * 100f;
        }
        public float GetVehSubmission(CitizenFX.Core.Vehicle veh)
        {
            return (veh.SubmersionLevel / 1000f) * 100f;
        }]]

local function DamageControl()
    local vehicle = GetVehicleIsPedIsDriver()
    if (GetVehEngineHealth(vehicle) < DamageEngine) then
        SetVehicleEngineHealth(vehicle, 100)
        SetVehicleUndriveable(vehicle, true)
        SetVehicleEngineOn(vehicle, false, true, true)
    end
    
end


Citizen.CreateThread(function()
    while true do
        if (not Config.Hud.CanHudShow) then return end
        if (IsPedIsDriver()) then
            local ped = PlayerPedId()
            local playerPositionX, playerPositionY, playerPositionZ = table.unpack(GetEntityCoords(ped, true))
            local streetHash = 0
            local crossingRoad = 0
            local streetHash, crossingRoad = GetStreetNameAtCoord(playerPositionX, playerPositionY, playerPositionZ)
            local streetName = GetStreetNameFromHashKey(streetHash)
            local zone = GetNameOfZone(playerPositionX, playerPositionY, playerPositionZ)
            local zoneText = ""
            for i, v in pairs(Config.Zones) do
                if i == zone then
                    zoneText = v[1]
                    break  
                end
            end
            local veh = GetVehicleIsPedIsDriver()
            local vehH = GetEntityHeading(veh)
            if (crossingRoad >0 ) then
                street = GetDirectionText(vehH) .." | " .. zoneText
                street2 = streetName .. " | " .. GetStreetNameFromHashKey(crossingRoad)
            else
                street = GetDirectionText(vehH) .." | " .. zoneText
                street2 = streetName
            end
            IsCanHudShow()
            SendNUIMessage({
                request = "hud.other",
                street = street,
                street2 = street2,
                inCar = IsPedIsDriver(),
                --canHudShow = Config.Hud.CanHudShow
                
            })

            DamageControl()

        else 
            SendNUIMessage({
                request = "carhud.hide",
                street = street,
                street2 = street2,
                inCar = IsPedIsDriver(),
                --canHudShow = Config.Hud.CanHudShow
                
            })
        end
        Citizen.Wait(100)
    end
end)


RegisterNetEvent('VehicelHudUpdate', function(mileage)
    if (not Config.Hud.CanHudShow) then return end    
    --if (not IsPedIsDriver()) then return end 
    Citizen.CreateThread(function()
        local ped = PlayerPedId()
        local vehicle = GetVehicleIsPedIsDriver()
        local speed = math.floor(GetEntitySpeed(vehicle) * 3.6)
        local rpm = math.floor(GetVehicleCurrentRpm(vehicle) * 100)
        local vehicleHealth = GetVehicleEngineHealth(vehicle)
        local fuel = GetVehicleFuelLevel(vehicle)
        local curVehiclePlate = GetVehicleNumberPlateText(vehicle)
        local curGear = GetVehicleCurrentGear(vehicle)
        local x,y,z = table.unpack(GetEntitySpeedVector(vehicle, true))
        if (y < 0) then curGear = "R" end 
        
        --print("VehicelHudUpdate", vehicle, speed , rpm, curGear, mileage, m)
        SendNUIMessage({
            action = "VehicleInfo",
            vehicleSpeed = speed,
            rpm = rpm,
            vehicleHealth = vehiclehealth,
            fuel = fuel,
            gear = gear,
            mileage = mileage, 
            inCar = IsPedIsDriver(),
            --canHudShow = CanHudShow
        })
        TerminateThisThread()
    end)
end)


--[[exports("VehicelHudUpdate", function (mileage)
--local function vehicelHudUpdate(mileage)
    if (not Config.Hud.CanHudShow) then return end    
    --if (not IsPedIsDriver()) then return end 
    Citizen.CreateThread(function()
        local ped = PlayerPedId()
        local vehicle = GetVehicleIsPedIsDriver()
        local speed = math.floor(GetEntitySpeed(vehicle) * 3.6)
        local rpm = math.floor(GetVehicleCurrentRpm(vehicle) * 100)
        local vehicleHealth = GetVehicleEngineHealth(vehicle)
        local fuel = GetVehicleFuelLevel(vehicle)
        local curVehiclePlate = GetVehicleNumberPlateText(vehicle)
        local curGear = GetVehicleCurrentGear(vehicle)
        local x,y,z = table.unpack(GetEntitySpeedVector(vehicle, true))
        if (y < 0) then curGear = "R" end 
        
        --print("VehicelHudUpdate", vehicle, speed , rpm, curGear, mileage, m)
        SendNUIMessage({
            action = "VehicleInfo",
            vehicleSpeed = speed,
            rpm = rpm,
            vehicleHealth = vehiclehealth,
            fuel = fuel,
            gear = gear,
            mileage = mileage, 
            inCar = IsPedIsDriver(),
            --canHudShow = CanHudShow
        })
        TerminateThisThread()
    end)
    
    
end)]]
--end
--exports('VehicelHudUpdate', vehicelHudUpdate)