resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'


dependencies {
	'vrp',
	'vrp_mysql'
}

server_scripts{ 
	"@vrp/lib/utils.lua",
	"server.lua",
	"@mysql-async/lib/MySQL.lua"
}

client_script "hitman_c.lua"









---------------- Pendente:
---------------- Deletar informação do banco de dados ao cumprir o contrato (x)
---------------- Corrigir bug que duplica o dinheiro ao cumprir o contrato (x)
---------------- Corrigir os textos (x)
---------------- Permissoes por job (x)
---------------- Melhorar o código (x)
----------------
----------------
----------------
----------------
----------------
----------------