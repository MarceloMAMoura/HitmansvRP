local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_banking")
isTransfer = false



------------------------------------------------------API VRP-----------------------------------------------------

RegisterServerEvent('contrato')--cria o comando /contrato

AddEventHandler('contrato', function(player, nick, valor)--Recebe os valores do arquivo hitman_c.lua, os valores são as informações que o jogador coloca no /contrato, player = jogador que colocou o contrato, nick = vitima, valor = valor do contrato

local user_id = vRP.getUserId({source})
local src = vRP.getUserSource({user_id})

if nick ~= nil or valor ~= nil then


MySQL.Async.execute("INSERT INTO hitman (player, valor_contrato) VALUES (@player, @valor_contrato)", {['@player'] = nick, ['@valor_contrato'] = valor})--Adiciona no banco de dados a vitima e o valor que está na cabeça dela



	function vRP.giveMoney(user_id,valor)--retira dinheiro do jogador que usou o /contrato
	local money = vRP.getMoney({user_id})
	vRP.setMoney({user_id,money-valor})--O comando precisa ter ({valores}) para funcionar, o comando não irá funcionar de ficar .setMoney() sem os {}
	end

	function arredondar(num, numDecimal)
	local mult = 5^(numDecimal or 0)
	return math.floor(num * mult + 0.5) / mult
	end


	valor = arredondar(tonumber(valor),0)

	local user_id = vRP.getUserId({source})
	vRP.giveMoney(user_id,valor)



	TriggerClientEvent('chatMessage', -1, '^7[^1Contrato^7]^2', {0,0,0} --[[ this table is just rgb ]], 'Algum jogador colocou contrato na cabeça do jogador '.. nick .. ' no valor de  R$'..valor) -- Mensagem sobre o contrato que foi colocado
else
vRPclient.notify(src,{"~w~[~r~Contrato~w~]~r~ ~g~Use o comando /contrato nick valor"})
--TriggerClientEvent('chatMessage', -1, '^7[^1Contrato^7]^2', {0,0,0} --[[ this table is just rgb ]], 'Use o comando /contrato nick valor')
end


	
end)


-----------------------------------------Fim do comando /contrato--------------------------------------------------







------------------------------------------------------/pegarcontrato-----------------------------------------------------

RegisterServerEvent('pegarcontrato')--cria o comando /contrato

AddEventHandler('pegarcontrato', function(player,vitima)--player = assassino/responsável por usar o comando, vitima = o nome da pessoa que o assassino deve matar

local user_id = vRP.getUserId({source})
local src = vRP.getUserSource({user_id})

if vitima ~= nil then


local user_id = vRP.getUserId({source})
if vRP.hasGroup({user_id,"Assassino lider"}) or vRP.hasGroup({user_id,"Assassino"}) then

MySQL.Async.fetchAll("UPDATE hitman SET assassino_resp=@assassino_resp, user_id_vrp=@user_id_vrp WHERE player=@player", {['@assassino_resp'] = player, ['@user_id_vrp'] = user_id, ['@player'] = vitima})
--atualiza no banco quem é o assassino/id vrp responsável pela vitima

--TriggerClientEvent('chatMessage', -1, '^7[^1Contrato^7]^2', {0,0,0} --[[ this table is just rgb ]], 'O jogador do RG '.. user_id .. ' de nome '..player.. ' pegou o contrado da vitima: '..vitima) -- Mensagem sobre o contrato que foi colocado
end
else
vRPclient.notify(src,{"~w~[~r~Contrato~w~]~r~ ~g~/pegarcontrato Nick_da_vitima"})
--TriggerClientEvent('chatMessage', -1, '^7[^Contrato^7]^2', {0,0,0} --[[ this table is just rgb ]], '/pegarcontrato Nick da vitima')
end

	
end)


-----------------------------------------Fim do comando /pegarcontrato--------------------------------------------------


------------------------------------------------------/contratos-----------------------------------------------------

RegisterServerEvent('contratos')--cria o comando /contratos

AddEventHandler('contratos', function(player)--player = assassino/responsável por usar o comando, vitima = o nome da pessoa que o assassino deve matar



local user_id = vRP.getUserId({source})
local src = vRP.getUserSource({user_id})




if vRP.hasGroup({user_id,"Assassino lider"}) or vRP.hasGroup({user_id,"Assassino"}) then



MySQL.Async.fetchAll("SELECT COUNT(*) as count FROM hitman WHERE assassino_resp IS NULL",{}, 
		function(contagemDB)
			if tonumber(contagemDB[1].count) ~= 0 then
					MySQL.Async.fetchAll("SELECT * FROM hitman WHERE assassino_resp IS NULL",{}, 
					function(result)
						vRPclient.notify(src,{'~w~[~r~Hitman~w~]~r~ ~y~Contrato na vitima: '..result[1].player..' no valor de R$'..result[1].valor_contrato})
						--TriggerClientEvent('chatMessage', -1, '^7[^1Hitman^7]^2', {0,0,0} --[[ this table is just rgb ]], 'Contrato na vitima: '..result[1].player..' no valor de R$'..result[1].valor_contrato) -- Comando mostra no char o contrato disponivel

					end)
			else
			vRPclient.notify(src,{"~w~[~r~Hitman~w~]~r~ ~g~Sem contratos no momento"})
	--		TriggerClientEvent('showNotification', player, "~w~[~r~Hitman~w~]~r~ ~g~Sem contratos no momento"..player) 
			--TriggerClientEvent('chatMessage', player, '^7[^1Hitman^7]^2', {0,0,0} --[[ this table is just rgb ]], 'Sem contratos no momento')
			end
		end)
	end
	
	
	
end)


-----------------------------------------Fim do comando /contratos--------------------------------------------------








-----------------------------------------Recompensa ao matar a vitima----------------------------------------------





RegisterServerEvent('playerDied')
AddEventHandler('playerDied',function(killer,reason)
	if killer == "**Invalid**" then --Can't figure out what's generating invalid, it's late. If you figure it out, let me know. I just handle it as a string for now.
		reason = 2
	end
	if reason == 0 then
		TriggerClientEvent('showNotification', -1,"~o~".. GetPlayerName(source).."~w~ committed suicide. ")
	elseif reason == 1 then
		TriggerClientEvent('showNotification', -1,"~b~".. killer .. "~w~ matou ~r~"..GetPlayerName(source).."~w~.")
		
		local assassino = killer
		local vitima = GetPlayerName(source)
		
		

		
		MySQL.Async.fetchAll("SELECT COUNT(*) as count FROM hitman WHERE assassino_resp IS NOT NULL",{}, 
		function(contagemDB)
			if tonumber(contagemDB[1].count) ~= 0 then

		
		MySQL.Async.fetchAll("SELECT * FROM hitman WHERE player=@player",{['@player'] = vitima}, 
		function(result)
		    if result[1].player == vitima and result[1].assassino_resp == killer then--Se a vitima for uma pessoa do banco de dados E o assassino for o responsável pelo /pegarcontrato for o killer, ele continua a condição
		
		
					function vRP.giveMoney(user_id,valor)--adiciona dinheiro caso o assassino que usou o comando /pegarcontrato nick mate a vitima
					local money = vRP.getMoney({user_id})
					vRP.setMoney({user_id,money+valor})--O comando precisa ter ({valores}) para funcionar, o comando não irá funcionar de ficar .setMoney() sem os {}
					end

					function arredondar(num, numDecimal)
					local mult = 5^(numDecimal or 0)
					return math.floor(num * mult + 0.5) / mult
					end

					local valor = result[1].valor_contrato
					local user_id = result[1].user_id_vrp
			
			
					if vRP.hasGroup({user_id,"Assassino lider"}) or vRP.hasGroup({user_id,"Assassino"}) then
					valor = arredondar(tonumber(valor),0)
					vRP.giveMoney(user_id,valor)
			

					TriggerClientEvent('chatMessage', -1, '^7[^1Hitman^7]^2', {0,0,0} --[[ this table is just rgb ]], 'Algum assassino cumpriu o contrato na cabeça de '..result[1].player..' no valor de R$'..result[1].valor_contrato)
					--TriggerClientEvent('chatMessage', -1, '^7[^1Hitman^7]^2', {0,0,0} --[[ this table is just rgb ]], 'RG: '..result[1].user_id_vrp..' O assassino '.. result[1].assassino_resp .. ' cumpriu o contrato na cabeça de '..result[1].player.. ' e ganhou '..result[1].valor_contrato)
					--O comando acima manda msg para o servidor informando os dados do assassino que matou a vitima
		
		
					--Ao cumprir o contrato, deleta as informações do alvo do banco de dados
					MySQL.Async.fetchAll("DELETE FROM hitman WHERE player=@player", {['@player'] = vitima})
					--assassino_resp = nick
					--user_id_vrp = id vrp do assassino
					vitima = nil
					assassino = nil
					return
			
			
					end
				end
			end)
		end
	end)
	
	else
		TriggerClientEvent('showNotification', -1,"~o~".. GetPlayerName(source).."~w~ died.")
	end
	
	
	
	
end)




