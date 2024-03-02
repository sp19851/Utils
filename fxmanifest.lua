fx_version 'cerulean'
game 'gta5'

description 'Lua utils'
version '1.0.0'



client_script 'client/*.lua'

shared_scripts {
    'config.lua',
	
}
files {
	'ui/index.html',
	'ui/scripts/*.js',
	'ui/assets/*.png',
	'ui/assets/img/*.png',
	'ui/assets/img/backgrounds/*.png',
    	'ui/assets/img/hud/*.png',
	'ui/assets/icons/*.png',
	'ui/hudscss/*.css',
	'ui/fonts/*.ttf',
}

ui_page 'ui/index.html'

lua54 'yes'