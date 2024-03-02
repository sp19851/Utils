--[[RegisterNetEvent("utils:client:setdamage", function(vehicle,body)
    print("utils:client:setdamage", vehicle,body)
    SetVehicleBodyHealth(vehicle, body)
end)

local function doCarDamage(currentVehicle, veh)
	local engine = veh.engine + 0.0
	local body = veh.body + 0.0

    Wait(100)
    if VisuallyDamageCars then
        if body < 900.0 then
            SmashVehicleWindow(currentVehicle, 0)
            SmashVehicleWindow(currentVehicle, 1)
            SmashVehicleWindow(currentVehicle, 2)
            SmashVehicleWindow(currentVehicle, 3)
            SmashVehicleWindow(currentVehicle, 4)
            SmashVehicleWindow(currentVehicle, 5)
            SmashVehicleWindow(currentVehicle, 6)
            SmashVehicleWindow(currentVehicle, 7)
        end
        if body < 800.0 then
            SetVehicleDoorBroken(currentVehicle, 0, true)
            SetVehicleDoorBroken(currentVehicle, 1, true)
            SetVehicleDoorBroken(currentVehicle, 2, true)
            SetVehicleDoorBroken(currentVehicle, 3, true)
            SetVehicleDoorBroken(currentVehicle, 4, true)
            SetVehicleDoorBroken(currentVehicle, 5, true)
            SetVehicleDoorBroken(currentVehicle, 6, true)
        end
        if body < 700.0 then
            SetVehicleTyreBurst(currentVehicle, 1, false, 990.0)
            SetVehicleTyreBurst(currentVehicle, 2, false, 990.0)
            SetVehicleTyreBurst(currentVehicle, 3, false, 990.0)
            SetVehicleTyreBurst(currentVehicle, 4, false, 990.0)
        end
        if body < 500.0 then
            SetVehicleTyreBurst(currentVehicle, 0, false, 990.0)
            SetVehicleTyreBurst(currentVehicle, 5, false, 990.0)
            SetVehicleTyreBurst(currentVehicle, 6, false, 990.0)
            SetVehicleTyreBurst(currentVehicle, 7, false, 990.0)
        end
    end
    SetVehicleEngineHealth(currentVehicle, engine)
    SetVehicleBodyHealth(currentVehicle, body)

end]]


--local function VehicleFuelMileage(currentVehicle, veh)


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


exports("VehicelHudUpdate", function (mileage)
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
    end)
end)
--end
--exports('VehicelHudUpdate', vehicelHudUpdate)