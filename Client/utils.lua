function IsPedIsDriver()
    local ped = PlayerPedId()
        if (IsPedInAnyVehicle(ped, false)) then
            if (GetPedInVehicleSeat(GetVehiclePedIsIn(ped, false), -1) == ped) then
                return true;
            end
        end
            return false;
end

function GetVehicleIsPedIsDriver()
    local ped = PlayerPedId()
    if (IsPedInAnyVehicle(ped, false)) then 
        if (GetPedInVehicleSeat(GetVehiclePedIsIn(ped, false), -1) == ped) then
            return GetVehiclePedIsIn(ped, false)
        end
    end
    return -1
end


function IsPedInVehicle()
    local ped = PlayerPedId()
    if (IsPedInAnyVehicle(ped, false)) then 
       return true
    end
    return false
end


function GetDirectionText(direction)
    if ((direction == 0 or  direction == 360) or 
        (direction >=340 and direction < 360) or 
        (direction >= 0 and direction < 20)) then
        return "Север"
    elseif (direction >= 20 and direction< 65) then
        return "Северо Восток"
    elseif (direction >= 65 and direction < 110) then
        return "Восток"
    elseif (direction >= 110 and direction < 160) then
        return "Юго Восток"
    elseif (direction >= 160 and direction < 200) then
        return "Юг"
    elseif (direction >= 200 and direction < 240) then
        return "Юго Запад"
    elseif (direction >= 240 and direction < 290) then
        return "Запад"
    elseif (direction >= 290 and direction < 340) then
        return "Северо Запад"
    else
        return "Error"
    end
end