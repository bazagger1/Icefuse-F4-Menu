--[[
Server Name: ▌ Icefuse.net ▌ DarkRP 100k Start ▌ Bitminers-Slots-Unbox ▌
Server IP:   208.103.169.42:27015
File Path:   addons/[server]_f4_menu_v2/lua/darkrp_modules/parallax/cl_configuration.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

--new
F4menu = F4menu or {}
F4menu.configuration = {}

F4menu.configuration.general = {

	banner = "https://icefuse.net/images/logo.png",

	-- Banner dimensions
	bannerW = 218 * .85,
	bannerH = 90 * .85,
	bannerOffsetTop = 10,
	bannerOffsetBottom = 5,

	// The banner to use up top of the F4. Make this value>      false     <to disable.
	// This can be a link to an image (has to start with http:// or https://), a material <Material("banner.png")> or text.
	// Has to be png.
	// Use the dimensions 3488 x 537 or something with the same aspect ratio or it might stretch.

	time_and_date = false,
	// Whether or not to display the time in the top left corner of the screen.

	theme = "icefuse_dark_v2",
	// The default theme to use.
	// "clear", "dark", "light"

	color = Color(0, 175, 255),
	// Color used for any other small things that dont have their own palette

	themes = {
		["icefuse_dark_v1"] = {
			blur_background = true,
			text = Color(235, 235, 235),
			background = Color(50, 50, 50, 230),
			player_background = Color(0, 0, 0, 50),
			job_background = Color(0, 0, 0, 50),
			list_background = Color(0, 0, 0, 50),
			listing_background = Color(0, 0, 0, 50),
			listing_header = Color(0, 0, 0, 150),
		},
		["icefuse_dark_v2"] = {
			blur_background = true,
			text = Color(235, 235, 235),
			background = Color(46, 64, 83, 230),
			player_background = Color(0, 0, 0, 50),
			job_background = Color(0, 0, 0, 50),
			list_background = Color(0, 0, 0, 50),
			listing_background = Color(0, 0, 0, 50),
			listing_header = Color(0, 0, 0, 100),
		},
		["clear"] = {
			blur_background = true,
			text = Color(235, 235, 235),
			background = Color(0, 0, 0, 100),
			player_background = Color(0, 0, 0, 50),
			job_background = Color(0, 0, 0, 50),
			list_background = Color(0, 0, 0, 50),
			listing_background = Color(0, 0, 0, 50),
			listing_header = Color(0, 0, 0, 150),
		},
		["dark"] = {
			text = Color(235, 235, 235),
			background = Color(54, 57, 62),
			player_background = Color(30, 33, 36),
			job_background = Color(46, 49, 54),
			list_background = Color(46, 49, 54),
			listing_background = Color(0, 0, 0, 0),
			listing_header = Color(0, 0, 0, 150),
		},
		["light"] = {
			light = true,
			text = Color(30, 30, 30),
			background = Color(255, 255, 255),
			player_background = Color(223, 223, 223),
			job_background = Color(243, 243, 243),
			job_header = Color(90, 90, 90),
			list_background = Color(46, 49, 54),
			listing_background = Color(223, 223, 223, 0),
			listing_header = Color(233, 233, 233),
			listing_items = Color(243, 243, 243),
		},
	},
}

F4menu.configuration.tabs = {
	jobs = {
		// Whether to enable or not
		enable = true,

		// What color to use for the tab in the menu
		color = Color(255, 175, 50),
	},

	ents = {
		enable = true,
		color = Color(255, 175, 50),
	},

	weapons = {
		enable = true,
		color = Color(255, 175, 50),
	},

	shipments = {
		enable = true,
		color = Color(255, 175, 50),
	},

	vehicles = {
		enable = true,
		color = Color(255, 175, 50),
	},

	ammunition = {
		enable = true,
		color = Color(255, 175, 50),
	},

	food = {
		enable = true,
		color = Color(255, 175, 50),

		// Since food doesnt categorize properly please add your cook team here so only the cook is able to see the menu.
		// Remove this to make everyone be able to see the food tab
		allowed = {TEAM_COOK},
	},
}

F4menu.configuration.webtabs = {
	//title 				url to visit 				color for category
	["Webpage"] = {url = "https://icefuse.net/", color = Color(0, 175, 255)},
	["Rules"] = {url = "https://docs.google.com/document/d/1NLCq9pIk-UCvTSUKGDrpP6u1qCGVDr9HLxUVnPEdB3U", color = Color(0, 175, 255)},
	["Store"] = {url = "https://store.icefuse.net", color = Color(0, 175, 255)},
	["Steam Group"] = {url = "https://steamcommunity.com/groups/Icefuse-Networks", color = Color(0, 175, 255)},


	/* This is a multiline comment line, remove this line to remove the comment.
	["Guidance"] = {
		// You can also replace url with HTML to run your own code through here.
		html = [[
<!DOCTYPE html>
<html>
<body>

<h1>My First Heading</h1>

<p>My first paragraph.</p>

</body>
</html>
		]],
		color = Color(0, 175, 255)
	},*/ //This is a multiline comment line, remove this line to remove the comment.
}
