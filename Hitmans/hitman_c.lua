------------------------------------/contrato nick valor-------------------------------------



RegisterCommand("contrato", function(source, args)



 TriggerServerEvent('contrato', NetworkPlayerGetName(PlayerId()), args[1], args[2])

     -- we have to concatenate the table because the 'args' cb return a table (array)
     -- the 2nd parameter in 'table.concat' is just spacing each args out
end)


-----------------------------/pegarcontrato nick---------------------------------
RegisterCommand("pegarcontrato", function(source, args)



 TriggerServerEvent('pegarcontrato', NetworkPlayerGetName(PlayerId()), args[1])

     -- we have to concatenate the table because the 'args' cb return a table (array)
     -- the 2nd parameter in 'table.concat' is just spacing each args out
end)


-----------------------------/contratos---------------------------------
RegisterCommand("contratos", function(source)


TriggerServerEvent('contratos', source)
-- TriggerServerEvent('contratos', GetPlayerServerId(source))



     -- we have to concatenate the table because the 'args' cb return a table (array)
     -- the 2nd parameter in 'table.concat' is just spacing each args out
end)



--Mostra as informações de quem matou, necessário para verificação se o assassino matou a vitima após o /pegarcontrato

RegisterNetEvent('showNotification')
AddEventHandler('showNotification', function(text)
	ShowNotification(text)
end)
function ShowNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(0,1)
end
Citizen.CreateThread(function()
    -- main loop thing
	alreadyDead = false
    while true do
        Citizen.Wait(50)
		local playerPed = GetPlayerPed(-1)
		if IsEntityDead(playerPed) and not alreadyDead then
			killer = GetPedKiller(playerPed)
			killername = false
			for id = 0, 64 do
				if killer == GetPlayerPed(id) then
					killername = GetPlayerName(id)
				end				
			end
			if killer == playerPed then
				TriggerServerEvent('playerDied',0,0)
			elseif killername then
				TriggerServerEvent('playerDied',killername,1)
			else
				TriggerServerEvent('playerDied',0,2)
			end
			alreadyDead = true
		end
		if not IsEntityDead(playerPed) then
			alreadyDead = false
		end
	end
end)










