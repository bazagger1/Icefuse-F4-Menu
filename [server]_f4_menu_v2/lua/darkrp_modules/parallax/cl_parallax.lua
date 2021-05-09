--[[
Server Name: ▌ Icefuse.net ▌ DarkRP 100k Start ▌ Bitminers-Slots-Unbox ▌
Server IP:   208.103.169.42:27015
File Path:   addons/[server]_f4_menu_v2/lua/darkrp_modules/parallax/cl_parallax.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

F4menu = F4menu or {}

local function theme()
	return F4menu.configuration.general.themes[F4menu.configuration.general.theme]
end

local invalidModel = 'models/props_wasteland/prison_padlock001a.mdl'

PANEL = {}


local material_blur = Material("pp/blurscreen")
function drawBlur(panel, amount, heavyness)
	local x, y = panel:LocalToScreen(0, 0)
	local scrW, scrH = ScrW(), ScrH()

	surface.SetDrawColor(255,255,255)
	surface.SetMaterial(material_blur)

	for i = 1, heavyness do
		material_blur:SetFloat("$blur", (i / 3) * (amount or 6))
		material_blur:Recompute()

		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
	end
end


function PANEL:Rebuild()
    if #self.iconList.Items == 0 then return end

    local x = 0
    for i, item in pairs(self.iconList.Items) do
        item:SetPos(x)

        x = x + item:GetWide() + 2
    end
    self.iconList:GetCanvas():SetWide(x)
end

function PANEL:getScroll()
    return self.scroll
end

function PANEL:setScroll(scroll)
    local canvas = self.iconList:GetCanvas()
    local x, y = canvas:GetPos()
    local minScroll = 0
    local maxScroll = math.Max(self.iconList:GetWide(), canvas:GetWide()) - self.iconList:GetWide()

    self.scroll = math.Max(0, scroll)
    local scrollPos = math.Clamp(scroll * -62, -maxScroll, -minScroll)

    if scrollPos == x then
        self.scroll = math.Max(self.scroll - 1, 0)
        return
    end

    canvas:SetPos(scrollPos, y)
end

function PANEL:Init()
    self.scroll = 0

	self.left = vgui.Create("DButton", self)
	self.right = vgui.Create("DButton", self)

	self.left:Dock(LEFT)
	self.left:SetWide(48)
	function self.left:Paint(w, h)
		self.alpha = self.alpha or 0

		if self.Hovered then
			self.alpha = math.Approach(self.alpha, 75, FrameTime()*300)
		end

		if self.Depressed then
			self.alpha = math.Approach(self.alpha, 125, FrameTime()*750)
		end

		if not self.Hovered then
			self.alpha = math.Approach(self.alpha, 50, FrameTime()*300)
		end

		surface.SetDrawColor(0, 0, 0, self.alpha)
		surface.DrawRect(0, 0, w, h)

		surface.DrawOutlinedRect(0, 0, w, h)

		surface.SetFont("dev button")
		local textw, texth = surface.GetTextSize(self.Text)
		surface.SetTextColor(theme().text)
		surface.SetTextPos(w/2-textw/2, h/2-texth/2)
		surface.DrawText(self.Text)
	end

	self.left:SetText("")
	self.left.Text = "<"
    self.left.DoClick = function(btn) self:setScroll(self:getScroll() - 1) end
    self.left.DoDoubleClick = self.left.DoClick

	self.right:Dock(RIGHT)
	self.right:SetWide(48)
	self.right.Paint = self.left.Paint
	self.right:SetText("")
	self.right.Text = ">"
	self.right.DoClick = function(btn) self:setScroll(self:getScroll() + 1) end
    self.right.DoDoubleClick = self.right.DoClick

    self.iconList = vgui.Create("DPanelList", self)
    self.iconList:EnableHorizontal(true)
    self.iconList:Dock(FILL)
    self.iconList.PerformLayout = fn.Partial(self.PerformLayout, self)
    self.iconList.Rebuild = fn.Curry(self.Rebuild, 2)(self)
end

function PANEL:PerformLayout()
    self.iconList:GetCanvas():SetTall(60)
    self.iconList:Rebuild()
end

function PANEL:Paint(w, h)
end

function PANEL:onSelected(item)
    for k,v in pairs(self.iconList.Items) do
        if v == item then continue end
        v:SetSelected(false)
        v.model:SetSize(60, 60)
        v.model:SetPos(0, 0)
    end
end

function PANEL:updateInfo(job)
    self.iconList:Clear()
    if not istable(job.model) then return end

    local preferredModel = DarkRP.getPreferredJobModel(job.team)
    for i, mdl in ipairs(job.model) do
	    btn = vgui.Create("ModelImage")
    	btn:SetSize(60, 60)
    	btn:SetPos(0, 0)
		btn:SetModel(mdl, 1, "000000000")
		function
			btn:Paint
				(w, h)
					self.alpha = self.alpha or 0

					if self.Hovered then
						self.alpha = math.Approach(self.alpha, 75, FrameTime()*300)
					end

					if self.Depressed then
						self.alpha = math.Approach(self.alpha, 125, FrameTime()*750)
					end

					if not self.Hovered then
						self.alpha = math.Approach(self.alpha, 50, FrameTime()*300)
					end

					surface.SetDrawColor(0, 0, 0, self.alpha)
					surface.DrawRect(0, 0, w, h)
		end

		function btn:OnMousePressed()
		end

		function btn:OnMouseReleased()
		    DarkRP.setPreferredJobModel(job.team, mdl)
		    F4menu.BuildChosen(job)
		end

        if preferredModel == mdl then
            btn:SetSelected(true)
        end
        self.iconList:AddItem(btn)
    end

    self.iconList:InvalidateLayout()
end
derma.DefineControl("choosejob", "", PANEL, "DPanel")

--
-- Possible DRM of some sort?
--
if true then
	local function LerpColor(frac,from,to)
		local col = Color(
			Lerp(frac,from.r,to.r),
			Lerp(frac,from.g,to.g),
			Lerp(frac,from.b,to.b),
			Lerp(frac,from.a,to.a)
		)
		return col
	end

	surface.CreateFont("dev title", {
		font = "Roboto Regular",
		size = ScreenScale(24)
	})

	surface.CreateFont("dev small title", {
		font = "Roboto Regular",
		size = ScreenScale(10)
	})

	surface.CreateFont("dev button", {
		font = "Roboto Regular",
		size = ScreenScale(6)
	})

	surface.CreateFont("dev text", {
		font = "Roboto Regular",
		size = ScreenScale(6),
		weight = 400,
	})

	surface.CreateFont("dev console", {
		font = "Roboto Regular",
		size = ScreenScale(5)
	})

	surface.CreateFont("Info Text", {
	    font = "Roboto Medium",
	    size = ScreenScale(6.4),
	    antialias = tru
	})

	surface.CreateFont("Info Title", {
	    font = "Roboto Medium",
	    size = ScreenScale(10),
	    antialias = true
	})

	draw.Circle = function(ox,oy,r)
		local PolyData = {}
		local originx = ox or 300
		local originy = oy or 300
		local radius = r
		for deg=0, 359 do
			local x,y = math.cos(math.rad(deg)*math.pi)*radius+originx, math.sin(math.rad(deg)*math.pi)*radius+originy
			PolyData[deg] = {x=x,y=y}
		end
		surface.DrawPoly(PolyData)
	end

	local html
	if F4menu.frame then
		F4menu.frame:SetMouseInputEnabled( false )
		F4menu.frame:SetKeyboardInputEnabled( false )
		F4menu.frame:Remove()
		F4menu.frame = nil
	end

	function F4menu.Open()
		F4menu.opened = CurTime()

		if F4menu.frame then
			F4menu.frame:SetVisible(true)
			F4menu.frame:AlphaTo(255, 0.3, 0)
			return
		end

		F4menu.frame = vgui.Create("DFrame")
		F4menu.frame:SetSize(ScrW(), ScrH())
		F4menu.frame:SetPos(0, 0)
		F4menu.frame:DockPadding(32, 32, 32, 32)
		F4menu.frame:ShowCloseButton(false)
		F4menu.frame:SetDraggable(false)
		F4menu.frame:SetTitle("")
		F4menu.frame:SetSizable(false)
		F4menu.frame:MakePopup()
		function F4menu.frame:Paint(w, h)

			drawBlur(self, 5, 3)

			surface.SetDrawColor(0, 0, 0, 100)
			surface.DrawRect(0, 0, w, h)

			-- if F4menu.configuration.general.time_and_date then
			-- 	local time = os.date( "%a, %I:%M:%S %p" )
			-- 	surface.SetFont("dev title")
			-- 	local textw, texth = surface.GetTextSize(time)
			-- 	surface.SetTextColor(Color(230, 230, 230))
			-- 	surface.SetTextPos(32, 132/2-texth/2)
			-- 	surface.DrawText(time)
			-- end
			--
			-- local banner = F4menu.configuration.general.banner
			-- if banner then
			-- 	if type(banner) == "IMaterial" then
			-- 		local imgw, imgh = 3488/6, 537/6
			-- 		surface.SetDrawColor(255, 255, 255)
			-- 		surface.SetMaterial(banner)
			-- 		surface.DrawTexturedRect(w/2-imgw/2, 132/2-imgh/2, imgw, imgh)
			-- 	elseif isstring(banner) and (banner:StartWith("http://") or banner:StartWith("https://")) then
			-- 		if not file.IsDir("cache", "DATA") then
			-- 			file.CreateDir("cache")
			-- 		end
			--
			-- 		local name = banner:gsub("//", ""):match("/.-%.png$"):gsub("/", "")
			--
			-- 		if not file.Exists("cache/" .. name, "DATA") then
			-- 			http.Fetch(banner, function(body)
			-- 				file.Write("cache/" .. name, body)
			-- 			end)
			-- 		end
			--
			-- 		image = Material("../data/cache/".. name)
			--
			-- 		local imgw, imgh = 3488/6, 537/6
			-- 		surface.SetDrawColor(255, 255, 255)
			-- 		surface.SetMaterial(image)
			-- 		surface.DrawTexturedRect(w/2-imgw/2, 132/2-imgh/2, imgw, imgh)
			-- 	elseif isstring(banner) then
			-- 		surface.SetFont("dev title")
			-- 		local textw, texth = surface.GetTextSize(banner)
			-- 		surface.SetTextColor(Color(230, 230, 230))
			-- 		surface.SetTextPos(w/2-textw/2, 132/2-texth/2)
			-- 		surface.DrawText(banner)
			-- 	end
			-- end

		end

		------------------------------------------------------------------------
		-- Close button

		local close
		do

			surface.SetFont("dev button")
			local textw, texth = surface.GetTextSize("close")

			close = vgui.Create("DButton", F4menu.frame)
			close:SetSize(16 + textw + 6, 24)
			close:SetPos(F4menu.frame:GetWide() - 32 - textw - 16 - 6, (32 - 24) / 2)
			close:SetText("")
			-- local size = 28
			local size = 12
			local alpha = 25
			local delay = 0.5

			function close:Paint(w, h)

				if (input.IsKeyDown(KEY_F4) or input.IsKeyDown(KEY_ESCAPE)) and F4menu.frame:IsVisible() and (CurTime() > (F4menu.opened + delay)) then
					close:DoClick()

					if gui.IsGameUIVisible() then
						gui.HideGameUI()
					end
				end

				if self.Hovered then
					size = math.Approach(size, 30, FrameTime()*30)
					alpha = math.Approach(alpha, 50, FrameTime()*300)
				end

				if self.Depressed then
					size = math.Approach(size, 32, FrameTime()*75)
					alpha = math.Approach(alpha, 100, FrameTime()*500)
				end

				if not self.Hovered then
					size = math.Approach(size, 28, FrameTime()*30)
					alpha = math.Approach(alpha, 25, FrameTime()*300)
				end

				surface.SetDrawColor(155+alpha, 50, 50, 100)
				-- draw.NoTexture()
				-- draw.Circle(w/2, h/2, size)
				surface.DrawRect(0, 0, w, h)

				surface.SetFont("dev button")
				surface.SetTextColor(Color(230, 230, 230))
				surface.SetTextPos(w/2-textw/2, (h-6)/2-texth/2 + 3)
				surface.DrawText("close")

			end

			function close:DoClick()
				F4menu.frame:SetAlpha(0)
				F4menu.frame:SetVisible(false)
			end

			-- close = vgui.Create("DButton", F4menu.frame)
			-- close:SetSize(64, 64)
			-- close:SetPos(F4menu.frame:GetWide()-64-32, 132/2-close:GetTall()/2)
			-- close:SetText("")
			-- local size = 28
			-- local alpha = 25
			-- local delay = 0.5
			--
			-- function close:Paint(w, h)
			-- 	if (input.IsKeyDown(KEY_F4) or input.IsKeyDown(KEY_ESCAPE)) and F4menu.frame:IsVisible() and (CurTime() > (F4menu.opened + delay)) then
			-- 		close:DoClick()
			--
			-- 		if gui.IsGameUIVisible() then
			-- 			gui.HideGameUI()
			-- 		end
			-- 	end
			--
			-- 	if self.Hovered then
			-- 		size = math.Approach(size, 30, FrameTime()*30)
			-- 		alpha = math.Approach(alpha, 50, FrameTime()*300)
			-- 	end
			--
			-- 	if self.Depressed then
			-- 		size = math.Approach(size, 32, FrameTime()*75)
			-- 		alpha = math.Approach(alpha, 100, FrameTime()*500)
			-- 	end
			--
			-- 	if not self.Hovered then
			-- 		size = math.Approach(size, 28, FrameTime()*30)
			-- 		alpha = math.Approach(alpha, 25, FrameTime()*300)
			-- 	end
			--
			-- 	surface.SetDrawColor(155+alpha, 50, 50, 100)
			-- 	draw.NoTexture()
			-- 	draw.Circle(w/2, h/2, size)
			--
			-- 	surface.SetFont("dev title")
			-- 	local textw, texth = surface.GetTextSize("x")
			-- 	surface.SetTextColor(Color(230, 230, 230))
			-- 	surface.SetTextPos(w/2-textw/2, (h-6)/2-texth/2)
			-- 	surface.DrawText("-")
			-- end
			--
			-- function close:DoClick()
			-- 	F4menu.frame:SetAlpha(0)
			-- 	F4menu.frame:SetVisible(false)
			-- end

		end

		------------------------------------------------------------------------

		-- local headerPanel = vgui.Create("DPanel", F4menu.frame)
		-- headerPanel:Dock(TOP)
		-- headerPanel:SetTall(32)
		-- headerPanel:InvalidateParent(true)
		-- headerPanel:SetAlpha(0)
		-- headerPanel:AlphaTo(255, 0.3, 0)
		--
		-- function headerPanel:Paint(w, h)
		-- 	surface.SetDrawColor(theme().background)
		-- 	surface.DrawRect(0, 0, w, h)
		-- 	surface.DrawOutlinedRect(0, 0, w, h)
		-- end

		local panel = vgui.Create("DPanel", F4menu.frame)
		panel:Dock(FILL)
		-- panel:DockMargin(32, 100, 32, 32)
		panel:InvalidateParent(true)
		panel:SetAlpha(0)
		panel:AlphaTo(255, 0.3, 0)

		function panel:Paint(w, h)
			surface.SetDrawColor(theme().background)
			surface.DrawRect(0, 0, w, h)
			surface.DrawOutlinedRect(0, 0, w, h)
		end

		local tabs = vgui.Create("DPanel", panel)
		tabs:SetSize(128*1.75, panel:GetTall())
		tabs:InvalidateParent(true)
		tabs:SetPos(-tabs:GetWide(), 0)
		tabs:MoveTo(0, 0, 0.3, 0, 4)
		tabs.Items = {}

		------------------------------------------------------------------------
		-- Theme change button

		if false then

			local themer = vgui.Create("DButton", tabs)
			themer:Dock(BOTTOM)
			themer:SetTall(48)
			themer:SetText("")
			themer.text = "Theme"
			local alpha = 50

			function themer:Paint(w, h)
				if self.Hovered then
					alpha = math.Approach(alpha, 75, FrameTime()*300)
				end

				if self.Depressed or tabs.core.Selected == k then
					alpha = math.Approach(alpha, 125, FrameTime()*750)
				end

				if not self.Hovered then
					alpha = math.Approach(alpha, 50, FrameTime()*300)
				end

				surface.SetDrawColor(0, 0, 0, alpha)
				surface.DrawRect(0, 0, w, h)

				//surface.SetDrawColor(color.r, color.g, color.b)
				//surface.DrawRect(w-4, 0, 4, h)

				surface.SetFont("dev button")
				local textw, texth = surface.GetTextSize(self.text)
				surface.SetTextColor(Color(185, 185, 185))
				surface.SetTextPos(8, h/2-texth/2)
				surface.DrawText(self.text)

				surface.SetDrawColor(0, 0, 0, 100)
				surface.DrawLine(0, h-1, w, h-1)
			end

			local selector = {}
			for k, v in pairs(F4menu.configuration.general.themes) do
				selector[k] = vgui.Create("DButton", tabs)

				local pnl = selector[k]
				pnl:Dock(BOTTOM)
				pnl:SetTall(48)
				pnl:SetText("")
				pnl.text = k
				pnl:SetVisible(false)
				local alpha = 50

				function pnl:Paint(w, h)
					if self.Hovered then
						F4menu.configuration.general.theme = k

						alpha = math.Approach(alpha, 75, FrameTime()*300)
					end

					if self.Depressed or tabs.core.Selected == k then
						alpha = math.Approach(alpha, 125, FrameTime()*750)
					end

					if not self.Hovered then
						alpha = math.Approach(alpha, 50, FrameTime()*300)
					end

					surface.SetDrawColor(100, 100, 100, alpha)
					surface.DrawRect(0, 0, w, h)

					//surface.SetDrawColor(color.r, color.g, color.b)
					//surface.DrawRect(w-4, 0, 4, h)

					surface.SetFont("dev button")
					local textw, texth = surface.GetTextSize(self.text)
					surface.SetTextColor(Color(185, 185, 185))
					surface.SetTextPos(8, h/2-texth/2)
					surface.DrawText(self.text)

					surface.SetDrawColor(0, 0, 0, 100)
					surface.DrawLine(0, h-1, w, h-1)
				end

				function pnl:DoClick()
					if themer.Tall then
						themer:SetTall(themer.Tall)
						themer.Tall = nil
					end

					for k, v in pairs(selector) do
						v:SetVisible(false)
					end

					F4menu.frame:SetMouseInputEnabled( false )
					F4menu.frame:SetKeyboardInputEnabled( false )
					F4menu.frame:Remove()
					F4menu.frame = nil

					F4menu.configuration.general.theme = k

					F4menu.Open()
				end
			end

			function themer:DoClick()
				self.Tall = self:GetTall()
				self:SetTall(0)

				for k, v in pairs(selector) do
					v:SetVisible(true)
				end
			end

		end

		------------------------------------------------------------------------

		function tabs:Paint(w, h)
			surface.SetDrawColor(theme().list_background or theme().job_background)
			surface.DrawRect(0, 0, w, h)
		end

		function tabs.Add(text, color, func)
			table.insert(tabs.Items, {text = text, color = color, func = func})
			local k = #tabs.Items

			local button = vgui.Create("DButton", tabs)
			button:Dock(TOP)
			button:SetTall(42)
			button:SetText("")
			local alpha = 50

			function button:Paint(w, h)
				if self.Hovered then
					alpha = math.Approach(alpha, 75, FrameTime()*300)
				end

				if self.Depressed or tabs.core.Selected == k then
					alpha = math.Approach(alpha, 125, FrameTime()*750)
				end

				if not self.Hovered then
					alpha = math.Approach(alpha, 50, FrameTime()*300)
				end

				surface.SetDrawColor(0, 0, 0, alpha)
				surface.DrawRect(0, 0, w, h)

				surface.SetDrawColor(color.r, color.g, color.b)
				surface.DrawRect(w-4, 0, 4, h)

				surface.SetFont("dev button")
				local textw, texth = surface.GetTextSize(text)
				surface.SetTextColor(Color(230, 230, 230))
				surface.SetTextPos(8, h/2-texth/2)
				surface.DrawText(text)

				surface.SetDrawColor(0, 0, 0, 100)
				surface.DrawLine(0, h-1, w, h-1)
			end

			function button:DoClick()

	            for _, v in pairs(tabs.core.Items) do
	                if _ == k then
	                    tabs.core:SetActiveTab(v.Tab)
	                    tabs.core.Selected = k

	                    --title.Text = text
	                end
	            end

				surface.PlaySound('buttons/lightswitch2.wav')

			end

			local bg = vgui.Create("DPanelList", tabs.core)
	        bg:Dock(FILL)
	        bg:InvalidateParent(true)
	        bg.Paint=function()end
	        func(bg)

	        tabs.core:AddSheet(text, bg, nil, true, false, "F4menu tab")
		end

		tabs.core = vgui.Create("DPropertySheet", panel)
	    tabs.core:Dock(FILL)
	    tabs.core:DockMargin(tabs:GetWide(), -28, 0, 0)
	    tabs.core:InvalidateParent(true)
	    tabs.core:SetFadeTime(0)
	    tabs.core.Selected = 1
	    function tabs.core.Paint(s, w, h)
	        for k, v in pairs(s.Items) do
	            v.Tab:SetSize(0, 0)
	            v.Tab:SetVisible(false)
	        end
	    end

	    /*
	    tabs.Add("Dashboard", Color(100, 255, 100), function(p)
	    	local info = vgui.Create("Panel", p)
	    	info:Dock(TOP)
	    	info:DockMargin(16, 16, 16, 0)
	    	info:SetTall(256)
	    	function info:Paint(w, h)
	    		surface.SetDrawColor(0, 0, 0, 50)
	    		surface.DrawRect(0, 0, w, h)
	    		surface.DrawOutlinedRect(0, 0, w, h)
	    	end

	    	local welcome = vgui.Create("DLabel", info)
	    	welcome:Dock(TOP)
	    	welcome:DockMargin(16, 16, 16, 16)
	    	welcome:SetFont("dev title")
	    	welcome:SetTextColor(Color(230, 230, 230, 255))
	    	welcome:SetText("Welcome!")
	    	welcome:SizeToContents()

			local players = vgui.Create("DPanelList", p)
			players:Dock(FILL)
			players:DockMargin(16, 16, 16, 16)
			players:InvalidateParent(true)
			players:EnableVerticalScrollbar(true)

			players.Paint = function(s, w, h)
				surface.SetDrawColor(0, 0, 0, 50)
				surface.DrawRect(0, 0, w, h)
				surface.DrawOutlinedRect(0, 0, w, h)
			end

			players.VBar.Paint = function(s, w, h)
				draw.RoundedBox(4, 3, 13, 8, h - 24, Color(0, 0, 0, 70))
			end

			players.VBar.btnUp.Paint = function(s, w, h) end
			players.VBar.btnDown.Paint = function(s, w, h) end

			players.VBar.btnGrip.Paint = function(s, w, h)
				draw.RoundedBox(4, 5, 0, 4, h + 22, Color(0, 0, 0, 70))
			end

			for k, v in pairs(player.GetAll()) do
				local player = vgui.Create("DPanel", p)
				player:SetTall(32)
				local alpha = 50
				local color = team.GetColor(v:Team())
				local text = v:Name()

				function player:Paint(w, h)
					if self.Hovered then
						alpha = math.Approach(alpha, 75, FrameTime()*300)
					end

					if self.Depressed then
						alpha = math.Approach(alpha, 125, FrameTime()*750)
					end

					if not self.Hovered then
						alpha = math.Approach(alpha, 50, FrameTime()*300)
					end

					surface.SetDrawColor(0, 0, 0, alpha)
					surface.DrawRect(0, 0, w, h)

					surface.SetDrawColor(color.r, color.g, color.b)
					surface.DrawRect(w-4, 0, 4, h)

					surface.SetDrawColor(0, 0, 0, 100)
					surface.DrawLine(0, h-1, w, h-1)
				end

				local avatar = vgui.Create("AvatarImage", player)
				avatar:Dock(LEFT)
				avatar:SetWide(32)
				avatar:SetPlayer(v)

				local function addinfo(str, color)
					local label = vgui.Create("DLabel", player)
					label:Dock(LEFT)
					label:DockMargin(32, 0, 0, 0)
					label:SetWide(128)
					label:SetFont("dev button")
					label:SetTextColor(color or Color(230, 230, 230))
					label:SetText(str or "null")
				end

				addinfo(v:Name())
				addinfo(team.GetName(v:Team()), team.GetColor(v:Team()))
				addinfo("k: "..v:Frags(), Color(200, 50, 50))
				addinfo("d: "..v:Deaths(), Color(200, 50, 50))
				addinfo(v:GetUserGroup(), Color(0, 175, 255))

				players:AddItem(player)
			end
	    end)*/
		--
	    -- local spacer = vgui.Create("DLabel", tabs)
		-- spacer:Dock(TOP)
		-- spacer:DockMargin(16, 0, 0, 0)
		-- spacer:SetTall(48)
		-- spacer:SetFont("dev button")
		-- spacer:SetTextColor((F4menu.configuration.general.theme == "clear") and Color(200, 200, 200) or Color(110, 110, 110))
		-- spacer:SetText("General")

		do

			local config = F4menu.configuration.general

			local bannerW, bannerH = config.bannerW, config.bannerH
			local offsetTop, offsetBottom = config.bannerOffsetTop, config.bannerOffsetBottom

			local bannerPanel = vgui.Create("DPanel", tabs)
			bannerPanel:Dock(TOP)
			bannerPanel:DockMargin(0, 0, 0, 0)
			bannerPanel:SetTall(bannerH + offsetTop + offsetBottom)
			bannerPanel.Paint = function(pnl, w, h)

				local banner = F4menu.configuration.general.banner
				if banner then

					if type(banner) == "IMaterial" then
						-- local imgw, imgh = 3488/6, 537/6
						surface.SetDrawColor(255, 255, 255)
						surface.SetMaterial(banner)
						surface.DrawTexturedRect(w/2 - bannerW/2, offsetTop, bannerW, bannerH)
					elseif isstring(banner) and (banner:StartWith("http://") or banner:StartWith("https://")) then
						if not file.IsDir("cache", "DATA") then
							file.CreateDir("cache")
						end

						local name = banner:gsub("//", ""):match("/.-%.png$"):gsub("/", "")

						if not file.Exists("cache/" .. name, "DATA") then
							http.Fetch(banner, function(body)
								file.Write("cache/" .. name, body)
							end)
						end

						image = Material("../data/cache/".. name)

						-- local imgw, imgh = 3488/6, 537/6
						surface.SetDrawColor(255, 255, 255)
						surface.SetMaterial(image)
						surface.DrawTexturedRect(w/2 - bannerW/2, offsetTop, bannerW, bannerH)
					elseif isstring(banner) then
						surface.SetFont("dev title")
						local textw, texth = surface.GetTextSize(banner)
						surface.SetTextColor(Color(230, 230, 230))
						surface.SetTextPos(w/2-textw/2, 132/2-texth/2)
						surface.DrawText(banner)
					end
				end

			end

		end

		if F4menu.configuration.tabs.jobs.enable then
			local count = 0
			for k, v in pairs(DarkRP.getCategories()["jobs"]) do
				if v.members then
					for k, v in pairs(v.members) do
						if v.canSee then
							if not v.canSee(LocalPlayer()) then
								continue
							end
						end

						if v.allowed then
							if not table.HasValue(v.allowed, LocalPlayer():Team()) then
								continue
							end
						end

						count = count + 1
					end
				end
			end



			if count > 0 then
			    tabs.Add("Roles", F4menu.configuration.tabs.jobs.color, function(p)
			    	local jobs = vgui.Create("DScrollPanel", p)
			    	jobs:Dock(LEFT)
			    	jobs:DockMargin(16, 16, 16, 16)
			    	jobs:InvalidateParent(true)
			    	jobs:SetWide(p:GetWide()-32)
			    	function jobs:Paint(w, h)
			    		surface.SetDrawColor(theme().listing_background)
			    		surface.DrawRect(0, 0, w, h)
			    		surface.DrawOutlinedRect(0, 0, w, h)
			    	end

					jobs.VBar.Paint = function(s, w, h)
						draw.RoundedBox(4, 3, 13, 8, h - 24, Color(0, 0, 0, 70))
					end

					jobs.VBar.btnUp.Paint = function(s, w, h) end
					jobs.VBar.btnDown.Paint = function(s, w, h) end

					jobs.VBar.btnGrip.Paint = function(s, w, h)
						draw.RoundedBox(4, 5, 0, 4, h + 22, Color(0, 0, 0, 70))
					end

					local jobIndex = 0

					local chosen
			    	local categories = {}
			    	for k, v in pairs(DarkRP.getCategories()["jobs"]) do
			    		local category = vgui.Create("DCollapsibleCategory", jobs)
			    		category:Dock(TOP)
			    		category:DockMargin(8, 8, 8, 0)
			    		category.Header:SetTall(48)
			    		category:SetExpanded(1)
			    		category:SetLabel("")
			    		category.Text = v.name
						category:SetExpanded(false)

						local count = 0
			    		for k, v in pairs(v.members) do
			    			if v.allowed then
				    			if not table.HasValue(v.allowed, LocalPlayer():Team()) then
				    				continue
				    			end
				    		end

				    		count = count + 1
			    		end

			    		if count == 0 then
			    			category:Remove()
			    			continue
			    		end

			    		function category:Paint(w, h)
			    			local h = 48
			    			surface.SetDrawColor(theme().listing_header)
			    			surface.DrawRect(0, 0, w, h)

			    			surface.SetDrawColor(v.color or F4menu.configuration.general.color)
			    			surface.DrawRect(0, h-2, w, 2)

			    			surface.SetFont("dev button")
			    			local textw, texth = surface.GetTextSize(self.Text)
			    			surface.SetTextColor(theme().text)
			    			surface.SetTextPos(16, h/2-texth/2)
			    			surface.DrawText(self.Text)
			    		end

			    		for k, v in pairs(v.members) do

							jobIndex = jobIndex  + 1

			    			local job = vgui.Create("DButton", category)
			    			job:Dock(TOP)
			    			job:DockMargin(0, 0, 0, 0)
			    			job:SetTall(48)
			    			job:SetText("")
			    			job.alpha = 50
			    			function job:Paint(w, h)
			    				if theme().light then
									if self.Hovered then
										self.alpha = math.Approach(self.alpha, 125, FrameTime()*300*2)
									end

									if self.Depressed then
										self.alpha = math.Approach(self.alpha, 75, FrameTime()*750*2)
									end

									if not self.Hovered then
										self.alpha = math.Approach(self.alpha, 255, FrameTime()*300*2)
									end
								else
									if self.Hovered then
										self.alpha = math.Approach(self.alpha, 75, FrameTime()*300)
									end

									if self.Depressed then
										self.alpha = math.Approach(self.alpha, 125, FrameTime()*750)
									end

									if not self.Hovered then
										self.alpha = math.Approach(self.alpha, 50, FrameTime()*300)
									end
								end

								local col = theme().listing_items or Color(0, 0, 0)
								surface.SetDrawColor(col.r, col.b, col.g, self.alpha)
								surface.DrawRect(0, 0, w, h)

								surface.SetDrawColor(v.color.r, v.color.g, v.color.b, theme().light and 175 or 100)
								surface.DrawRect(0, 0, 60, h)

								surface.SetDrawColor(v.color.r, v.color.g, v.color.b)
								surface.DrawRect(60, 0, self.Depressed and 8 or (self.Hovered and 6 or 4), h)

								surface.SetDrawColor(0, 0, 0, 100)
								surface.DrawLine(0, h-1, w, h-1)

								if not theme().light then
									surface.SetDrawColor(0, 0, 0, 50)
				    				surface.DrawRect(0, 0, w, h)
				    			end

			    				surface.SetFont("dev button")
			    				local textw, texth = surface.GetTextSize(v.name)
			    				surface.SetTextColor(theme().text)
			    				surface.SetTextPos(64+16, h/2-texth/2)
			    				surface.DrawText(v.name)

			    				surface.SetFont("dev button")
			    				local text = #team.GetPlayers(v.team) .. "/" .. v.max
			    				local textw, texth = surface.GetTextSize(text)
			    				surface.SetTextColor(theme().text)
			    				surface.SetTextPos(w-16-textw, h/2-texth/2)
			    				surface.DrawText(text)
			    			end

			    			job.model = job.model or vgui.Create("ModelImage", job)
						    job.model:SetSize(60, 60)
						    job.model:SetPos(0, 0)
							job.model:SetVisible(false)

						    local model = v.model
						    if istable(model) then
						    	model = model[1]
						    end

							timer.Simple(jobIndex * 0.05, function()

								-- if Model(model) and util.IsValidModel(model) == false then
								-- 	model = invalidModel
								-- end

								if IsValid(job) then
						    		job.model:SetModel(model, 1, "000000000")
									job.model:SetVisible(true)
								end

							end)

						    function job:DoClick()
						    	jobs:SetWide(p:GetWide()/4*3)

						    	F4menu.BuildChosen(v)

								surface.PlaySound('buttons/lightswitch2.wav')

						    end

							local _OnMousePressed = job.OnMousePressed
							function job:OnMousePressed(code)

								if code == MOUSE_LEFT then

									-- Double click become job
									if SysTime() - (self._lastLeftClick or 0) < 0.3 then

										if v.vote or v.RequiresVote and v.RequiresVote(LocalPlayer(), v.team) then
											RunConsoleCommand("darkrp", "vote" .. v.command)
										else
											RunConsoleCommand("darkrp", v.command)
										end

										close:DoClick()

										return
									end
									self._lastLeftClick = SysTime()

								end

								_OnMousePressed(self, code)

							end

			    		end
			    	end

			    	function F4menu.BuildChosen(v)
			    		if chosen then
			    			chosen:Remove()
			    			chosen = nil
			    		end

				    	chosen = vgui.Create("DPanel", p)
				    	chosen:Dock(RIGHT)
				    	chosen:SetWide(p:GetWide()-jobs:GetWide()-32-8)
				    	chosen:InvalidateParent(true)
				    	chosen:DockMargin(32+16, 16, 16, 16)
				    	function chosen:Paint(w, h)
				    		surface.SetDrawColor(theme().job_background)
				    		surface.DrawRect(0, 0, w, h)
				    		surface.DrawOutlinedRect(0, 0, w, h)
				    	end

				    	-- chosen.title = vgui.Create("DPanel", chosen)
				    	-- chosen.title:Dock(TOP)
				    	-- chosen.title:SetTall(32)
				    	-- function chosen.title:Paint(w, h)
				    	-- 	surface.SetDrawColor(theme().job_header or Color(0, 0, 0, 50))
				    	-- 	surface.DrawRect(0, 0, w, h)
						--
				    	-- end

						local preferredModel = DarkRP.getPreferredJobModel(v.team)
						local model = preferredModel or (isstring(v.model) and v.model or v.model[1])

						-- if Model(model) and util.IsValidModel(model) == false then
						-- 	model = invalidModel
						-- end

				    	chosen.model = vgui.Create("DModelPanel", chosen)
				    	chosen.model:Dock(TOP)
				    	chosen.model:SetTall(chosen:GetTall()/3)
				    	chosen.model:SetModel(model)

				    	local mn, mx = chosen.model.Entity:GetRenderBounds()
						local size = 0
						size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
						size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
						size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )

						chosen.model:SetCamPos( Vector( size, size, size ) )
						chosen.model:SetLookAt( ( mn + mx ) * 0.5 )

						local boneIndex = chosen.model.Entity:LookupBone( "ValveBiped.Bip01_Head1" )
						if boneIndex ~= nil then
							local headpos = chosen.model.Entity:GetBonePosition( boneIndex )
							chosen.model:SetLookAt( headpos-Vector(0, 0, 15) )
							chosen.model:SetCamPos( headpos-Vector( -75, -20, 0 ) )
						end

						function chosen.model:Paint( w, h )
							if ( !IsValid( self.Entity ) ) then return end

							surface.SetDrawColor(theme().player_background)
							surface.DrawRect(0, 0, w, h)

							local x, y = self:LocalToScreen( 0, 0 )

							self:LayoutEntity( self.Entity )

							local ang = self.aLookAngle
							if ( !ang ) then
								ang = ( self.vLookatPos - self.vCamPos ):Angle()
							end

							cam.Start3D( self.vCamPos, ang, self.fFOV, x, y, w, h, 5, self.FarZ )

							render.SuppressEngineLighting( true )
							render.SetLightingOrigin( self.Entity:GetPos() )
							render.ResetModelLighting( self.colAmbientLight.r / 255, self.colAmbientLight.g / 255, self.colAmbientLight.b / 255 )
							render.SetColorModulation( self.colColor.r / 255, self.colColor.g / 255, self.colColor.b / 255 )
							render.SetBlend( ( self:GetAlpha() / 255 ) * ( self.colColor.a / 255 ) )

							for i = 0, 6 do
								local col = self.DirectionalLight[ i ]
								if ( col ) then
									render.SetModelLighting( i, col.r / 255, col.g / 255, col.b / 255 )
								end
							end

							self:DrawModel()

							render.SuppressEngineLighting( false )
							cam.End3D()

							self.LastPaint = RealTime()

							local texty = 10

				    		surface.SetFont("dev button")
				    		local textw, texth = surface.GetTextSize(v.name)
				    		surface.SetTextPos(10, texty)
				    		surface.SetTextColor(theme().light and Color(230, 230, 230) or theme().text)
				    		surface.DrawText(v.name)
							local jobTextW, jobTextH = textw, texth

				    		surface.SetFont("dev button")
				    		local text = "$" .. v.salary .. "/h"
				    		local textw, texth = surface.GetTextSize(text)

							if w - jobTextW - textw - 5 < 0 then
								texty = jobTextH + 13
							end

				    		surface.SetTextPos(w-textw-10, texty)
				    		surface.SetTextColor(75, 255, 75)
				    		surface.DrawText(text)

						end

						local sequences = {
							'pose_standing_01',
							'pose_standing_02',
							'pose_standing_03',
							'pose_standing_04'
						}

						local sequence, model = -1, nil
						function chosen.model:LayoutEntity(ent)
							chosen.model:SetFOV(45+(math.sin(RealTime())*3.5))

							if model == nil or model ~= self:GetModel() then
								model = self:GetModel()

								sequence = ent:LookupSequence(sequences[math.random(#sequences)])
								if sequence == -1 then
									sequence = ent:LookupSequence('pose_standing_01')
								end

							end

							if sequence > -1 then
								ent:SetSequence(sequence)
								chosen.model:RunAnimation()
							end

						end

						if #v.model > 1 then
							chosen.select = vgui.Create("choosejob", chosen)
							chosen.select:Dock(TOP)
							chosen.select:SetTall(48)
							chosen.select:updateInfo(v)
					    end

						chosen.become = vgui.Create("DButton", chosen)
						chosen.become:Dock(BOTTOM)
						chosen.become:SetTall(42)
						chosen.become:SetText("")

						function chosen.become:Paint(w, h)
							self.alpha = self.alpha or 0
							if self.Hovered then
								self.alpha = math.Approach(self.alpha, 75, FrameTime()*300)
							end

							if self.Depressed or tabs.core.Selected == k then
								self.alpha = math.Approach(self.alpha, 125, FrameTime()*750)
							end

							if not self.Hovered then
								self.alpha = math.Approach(self.alpha, 50, FrameTime()*300)
							end

							surface.SetDrawColor(0, 0, 0, self.alpha)
							surface.DrawRect(0, 0, w, h)

							surface.SetDrawColor(Color(0, 175, 255))
							surface.DrawRect(w-4, 0, 4, h)

							surface.SetFont("dev button")
							local text = "Switch Roles"
							local textw, texth = surface.GetTextSize(text)
							surface.SetTextColor(theme().text)
							surface.SetTextPos(32, h/2-texth/2)
							surface.DrawText(text)

							surface.SetDrawColor(0, 0, 0, 100)
							surface.DrawLine(0, h-1, w, h-1)
							surface.DrawLine(0, 1, w, 1)
							surface.DrawLine(0, 1, 0, h-1)
						end

						function chosen.become:DoClick()
							if v.vote or v.RequiresVote and v.RequiresVote(LocalPlayer(), v.team) then
						        RunConsoleCommand("darkrp", "vote" .. v.command)
						    else
								RunConsoleCommand("darkrp", v.command)
							end

							close:DoClick()

							surface.PlaySound('buttons/lightswitch2.wav')

						end

						local carry
					    local weps = v.weapons
					    if #weps > 0 then
						    carry = [[ ]]
						    for k, v in pairs(weps) do
						    	local wep = weapons.Get(tostring(v))
						    	if wep then
						    		carry = carry .. "- " .. wep.PrintName or "unknown tool!\n"
						    	else
						    		carry = " "
						    	end
						    end
						elseif #weps < 0 then
							carry = " "
						elseif #weps == 1 then
							local wep = weapons.Get(tostring(weps[1]))
							if wep then
								carry = "This role has 1 weapon" .. wep.PrintName or "unknown tool!"
							else
								carry = " "
							end
						end

						local col = theme().light and Color(64, 64, 64) or Color(230, 230, 230)
						local text = vgui.Create("ExText", chosen)
				        text:Dock(FILL)
				        text:DockMargin(24, 24, 24, 0)
				        text:AppendLine({
				            Type = "Font",
				            Data = "Info Title",
				        },
				        {
				            Type = "Color",
				            Data = col,
				        },
				        {
				            Type = "Text",
				            Data = "Description",
				        },
				        {
				            Type = "Spacer",
				            Data = 16
				        })

				        text:AppendLine({
				            Type = "Font",
				            Data = "Info Text",
				        },
				        {
				            Type = "Color",
				            Data = col,
				        },
				        {
				            Type = "Text",
				            Data = v.description,
				        },
				        {
				            Type = "Spacer",
				            Data = 16
				        })

				        text:AppendLine({
				            Type = "Font",
				            Data = "Info Title",
				        },
				        {
				            Type = "Color",
				            Data = col,
				        },
				        {
				            Type = "Text",
				            Data = "Weapon Loadout",
				        },
				        {
				            Type = "Spacer",
				            Data = 16
				        })

				        text:AppendLine({
				            Type = "Font",
				            Data = "Info Text",
				        },
				        {
				            Type = "Color",
				            Data = col,
				        },
				        {
				            Type = "Text",
				            Data = carry or "Sorry!",
				        })
	    			end
			    end)
			end
		end

		if F4menu.configuration.tabs.ents.enable then
			local count = 0
			for k, v in pairs(DarkRP.getCategories()["entities"]) do
				if v.members then
					for k, v in pairs(v.members) do
						if v.canSee then
							if not v.canSee(LocalPlayer()) then
								continue
							end
						end

						if v.allowed then
							if not table.HasValue(v.allowed, LocalPlayer():Team()) then
								continue
							end
						end

						count = count + 1
					end
				end
			end



			if count > 0 then
			    tabs.Add("Purchasables", F4menu.configuration.tabs.ents.color, function(p)
			    	local entities = vgui.Create("DScrollPanel", p)
			    	entities:Dock(FILL)
			    	entities:DockMargin(16, 16, 16, 16)
			    	entities:InvalidateParent(true)
			    	entities:SetWide(p:GetWide())
			    	function entities:Paint(w, h)
			    		surface.SetDrawColor(theme().listing_background)
			    		surface.DrawRect(0, 0, w, h)
			    		surface.DrawOutlinedRect(0, 0, w, h)
			    	end

					entities.VBar.Paint = function(s, w, h)
						draw.RoundedBox(4, 3, 13, 8, h - 24, Color(0, 0, 0, 70))
					end

					entities.VBar.btnUp.Paint = function(s, w, h) end
					entities.VBar.btnDown.Paint = function(s, w, h) end

					entities.VBar.btnGrip.Paint = function(s, w, h)
						draw.RoundedBox(4, 5, 0, 4, h + 22, Color(0, 0, 0, 70))
					end

			    	local categories = {}
			    	for k, v in pairs(DarkRP.getCategories()["entities"]) do
			    		local category = vgui.Create("DCollapsibleCategory", entities)
			    		category:Dock(TOP)
			    		category:DockMargin(8, 8, 8, 0)
			    		category.Header:SetTall(48)
			    		category:SetExpanded(1)
			    		category:SetLabel("")
			    		category.Text = v.name

			    		local count = 0
			    		for k, v in pairs(v.members) do
			    			if v.allowed then
				    			if not table.HasValue(v.allowed, LocalPlayer():Team()) then
				    				continue
				    			end
				    		end

				    		count = count + 1
			    		end

			    		if count == 0 then
			    			category:Remove()
			    			continue
			    		end

			    		function category:Paint(w, h)
			    			local h = 48
			    			surface.SetDrawColor(theme().listing_header)
			    			surface.DrawRect(0, 0, w, h)

			    			surface.SetDrawColor(F4menu.configuration.general.color)
			    			surface.DrawRect(0, h-2, w, 2)

			    			surface.SetFont("dev button")
			    			local textw, texth = surface.GetTextSize(self.Text)
			    			surface.SetTextColor(theme().text)
			    			surface.SetTextPos(16, h/2-texth/2)
			    			surface.DrawText(self.Text)
			    		end

			    		for k, v in pairs(v.members) do
			    			if v.allowed then
				    			if not table.HasValue(v.allowed, LocalPlayer():Team()) then
				    				continue
				    			end
				    		end

			    			local entity = vgui.Create("DButton", category)
			    			entity:Dock(TOP)
			    			entity:DockMargin(0, 0, 0, 0)
			    			entity:SetTall(48)
			    			entity:SetText("")
			    			entity.alpha = 5
			    			local color = Color(0, 175, 255)
			    			function entity:Paint(w, h)
			    				if theme().light then
									if self.Hovered then
										self.alpha = math.Approach(self.alpha, 125, FrameTime()*300*2)
									end

									if self.Depressed then
										self.alpha = math.Approach(self.alpha, 75, FrameTime()*750*2)
									end

									if not self.Hovered then
										self.alpha = math.Approach(self.alpha, 255, FrameTime()*300*2)
									end
								else
									if self.Hovered then
										self.alpha = math.Approach(self.alpha, 75, FrameTime()*300)
									end

									if self.Depressed then
										self.alpha = math.Approach(self.alpha, 125, FrameTime()*750)
									end

									if not self.Hovered then
										self.alpha = math.Approach(self.alpha, 50, FrameTime()*300)
									end
								end

								local col = theme().listing_items or Color(0, 0, 0)
								surface.SetDrawColor(col.r, col.b, col.g, self.alpha)
								surface.DrawRect(0, 0, w, h)

								surface.SetDrawColor(0, 0, 0, 100)
								surface.DrawLine(0, h-1, w, h-1)

								if not theme().light then
									surface.SetDrawColor(0, 0, 0, 50)
				    				surface.DrawRect(0, 0, w, h)
				    			end

			    				surface.SetFont("dev button")
			    				local textw, texth = surface.GetTextSize(v.name)
			    				surface.SetTextColor(theme().text)
			    				surface.SetTextPos(64+16, h/2-texth/2)
			    				surface.DrawText(v.name)

			    				surface.SetFont("dev button")
			    				local text = #team.GetPlayers(v.team) .. "/" .. v.max
			    				local textw, texth = surface.GetTextSize(text)
			    				surface.SetTextColor(theme().text)
			    				surface.SetTextPos(w-16-textw, h/2-texth/2)
			    				surface.DrawText(text)

			    				surface.SetFont("dev button")
			    				local text = "$" .. v.price
			    				local textw2, texth2 = surface.GetTextSize(text)
			    				surface.SetTextColor(theme().light and Color(20, 150, 20) or Color(75, 235, 75))
			    				surface.SetTextPos(w-16-textw-textw2-32, h/2-texth/2)
			    				surface.DrawText(text)
			    			end

			    			entity.model = entity.model or vgui.Create("ModelImage", entity)
						    entity.model:SetSize(60, 60)
						    entity.model:SetPos(0, 0)

						    local model = v.model
						    if istable(model) then
						    	model = model[1]
						    end

						    entity.model:SetModel(model, 1, "000000000")

						    function entity:DoClick()
						    	if v.cmd then
						    		RunConsoleCommand("say", "/" .. v.cmd)
						    	else
						    		RunConsoleCommand("DarkRP", "buy", v.name)
						    	end
								surface.PlaySound('buttons/lightswitch2.wav')
						    end
						end
				    end
				end)
		    end
		end

		if F4menu.configuration.tabs.weapons.enable then
			local count = 0
			for k, v in pairs(DarkRP.getCategories()["weapons"]) do
				if v.members then
					for k, v in pairs(v.members) do
						if v.canSee then
							if not v.canSee(LocalPlayer()) then
								continue
							end
						end

						if v.allowed then
							if not table.HasValue(v.allowed, LocalPlayer():Team()) then
								continue
							end
						end

						count = count + 1
					end
				end
			end



			if count > 0 then
				tabs.Add("Weapons", F4menu.configuration.tabs.weapons.color, function(p)
			    	local entities = vgui.Create("DScrollPanel", p)
			    	entities:Dock(FILL)
			    	entities:DockMargin(16, 16, 16, 16)
			    	entities:InvalidateParent(true)
			    	entities:SetWide(p:GetWide())
			    	function entities:Paint(w, h)
			    		surface.SetDrawColor(theme().listing_background)
			    		surface.DrawRect(0, 0, w, h)
			    		surface.DrawOutlinedRect(0, 0, w, h)
			    	end

					entities.VBar.Paint = function(s, w, h)
						draw.RoundedBox(4, 3, 13, 8, h - 24, Color(0, 0, 0, 70))
					end

					entities.VBar.btnUp.Paint = function(s, w, h) end
					entities.VBar.btnDown.Paint = function(s, w, h) end

					entities.VBar.btnGrip.Paint = function(s, w, h)
						draw.RoundedBox(4, 5, 0, 4, h + 22, Color(0, 0, 0, 70))
					end

			    	local categories = {}
			    	for k, v in pairs(DarkRP.getCategories()["weapons"]) do
			    		local category = vgui.Create("DCollapsibleCategory", entities)
			    		category:Dock(TOP)
			    		category:DockMargin(8, 8, 8, 0)
			    		category.Header:SetTall(48)
			    		category:SetExpanded(1)
			    		category:SetLabel("")
			    		category.Text = v.name

			    		local count = 0
			    		for k, v in pairs(v.members) do
			    			if v.allowed then
				    			if not table.HasValue(v.allowed, LocalPlayer():Team()) then
				    				continue
				    			end
				    		end

				    		count = count + 1
			    		end

			    		if count == 0 then
			    			category:Remove()
			    			continue
			    		end

			    		function category:Paint(w, h)
			    			local h = 48
			    			surface.SetDrawColor(theme().listing_header)
			    			surface.DrawRect(0, 0, w, h)

			    			surface.SetDrawColor(F4menu.configuration.general.color)
			    			surface.DrawRect(0, h-2, w, 2)

			    			surface.SetFont("dev button")
			    			local textw, texth = surface.GetTextSize(self.Text)
			    			surface.SetTextColor(theme().text)
			    			surface.SetTextPos(16, h/2-texth/2)
			    			surface.DrawText(self.Text)
			    		end

			    		for k, v in pairs(v.members) do
			    			if v.allowed then
				    			if not table.HasValue(v.allowed, LocalPlayer():Team()) then
				    				continue
				    			end
				    		end

			    			local entity = vgui.Create("DButton", category)
			    			entity:Dock(TOP)
			    			entity:DockMargin(0, 0, 0, 0)
			    			entity:SetTall(48)
			    			entity:SetText("")
			    			entity.alpha = 5
			    			local color = Color(0, 175, 255)
			    			function entity:Paint(w, h)
			    				if theme().light then
									if self.Hovered then
										self.alpha = math.Approach(self.alpha, 125, FrameTime()*300*2)
									end

									if self.Depressed then
										self.alpha = math.Approach(self.alpha, 75, FrameTime()*750*2)
									end

									if not self.Hovered then
										self.alpha = math.Approach(self.alpha, 255, FrameTime()*300*2)
									end
								else
									if self.Hovered then
										self.alpha = math.Approach(self.alpha, 75, FrameTime()*300)
									end

									if self.Depressed then
										self.alpha = math.Approach(self.alpha, 125, FrameTime()*750)
									end

									if not self.Hovered then
										self.alpha = math.Approach(self.alpha, 50, FrameTime()*300)
									end
								end

								local col = theme().listing_items or Color(0, 0, 0)
								surface.SetDrawColor(col.r, col.b, col.g, self.alpha)
								surface.DrawRect(0, 0, w, h)

								surface.SetDrawColor(0, 0, 0, 100)
								surface.DrawLine(0, h-1, w, h-1)

								if not theme().light then
									surface.SetDrawColor(0, 0, 0, 50)
				    				surface.DrawRect(0, 0, w, h)
				    			end

			    				surface.SetFont("dev button")
			    				local textw, texth = surface.GetTextSize(v.name)
			    				surface.SetTextColor(theme().text)
			    				surface.SetTextPos(64+16, h/2-texth/2)
			    				surface.DrawText(v.name)

			    				surface.SetFont("dev button")
			    				local text = "$" .. v.price
			    				local textw2, texth2 = surface.GetTextSize(text)
			    				surface.SetTextColor(theme().light and Color(20, 150, 20) or Color(75, 235, 75))
			    				surface.SetTextPos(w-16-textw2-32, h/2-texth/2)
			    				surface.DrawText(text)
			    			end

			    			entity.model = entity.model or vgui.Create("ModelImage", entity)
						    entity.model:SetSize(60, 60)
						    entity.model:SetPos(0, 0)

						    local model = v.model
						    if istable(model) then
						    	model = model[1]
						    end

						    entity.model:SetModel(model, 1, "000000000")

						    function entity:DoClick()
						    	RunConsoleCommand("DarkRP", "buy", v.name)
								surface.PlaySound('buttons/lightswitch2.wav')
						    end
						end
				    end
			    end)
			end
		end

		if F4menu.configuration.tabs.shipments.enable then
			local count = 0
			for k, v in pairs(DarkRP.getCategories()["shipments"]) do
				if v.members then
					for k, v in pairs(v.members) do
						if v.canSee then
							if not v.canSee(LocalPlayer()) then
								continue
							end
						end

						if v.allowed then
							if not table.HasValue(v.allowed, LocalPlayer():Team()) then
								continue
							end
						end

						count = count + 1
					end
				end
			end



			if count > 0 then
				tabs.Add("Shipments", F4menu.configuration.tabs.shipments.color, function(p)
			    	local entities = vgui.Create("DScrollPanel", p)
			    	entities:Dock(FILL)
			    	entities:DockMargin(16, 16, 16, 16)
			    	entities:InvalidateParent(true)
			    	entities:SetWide(p:GetWide())
			    	function entities:Paint(w, h)
			    		surface.SetDrawColor(theme().listing_background)
			    		surface.DrawRect(0, 0, w, h)
			    		surface.DrawOutlinedRect(0, 0, w, h)
			    	end

					entities.VBar.Paint = function(s, w, h)
						draw.RoundedBox(4, 3, 13, 8, h - 24, Color(0, 0, 0, 70))
					end

					entities.VBar.btnUp.Paint = function(s, w, h) end
					entities.VBar.btnDown.Paint = function(s, w, h) end

					entities.VBar.btnGrip.Paint = function(s, w, h)
						draw.RoundedBox(4, 5, 0, 4, h + 22, Color(0, 0, 0, 70))
					end

			    	local categories = {}
			    	for k, v in pairs(DarkRP.getCategories()["shipments"]) do
			    		local category = vgui.Create("DCollapsibleCategory", entities)
			    		category:Dock(TOP)
			    		category:DockMargin(8, 8, 8, 0)
			    		category.Header:SetTall(48)
			    		category:SetExpanded(1)
			    		category:SetLabel("")
			    		category.Text = v.name

			    		local count = 0
			    		for k, v in pairs(v.members) do
			    			if v.allowed then
				    			if not table.HasValue(v.allowed, LocalPlayer():Team()) then
				    				continue
				    			end
				    		end

				    		count = count + 1
			    		end

			    		if count == 0 then
			    			category:Remove()
			    			continue
			    		end

			    		function category:Paint(w, h)
			    			local h = 48
			    			surface.SetDrawColor(theme().listing_header)
			    			surface.DrawRect(0, 0, w, h)

			    			surface.SetDrawColor(F4menu.configuration.general.color)
			    			surface.DrawRect(0, h-2, w, 2)

			    			surface.SetFont("dev button")
			    			local textw, texth = surface.GetTextSize(self.Text)
			    			surface.SetTextColor(theme().text)
			    			surface.SetTextPos(16, h/2-texth/2)
			    			surface.DrawText(self.Text)
			    		end

			    		for k, v in pairs(v.members) do
			    			if v.allowed then
				    			if not table.HasValue(v.allowed, LocalPlayer():Team()) then
				    				continue
				    			end
				    		end

			    			local entity = vgui.Create("DButton", category)
			    			entity:Dock(TOP)
			    			entity:DockMargin(0, 0, 0, 0)
			    			entity:SetTall(48)
			    			entity:SetText("")
			    			entity.alpha = 5
			    			local color = Color(0, 175, 255)
			    			function entity:Paint(w, h)
			    				if theme().light then
									if self.Hovered then
										self.alpha = math.Approach(self.alpha, 125, FrameTime()*300*2)
									end

									if self.Depressed then
										self.alpha = math.Approach(self.alpha, 75, FrameTime()*750*2)
									end

									if not self.Hovered then
										self.alpha = math.Approach(self.alpha, 255, FrameTime()*300*2)
									end
								else
									if self.Hovered then
										self.alpha = math.Approach(self.alpha, 75, FrameTime()*300)
									end

									if self.Depressed then
										self.alpha = math.Approach(self.alpha, 125, FrameTime()*750)
									end

									if not self.Hovered then
										self.alpha = math.Approach(self.alpha, 50, FrameTime()*300)
									end
								end

								local col = theme().listing_items or Color(0, 0, 0)
								surface.SetDrawColor(col.r, col.b, col.g, self.alpha)
								surface.DrawRect(0, 0, w, h)

								surface.SetDrawColor(0, 0, 0, 100)
								surface.DrawLine(0, h-1, w, h-1)

								if not theme().light then
									surface.SetDrawColor(0, 0, 0, 50)
				    				surface.DrawRect(0, 0, w, h)
				    			end

			    				surface.SetFont("dev button")
			    				local textw, texth = surface.GetTextSize(v.name)
			    				surface.SetTextColor(theme().text)
			    				surface.SetTextPos(64+16, h/2-texth/2)
			    				surface.DrawText(v.name)

			    				surface.SetFont("dev button")
			    				local text = "$" .. v.price
			    				local textw, texth = surface.GetTextSize(text)
			    				surface.SetTextColor(theme().light and Color(20, 150, 20) or Color(75, 235, 75))
			    				surface.SetTextPos(w-16-textw, h/2-texth/2)
			    				surface.DrawText(text)

			    				surface.SetFont("dev button")
			    				local text = "x ".. v.amount
			    				local textw2, texth2 = surface.GetTextSize(text)
			    				surface.SetTextColor(theme().text)
			    				surface.SetTextPos(w-16-textw-textw2-32, h/2-texth/2)
			    				surface.DrawText(text)
			    			end

			    			entity.model = entity.model or vgui.Create("ModelImage", entity)
						    entity.model:SetSize(60, 60)
						    entity.model:SetPos(0, 0)

						    local model = v.model
						    if istable(model) then
						    	model = model[1]
						    end

						    entity.model:SetModel(model, 1, "000000000")

						    function entity:DoClick()
						    	RunConsoleCommand("DarkRP", "buyshipment", v.name)
								surface.PlaySound('buttons/lightswitch2.wav')
						    end
						end
				    end
			    end)
			end
		end

		if F4menu.configuration.tabs.vehicles.enable then
			local count = 0
			for k, v in pairs(DarkRP.getCategories()["vehicles"]) do
				if v.members then
					for k, v in pairs(v.members) do
						if v.canSee then
							if not v.canSee(LocalPlayer()) then
								continue
							end
						end

						if v.allowed then
							if not table.HasValue(v.allowed, LocalPlayer():Team()) then
								continue
							end
						end

						count = count + 1
					end
				end
			end



			if count > 0 then
				tabs.Add("Vehicles", F4menu.configuration.tabs.vehicles.color, function(p)
			    	local entities = vgui.Create("DScrollPanel", p)
			    	entities:Dock(FILL)
			    	entities:DockMargin(16, 16, 16, 16)
			    	entities:InvalidateParent(true)
			    	entities:SetWide(p:GetWide())
			    	function entities:Paint(w, h)
			    		surface.SetDrawColor(theme().listing_background)
			    		surface.DrawRect(0, 0, w, h)
			    		surface.DrawOutlinedRect(0, 0, w, h)
			    	end

					entities.VBar.Paint = function(s, w, h)
						draw.RoundedBox(4, 3, 13, 8, h - 24, Color(0, 0, 0, 70))
					end

					entities.VBar.btnUp.Paint = function(s, w, h) end
					entities.VBar.btnDown.Paint = function(s, w, h) end

					entities.VBar.btnGrip.Paint = function(s, w, h)
						draw.RoundedBox(4, 5, 0, 4, h + 22, Color(0, 0, 0, 70))
					end

			    	local categories = {}
			    	for k, v in pairs(DarkRP.getCategories()["vehicles"]) do
			    		local category = vgui.Create("DCollapsibleCategory", entities)
			    		category:Dock(TOP)
			    		category:DockMargin(8, 8, 8, 0)
			    		category.Header:SetTall(48)
			    		category:SetExpanded(1)
			    		category:SetLabel("")
			    		category.Text = v.name

			    		local count = 0
			    		for k, v in pairs(v.members) do
			    			if v.allowed then
				    			if not table.HasValue(v.allowed, LocalPlayer():Team()) then
				    				continue
				    			end
				    		end

				    		count = count + 1
			    		end

			    		if count == 0 then
			    			category:Remove()
			    			continue
			    		end

			    		function category:Paint(w, h)
			    			local h = 48
			    			surface.SetDrawColor(theme().listing_header)
			    			surface.DrawRect(0, 0, w, h)

			    			surface.SetDrawColor(F4menu.configuration.general.color)
			    			surface.DrawRect(0, h-2, w, 2)

			    			surface.SetFont("dev button")
			    			local textw, texth = surface.GetTextSize(self.Text)
			    			surface.SetTextColor(theme().text)
			    			surface.SetTextPos(16, h/2-texth/2)
			    			surface.DrawText(self.Text)
			    		end

			    		for k, v in pairs(v.members) do
			    			if v.allowed then
				    			if not table.HasValue(v.allowed, LocalPlayer():Team()) then
				    				continue
				    			end
				    		end

			    			local entity = vgui.Create("DButton", category)
			    			entity:Dock(TOP)
			    			entity:DockMargin(0, 0, 0, 0)
			    			entity:SetTall(48)
			    			entity:SetText("")
			    			entity.alpha = 5
			    			local color = Color(0, 175, 255)
			    			function entity:Paint(w, h)
			    				if theme().light then
									if self.Hovered then
										self.alpha = math.Approach(self.alpha, 125, FrameTime()*300*2)
									end

									if self.Depressed then
										self.alpha = math.Approach(self.alpha, 75, FrameTime()*750*2)
									end

									if not self.Hovered then
										self.alpha = math.Approach(self.alpha, 255, FrameTime()*300*2)
									end
								else
									if self.Hovered then
										self.alpha = math.Approach(self.alpha, 75, FrameTime()*300)
									end

									if self.Depressed then
										self.alpha = math.Approach(self.alpha, 125, FrameTime()*750)
									end

									if not self.Hovered then
										self.alpha = math.Approach(self.alpha, 50, FrameTime()*300)
									end
								end

								local col = theme().listing_items or Color(0, 0, 0)
								surface.SetDrawColor(col.r, col.b, col.g, self.alpha)
								surface.DrawRect(0, 0, w, h)

								surface.SetDrawColor(0, 0, 0, 100)
								surface.DrawLine(0, h-1, w, h-1)

								if not theme().light then
									surface.SetDrawColor(0, 0, 0, 50)
				    				surface.DrawRect(0, 0, w, h)
				    			end

			    				surface.SetFont("dev button")
			    				local textw, texth = surface.GetTextSize(v.name)
			    				surface.SetTextColor(theme().text)
			    				surface.SetTextPos(64+16, h/2-texth/2)
			    				surface.DrawText(v.name)

			    				surface.SetFont("dev button")
			    				local text = #team.GetPlayers(v.team) .. "/" .. v.max
			    				local textw, texth = surface.GetTextSize(text)
			    				surface.SetTextColor(theme().text)
			    				surface.SetTextPos(w-16-textw, h/2-texth/2)
			    				surface.DrawText(text)

			    				surface.SetFont("dev button")
			    				local text = "$" .. v.price
			    				local textw2, texth2 = surface.GetTextSize(text)
			    				surface.SetTextColor(theme().light and Color(20, 150, 20) or Color(75, 235, 75))
			    				surface.SetTextPos(w-16-textw-textw2-32, h/2-texth/2)
			    				surface.DrawText(text)
			    			end

			    			entity.model = entity.model or vgui.Create("ModelImage", entity)
						    entity.model:SetSize(60, 60)
						    entity.model:SetPos(0, 0)

						    local model = v.model
						    if istable(model) then
						    	model = model[1]
						    end

						    entity.model:SetModel(model, 1, "000000000")

						    function entity:DoClick()
						    	RunConsoleCommand("DarkRP", "buyvehicle", v.name)
								surface.PlaySound('buttons/lightswitch2.wav')
						    end
						end
				    end
				end)
		    end
		end

		if F4menu.configuration.tabs.ammunition.enable then
			local count = 0
			for k, v in pairs(DarkRP.getCategories()["ammo"]) do
				if v.members then
					for k, v in pairs(v.members) do
						if v.canSee then
							if not v.canSee(LocalPlayer()) then
								continue
							end
						end

						if v.allowed then
							if not table.HasValue(v.allowed, LocalPlayer():Team()) then
								continue
							end
						end

						count = count + 1
					end
				end
			end

			if count > 0 then
				tabs.Add("Ammunition", F4menu.configuration.tabs.ammunition.color, function(p)
			    	local entities = vgui.Create("DScrollPanel", p)
			    	entities:Dock(FILL)
			    	entities:DockMargin(16, 16, 16, 16)
			    	entities:InvalidateParent(true)
			    	entities:SetWide(p:GetWide())
			    	function entities:Paint(w, h)
			    		surface.SetDrawColor(theme().listing_background)
			    		surface.DrawRect(0, 0, w, h)
			    		surface.DrawOutlinedRect(0, 0, w, h)
			    	end

					entities.VBar.Paint = function(s, w, h)
						draw.RoundedBox(4, 3, 13, 8, h - 24, Color(0, 0, 0, 70))
					end

					entities.VBar.btnUp.Paint = function(s, w, h) end
					entities.VBar.btnDown.Paint = function(s, w, h) end

					entities.VBar.btnGrip.Paint = function(s, w, h)
						draw.RoundedBox(4, 5, 0, 4, h + 22, Color(0, 0, 0, 70))
					end

			    	local categories = {}
			    	for k, v in pairs(DarkRP.getCategories()["ammo"]) do
			    		local category = vgui.Create("DCollapsibleCategory", entities)
			    		category:Dock(TOP)
			    		category:DockMargin(8, 8, 8, 0)
			    		category.Header:SetTall(48)
			    		category:SetExpanded(1)
			    		category:SetLabel("")
			    		category.Text = v.name

			    		local count = 0
			    		for k, v in pairs(v.members) do
			    			if v.allowed then
				    			if not table.HasValue(v.allowed, LocalPlayer():Team()) then
				    				continue
				    			end
				    		end

				    		count = count + 1
			    		end

			    		if count == 0 then
			    			category:Remove()
			    			continue
			    		end

			    		function category:Paint(w, h)
			    			local h = 48
			    			surface.SetDrawColor(theme().listing_header)
			    			surface.DrawRect(0, 0, w, h)

			    			surface.SetDrawColor(F4menu.configuration.general.color)
			    			surface.DrawRect(0, h-2, w, 2)

			    			surface.SetFont("dev button")
			    			local textw, texth = surface.GetTextSize(self.Text)
			    			surface.SetTextColor(theme().text)
			    			surface.SetTextPos(16, h/2-texth/2)
			    			surface.DrawText(self.Text)
			    		end

			    		for k, v in pairs(v.members) do
			    			if v.allowed then
				    			if not table.HasValue(v.allowed, LocalPlayer():Team()) then
				    				continue
				    			end
				    		end

			    			local entity = vgui.Create("DButton", category)
			    			entity:Dock(TOP)
			    			entity:DockMargin(0, 0, 0, 0)
			    			entity:SetTall(48)
			    			entity:SetText("")
			    			entity.alpha = 5
			    			local color = Color(0, 175, 255)
			    			function entity:Paint(w, h)
			    				if theme().light then
									if self.Hovered then
										self.alpha = math.Approach(self.alpha, 125, FrameTime()*300*2)
									end

									if self.Depressed then
										self.alpha = math.Approach(self.alpha, 75, FrameTime()*750*2)
									end

									if not self.Hovered then
										self.alpha = math.Approach(self.alpha, 255, FrameTime()*300*2)
									end
								else
									if self.Hovered then
										self.alpha = math.Approach(self.alpha, 75, FrameTime()*300)
									end

									if self.Depressed then
										self.alpha = math.Approach(self.alpha, 125, FrameTime()*750)
									end

									if not self.Hovered then
										self.alpha = math.Approach(self.alpha, 50, FrameTime()*300)
									end
								end

								local col = theme().listing_items or Color(0, 0, 0)
								surface.SetDrawColor(col.r, col.b, col.g, self.alpha)
								surface.DrawRect(0, 0, w, h)

								surface.SetDrawColor(0, 0, 0, 100)
								surface.DrawLine(0, h-1, w, h-1)

								if not theme().light then
									surface.SetDrawColor(0, 0, 0, 50)
				    				surface.DrawRect(0, 0, w, h)
				    			end

			    				surface.SetFont("dev button")
			    				local textw, texth = surface.GetTextSize(v.name)
			    				surface.SetTextColor(theme().text)
			    				surface.SetTextPos(64+16, h/2-texth/2)
			    				surface.DrawText(v.name)

			    				surface.SetFont("dev button")
			    				local text = ""
			    				local textw, texth = surface.GetTextSize(text)
			    				surface.SetTextColor(theme().text)
			    				surface.SetTextPos(w-16-textw, h/2-texth/2)
			    				surface.DrawText(text)

			    				surface.SetFont("dev button")
			    				local text = "$" .. v.price
			    				local textw2, texth2 = surface.GetTextSize(text)
			    				surface.SetTextColor(theme().light and Color(20, 150, 20) or Color(75, 235, 75))
			    				surface.SetTextPos(w-16-textw-textw2-32, h/2-texth/2)
			    				surface.DrawText(text)
			    			end

			    			entity.model = entity.model or vgui.Create("ModelImage", entity)
						    entity.model:SetSize(60, 60)
						    entity.model:SetPos(0, 0)

						    local model = v.model
						    if istable(model) then
						    	model = model[1]
						    end

						    entity.model:SetModel(model, 1, "000000000")

						    function entity:DoClick()
						    	RunConsoleCommand("DarkRP", "buyammo", v.id)
								surface.PlaySound('buttons/lightswitch2.wav')
						    end
						end
				    end
			    end)
			end
		end

		if F4menu.configuration.tabs.food.enable and (F4menu.configuration.tabs.food.allowed and table.HasValue(F4menu.configuration.tabs.food.allowed, LocalPlayer():Team())) then
			local count = 0
			for k, v in pairs(DarkRP.getFoodItems()) do
				if v.canSee and (not v.canSee(LocalPlayer())) then
					continue
				end

				if v.allowed and (not table.HasValue(v.allowed, LocalPlayer():Team())) then
					continue
				end

				count = count + 1
			end

			if count > 0 then
				tabs.Add("Food", F4menu.configuration.tabs.food.color, function(p)
			    	local entities = vgui.Create("DScrollPanel", p)
			    	entities:Dock(FILL)
			    	entities:DockMargin(16, 16, 16, 16)
			    	entities:InvalidateParent(true)
			    	entities:SetWide(p:GetWide())
			    	function entities:Paint(w, h)
			    		surface.SetDrawColor(theme().listing_background)
			    		surface.DrawRect(0, 0, w, h)
			    		surface.DrawOutlinedRect(0, 0, w, h)
			    	end

					entities.VBar.Paint = function(s, w, h)
						draw.RoundedBox(4, 3, 13, 8, h - 24, Color(0, 0, 0, 70))
					end

					entities.VBar.btnUp.Paint = function(s, w, h) end
					entities.VBar.btnDown.Paint = function(s, w, h) end

					entities.VBar.btnGrip.Paint = function(s, w, h)
						draw.RoundedBox(4, 5, 0, 4, h + 22, Color(0, 0, 0, 70))
					end

			    	local category = vgui.Create("DCollapsibleCategory", entities)
			    	category:Dock(TOP)
			    	category:DockMargin(8, 8, 8, 0)
			    	category.Header:SetTall(48)
			    	category:SetExpanded(1)
			    	category:SetLabel("")
			    	category.Text = "Foods"

			    		function category:Paint(w, h)
			    			local h = 48
			    			surface.SetDrawColor(theme().listing_header)
			    			surface.DrawRect(0, 0, w, h)

			    			surface.SetDrawColor(F4menu.configuration.general.color)
			    			surface.DrawRect(0, h-2, w, 2)

			    			surface.SetFont("dev button")
			    			local textw, texth = surface.GetTextSize(self.Text)
			    			surface.SetTextColor(theme().text)
			    			surface.SetTextPos(16, h/2-texth/2)
			    			surface.DrawText(self.Text)
			    		end

			    		for k, v in pairs(DarkRP.getFoodItems()) do
			    			if v.allowed then
				    			if not table.HasValue(v.allowed, LocalPlayer():Team()) then
				    				continue
				    			end
				    		end

			    			local entity = vgui.Create("DButton", category)
			    			entity:Dock(TOP)
			    			entity:DockMargin(0, 0, 0, 0)
			    			entity:SetTall(48)
			    			entity:SetText("")
			    			entity.alpha = 5
			    			local color = Color(0, 175, 255)
			    			function entity:Paint(w, h)
			    				if theme().light then
									if self.Hovered then
										self.alpha = math.Approach(self.alpha, 125, FrameTime()*300*2)
									end

									if self.Depressed then
										self.alpha = math.Approach(self.alpha, 75, FrameTime()*750*2)
									end

									if not self.Hovered then
										self.alpha = math.Approach(self.alpha, 255, FrameTime()*300*2)
									end
								else
									if self.Hovered then
										self.alpha = math.Approach(self.alpha, 75, FrameTime()*300)
									end

									if self.Depressed then
										self.alpha = math.Approach(self.alpha, 125, FrameTime()*750)
									end

									if not self.Hovered then
										self.alpha = math.Approach(self.alpha, 50, FrameTime()*300)
									end
								end

								local col = theme().listing_items or Color(0, 0, 0)
								surface.SetDrawColor(col.r, col.b, col.g, self.alpha)
								surface.DrawRect(0, 0, w, h)

								surface.SetDrawColor(0, 0, 0, 100)
								surface.DrawLine(0, h-1, w, h-1)

								if not theme().light then
									surface.SetDrawColor(0, 0, 0, 50)
				    				surface.DrawRect(0, 0, w, h)
				    			end

			    				surface.SetFont("dev button")
			    				local textw, texth = surface.GetTextSize(v.name)
			    				surface.SetTextColor(theme().text)
			    				surface.SetTextPos(64+16, h/2-texth/2)
			    				surface.DrawText(v.name)

			    				surface.SetFont("dev button")
			    				local text = ""
			    				local textw, texth = surface.GetTextSize(text)
			    				surface.SetTextColor(theme().text)
			    				surface.SetTextPos(w-16-textw, h/2-texth/2)
			    				surface.DrawText(text)

			    				surface.SetFont("dev button")
			    				local text = "$" .. v.price
			    				local textw2, texth2 = surface.GetTextSize(text)
			    				surface.SetTextColor(theme().light and Color(20, 150, 20) or Color(75, 235, 75))
			    				surface.SetTextPos(w-16-textw-textw2-32, h/2-texth/2)
			    				surface.DrawText(text)
			    			end

			    			entity.model = entity.model or vgui.Create("ModelImage", entity)
						    entity.model:SetSize(60, 60)
						    entity.model:SetPos(0, 0)

						    local model = v.model
						    if istable(model) then
						    	model = model[1]
						    end

						    entity.model:SetModel(model, 1, "000000000")

						    function entity:DoClick()
						    	RunConsoleCommand("DarkRP", "buyfood", v.name)
								surface.PlaySound('buttons/lightswitch2.wav')
						    end
						end

			    end)
			end
		end

		local spacer = vgui.Create("DLabel", tabs)
		spacer:Dock(TOP)
		spacer:DockMargin(16, 0, 0, 0)
		-- spacer:SetTall(48)
		spacer:SetTall(28)
		spacer:SetFont("dev button")
		spacer:SetTextColor((F4menu.configuration.general.theme == "clear") and Color(200, 200, 200) or Color(110, 110, 110))
		-- spacer:SetText("Websites")
		spacer:SetText("")

		for k, v in pairs(F4menu.configuration.webtabs) do
			tabs.Add(k, v.color, function(p)
		    	local web = vgui.Create(v.html and "DHTML" or "HTML", p)
		    	web:Dock(FILL)
		    	web:DockMargin(16, 16, 16, 16)
		    	web:InvalidateParent(true)
		    	web:SetWide(p:GetWide())
		    	if v.html then
					web:SetHTML(v.html)
				else
					web:OpenURL(v.url)
		    	end
		    end)
		end

		local spacer = vgui.Create("DLabel", tabs)
		spacer:Dock(TOP)
		spacer:DockMargin(16, 0, 0, 0)
		-- spacer:SetTall(48)
		spacer:SetTall(28)
		spacer:SetFont("dev button")
		-- spacer:SetTextColor((F4menu.configuration.general.theme == "clear") and Color(200, 200, 200) or Color(110, 110, 110))
		spacer:SetText("")

		------------------------------------------------------------------------
		-- Skills
		if skill ~= nil then

			local skills, skillCount, skillPoints = {}, 0, 0

			net.Receive('F4Menu.skills.requestData', function()

				skills = {}
				skillCount = net.ReadUInt(8)
				skillPoints = (LocalPlayer():getDarkRPVar('level') or 0) - skillCount

				print(skills, skillCount, skillPoints)

				for i = 1, net.ReadUInt(8) do
					skills[net.ReadString()] = net.ReadUInt(8)
				end

			end)

			tabs.Add("Skills", Color(0, 180, 0), function(panel)

				local container = vgui.Create("DPanel", panel)
				container:Dock(FILL)
				container:DockMargin(16, 16, 16, 16)
				container:InvalidateParent(true)
				container:SetTall(panel:GetTall())

				function container:Paint(w, h)
					surface.SetDrawColor(theme().listing_background)
					surface.DrawRect(0, 0, w, h)
					surface.DrawOutlinedRect(0, 0, w, h)
				end

				local topPanel = vgui.Create("DPanel", container)
				topPanel:Dock(TOP)
				topPanel:SetTall(32)
				function topPanel:Paint(w, h)

					surface.SetDrawColor(theme().listing_background)
					surface.DrawRect(0, 0, w, h)
					surface.DrawOutlinedRect(0, 0, w, h)

		    		surface.SetFont("dev button")
		    		local text = "You have " .. skillPoints .. " points to spend"
		    		local textW, textH = surface.GetTextSize(text)

		    		surface.SetTextPos(w - textW - 10, h * .5 - textH * .5)
		    		surface.SetTextColor(75, 255, 75)
		    		surface.DrawText(text)

				end

				local scrollPanel = vgui.Create("DScrollPanel", container)
				scrollPanel:Dock(FILL)
				scrollPanel:DockMargin(0, 0, 0, 0)
				-- scrollPanel:SetTall(400)
				scrollPanel:InvalidateParent(true)

				-- Scroll panel paint
				function scrollPanel:Paint(w, h) end
				scrollPanel.VBar.Paint = function(s, w, h)
					draw.RoundedBox(4, 3, 13, 8, h - 24, Color(0, 0, 0, 70))
				end
				scrollPanel.VBar.btnUp.Paint = function(s, w, h) end
				scrollPanel.VBar.btnDown.Paint = function(s, w, h) end
				scrollPanel.VBar.btnGrip.Paint = function(s, w, h)
					draw.RoundedBox(4, 5, 0, 4, h + 22, Color(0, 0, 0, 70))
				end
				for k, v in pairs(skill.Skills) do

					local item = vgui.Create("DButton", category)
					item:Dock(TOP)
					item:DockMargin(8, 8, 8, 0)
					item:SetTall(52)
					item:SetText("")
					item.alpha = 0
					function item:Paint(w, h)

						if theme().light then
							if self.Hovered then
								self.alpha = math.Approach(self.alpha, 125, FrameTime()*300*2)
							end

							if self.Depressed then
								self.alpha = math.Approach(self.alpha, 75, FrameTime()*750*2)
							end

							if not self.Hovered then
								self.alpha = math.Approach(self.alpha, 255, FrameTime()*300*2)
							end
						else
							if self.Hovered then
								self.alpha = math.Approach(self.alpha, 75, FrameTime()*300)
							end

							if self.Depressed then
								self.alpha = math.Approach(self.alpha, 125, FrameTime()*750)
							end

							if not self.Hovered then
								self.alpha = math.Approach(self.alpha, 50, FrameTime()*300)
							end
						end

						local col = theme().listing_items or Color(0, 0, 0)
						surface.SetDrawColor(col.r, col.b, col.g, self.alpha)
						surface.DrawRect(0, 0, w, h)

						-- surface.SetDrawColor(v.color.r, v.color.g, v.color.b, theme().light and 175 or 100)
						-- surface.DrawRect(0, 0, 60, h)
						--
						-- surface.SetDrawColor(v.color.r, v.color.g, v.color.b)
						-- surface.DrawRect(60, 0, self.Depressed and 8 or (self.Hovered and 6 or 4), h)
						--
						-- surface.SetDrawColor(0, 0, 0, 100)
						-- surface.DrawLine(0, h-1, w, h-1)
						--
						-- if not theme().light then
						-- 	surface.SetDrawColor(0, 0, 0, 50)
						-- 	surface.DrawRect(0, 0, w, h)
						-- end

						surface.SetFont("dev small title")
						local textw, texth = surface.GetTextSize(v.Name)
						surface.SetTextColor(theme().text)
						surface.SetTextPos(10, 6)
						surface.DrawText(v.Name)

						surface.SetFont("dev button")
						local textw, texth = surface.GetTextSize(v.Desc)
						surface.SetTextColor(theme().text)
						surface.SetTextPos(10, 30)
						surface.DrawText(v.Desc)

						surface.SetFont("dev small title")
						local text = (skills[v.ID] or 0) .. '/' .. v.Max
						local textw, texth = surface.GetTextSize(text)
						surface.SetTextColor(theme().text)
						surface.SetTextPos(w-16-textw, h/2-texth/2)
						surface.DrawText(text)

						surface.SetDrawColor(theme().listing_background)
						surface.DrawRect(0, 0, w, h)
						surface.DrawOutlinedRect(0, 0, w, h)

					end

					function item:DoClick()
						surface.PlaySound(skill.ButtonSounds[math.random(#skill.ButtonSounds)])

						RunConsoleCommand('skill_buy', v.ID)
						if (skills[v.ID] and (skills[v.ID] >= v.Max)) or (skillPoints <= 0) then return end
						skills[v.ID] = (skills[v.ID] or 0) + 1

						skillCount = skillCount + 1
						skillPoints =  (LocalPlayer():getDarkRPVar('level') or 0) - skillCount

					end

					scrollPanel:AddItem(item)

				end

				local buttonPanel = vgui.Create("DPanel", container)
				buttonPanel:Dock(BOTTOM)
				buttonPanel:DockMargin(8, 8, 8, 8)
				buttonPanel:SetWide(container:GetWide())
				buttonPanel:SetTall(42)
				buttonPanel.Paint = function(pnl, w, h) end

				local upgradeButton = vgui.Create("DButton", buttonPanel)
				upgradeButton:Dock(RIGHT)
				upgradeButton:DockMargin(8, 0, 0, 0)
				upgradeButton:SetTall(42)
				upgradeButton:SetWide(200)
				upgradeButton:SetText("")

				function upgradeButton:Paint(w, h)

					self.alpha = self.alpha or 0
					if self.Hovered then
						self.alpha = math.Approach(self.alpha, 75, FrameTime()*300)
					end

					if self.Depressed or tabs.core.Selected == k then
						self.alpha = math.Approach(self.alpha, 125, FrameTime()*750)
					end

					if not self.Hovered then
						self.alpha = math.Approach(self.alpha, 50, FrameTime()*300)
					end

					surface.SetDrawColor(0, 0, 0, self.alpha)
					surface.DrawRect(0, 0, w, h)

					surface.SetDrawColor(Color(0, 175, 255))
					surface.DrawRect(w-4, 0, 4, h)

					surface.SetFont("dev button")
					local text = "Upgrade Level"
					local textw, texth = surface.GetTextSize(text)
					surface.SetTextColor(theme().text)
					surface.SetTextPos(32, h/2-texth/2)
					surface.DrawText(text)

					surface.SetDrawColor(0, 0, 0, 100)
					surface.DrawLine(0, h-1, w, h-1)
					surface.DrawLine(0, 1, w, 1)
					surface.DrawLine(0, 1, 0, h-1)
				end

				function upgradeButton:DoClick()
					gui.OpenURL(skill.BuyLevelURL)
				end

				local resetButton = vgui.Create("DButton", buttonPanel)
				resetButton:Dock(FILL)
				-- resetButton:SetTall(42)
				resetButton:SetText("")
				resetButton:InvalidateParent(true)

				function resetButton:Paint(w, h)

					self.alpha = self.alpha or 0
					if self.Hovered then
						self.alpha = math.Approach(self.alpha, 75, FrameTime()*300)
					end

					if self.Depressed or tabs.core.Selected == k then
						self.alpha = math.Approach(self.alpha, 125, FrameTime()*750)
					end

					if not self.Hovered then
						self.alpha = math.Approach(self.alpha, 50, FrameTime()*300)
					end

					surface.SetDrawColor(0, 0, 0, self.alpha)
					surface.DrawRect(0, 0, w, h)

					surface.SetDrawColor(Color(0, 175, 255))
					surface.DrawRect(w-4, 0, 4, h)

					surface.SetFont("dev button")
					local text = "Reset All ($" .. skill.ResetPrice .. ")"
					local textw, texth = surface.GetTextSize(text)
					surface.SetTextColor(theme().text)
					surface.SetTextPos(32, h/2-texth/2)
					surface.DrawText(text)

					surface.SetDrawColor(0, 0, 0, 100)
					surface.DrawLine(0, h-1, w, h-1)
					surface.DrawLine(0, 1, w, 1)
					surface.DrawLine(0, 1, 0, h-1)
				end

				function resetButton:DoClick()
					surface.PlaySound(skill.ButtonSounds[math.random(#skill.ButtonSounds)])

					Derma_Query("Are you sure?", "Reset", "Yes", function()
						RunConsoleCommand('skill_reset')

						timer.Simple(.5, function()
							net.Start('F4Menu.skills.requestData')
							net.SendToServer()
						end)

					end, "No", function() end)

				end

				net.Start('F4Menu.skills.requestData')
				net.SendToServer()

			end)

		end

		------------------------------------------------------------------------

	end

	local gm = gmod.GetGamemode() or (GAMEMODE or GM)
	function gm:ShowSpare2()
		F4menu.Open()
	end
end

hook.Add("OnPlayerChangedTeam", "Refresh Menu", function(p)
	if p == LocalPlayer() then
		if F4menu.frame then
			F4menu.frame:SetMouseInputEnabled( false )
			F4menu.frame:SetKeyboardInputEnabled( false )
			F4menu.frame:Remove()
			F4menu.frame = nil
		end
	end
end)
