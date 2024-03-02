Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        local control = true
        while control do 
            local player = GetPlayerPed(-1)
            local playerCoord = GetEntityCoords(player) 
            for i, v in pairs(Config.SpeedCam.Radars) do
                
                --print (i, '---', v, v.x, v.y, v.z, v.speed)
                if GetDistanceBetweenCoords(v.x, v.y, v.z, playerCoord, false) <= 25.0 then
                    local veh = GetVehiclePedIsIn(player, false)
					if GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1)), -1) == GetPlayerPed(-1) then
						if veh ~= 0 then
							local vehspeed = GetEntitySpeed(veh)
							local vehClass = GetVehicleClass(veh)
                           
							if vehClass ~= 16 and vehClass ~= 15 and vehClass ~= 13 then 
								print ('67', vehspeed, vehspeed* 3.6, vehClass, 'IsVehicleSirenOn(veh)', IsVehicleSirenOn(veh))
								--math.ceil(speed)
								if math.ceil(vehspeed * 3.6) > math.ceil((v.speed) + 10.0) then
                                    if vehClass == 18 then
                                        if IsVehicleSirenOn(veh) == false then
                                            TriggerServerEvent("InteractSound_SV:PlayOnSource", "speedcamera", 0.25)
                                            TriggerEvent("GenerateInvoiceEvent", vehspeed * 3.6)
                                        
											control = false
                                        end
                                    else
                                        TriggerServerEvent("InteractSound_SV:PlayOnSource", "speedcamera", 0.25)
                                        TriggerEvent("GenerateInvoiceEvent", vehspeed * 3.6)
                                        
										control = false
                                    end
								end
							end
						end
					end
                end
        
            end
        Citizen.Wait (100)   
        end
        Citizen.Wait (10000)
        control = true
    end
end)