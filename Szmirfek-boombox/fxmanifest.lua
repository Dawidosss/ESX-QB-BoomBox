fx_version "cerulean"
game "gta5"

author 'edited by many'

description 'skrypt na boombox'

version '2.1.0'

lua54 'yes'

client_scripts {
    'client/**.lua'
}

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'server/**.lua'
}

shared_scripts {
  '@ox_lib/init.lua',
  'config.lua'
}

dependencies {
  'xsound',
  'ox_lib',
  'many-core'
}
