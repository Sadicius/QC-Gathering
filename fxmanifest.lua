fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

quantum_github 'https://github.com/Quantum-Projects-RedM/QC-Gathering'
author 'Quantum Projects'
description 'Quantum Gathering.'

version '1.0.0'

shared_script {
	'@ox_lib/init.lua',
	'shared/config.lua',
	'gatherhash.lua'
}

client_script {
	'client/*.lua',
}

server_script {
	'@oxmysql/lib/MySQL.lua',
	'server/*.lua'
}

files {
	'locales/*.json'
  }

lua54 'yes'
