--Вывод данных худа ТС
local inCar = false
exports("ShowVehicleHud", function (bool)
    --if (inCar == false) then return end
    inCar= bool
end)

Citizen.CreateThread(function()
    while true do
        if (not Config.Hud.CanHudShow) then return end
        if (IsPedIsDriver()) then
            local ped = PlayerPedId()
            local playerPositionX, playerPositionY, playerPositionZ = table.unpack(GetEntityCoords(ped, true))
            local streetHash = 0
            local crossingRoad = 0
            local streetHash, crossingRoad = GetStreetNameAtCoord(playerPositionX, playerPositionY, playerPositionZ)
            local street = GetStreetNameFromHashKey(streetHash)
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
                street = GetDirectionText(vehH) .." | " .. zoneText .. " | " .. street .. " | " .. GetStreetNameFromHashKey(crossingRoad)
            else
                street = GetDirectionText(vehH) .. " | " .. zoneText .. " | " .. street
            end
            IsCanHudShow()
            SendNUIMessage({
                request = "hud.other",
                street = street,
                inCar = IsPedIsDriver(),
                --canHudShow = Config.Hud.CanHudShow
                
            })
        else 
            SendNUIMessage({
                request = "carhud.hide",
                street = street,
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