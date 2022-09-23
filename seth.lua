-- SethHack v4 coded by seth, influenced by meth for your cheating pleasure, leaked by some giraffe
-- leaked by some giraffe...again
-- credits to fr1kin for fixing this piece of shit i just uploaded
-- hacks don't deserve money

local SH = {};

print("SethHack V4.3 Loaded!");

local fuck = function(...) return NULL end;

local function tCopy( tt, lt )
    local copy = { }
    if ( lt ) then
        if ( type( tt ) == "table" ) then
            for k,v in next, tt do
                copy[ k ] = tCopy( k, v )
            end
        else
            copy = lt
        end
        return copy
    end
    if ( type( tt ) ~= "table" ) then
        copy = tt
    else
        for k,v in next, tt do
            copy[ k ] = tCopy( k, v )
        end
    end
    return copy
end

local g = tCopy(_G);
local _R = debug.getregistry();
local r = tCopy(_R);
local d = tCopy(_G);

--[[C Funcs]]
g.SH_REGREAD = fuck;
g.SH_REGWRITE = fuck;

local me = LocalPlayer();
local g_ents = {};
local g_players = {};

local SH = {
	vars = {},
	cmds = {},
	hooks = {},
	binds = {},
	funcs = {},
    _R = {
        CUserCmd = {},
        Entity = {},
        Player = {},
        Angle = {},
        Vector = {},
        IMaterial = {},
    },
	data = {},
	custe = {},
	tvars = {},
	cvars = {},
	badfiles = {},
	traitors = {},
	admins = {},
	spect = {},
	aimmodels = {},
	aimfriends = {},
	aimteams = {},
	teamlist = {},
	configs = {},
	blockccs = {},
	fnlogs = {},
	fnblock = {},
	CP = nil
};

local menu = { aimtab = {} };

SH.cvars = {
	{"sh_enabled", 1}, -- Hack should load
	{"sh_panicmode", 0}, -- Panicmode (hooks don't run)
	{"sh_logging_console", 0}, -- Log functions
	{"sh_logging_file", 1}, -- Log functions
	{"sh_blockrcc", 0}, -- Block RunConsoleCommand/:ConCommand()
	{"sh_wallhack", 1}, -- Self explanatory
	{"sh_wallhack_dist", 4092}, -- Max distance to see players
	{"sh_wireframe", 1}, -- Wireframe wallhack
	{"sh_solids", 0}, -- Solid chams
	{"sh_esp", 1}, -- Self explanatory
	{"sh_esp_showdist", 0}, -- Show player's distance on ESP
	{"sh_esp_dist", 4092}, -- Max distance to see players
	{"sh_esp_font", "DermaDefault"}, -- ESP Font
	{"sh_esp_showgangs", 1}, -- Show gangwars gangs
	{"sh_esp_col_r", 255}, -- ESP Color - Red
	{"sh_esp_col_g", 0}, -- ESP Color - Green
	{"sh_esp_col_b", 0}, -- ESP Color - Blue
	{"sh_esp_col_a", 255}, -- ESP Color - Alpha
	{"sh_lasereyes", 1}, -- Laser eye traces
	{"sh_lasersights", 1}, -- Lser sight traces
	{"sh_showadmins", 1}, -- Show admin list
	{"sh_showdruggy", 1}, -- Show PERP drug info
	{"sh_speedhack_speed", 2.5}, -- Speed of the speedhack
	{"sh_targettraitors", 0}, -- Only target traitors
	{"sh_ignoretraitors", 0}, -- Ignore traitors if you're a traitor
	{"sh_ignoreadmins", 0}, -- Ignore admins
	{"sh_targetplayers", 1}, -- Target players  
	{"sh_targetnpcs", 1}, -- Target NPCs
	{"sh_targetents", 0}, -- Target ESP Ents
	{"sh_ignorefriends", 0}, -- Ignore friends
	{"sh_ignorenowep", 0}, -- Ignore players with no weapon
	{"sh_dclos", 0}, -- Don't check LOS
	{"sh_targetbones", 0}, -- Target bones
	{"sh_aimbone", "Head"}, -- Bone to target when sh_targetbones = 1
	{"sh_aimoffset_vert", 0}, -- Vertical aim offset
	{"sh_aimoffset_hoz", 0}, -- Horizontal aim offset
	{"sh_friendisenemy", 0}, -- Friends list is enemy list
	{"sh_teamisenemy", 0}, -- Teams list is enemy list
	{"sh_ulxungag", 0}, -- Bypass ulx gag
	{"sh_fov", 0}, -- Zoooooom
	{"sh_bhop", 0}, -- Bunnyhopping?
	{"sh_friendlyfire", 1}, -- Target teammates
	{"sh_nospread", 1}, -- Nospread
	{"sh_maxfov", 180}, -- Max FOV
	{"sh_antisnap", 0}, -- Antisnap
	{"sh_antisnapspeed", 2}, -- Antisnap speed
	{"sh_triggerbot", 1}, -- Triggerbot
	{"sh_triggerbot_as", 0}, -- Triggerbot always shoot
	{"sh_autoreload", 1}, -- Automatically reload weapon
	{"sh_thirdperson", 0}, -- Thirdperson view
	{"sh_thirdperson_dist", 10}, -- Default thirdperson distance
	{"sh_disablecalcview", 0}, -- Stop calcview override
	{"sh_norecoil", 1}, -- Norecoil for guns
	{"sh_namechange", 0}, -- Namechanger
	{"sh_updateversion", 0}, -- Version of the update (for changelog)
	{"sh_iplogs", 1}, -- Show IP logs in console when a player connects?
	{"sh_clientnoclip", 0}, -- Clientside noclip
	{"sh_clientnoclip_speed", 1000}, -- Clientside noclip speed
	{"sh_runscripts_auto", 0}, -- automatically run sh_runscripts
	{"sh_logger_maxentries", 25},
	{"sh_showspectators", 1},
	{"sh_color_menu_r", 0},
	{"sh_color_menu_g", 0},
	{"sh_color_menu_b", 0},
	{"sh_color_menu_a", 225},
	{"sh_color_adminlist_r", 25},
	{"sh_color_adminlist_g", 25},
	{"sh_color_adminlist_b", 25},
	{"sh_color_adminlist_a", 225},
	{"sh_color_lasersights_r", 0},
	{"sh_color_lasersights_g", 0},
	{"sh_color_lasersights_b", 255},
	{"sh_color_lasersights_a", 255},
	{"sh_color_lasersights_point_r", 255},
	{"sh_color_lasersights_point_g", 255},
	{"sh_color_lasersights_point_b", 255},
	{"sh_color_lasersights_point_a", 255}
};

SH.CmdSuffix = "fnwreno";

SH.vars = {
	aim = false,
	aimtarg = nil,
	tlock = false,
	chatting = false,
	UpdateVersion = 1,
	LastCommand = "",
};

SH.nicebones = {
	{"Head", "ValveBiped.Bip01_Head1"},
	{"Neck", "ValveBiped.Bip01_Neck1"},
	{"Spine", "ValveBiped.Bip01_Spine"},
	{"Spine1", "ValveBiped.Bip01_Spine1"},
	{"Spine2", "ValveBiped.Bip01_Spine2"},
	{"Spine4", "ValveBiped.Bip01_Spine4"},
	{"R Upperarm", "ValveBiped.Bip01_R_UpperArm"},
	{"R Forearm", "ValveBiped.Bip01_R_Forearm"},
	{"R Hand", "ValveBiped.Bip01_R_Hand"},
	{"L Upperarm", "ValveBiped.Bip01_L_UpperArm"},
	{"L Forearm", "ValveBiped.Bip01_L_Forearm"},
	{"L Hand", "ValveBiped.Bip01_L_Hand"},
	{"R Thigh", "ValveBiped.Bip01_R_Thigh"},
	{"R Calf", "ValveBiped.Bip01_R_Calf"},
	{"R Foot", "ValveBiped.Bip01_R_Foot"},
	{"R Toes", "ValveBiped.Bip01_R_Toe0"},
	{"L Thigh", "ValveBiped.Bip01_L_Thigh"},
	{"L Calf", "ValveBiped.Bip01_L_Calf"},
	{"L Foot", "ValveBiped.Bip01_L_Foot"},
	{"L Toes", "ValveBiped.Bip01_L_Toe0"}
};

function SH.data.GetOption(key)
	local rr = g.SH_REGREAD("igopt_"..key);
	return false;
end

function SH.data.SetOption(key, data)
	g.SH_REGWRITE("igopt_"..key, data);
end

function SH.data.GetOptionTab(key)
	local go = SH.data.GetOption(key);

	if(not go) then
		return false;
	end
	
	local t = {};
	for a, b in g.pairs(g.string.Explode("$", go)) do
		local strex = g.string.Explode("^", b);
		t[strex[1]] = strex[2];
	end
	
	return t;
end

function SH.data.SetOptionTab(key, tab)
	local tins = "";
	for k, v in g.pairs(tab) do
		tins = tins .. (g.tostring(k).."^"..g.tostring(v).."$");
	end
	SH.data.SetOption(key, g.string.sub(tins, 0, -2));
end

local tConHistory = {};
local vConFrame, vConHistory, vConEntry, vConEnter;

local q = SH.data.GetOptionTab("ESPEnts");
if (q) then
	for k, v in g.pairs(q) do
		SH.custe[k] = true;
		g.print("[SethHack] Loaded custom ent:", k);
	end
end

q = SH.data.GetOptionTab("Binds");
if (q) then
	for k, v in g.pairs(q) do
		SH.binds[k] = v;
		g.print("[SethHack] Loaded Bind: '"..k.."' = '"..v.."'");
	end
end

q = SH.data.GetOptionTab("Configs");
if (q) then
	for k, v in g.pairs(q) do
		local t = {};
		local expl1 = g.string.Explode("`", v);
		for a, b in g.pairs(expl1) do
			local expl2 = g.string.Explode("=", b);
			if(expl2[1] and expl2[2]) then
				g.table.insert(t, {expl2[1], expl2[2]});
			end
		end
		SH.configs[k] = t;
		g.print("[SethHack] Loaded Config:", k);
	end
else
	local ge = "";
	for k, v in g.pairs(SH.cvars) do
		ge = ge .. v[1] .. "=" .. v[2] .. "`";
	end
	
	local t = {};
	t["Default"] = ge;
	SH.data.SetOptionTab("Configs", t);
	
	SH.configs["Default"] = tCopy(SH.cvars);
	g.print("[SethHack] Created initial Default config.");
end

--[[function SH:RegisterHook(name, func)
	SH.hooks[name] = func;
    hook.Add(name, SH.randomString(), func)
end]]

function SH:RegisterCommand(name, func)
	SH.cmds[name] = func;
    --concommand.Add(name, func)
end

function SH.sprint(...)
	g.print(...);
	if(g.IsValid(vConFrame)) then
		local txt = g.table.concat({...}, g.string.rep(" ", 5));
		g.table.insert(tConHistory, txt);
		vConHistory:AddLine(txt);
		vConHistory:PerformLayout();
		vConHistory.VBar:SetScroll(vConHistory.VBar.CanvasSize);
		vConEntry:SetText("");
	end
end

SH:RegisterCommand("bindy", function(ply, cmd, args)
	if(not args[1]) then SH.sprint("Bind requires a key (and an optional command!)"); return; end
	
	local key = "KEY_"..g.string.upper(args[1]);
	local cmd = args[2];
	
	if(not g[key]) then
		key = g.string.Replace(key, "KEY_", "");
		key = g.string.Replace(key, "MOUSE", "MOUSE_");
	end
	
	for k, v in g.pairs(SH.binds) do
		if(v == cmd) then
			SH.binds[k] = nil;
			
			local t = SH.data.GetOptionTab("Binds") or {};
			t[k] = nil;
			SH.data.SetOptionTab("Binds", t);
		end
	end
	
	if(not cmd) then
		if(SH.binds[key]) then
			SH.sprint("Key '"..key.."' is bound to '"..SH.binds[key].."'!");
		else
			SH.sprint("Key '"..key.."' is not bound!");
			SH.sprint("Are you trying to bind this key? You need to specify a command!");
		end
		return;
	end
	
	if(not g[key]) then SH.sprint("Key '"..key.."' is not a valid key!"); return; end
	if(not SH.cmds[cmd]) then SH.sprint("Command '"..cmd.."' is not a valid command!"); return; end
	
	SH.binds[key] = cmd;
	
	local t = SH.data.GetOptionTab("Binds") or {};
	t[key] = cmd;
	SH.data.SetOptionTab("Binds", t);
	
	SH.sprint("Bound '"..key.."' to '"..cmd.."'!");
end);

SH:RegisterCommand("ubind", function(ply, cmd, args)
	if(not args[1]) then SH.sprint("Unbind requires a key!"); return; end
	
	local key = "KEY_"..g.string.upper(args[1]);
	
	if(not g[key]) then
		key = g.string.Replace(key, "KEY_", "");
		key = g.string.Replace(key, "MOUSE", "MOUSE_");
	end
	
	if(not g[key]) then SH.sprint("Key '"..key.."' is not a valid key!"); return; end
	
	local t = SH.data.GetOptionTab("Binds") or {};
	t[key] = nil;
	SH.data.SetOptionTab("Binds", t);
	
	SH.sprint("Unbound '"..key.."'!");
end);

SH:RegisterCommand("sh_commands", function()
	for k, v in g.pairs(SH.cmds) do
		SH.sprint(k);
	end
end);

function SH.randomString(spshv)
	g.math.randomseed(g.CurTime());
	local ret = "";

	local len = g.math.random(5, 25);

	for i = 0, len do
		local ch = g.string.char(g.math.random(97, 122));
		ret = ret .. ch;
	end

	--[[if(not spshv) then
		ret = ret .. SH.CmdSuffix;
	end]]

	return not spshv and ret .. SH.CmdSuffix or ret;
end

SH.CmdSuffix = SH.randomString(true);

for k, v in g.pairs(SH.cvars) do
	local nn = SH.randomString();
	g.CreateClientConVar(nn, SH.data.GetOption(v[1]) or v[2], false, false);
	SH.tvars[v[1]] = {};
	SH.tvars[v[1]][1] = g.type(v[1]) == "number" and g.GetConVarNumber(nn) or g.GetConVarString(nn);
	SH.tvars[v[1]][2] = nn;

	g.cvars.AddChangeCallback(nn, function(cvar, old, new)
		if(g.string.len(new) >= 1 and new ~= " ") then
			if(g.IsValid(vConFrame)) then
				vConHistory:AddLine("Updated " .. v[1] .. " to " .. new);
				vConHistory:PerformLayout();
				vConHistory.VBar:SetScroll(vConHistory.VBar.CanvasSize);
				vConEntry:SetText("");
			end
			SH.tvars[v[1]][1] = new;
			SH.data.SetOption(v[1], new);
		end
	end);

	SH:RegisterCommand(v[1], function(ply, cmd, args)
		if(args[1]) then
			g.RunConsoleCommand(nn, args[1]);
		else
			SH.sprint(v[1], g.GetConVarNumber(nn));
		end
	end);

	SH:RegisterCommand(v[1].."_toggle", function(ply, cmd, args)
		local ret = SH.GetCVNum(v[1]);
		if(ret == 0) then
			g.RunConsoleCommand(nn, "1");
		else
			g.RunConsoleCommand(nn, "0");
		end
	end);
end

function SH.GetCVNum(cvar)
	local val;
    val = not SH.tvars[cvar] and 0 or SH.tvars[cvar][1];
	--if(not SH.tvars[cvar]) then val = 0; else val = SH.tvars[cvar][1]; end
	return g.tonumber(val or 0);
end

function SH.GetCVStr(cvar)
	local val;
    val = not SH.tvars[cvar] and "" or SH.tvars[1];
	--if(not SH.tvars[cvar]) then val = ""; else val = SH.tvars[cvar][1]; end
	return g.tostring(val or "");
end

SH:RegisterCommand("help", function()
	SH.sprint("Type 'sh_commands' for a list of SethHack commands.");
	SH.sprint("Type 'bind KEY COMMAND' to bind a key. Type 'unbind KEY' to unbind it.");
end);

if(SH.GetCVNum("sh_enabled") ~= 1) then
	g.concommand.Add("shenable" .. g.tostring(g.math.random(1111,9999)), function()
		g.RunConsoleCommand(SH.tvars["sh_enabled"][2], "1");
		--g.SH_PURECC("retry");
		RunConsoleCommand("retry");
	end);
	
	g.print("SH Disabled");
	return;
end

function SH:SetVar(var, val)
	SH.vars[var] = val;
end

function SH.Bunnyhop()
	if(SH.vars["bhop"] or (SH.GetCVNum("sh_bhop") == 1 and g.input.IsKeyDown(g.KEY_SPACE))) then
		if(me:OnGround()) then
			g.RunConsoleCommand("+jump");
			g.timer.Simple(.1, function() 
				g.RunConsoleCommand("-jump");
			end);
		end
	end
end

SH:RegisterCommand("+sh_bhop", function() SH:SetVar("bhop", true); end);
SH:RegisterCommand("-sh_bhop", function() SH:SetVar("bhop", false); end);
SH:RegisterCommand("sh_bhop_toggle", function() SH.vars.bhop = not SH.vars.bhop end);
hook.Add("Think", "bhop", SH.Bunnyhop);

hook.Add("Tick", "updateVars", function()
	g_ents = g.ents.GetAll();
	g_players = g.player.GetAll();
    g_playerCount = g.player.GetCount();
	
	if(_G.ulx and _G.ulx.gagUser) then
		if(SH.GetCVNum("sh_ulxungag") == 1) then
			_G.ulx.gagUser(false);
		end
	end
	
	for k, v in g.pairs(SH.traitors) do
		if(not g.IsValid(v)) then
			g.table.remove(SH.traitors, k);
		end
	end
	
	for k, v in g.pairs(SH.admins) do
		if(not g.IsValid(v) or not v:IsAdmin()) then
			g.table.remove(SH.admins, k);
		end
	end
	
	for k, v in g.pairs(SH.aimfriends) do
		if(not g.IsValid(v)) then
			g.table.remove(SH.aimfriends, k);
		end
	end
	
	for k, v in g.pairs(g_players) do
		if(g.IsValid(v:GetObserverTarget()) and v:GetObserverTarget():IsPlayer() and v:GetObserverTarget() == me) then
			if(not g.table.HasValue(SH.spect, v)) then
				g.table.insert(SH.spect, v);
				if(SH.GetCVNum("sh_showspectators") == 1) then
					g.chat.AddText(g.Color(100, 100, 100), 
						"[SethHack] ", g.Color(255, 10, 10), v:Nick() .. " is now spectating you!"
					);
					g.surface.PlaySound("buttons/blip1.wav");
				end
			end
		end
	end
	
	for k, v in g.pairs(SH.spect) do
		if(not g.IsValid(v) or not g.IsValid(v:GetObserverTarget()) or not v:GetObserverTarget():IsPlayer() or (v:GetObserverTarget() ~= me)) then
			g.table.remove(SH.spect, k);
			if(SH.GetCVNum("sh_showspectators") == 1) then
				g.chat.AddText(g.Color(100, 100, 100), 
					"[SethHack] ", g.Color(255, 10, 10), v:Nick() .. " is no longer spectating you!"
				);
			end
		end
	end
	
	if(_G.KARMA) then
		for k, v in g.ipairs(g_players) do
			if(v:Alive() and not g.table.HasValue(SH.traitors, v)) then
				for x, y in g.pairs(r.Player.GetWeapons(v)) do
					if(g.IsValid(y)) then
						if(y.CanBuy and g.table.HasValue(y.CanBuy, ROLE_TRAITOR)) then
							g.table.insert(SH.traitors, v);
							g.chat.AddText(g.Color(100, 100, 100), 
								"[SethHack] ", g.Color(255, 10, 10), v:Nick() .. " has traitor weapon " .. y:GetClass() .. "!"
							);
						end
					end
				end
			end
		end
	end
	
	if(SH.GetCVNum("sh_showadmins") == 1) then
		for k, v in g.ipairs(g_players) do
			if(v:IsAdmin() and not g.table.HasValue(SH.admins, v)) then
				g.table.insert(SH.admins, v);
				g.chat.AddText(g.Color(100, 100, 100), "[SethHack] ", g.Color(0, 255, 255), "Admin " .. v:Nick() .. " has joined!");
				g.surface.PlaySound("buttons/blip1.wav");
			end
		end
	end
	
	--[[if(SH.GetCVNum("sh_namechange") == 1) then
		if(g_playerCount > 1) then
			local pn = g.table.Random(g_players);
			if(pn ~= me:Nick()) then
				print("fuck daddy rebuild me");--g.SH_SETNAME(pn:Nick().. " ~");
			end
		end
	end]]
end);

SH:RegisterCommand("sh_print_traitors", function()
	SH.sprint("Traitors:");
	for k, v in g.pairs(SH.traitors) do
		SH.sprint("Name:", v:Nick());
	end
end);

function SH.BlowC4()
	if(not _G.KARMA) then
		g.chat.AddText(g.Color(100, 100, 100), "[SethHack] ", g.Color(0, 255, 255), "Gamemode does not appear to be TTT!");
		return;
	end
	
	if(_R.Player.IsTraitor and me:IsTraitor()) then
		g.chat.AddText(g.Color(100, 100, 100), "[SethHack] ", g.Color(0, 255, 255), "Cannot do this as traitor!");
		return;
	end
	
	for k, v in g.pairs(g.ents.FindByClass("ttt_c4")) do
		g.RunConsoleCommand("ttt_c4_disarm", v:EntIndex(), g.math.random(1000, 5000));
	end
	
	g.chat.AddText(g.Color(100, 100, 100), "[SethHack] ", g.Color(0, 255, 255), "Blown all C4!");
end

SH:RegisterCommand("sh_blowc4", SH.BlowC4);

SH.WFMat = g.CreateMaterial("SHWFMat", "Wireframe", {
	["$basetexture"] = "models/wireframe",
	["$ignorez"] = 1
});

SH.SLMat = g.CreateMaterial("SHSLMat", "UnlitGeneric", {
	["$basetexture"] = "models/debug/debugwhite",
	["$ignorez"] = 1
});

SH.ESPMat = g.Material("cable/redlaser");
SH.LZRMat = g.Material("sprites/bluelaser1");
SH.LZR2Mat = g.Material("Sprites/light_glow02_add_noz");

g.SetMaterialOverride = g.SetMaterialOverride or g.render.MaterialOverride;

function SH.Wallhack()
	if(SH.GetCVNum("sh_wallhack") ~= 1) then return; end
	
	g.cam.Start3D(g.EyePos(), g.EyeAngles())
		for k, v in g.ipairs(g_ents) do
			if(g.IsValid(v) and v ~= me) then
				local valid = ((v:IsPlayer() and v:Alive() and v:Health() > 0) or 
				(v:IsNPC() and v:GetMoveType() ~= 0) or 
				SH.custe[v:GetClass()] or v:IsWeapon());
				
				if(valid) then
					local dst = v:GetPos():Distance(me:GetPos());
					if(dst < SH.GetCVNum("sh_wallhack_dist")) then
						if(SH.GetCVNum("sh_wireframe") == 1 or SH.GetCVNum("sh_solids") == 1) then
							local col;
							if(v:IsPlayer()) then
								col = g.team.GetColor(v:Team());
								
								if(_G.KARMA and g.table.HasValue(SH.traitors, v)) then
									col = g.Color(255, 0, 0, 255);
								end
								
								if(SH.GetCVNum("sh_lasereyes") == 1) then
									g.render.SetMaterial(SH.ESPMat);
									
									local pos, ang = SH.GetShootPos(v);
									g.render.DrawBeam(pos, v:GetEyeTrace().HitPos, 5, 0, 0, col);
								end
								
								if(g.IsValid(v:GetEyeTrace().Entity) and v:GetEyeTrace().Entity == me) then
									print(v);
								end
							elseif(v:IsWeapon()) then
								col = g.Color(255, 25, 25, 255);
							else
								col = g.Color(25, 235, 25, 255);
							end
							
							g.SetMaterialOverride(SH.GetCVNum("sh_solids") == 1 and SH.SLMat or SH.WFMat);
							g.render.SetColorModulation(col.r / 255, col.g / 255, col.b / 255);
							g.render.SetBlend(col.a / 255);
							v:DrawModel();
							g.SetMaterialOverride(nil);
						else
							g.cam.IgnoreZ(true);
							v:DrawModel();
							g.cam.IgnoreZ(false);
						end
					end
				end
			end
		end
	g.cam.End3D();
end

function SH.LaserEyes()
	g.cam.Start3D(g.EyePos(), g.EyeAngles())
		if(SH.GetCVNum("sh_lasersights") == 1 and SH.GetCVNum("sh_thirdperson") == 0) then
			local vm = me:GetViewModel();
			if(vm and g.IsValid(me:GetActiveWeapon()) and g.IsValid(vm)) then
				if(me:GetActiveWeapon():GetClass() ~= "weapon_physgun") then
					local ai = vm:LookupAttachment("muzzle");
					if(ai == 0) then
						ai = vm:LookupAttachment("1");
					end
					
					local tr = g.util.TraceLine(util.GetPlayerTrace(me));
					if(vm:GetAttachment(ai)) then
						g.render.SetMaterial(SH.LZRMat);
						g.render.DrawBeam(vm:GetAttachment(ai).Pos, tr.HitPos, 4, 0, 12.5, g.Color(
						SH.GetCVNum("sh_color_lasersights_r"),
						SH.GetCVNum("sh_color_lasersights_g"),
						SH.GetCVNum("sh_color_lasersights_b"),
						SH.GetCVNum("sh_color_lasersights_a")));
						
						g.render.SetMaterial(SH.LZR2Mat);
						g.render.DrawQuadEasy(tr.HitPos, (g.EyePos() - tr.HitPos):GetNormal(), 25, 25, g.Color(
						SH.GetCVNum("sh_color_lasersights_point_r"),
						SH.GetCVNum("sh_color_lasersights_point_g"),
						SH.GetCVNum("sh_color_lasersights_point_b"),
						SH.GetCVNum("sh_color_lasersights_point_a")), 0)
					end
				end
			end
		end
	g.cam.End3D();
end

function SH.RSSE()
	SH.Wallhack();
	SH.LaserEyes();
end

hook.Add("RenderScreenspaceEffects", "SSE", SH.RSSE);

function SH.ESP()
	if(SH.GetCVNum("sh_esp") ~= 1) then return; end
	local ggn = "";
	g.surface.SetFont("sh_esp_font");
	for k, v in g.ipairs(g_ents) do
		if(g.IsValid(v) and (v:GetPos():Distance(me:GetPos()) < SH.GetCVNum("sh_esp_dist"))) then
			if(v:IsPlayer()) then
				if(g.IsValid(v) and v:Alive() and v ~= me) then
					if(v:Team() ~= g.TEAM_SPECTATOR and v:Team() ~= 1002) then
						local txt, rank, wep, dist, health, armor, gang = "", "", "", "", "", "", "";
						
						if(v:IsAdmin()) then rank = " - [A]"; end
						if(v:IsSuperAdmin()) then rank = " - [SA]"; end
						
						local col = g.team.GetColor(v:Team());
						
						if(g.IsValid(v:GetActiveWeapon())) then
							wep = g.string.gsub(v:GetActiveWeapon():GetPrintName(), "#HL2_", "");
							wep = g.string.gsub(wep, "#GMOD_", "");
						end
								
						health = " - " .. v:Health() .. "H";
						armor = "," .. v:Armor() .. "A";
						
						ggn = g.gmod.GetGamemode().Name;
						if(_G.KARMA) then
							if(g.table.HasValue(SH.traitors, v)) then
								col = g.Color(255, 0, 0, 255);
							end
						end
								
						if(SH.GetCVNum("sh_esp_showdist") == 1) then
							dist = " - " .. g.math.Round(v:GetPos():Distance(me:GetPos())) .. "D";
						end
								
						if(SH.GetCVNum("sh_esp_showgangs") == 1) then
							local gn = v:GetNWString("gang_name");
							if(gn and gn ~= "") then
								gang = gn .. " - ";
							end
						end
						
						txt = g.string.format("%s%s%s%s%s", gang, v:Nick(), rank, health, armor);
						wep = g.string.format("%s%s", wep, dist);
							
						local pos = v:EyePos():ToScreen();
						g.surface.SetTextColor(col);
						g.surface.SetTextPos(pos.x-30, pos.y-20);
						g.surface.DrawText(txt);
							
						g.surface.SetTextPos(pos.x-30, pos.y-8);
						g.surface.DrawText(wep);
					end
				end
			end
			for k, t in g.pairs(SH.custe) do
				if(g.IsValid(v) and v:GetClass() == k) then
					local pos = (v:GetPos() + g.Vector(0, 0, 50)):ToScreen();
					g.surface.SetTextColor(g.Color(SH.GetCVNum("sh_esp_col_r"), SH.GetCVNum("sh_esp_col_g"), SH.GetCVNum("sh_esp_col_b"), SH.GetCVNum("sh_esp_col_a")));
					g.surface.SetTextPos(pos.x-30, pos.y-8);
					g.surface.DrawText(k);		
				end
			end
		end
	end
	
	if(SH.vars.aim) then
		g.surface.SetFont("DermaDefault");
		
		g.surface.SetTextColor(not SH.vars.aimtarg and g.Color(255, 15, 15, 255) or g.Color(25, 255, 25, 255));
		
		local w,h = g.ScrW(), g.ScrH();
		g.surface.SetTextPos(w/2-28, h/2+15);
		
		g.surface.DrawText(not SH.vars.aimtarg and "Scanning..." or "Locked!");
	end
	
	if(SH.GetCVNum("sh_showadmins") == 1) then
		local offs = 30;
		local height = 30;
		
        local adminLen = #SH.admins
		for i = 1, adminLen do
			height = height + 15;
		end
		
		g.surface.SetDrawColor(g.Color(
		SH.GetCVNum("sh_color_adminlist_r"),
		SH.GetCVNum("sh_color_adminlist_g"),
		SH.GetCVNum("sh_color_adminlist_b"),
		SH.GetCVNum("sh_color_adminlist_a")));
		
		g.surface.DrawRect(g.ScrW()-185, g.ScrH()-g.ScrH()+5, 175, height);
		
		g.surface.SetTextColor(g.Color(255, 255, 255, 255));
		g.surface.SetTextPos(g.ScrW()-125, g.ScrH()-g.ScrH()+5);
		g.surface.SetFont("DermaDefault");
		g.surface.DrawText("ADMINS");
		
		g.surface.SetFont("DefaultFixedDropShadow");
		
		--for k, v in g.ipairs(SH.admins) do
        for i = 1, adminLen do
            local v = SH.admins[i]

			if not (g.IsValid(v)) then continue end
			local nick = v:Nick();
			nick = g.string.sub(nick, 0, 22);

            nick = v:IsAdmin() and not v:IsSuperAdmin() and nick .. "[A]" or nick .. "[SA]";
				--[[if(v:IsAdmin() and not v:IsSuperAdmin()) then
					nick = nick .. " [A]";
				else
					nick = nick .. " [SA]";
				end]]
				
			surface.SetTextPos(g.ScrW()-175, g.ScrH()-g.ScrH()+offs);
			surface.DrawText(nick);
			offs = offs+15;
		end
	end
	
	if(SH.GetCVNum("sh_showdruggy") == 1 and ggn and g.string.find(ggn, "PERP") or g.string.find(ggn, "agrp")) then
		g.surface.SetDrawColor(g.Color(25, 25, 25, 225));
		
		g.surface.DrawRect(g.ScrW()-g.ScrW()+15, g.ScrH()-g.ScrH()+5, 175, 60);
		
		g.surface.SetTextColor(g.Color(255, 255, 255, 255));
		g.surface.SetTextPos(g.ScrW()-g.ScrW()+55, g.ScrH()-g.ScrH()+5);
		g.surface.SetFont("DermaDefault");
		g.surface.DrawText("DRUG DEALER");
		
		g.surface.SetFont("DermaDefault");
		
		local buy = "None";
		local sell = "None";
		
		local buyi = g.GetGlobalInt("perp_druggy_buy", 0);
		local selli = g.GetGlobalInt("perp_druggy_sell", 0);
		
		if(g.string.find(ggn, "PERP2") or g.string.find(ggn, "PERP3") or g.string.find(ggn, "PERP4")) then
			if(buyi == 2) then
				buy = "Meth";
			elseif(buyi == 1) then
				buy = "Weed";
			elseif(buyi == 3) then
				buy = "Shrooms";
			end
		elseif(g.string.find(ggn, "agrp")) then
			if(buyi == 2) then
				buy = "Meth";
			elseif(buyi == 1) then
				buy = "Weed";
			elseif(buyi == 3) then
				buy = "Hulk";
			elseif(buyi == 4) then
				buy = "LSD";
			elseif(buyi == 5) then
				buy = "Shrooms";
			elseif(buyi == 6) then
				buy = "Cocaine";
			end
		else
			if(buyi == 2) then
				buy = "Weed";
			elseif(buyi == 3) then
				buy = "Shrooms";
			end
		end
		
		if(g.string.find(ggn, "agrp") or g.string.find(ggn, "PERP X2")) then
			if(selli == 1) then
				sell = "Seeds";
			elseif(selli == 2) then
				sell = "LSD";
			elseif(selli == 3) then
				sell = "Hulk";
			elseif(selli == 4) then
				sell = "Shrooms";
			elseif(selli == 5) then
				sell = "Cocaine";
			end
		else
			if(selli == 1) then
				sell = "Seeds";
			elseif(selli == 2) then
				sell = "Shrooms";
			end
		end
		
		surface.SetTextPos(g.ScrW()-g.ScrW()+25, g.ScrH()-g.ScrH()+30);
		surface.DrawText("Currently selling " .. sell);
		
		surface.SetTextPos(g.ScrW()-g.ScrW()+25, g.ScrH()-g.ScrH()+45);
		surface.DrawText("Currently buying  " .. buy);
	end
end
hook.Add("HUDPaint", "stuff", SH.ESP);

SH:RegisterCommand("sh_togglevar", function(ply, cmd, args)
	local cc = args[1];
	if(not cc) then
		SH.sprint("invalid format");
		return;
	end
	
	local cn = SH.tvars[cc];
	if(not cn) then
		SH.sprint("invalid cvar");
		return;
	end
	
	cn = cn[2];
	
	if(g.GetConVarNumber(cn) == 0) then
		g.RunConsoleCommand(cn, 1);
	else
		g.RunConsoleCommand(cn, 0);
	end
end)

-- Aimbot/Nospread/UCMD

SH.aimmodels = {
	["models/combine_scanner.mdl"] = "Scanner.Body",
	["models/hunter.mdl"] = "MiniStrider.body_joint",
	["models/combine_turrets/floor_turret.mdl"] = "Barrel",
	["models/dog.mdl"] = "Dog_Model.Eye",
	["models/antlion.mdl"] = "Antlion.Body_Bone",
	["models/antlion_guard.mdl"] = "Antlion_Guard.Body",
	["models/antlion_worker.mdl"] = "Antlion.Head_Bone",
	["models/zombie/fast_torso.mdl"] = "ValveBiped.HC_BodyCube",
	["models/zombie/fast.mdl"] = "ValveBiped.HC_BodyCube",
	["models/headcrabclassic.mdl"] = "HeadcrabClassic.SpineControl",
	["models/headcrabblack.mdl"] = "HCBlack.body",
	["models/headcrab.mdl"] = "HCFast.body",
	["models/zombie/poison.mdl"] = "ValveBiped.Headcrab_Cube1",
	["models/zombie/classic.mdl"] = "ValveBiped.HC_Body_Bone",
	["models/zombie/classic_torso.mdl"] = "ValveBiped.HC_Body_Bone",
	["models/zombie/zombie_soldier.mdl"] = "ValveBiped.HC_Body_Bone",
	["models/combine_strider.mdl"] = "Combine_Strider.Body_Bone",
	["models/lamarr.mdl"] = "HeadcrabClassic.SpineControl"
};

local CustomCones = {
	["#HL2_SMG1"] = g.Vector(-0.04362, -0.04362, -0.04362),
	["#HL2_Pistol"] = g.Vector(-0.0100, -0.0100, -0.0100),
	["#HL2_Pulse_Rifle"] = g.Vector(-0.02618, -0.02618, -0.02618),
	["#HL2_Shotgun"] = g.Vector( -0.08716, -0.08716, -0.08716 ),
};

function SH.PredictSpread(cmd, aimAngle)
	cmd2, seed = 0, 0--g.hl2_ucmd_getprediction(cmd)
	currentseed = 0, 0, 0;
	if(cmd2 ~= 0) then currentseed = seed; end
	wep = me:GetActiveWeapon();
	vecCone, valCone = g.Vector(0, 0, 0);
	if(g.IsValid(wep)) then
		if(wep.Base) then
			valCone = wep.Primary and wep.Primary.Cone or 0;
			if(g.tonumber(valCone)) then
				vecCone = g.Vector(-valCone, -valCone, -valCone);
			elseif(g.type(valCone) == "Vector") then
				vecCone = -1 * valCone;
			end
		else
			local pn = wep:GetPrintName();
			if(CustomCones[pn]) then vecCone = CustomCones[pn]; end
		end
	end
	return aimAngle--g.hl2_shotmanip(currentseed or 0, (aimAngle or me:GetAimVector():Angle()):Forward(), vecCone):Angle();
end

local ARTime;
function SH.Autoreload(uc)
	if(SH.GetCVNum("sh_autoreload") ~= 1) then return; end
	if(me:Alive() and g.IsValid(me:GetActiveWeapon())) then
		if(me:GetActiveWeapon():Clip1() <= 0) then
			if(not ARTime or ARTime < g.CurTime()) then
				g.RunConsoleCommand("+reload");
				ARTime = g.CurTime() + 5;
				timer.Simple(.2, function()
					g.RunConsoleCommand("-reload");
				end);
			end
		end
	end
end

function SH.GetShootPos(ent)
	if(SH.GetCVNum("sh_targetbones") ~= 1) then
		local eyes = ent:LookupAttachment("eyes");
		if(eyes ~= 0) then
			eyes = ent:GetAttachment(eyes);
			if(eyes and eyes.Pos) then
				return eyes.Pos, eyes.Ang;
			end
		end
	end
	
	local bname = SH.aimmodels[ent:GetModel()];
	if(not bname) then
		for k, v in g.pairs(SH.nicebones) do
			if(v[1] == SH.GetCVStr("sh_aimbone")) then
				bname = v[2];
			end
		end
		bname = bname or "ValveBiped.Bip01_Head1";
	end
	
	local bone = ent:LookupBone(bname);

	if(bone) then
		local pos, ang = ent:GetBonePosition(bone);
		return pos, ang;
	end
	
	return ent:LocalToWorld(ent:OBBCenter());
end

function SH.HasLOS(ent)
	if(SH.GetCVNum("sh_dclos") == 1) then return true; end
	local trace = {start = me:GetShootPos(), endpos = SH.GetShootPos(ent), filter = {me, ent}, mask = 1174421507};
	local tr = g.util.TraceLine(trace);
	return (tr.Fraction == 1);
end

function SH.CanShoot(ent)
	if(not g.IsValid(ent)) then return false; end
	if(me == ent) then return false; end
	if((not ent:IsPlayer() and not ent:IsNPC()) and SH.GetCVNum("sh_targetents") ~= 1) then return false; end
	if(not ent:IsPlayer() and not ent:IsNPC() and not SH.custe[ent:GetClass()]) then return false; end
	
	--if(g.SH_ISDORMANT(ent:EntIndex())) then return false; end
	if(ent:GetMoveType() == 0) then return false; end
	if(ent:IsPlayer() and not ent:Alive()) then return false; end
	if(ent:IsPlayer() and (ent:Team() == TEAM_SPECTATOR or ent:Team() == 1002)) then return false; end
	
	if(ent:IsPlayer() and ent:Health() <= 0) then return false; end
	if(ent:IsPlayer() and SH.GetCVNum("sh_targettraitors") == 1 and #SH.traitors > 0 and not g.table.HasValue(SH.traitors, ent)) then return false; end
	if(ent:IsPlayer() and ent:Team() == me:Team() and SH.GetCVNum("sh_friendlyfire") ~= 1) then return false; end
	if(ent:IsPlayer() and _R.Player.IsTraitor and ent:IsTraitor() and SH.GetCVNum("sh_ignoretraitors") == 1) then return false; end
	if(ent:IsPlayer() and SH.GetCVNum("sh_targetplayers") ~= 1) then return false; end
	if(ent:IsNPC() and SH.GetCVNum("sh_targetnpcs") ~= 1) then return false; end
	if(ent:IsPlayer() and SH.GetCVNum("sh_ignorefriends") == 1 and ent:GetFriendStatus() == "friend") then return false; end
	if(ent:IsPlayer() and (ent:IsAdmin() or ent:IsSuperAdmin()) and SH.GetCVNum("sh_ignoreadmins") == 1) then return false; end
	if(ent:IsPlayer() and SH.GetCVNum("sh_ignorenowep") == 1 and not g.IsValid(ent:GetActiveWeapon())) then return false; end
	
	local hv = g.table.HasValue(SH.aimfriends, ent);
	if(ent:IsPlayer() and SH.GetCVNum("sh_friendisenemy") == 1 and not hv) then return false; end
	if(ent:IsPlayer() and SH.GetCVNum("sh_friendisenemy") ~= 1 and hv) then return false; end
	
	hv = ent:IsPlayer() and g.table.HasValue(SH.aimteams, g.team.GetName(ent:Team())) or false;
	if(ent:IsPlayer() and SH.GetCVNum("sh_teamisenemy") == 1 and not hv) then return false; end
	if(ent:IsPlayer() and SH.GetCVNum("sh_teamisenemy") ~= 1 and hv) then return false; end
	
	local fov = SH.GetCVNum("sh_maxfov");
	if(fov ~= 180) then
		local lpang = me:GetAngles();
		local ang = (ent:GetPos() - me:GetPos()):Angle();
		local ady = g.math.abs(g.math.NormalizeAngle(lpang.y - ang.y))
		local adp = g.math.abs(g.math.NormalizeAngle(lpang.p - ang.p ))
		if(ady > fov or adp > fov) then return false; end
	end
	
	return true;
end

function SH.GetAimTarg()
	if(SH.CanShoot(SH.vars.aimtarg) and SH.HasLOS(SH.vars.aimtarg)) then 
		return SH.vars.aimtarg; 
	else 
		SH.vars.aimtarg = nil;
	end
	
	local position = me:EyePos();
	local angle = me:GetAimVector();
	local tar = {0, 0};
	local tab = (SH.GetCVNum("sh_targetnpcs") == 1 or SH.GetCVNum("sh_targetents") == 1) and g_ents or g_players;
	
	for k, v in g.ipairs(tab) do
		if(SH.CanShoot(v) and SH.HasLOS(v)) then
			local plypos = v:EyePos();
			local difr = (plypos - position):Normalize();
			difr = difr - angle;
			difr = difr:Length();
			difr = g.math.abs(difr);
			if(difr < tar[2] or tar[1] == 0) then
				tar = {v, difr};
			end	
		end
	end
	return tar[1];
end

function SH.Triggerbot(uc)
	if(SH.GetCVNum("sh_triggerbot") ~= 1) then return; end
	if(not me:Alive()) then return; end
	local ent = me:GetEyeTrace().Entity;
	
	if((SH.vars.tlock and SH.vars.aim and g.IsValid(SH.vars.aimtarg) and SH.HasLOS(SH.vars.aimtarg)) or 
	(SH.GetCVNum("sh_triggerbot_as") == 1 and g.IsValid(ent) and (ent:IsPlayer() or 
	ent:IsNPC()) and SH.CanShoot(ent))) then
		if(SH.vars.firing) then return; end
		g.RunConsoleCommand("+attack");
		SH:SetVar("firing",true);
		g.timer.Simple(me:GetActiveWeapon().Primary and me:GetActiveWeapon().Primary.Delay or 0.05, function()
			g.RunConsoleCommand("-attack");
			SH:SetVar("firing",false);
		end);
	end
end

SH:RegisterCommand("+sh_triggerbot", function()
	g.RunConsoleCommand("_sh_triggerbot", "1");
end);

SH:RegisterCommand("-sh_triggerbot", function()
	g.RunConsoleCommand("_sh_triggerbot", "0");
end);

SH:RegisterCommand("sh_addlookingent", function()
	local ent = me:GetEyeTrace().Entity;
	if(not IsValid(ent)) then return; end
	local v = ent:GetClass();
	
	SH.custe[v] = true;
	local t = SH.data.GetOptionTab("ESPEnts") or {};
	t[v] = true;
	SH.data.SetOptionTab("ESPEnts", t);
	
	me:ChatPrint("Added " .. v);
end);

function SH.Antisnap(ang)
	ang.p = g.math.NormalizeAngle(ang.p);
	ang.y = g.math.NormalizeAngle(ang.y);
	lpang = me:EyeAngles();
	local as = SH.GetCVNum("sh_antisnapspeed");
	lpang.p = g.math.Approach(lpang.p, ang.p, as)
	lpang.y = g.math.Approach(lpang.y, ang.y, as)
	lpang.r = 0;
	ang = lpang;
	return ang;
end

function SH.Aimbot(uc)
	if(not SH.vars.aim) then return; end

	if ( R.CUserCmd.CommandNumber(uc) == 0 ) then return; end
	
	local ply = SH.GetAimTarg();
	if(ply == 0) then SH.vars.tlock = false; SH:SetVar("aimang", nil); return; end
	SH:SetVar("aimtarg",ply);
	
	local pos, ang = SH.GetShootPos(ply);
	pos = pos + ply:GetVelocity()/50 - me:GetVelocity()/50 - g.Vector(0,0,0);
	
	pos = pos - g.Vector(SH.GetCVNum("sh_aimoffset_hoz"), 0, SH.GetCVNum("sh_aimoffset_vert"));
	
	ang = (pos-me:GetShootPos()):Angle();
	
	if(SH.GetCVNum("sh_antisnap") == 1) then
		ang = SH.Antisnap(ang);
	end
	
	SH:SetVar("aimang", ang);
	
	if(SH.GetCVNum("sh_nospread") == 1) then
		ang = SH.PredictSpread(uc, ang);
	end
	
	ang.p, ang.y, ang.r = g.math.NormalizeAngle(ang.p), g.math.NormalizeAngle(ang.y), g.math.NormalizeAngle(ang.r);
	
	SH:SetVar("tlock", true);
	
	R.CUserCmd.SetViewAngles(uc, ang);
end

SH:RegisterCommand("+sh_aim", function() SH:SetVar("aim",true); end);

SH:RegisterCommand("-sh_aim", function() 
	SH:SetVar("aim",false);
	SH:SetVar("aimtarg",nil);
	SH:SetVar("aimang", nil);
end);

SH:RegisterCommand("sh_toggleaim", function() 
	if(not SH.vars.aim) then
		SH:SetVar("aim",true);
	else
		SH:SetVar("aim",false);
		SH:SetVar("aimtarg",nil);
		SH:SetVar("aimang", nil);
	end
end);

function SH.ClientNoClipCM(uc)
	if(SH.GetCVNum("sh_clientnoclip") ~= 1) then return end
	uc:SetForwardMove(0);
	uc:SetSideMove(0);
	uc:SetUpMove(0);
end

function SH.CreateMove(uc)
	SH.Aimbot(uc);
	SH.Triggerbot(uc);
	SH.Autoreload(uc);
	SH.ClientNoClipCM(uc);
end

hook.Add("CreateMove", "", SH.CreateMove);

hook.Add("InputMouseApply", "why?", function(cmd, x, y, angle)
	if(SH.vars.tlock and SH.vars.aim) then return true; end
end);

--[[SH:RegisterHook("StartChat", function()
	SH.vars.chatting = true;
	return oldHookCall("StartChat", GAMEMODE or GM, nil);
end);

SH:RegisterHook("FinishChat", function()
	SH.vars.chatting = false;
end);]]

function SH.CalcView(ply, pos, angles, fov)
	if(g.IsValid(me:GetActiveWeapon()) and me:GetActiveWeapon().Primary and SH.GetCVNum("sh_norecoil") == 1) then
		me:GetActiveWeapon().Primary.Recoil = 0;
	end
	
	if(SH.GetCVNum("sh_disablecalcview") == 1) then
		return GAMEMODE:CalcView(ply, pos, angles, fov);
	end
	
	if(SH.GetCVNum("sh_clientnoclip") == 1 and SH.CP) then
		angles = angles:Forward();
		if(me:KeyDown(g.IN_FORWARD)) then
			local tr = g.util.TraceLine({start = SH.CP, endpos = SH.CP + angles * g.FrameTime() * SH.GetCVNum("sh_clientnoclip_speed"), mask = g.COLLISION_GROUP_WORLD});
			SH.CP = tr.HitPos;
		end
		if(me:KeyDown(g.IN_BACK)) then
			local tr = g.util.TraceLine({start = SH.CP, endpos = SH.CP + angles * g.FrameTime() * SH.GetCVNum("sh_clientnoclip_speed") * -1, mask = g.COLLISION_GROUP_WORLD});
			SH.CP = tr.HitPos;
		end
		if(me:KeyDown(g.IN_MOVELEFT)) then
			local tr = g.util.TraceLine({start = SH.CP, endpos = SH.CP + angles:Angle():Right() * g.FrameTime() * SH.GetCVNum("sh_clientnoclip_speed") * -1, mask = g.COLLISION_GROUP_WORLD});
			SH.CP = tr.HitPos;
		end
		if(me:KeyDown(g.IN_MOVERIGHT)) then
			local tr = g.util.TraceLine({start = SH.CP, endpos = SH.CP + angles:Angle():Right() * g.FrameTime() * SH.GetCVNum("sh_clientnoclip_speed"), mask = g.COLLISION_GROUP_WORLD});
			SH.CP = tr.HitPos;
		end
		
		return({origin = SH.CP});
	end
	
	if(SH.vars.aimang) then
		angles = SH.vars.aimang;
	end
	
	if(SH.GetCVNum("sh_thirdperson") == 1) then
		return({origin = pos - (angles:Forward() * (50 + SH.GetCVNum("sh_thirdperson_dist")))});
	end
	
	local cfov = SH.GetCVNum("sh_fov");
	if(cfov ~= 0) then
		return({fov = cfov});
	end
	
	return GAMEMODE:CalcView(ply, pos, angles, fov);
end
hook.Add("CalcView", "beenieweenies", SH.CalcView)

--[[this hook is outdated]]
--[[function SH.SDLP()
	return(SH.GetCVNum("sh_thirdperson") == 1);
end
SH:RegisterHook( "ShouldDrawLocalPlayer", SH.SDLP);]]

function SH.AddTracePlayer()
	local ent = me:GetEyeTrace().Entity;
	if(not g.IsValid(ent) or not ent:IsPlayer()) then return; end

	me:ChatPrint("Added/Removed " .. ent:Nick() .. " to friends!");
	
	if(not g.table.HasValue(SH.aimfriends, ent)) then
		g.table.insert(SH.aimfriends, ent);
		return;
	end
	
	for k, v in g.pairs(SH.aimfriends) do
		if(v == ent) then
			g.table.remove(SH.aimfriends, k);
			break
		end
	end
end
SH:RegisterCommand("sh_addtracebuddy", SH.AddTracePlayer);

--SH:RegisterCommand("sh_runscripts", g.SH_RUNSCRIPTS);

hook.Add("InitPostEntity", "Init", function()	
	SH.UpdateMenu();
	--g.SH_SETCVAR(g.CreateConVar("sv_allow_voice_from_file", ""), "1");
	for k, v in g.pairs(g.team.GetAllTeams()) do
		if(k ~= 0 and k ~= 1001 and k ~= 1002) then
			g.table.insert(SH.teamlist, v);
		end
	end
	
	if(SH.GetCVNum("sh_clientnoclip") == 1) then
		SH.CP = g.LocalPlayer():EyePos();
	end
	
	--[[if(SH.GetCVNum("sh_runscripts_auto") == 1) then
		--g.SH_RUNSCRIPTS();
		print("Rebuild me daddy!!1!!11!1!11");
	end]]
	
	--GAMEMODE.AchievementThink = function() end
end);

--[[g.cvars.AddChangeCallback(SH.tvars["sh_panicmode"][2], function(cvar, old, new)
	if(g.tostring(new) == "1") then
		if(menu.frame) then menu.frame:Remove(); menu.frame = nil; end
	end
end);

g.cvars.AddChangeCallback(SH.tvars["sh_clientnoclip"][2], function(cvar, old, new)
	if(g.tostring(new) == "1") then
		SH.CP = me:EyePos();
	else
		--g.SH_SUPPRESSIPLOGS(true);
		return NULL
	end
end);]]

SH:RegisterCommand("sh_addespent", function(ply, cmd, args)
	if(not args[1]) then
		SH.sprint("Usage: sh_addespent <entclass>");
		return;
	end
	
	local ent = args[1];	
	SH.custe[ent] = true;
	
	local t = SH.data.GetOptionTab("ESPEnts") or {};
	t[ent] = true;
	SH.data.SetOptionTab("ESPEnts", t);
	
	SH.sprint("Added entity to esp ents list!");
end);

SH:RegisterCommand("sh_forcecvar", function(ply, cmd, args)
	if(not args[2]) then return; end
	args[1] = "Fuck, rebuild me "
	args[2] = "big daddy!!1!111 "
	--g.SH_SETCVAR(g.GetConVar(args[1]), tostring(args[2]));
	SH.sprint("Forced " .. tostring(args[1]) .. " to " .. tostring(args[2]));
end);

SH:RegisterCommand("sh_blockcc", function(ply, cmd, args)
	if(not args[1]) then return; end
	g.table.insert(SH.blockccs, tostring(args[1]));
	SH.sprint("Blocked command " .. tostring(args[1]));
end);

SH:RegisterCommand("sh_allowcc", function(ply, cmd, args)
	if(not args[1]) then return; end
	
	if(not g.table.HasValue(SH.blockccs, tostring(args[1]))) then
		SH.sprint("Command " .. tostring(args[1]) .. " isn't blocked!");
	else
		for k, v in g.pairs(SH.blockccs) do
			if(v == tostring(args[1])) then
				g.table.remove(SH.blockccs, k);
			end
		end
		SH.sprint("Allowed command " .. tostring(args[1]));
	end
end);

SH:RegisterCommand("sh_clearccs", function(ply, cmd, args)
	SH.blockccs = {};
	SH.sprint("Removed all ConCommand blocks!");
end);

-- CUSTOM CONSOLE

function SH.ConAddEntry(txt)
	vConEntry:RequestFocus();
	if(g.string.len(txt) < 1) then return; end
	
	local args = g.string.Explode(" ", txt);
	local cmd = args[1];
	g.table.remove(args, 1);
	
	if(cmd == "sh_luarun") then
		args = {g.string.Replace(txt, "sh_luarun ", "")};
	end
	
	g.table.insert(tConHistory, "] "..txt);
	vConHistory:AddLine("] "..txt);
	
	if(not SH.cmds[cmd]) then
		local ucm = "Unknown command: " .. txt .. ". Type 'help' for a list of commands.";
		g.table.insert(tConHistory, ucm);
		vConHistory:AddLine(ucm);
	else
		SH.cmds[cmd](me, cmd, args);
	end
	
	vConHistory:PerformLayout();
	vConHistory.VBar:SetScroll(vConHistory.VBar.CanvasSize);
	vConEntry:SetText("");
end

function SH.ConToggle()
	vConFrame = vgui.Create("DFrame");
	vConFrame:SetSize(750, 500);
	vConFrame:SetPos(50, 50);
	vConFrame:SetTitle("SethHack Console");
	vConFrame:ShowCloseButton(true);
	vConFrame:MakePopup();

	function vConFrame:Think()
		if(g.input.IsKeyDown(g.KEY_ESCAPE)) then
			--g.SH_PURECC("cancelselect");
			g.RunConsoleCommand("cancelselect");
			self:Remove();
		end
	end
	
	vConHistory = vgui.Create("DListView", vConFrame);
	vConHistory:SetMultiSelect(false);
	vConHistory:SetSize(740, 440);
	vConHistory:SetPos(5, 27);
	vConHistory:SetSortable(false);
	vConHistory:AddColumn("");
	
	vConEntry = vgui.Create("DTextEntry", vConFrame);
	vConEntry:SetMultiline(false);
	vConEntry:SetSize(650, 20);
	vConEntry:SetPos(15, 472);
	
	function vConEntry:OnEnter()
		SH.vars.LastCommand = vConEntry:GetText();
		SH.ConAddEntry(vConEntry:GetText());
	end
	
	function vConEntry:Think()
		vConEntry:RequestFocus();
	end
	
	vConEnter = vgui.Create("DButton", vConFrame);
	vConEnter:SetSize(50, 20);
	vConEnter:SetPos(675, 472);
	vConEnter:SetText("Submit");
	function vConEnter:DoClick()
		SH.vars.LastCommand = vConEntry:GetText();
		SH.ConAddEntry(vConEntry:GetText());
	end
	
	for k, v in pairs(tConHistory) do 
		vConHistory:AddLine(v);
	end
end

SH.urbinds={};
SH.bindcooldown = {};
local togglecooldown;
hook.Add("DrawOverlay", "Console", function()
	if(not g.IsValid(vConFrame)) then
		if(g.input.IsKeyDown(g.KEY_Q) and (g.input.IsKeyDown(g.KEY_TAB) or g.input.IsKeyDown(g.KEY_LALT))) then
			if(not togglecooldown or togglecooldown < g.CurTime()) then
				SH.ConToggle();
				togglecooldown = g.CurTime() + 1;
			end
		end
	else
		if(g.input.IsKeyDown(g.KEY_Q) and (g.input.IsKeyDown(g.KEY_TAB) or g.input.IsKeyDown(g.KEY_LALT))) then
			if(not togglecooldown or togglecooldown < g.CurTime()) then
				if(g.IsValid(vConFrame)) then
					vConFrame:Remove();
					vConFrame = nil;
					togglecooldown = g.CurTime() + 1;
					return;
				end
			end
		end
		
		if(g.input.IsKeyDown(g.KEY_UP)) then
			if(SH.vars.LastCommand ~= "") then
				vConEntry:SetText(SH.vars.LastCommand);
				vConEntry:SetCaretPos(g.string.len(SH.vars.LastCommand));
			end
		end
		
		local arr = vConEntry:GetText();
		if(arr and g.string.len(arr) >= 1) then
			local cmdarr = {};
			for k, v in g.pairs(SH.cmds) do
				if(g.string.find(k, arr)) then
					g.table.insert(cmdarr, k);
				end
			end
			local pos = 560;
			for i = 1, 5 do
				if(cmdarr[i]) then
					for k, v in g.pairs(SH.cvars) do
						if(v[1] == cmdarr[i]) then
							if(g.type(v[1]) == "number") then	
								cmdarr[i] = cmdarr[i] .. "    ["..SH.GetCVNum(v[1]).."]";
							elseif(g.type(v[1]) == "string") then
								cmdarr[i] = cmdarr[i] .. "    ["..SH.GetCVStr(v[1]).."]";
							end
						end
					end
					g.draw.SimpleTextOutlined(cmdarr[i],
					"DermaDefault", 
					70, pos, 
					g.Color(255, 204, 102, 255), 
					g.TEXT_ALIGN_LEFT,
					g.TEXT_ALIGN_LEFT,
					1,
					g.Color(0, 0, 0, 255));
					pos = pos + 25;
				end
			end
		end
	end
	
	if(SH.vars.chatting) then return; end
	if(_G.openAura and _G.openAura.chatBox and _G.openAura.chatBox.panel and _G.openAura.chatBox.panel:IsVisible()) then return; end
	if(_G.blueprint and _G.blueprint.chatBox and _G.blueprint.chatBox.panel and _G.blueprint.chatBox.panel:IsVisible()) then return; end
	if(_G.blackbox and _G.blackbox.chatBox and _G.blackbox.chatBox.panel and _G.blackbox.chatBox.panel:IsVisible()) then return; end
	if(_G.STGamemodes and _G.STGamemodes.ChatBox and _G.STGamemodes.ChatBox.Panel and _G.STGamemodes.ChatBox.Panel:IsVisible()) then return; end
	if(_G.g_SpawnMenu and _G.g_SpawnMenu:IsVisible()) then return; end
	if(_G.g_ContextMenu and _G.g_ContextMenu:IsVisible()) then return; end
	if(_G.chaton) then return; end
	if(g.IsValid(vConFrame)) then return; end
	
	for k, v in g.pairs(SH.binds) do
		if((g.input.IsKeyDown(g[k]) or (g.string.find(k, "MOUSE") and g.input.IsMouseDown(g[k]))) and SH.cmds[v]) then
			if(not SH.urbinds[v] and (not SH.bindcooldown[v] or SH.bindcooldown[v] < g.CurTime())) then
				SH.cmds[v](me, v, {});
				if(g.string.sub(g.string.reverse(v), -1) == "+") then
					SH.urbinds[v] = true;
				else
					SH.bindcooldown[v] = g.CurTime() + 0.75;
				end
			end
		else
			if(SH.urbinds[v]) then
				if(g.string.sub(g.string.reverse(v), -1) == "+") then
					local nv = g.string.Replace(v, "+", "-");
					SH.cmds[nv](me, nv, {});
					SH.urbinds[v] = nil;
				end
			end
		end
	end
end);

-- END CUSTOM CONSOLE

-- MENU

local mwidth = 500;
local mheight = 435;
local SelectedWindow = "Aimbot";

local function fentsGetAll()
	local t = {};
	for k, v in g.ipairs(g_ents) do
		if(g.IsValid(v)) then
			if(not g.table.HasValue(t, v:GetClass())) then
				g.table.insert(t, v:GetClass());
			end
		end
	end
	return t;
end

function SH.CreateOption(dtype, parent, tooltip, o1, o2, o3, o4, o5, o6, o7, o8, o9)
	if(not parent) then return; end
	if(dtype == "Checkbox") then
		dtype = "DCheckBoxLabel";
		local text, cvar, x, y = o1, o2, o3, o4;
		local dele = vgui.Create(dtype, parent);
		dele:SetText(text);
		dele:SetConVar(SH.tvars[cvar][2]);
		dele:SetValue(SH.GetCVNum(cvar));
		dele:SetPos(x, y);
		dele:SizeToContents();
		dele:SetTextColor(g.color_white);
		if(tooltip ~= "") then
			dele:SetTooltip(tooltip);
		end
		
	elseif(dtype == "Slider") then
		dtype = "DNumSlider";
		local text, cvar, dec, min, max, wide, x, y = o1, o2, o3, o4, o5, o6, o7, o8;
		local dele = vgui.Create(dtype, parent);
		dele:SetPos(x, y);
		dele:SetWide(wide);
		dele:SetText(text);
		dele:SetMin(min);
		dele:SetMax(max);
		dele:SetDecimals(dec);
		dele:SetConVar(SH.tvars[cvar][2]);
		if(tooltip ~= "") then
			dele:SetTooltip(tooltip);
		end
	elseif(dtype == "Label") then
		dtype = "DLabel";
		local text, x, y = o1, o2, o3;
		local dele = vgui.Create(dtype, parent);
		dele:SetPos(x, y);
		dele:SetText(text);
		dele:SizeToContents();
		dele:SetTextColor(g.color_white);
	end
end

function SH.CreateButton(txt, szw, szh, psw, psh, parent, func)
	if(not parent) then return; end
	
	local button = vgui.Create("DButton", parent);
	button:SetText(txt);
	button:SetSize(szw, szh);
	button:SetPos(psw, psh);
	button:SetVisible(true);
	function button:Paint()
		g.draw.RoundedBox(8, 0, 0, self:GetWide(), self:GetTall(), Color(104, 104, 104, 225));
	end
	button.DoClick = func or function()
		SelectedWindow = txt;
		SH.Menu();
		g.surface.PlaySound("ambient/levels/canals/drip4.wav");
	end
	
	local panel;
	if(txt == SelectedWindow) then
		panel = vgui.Create("DPanel", menu.frame);
		panel:SetPos(135,85);
		panel:SetSize(345,335);
		function panel:Paint() end
	end
	
	return button, panel;
end

local SKIN = g.setmetatable({}, {
	__index = function(t, k)
		return derma.GetDefaultSkin()[k];
	end,
});

function SKIN:PaintCheckBox(panel)
	local w, h = panel:GetSize();
	draw.RoundedBox(4, 1, 1, w-2, h-2, g.Color(210, 210, 210, 205));
end

function SKIN:SchemeCheckBox(panel)
	panel:SetTextColor(g.Color(0, 85, 255, 255));
	DButton.ApplySchemeSettings(panel); --DSyS
end

function SKIN:SchemeSlider(panel)
	panel.Knob:SetImageColor(g.Color(0, 85, 255, 255));
end

g.surface.CreateFont( "shmenufont", {
    font = "coolvetica",
    size = 64,
    weight = 500,
    antialias = true,
    outline = true,
} )

g.surface.CreateFont( "sh_esp_font", {
    font = "coolvetica",
    size = 64,
    weight = 500,
    antialias = true,
    outline = true,
} )

function SH.Menu()
	if(menu.frame) then menu.frame:Remove(); end
	
	menu.frame = vgui.Create("DFrame");
	menu.frame:SetPos(g.ScrW()/2-184, g.ScrH()/2-155);
	menu.frame:SetSize(mwidth, mheight);
	menu.frame:SetTitle("");
	menu.frame:SetVisible(true);
	menu.frame:SetDraggable(false);
	menu.frame:SetSizable(false);
	menu.frame:ShowCloseButton(false);
	menu.frame:MakePopup();
	
	function menu.frame:GetSkin()
		return SKIN;
	end
	
	function menu.frame:Paint()
		g.draw.RoundedBox(7, 0, 0, self:GetWide(), self:GetTall(), --[[g.Color(
		SH.GetCVNum("sh_color_menu_r"),
		SH.GetCVNum("sh_color_menu_g"),
		SH.GetCVNum("sh_color_menu_b"),
		SH.GetCVNum("sh_color_menu_a"))]] g.Color(0,0,0,225));
		
		g.draw.SimpleText("SethHack", "shmenufont", 215, 10, g.Color(210, 210, 210, 235), TEXT_ALIGN_CENTER);
		g.draw.SimpleText("V4", "shmenufont", 365, 10, g.Color(0, 192, 255, 235), TEXT_ALIGN_CENTER);
		g.draw.SimpleText("sethhack.net", "DermaDefault", 355, 60, g.Color(210, 210, 210, 235), TEXT_ALIGN_CENTER);
	end
	
	menu.aimbutton, menu.aimpanel = SH.CreateButton("Aimbot", 75, 20, 15, 85, menu.frame);
	menu.friendsbutton, menu.friendspanel = SH.CreateButton("Friends", 75, 20, 15, 125, menu.frame);
	menu.teamsbutton, menu.teamspanel = SH.CreateButton("Teams", 75, 20, 15, 165, menu.frame);
	menu.custebutton, menu.custepanel = SH.CreateButton("Custom Ents", 75, 20, 15, 205, menu.frame);
	menu.espbutton, menu.esppanel = SH.CreateButton("ESP/Wallhack", 75, 20, 15, 245, menu.frame);
	menu.miscbutton, menu.miscpanel = SH.CreateButton("Misc", 75, 20, 15, 285, menu.frame);
	menu.configbutton, menu.configpanel = SH.CreateButton("Configurations", 75, 20, 15, 325, menu.frame);
	menu.iplogbutton, menu.iplogpanel = SH.CreateButton("IP Logs (x)", 75, 20, 15, 365, menu.frame);
	menu.loggerbutton, menu.loggerpanel = SH.CreateButton("Logger", 75, 20, 15, 405, menu.frame);
	
	SH.CreateOption("Checkbox", menu.aimpanel, "Automatically fires when locked on to an enemy", "Triggerbot", "sh_triggerbot", 0, 0);
	SH.CreateOption("Checkbox", menu.aimpanel, 
	"Automatically fires when looking at an enemy (does not require aimbot)", 
	"Triggerbot (Always Shoot)", "sh_triggerbot_as", 0, 20);
	SH.CreateOption("Checkbox", menu.aimpanel, "Predicts the spread on weapons, making them more accurate", "Nospread", "sh_nospread", 0, 40);
	SH.CreateOption("Checkbox", menu.aimpanel, "Smoothly turns your aim to face the target", "Antisnap", "sh_antisnap", 0, 60);
	SH.CreateOption("Checkbox", menu.aimpanel, "Allows the aimbot to target members of your team", "Friendly Fire", "sh_friendlyfire", 0, 80);
	SH.CreateOption("Checkbox", menu.aimpanel, "Allows the aimbot to target players", "Target Players", "sh_targetplayers", 0, 100);
	SH.CreateOption("Checkbox", menu.aimpanel, "Allows the aimbot to target NPCs", "Target NPCs", "sh_targetnpcs", 0, 120);
	SH.CreateOption("Checkbox", menu.aimpanel, "Allows the aimbot to target custom entities on the ESP Entities list", "Target Entities", "sh_targetents", 0, 140);
	SH.CreateOption("Checkbox", menu.aimpanel, "Stops the aimbot from targetting Steam friends", "Ignore Steam Friends", "sh_ignorefriends", 0, 160);
	SH.CreateOption("Checkbox", menu.aimpanel, "Do not target players who don't have a weapon", "Ignore Weaponless Players", "sh_ignorenowep", 0, 180);
	SH.CreateOption("Checkbox", menu.aimpanel, "Allows the aimbot to target people through walls and other objects", "Don't check LOS", "sh_dclos", 0, 200);
	SH.CreateOption("Checkbox", menu.aimpanel, "Forces the aimbot to target bones instead of attachments. Required for bone selection.", "Target Bones", "sh_targetbones", 0, 220);
	SH.CreateOption("Checkbox", menu.aimpanel, "Aimbot ignores admins/superadmins.", "Ignore Admins", "sh_ignoreadmins", 0, 240);
	
	SH.CreateOption("Checkbox", menu.aimpanel, "Do not target other traitors (if you're a traitor)", "Ignore Traitors (TTT)", "sh_ignoretraitors", 185, 0);
	SH.CreateOption("Checkbox", menu.aimpanel, "Do not target other innocents (if you're innocent)", "Ignore Innocents (TTT)", "sh_targettraitors", 185, 20);
	
	SH.CreateOption("Slider", menu.aimpanel, "Targets a certain amount left/right from the target's head", "Aim Offset (Hrzntl.)", "sh_aimoffset_hoz", 1, -50, 50, 150, 180, 165);
	SH.CreateOption("Slider", menu.aimpanel, "Targets a certain amount down from the target's head", "Aim Offset (Vertical)", "sh_aimoffset_vert", 1, -50, 50, 150, 180, 205);
	SH.CreateOption("Slider", menu.aimpanel, "Controls how far around your aimbot can target people (degrees)", "Max FOV", "sh_maxfov", 0, 1, 180, 150, 180, 245);
	SH.CreateOption("Slider", menu.aimpanel, "Controls the speed of the Antisnap", "Antisnap Speed", "sh_antisnapspeed", 1, 0, 20, 150, 180, 285);
	
	SH.CreateOption("Label", menu.aimpanel, nil, "Bone:", 46, 285);
	
	SH.CreateOption("Label", menu.friendspanel, nil, "Players", 30, 0);
	SH.CreateOption("Label", menu.friendspanel, nil, "Friends", 250, 0);
	
	SH.CreateOption("Label", menu.teamspanel, nil, "Teams", 25, 0);
	SH.CreateOption("Label", menu.teamspanel, nil, "Whitelist", 250, 0);
	
	SH.CreateOption("Label", menu.custepanel, nil, "Entities", 25, 0);
	SH.CreateOption("Label", menu.custepanel, nil, "List", 250, 0);
	
	SH.CreateOption("Checkbox", menu.esppanel, "Show player's name, health, weapon, and more above their head", "ESP", "sh_esp", 0, 0);
	SH.CreateOption("Checkbox", menu.esppanel, "Allows you to see players and NPCs through walls and other objects", "Wallhack", "sh_wallhack", 0, 20);
	SH.CreateOption("Checkbox", menu.esppanel, "Turns players, props, weapons, and more into wireframe", "Wireframe Chams", "sh_wireframe", 0, 40);
	SH.CreateOption("Checkbox", menu.esppanel, "Turns players, props, weapons, and more into solid chams", "Solid Chams", "sh_solids", 0, 60);
	SH.CreateOption("Checkbox", menu.esppanel, "Shows a list of admins and superadmins in the top right of the screen", "Show Admins", "sh_showadmins", 0, 80);
	SH.CreateOption("Checkbox", menu.esppanel, "Shows a list of what the drug dealer is current buying/selling in the top left of the screen", "Show Druggy Stock (PERP)", "sh_showdruggy", 0, 100);
	SH.CreateOption("Checkbox", menu.esppanel, "Shows a players distance on the esp", "Show Distance", "sh_esp_showdist", 0, 120);
	SH.CreateOption("Checkbox", menu.esppanel, "Shows players GangWars gangs", "Show GangWars Gangs", "sh_esp_showgangs", 0, 140);
	SH.CreateOption("Checkbox", menu.esppanel, "Shows a laser eye trace to player's view positions", "Laser Eyes", "sh_lasereyes", 0, 160);
	SH.CreateOption("Checkbox", menu.esppanel, "Shows a laser eye trace from your weapon to your hit position", "Laser Sights", "sh_lasersights", 0, 180);
	
	SH.CreateOption("Slider", menu.esppanel, "The maximum distance that players can be for the ESP to show them",
	"Max ESP Dist", "sh_esp_dist", 0, 1, 25000, 150, 180, 245);
	SH.CreateOption("Slider", menu.esppanel, "The maximum distance that players can be for the Wallhack to show them", 
	"Max Wallhack Dist", "sh_wallhack_dist", 0, 1, 25000, 150, 180, 285);
	
	SH.CreateOption("Checkbox", menu.miscpanel, "Automatically reloads your weapon when you have no ammo", "Autoreload", "sh_autoreload", 0, 0);
	SH.CreateOption("Checkbox", menu.miscpanel, "Blocks RunConsoleCommand and :ConCommand() from being used", "Block RunConsoleCommand", "sh_blockrcc", 0, 20);
	SH.CreateOption("Checkbox", menu.miscpanel, "Puts your view into thirdperson mode", "Thirdperson", "sh_thirdperson", 0, 40);
	SH.CreateOption("Checkbox", menu.miscpanel, "Logs functions such as RunConsoleCommand and file.Exists", "Console Logging", "sh_logging_console", 0, 60);
	SH.CreateOption("Checkbox", menu.miscpanel, "Disables custom view", "Disable CalcView", "sh_disablecalcview", 0, 80);
	SH.CreateOption("Checkbox", menu.miscpanel, "Bypass ULX's gag (voicemute) system", "Bypass ULX Gag", "sh_ulxungag", 0, 100);
	SH.CreateOption("Checkbox", menu.miscpanel, "Turn off every single SethHack feature", "Panic Mode", "sh_panicmode", 0, 120);
	SH.CreateOption("Checkbox", menu.miscpanel, "Disable recoil for weapons. Needs a respawn to disable.", "No-Recoil", "sh_norecoil", 0, 140);
	SH.CreateOption("Checkbox", menu.miscpanel, "Randomly change your name to that of other players.", "Name-Changer", "sh_namechange", 0, 160);
	SH.CreateOption("Checkbox", menu.miscpanel, "Jump the moment you touch the ground if you are holding space", "Bunnyhop", "sh_bhop", 0, 180);
	SH.CreateOption("Checkbox", menu.miscpanel, "Shows connecting player's IP in your console (Dead Feature)", "IP Logging(x)", "sh_iplogs", 0, 200);
	SH.CreateOption("Checkbox", menu.miscpanel, "Enables a clientside noclip", "Client Noclip", "sh_clientnoclip", 0, 220);
	SH.CreateOption("Checkbox", menu.miscpanel, "Prints into chatbox when an admin spectates you!", "Show Spectators", "sh_showspectators", 0, 240);
	
	SH.CreateOption("Slider", menu.miscpanel, "Speed of the clientside noclip", "Client Noclip Speed", "sh_clientnoclip_speed", 0, 200, 2000, 150, 180, 165);
	SH.CreateOption("Slider", menu.miscpanel, "Your view's field-of-view (FOV). Set to 0 to disable", "Field-Of-View", "sh_fov", 0, 0, 90, 150, 180, 205);
	SH.CreateOption("Slider", menu.miscpanel,
	"The distance that the thirdperson camera is from yourself",
	"Thirdperson Distance", "sh_thirdperson_dist", 0, 0, 200, 150, 180, 245);
	SH.CreateOption("Slider", menu.miscpanel, "The speed of the speedhack", "Speedhack Speed", "sh_speedhack_speed", 2, 1, 25, 150, 180, 285);
	
	SH.CreateButton("Blow C4s (TTT)", 85, 20, 0, 290, menu.miscpanel, SH.BlowC4);
	
	SH.CreateOption("Checkbox", menu.friendspanel, "Makes the friends list an enemy list", "Friends List is Enemy List", "sh_friendisenemy", 95, 255);
	SH.CreateOption("Checkbox", menu.teamspanel, "Makes the teams list an enemy list", "Teams List is Enemy List", "sh_teamisenemy", 95, 255);
	
	SH.CreateOption("Label", menu.configpanel, nil, [[
		Custom configurations allow you to save all SethHack settings
		under a specified name, and restore the exact same settings
		at a later time!]], 5, 260);
		
	SH.CreateOption("Label", menu.friendspanel, nil, [[
		Players added to the friends list will not be targetted
		by the aimbot. If the above box is checked, only players
		on this list will be targetted.]], 15, 280);
		
	SH.CreateOption("Label", menu.teamspanel, nil, [[
		Players on teams added to the friends list will not be
		targetted by the aimbot. If the above box is checked,
		only players on teams on this list will be targetted.]], 15, 280);
		
	SH.CreateOption("Label", menu.custepanel, nil, [[
		Entities added to this list will be shown on the ESP.]], 15, 290);
		
	if(menu.aimpanel) then
		local List = vgui.Create("DComboBox", menu.aimpanel);
		List:SetPos(0, 300);
		List:SetSize(125, 20);
		
		for k, v in g.pairs(SH.nicebones) do
			List:AddChoice(v[1]);
		end
		
		List:SetConVar(SH.tvars["sh_aimbone"][2]);

		--g.timer.Simple(0.01, function()
		--List:SetValue(SH.GetCVStr("sh_aimbone"));
		--end);
		--List:SetEditable(false);
	end
	
	local FriendsList, TeamList, EntsList;
	
	local CloseButton = vgui.Create("DButton", menu.frame);
	--CloseButton:SetType("close");
	CloseButton:SetPos(481, 2);
	CloseButton:SetSize(15, 15);
	CloseButton.DoClick = function() if(menu.frame) then menu.frame:Remove(); menu.frame = nil; end end;
	
	if(menu.friendspanel) then
		--[[ Friends List --]]
		local FriendsList;
		local function FList()
			FriendsList = vgui.Create("DComboBox", menu.friendspanel)
			FriendsList:SetPos(0, 25);
			FriendsList:SetSize(110, 180);
			--FriendsList:SetMultiple(false);
			for k, v in g.pairs(g_players) do
				if(v ~= me and not g.table.HasValue(SH.aimfriends, v)) then
					FriendsList:AddChoice(v:Nick());
					--i:SetTooltip(v:Nick());
				end
			end
		end
		FList();
		
		local FriendsListC;
		local function FListC()
			FriendsListC = vgui.Create("DComboBox", menu.friendspanel);
			FriendsListC:SetPos(225, 25);
			FriendsListC:SetSize(110, 180);
			--FriendsListC:SetMultiple(false);
			for k, v in g.pairs(SH.aimfriends) do
				FriendsListC:AddChoice(v:Nick());
				--i:SetTooltip(v:Nick());
			end	
		end
		FListC()
		
		local FriendsListAdd = vgui.Create("DButton", menu.friendspanel);
		FriendsListAdd:SetPos(20, 215);
		FriendsListAdd:SetText("Add");
		FriendsListAdd.DoClick = function()
			if(FriendsList:GetSelectedItems() and FriendsList:GetSelectedItems()[1]) then
				for k, v in g.pairs(g_players) do
					if(v:Nick() == FriendsList:GetSelectedItems()[1]:GetValue()) then
						g.table.insert(SH.aimfriends, v);
						me:ChatPrint("Added " .. v:Nick());
					end	
				end	
			end
			FList();
			FListC();
		end
			
		local FriendsListRem = vgui.Create("DButton", menu.friendspanel);
		FriendsListRem:SetPos(240, 215);
		FriendsListRem:SetText("Remove");
		FriendsListRem.DoClick = function()
			if(FriendsListC:GetSelectedItems() and FriendsListC:GetSelectedItems()[1]) then
				for k, v in g.pairs(SH.aimfriends) do 
					if(v:Nick() == FriendsListC:GetSelectedItems()[1]:GetValue()) then
						g.table.remove(SH.aimfriends, k);
						me:ChatPrint("Removed " .. v:Nick());
					end	
				end
			end
			FListC();
			FList();
		end
	end
	
	if(menu.teamspanel) then
		local function TList()
			TeamList = vgui.Create("DComboBox", menu.teamspanel);
			TeamList:SetPos(0, 25);
			TeamList:SetSize(110, 180);
			--TeamList:SetMultiple(false);
			for k, v in g.pairs(SH.teamlist) do
				if(not g.table.HasValue(SH.aimteams,v.Name)) then
					TeamList:AddChoice(v.Name);
					--i:SetTooltip(v.Name);
				end	
			end
		end
		TList()
		
		local TeamListC
		local function TListC()
			TeamListC = vgui.Create("DComboBox", menu.teamspanel);
			TeamListC:SetPos(225, 25);
			TeamListC:SetSize(110, 180);
			--TeamListC:SetMultiple(false);
			for k, v in g.pairs(SH.aimteams) do
				TeamListC:AddChoice(v);
				--i:SetTooltip(v);
			end
		end
			
		TListC();
			
		local TeamListAdd = vgui.Create("DButton", menu.teamspanel);
		TeamListAdd:SetPos(20, 215);
		TeamListAdd:SetText("Add");
		TeamListAdd.DoClick = function()
			if(TeamList:GetSelectedItems() and TeamList:GetSelectedItems()[1]) then
				for k, v in g.pairs(SH.teamlist) do 
					if(v.Name == TeamList:GetSelectedItems()[1]:GetValue()) then
						g.table.insert(SH.aimteams, v.Name);
						me:ChatPrint("Added " .. v.Name);
					end	
				end	
			end
			TList();
			TListC();
		end
			
		local TeamListRem = vgui.Create("DButton", menu.teamspanel);
		TeamListRem:SetPos(240, 215);
		TeamListRem:SetText("Remove");
		TeamListRem.DoClick = function()
			if(TeamListC:GetSelectedItems() and TeamListC:GetSelectedItems()[1]) then
				for k, v in g.pairs(SH.aimteams) do 
					if(v == TeamListC:GetSelectedItems()[1]:GetValue()) then
						table.remove(SH.aimteams, k );
						me:ChatPrint("Removed " .. v);
					end
				end	
			end
			TListC();
			TList();
		end
	end
	
	if(menu.custepanel) then
		local function EList()
			EntsList = vgui.Create("DListView", menu.custepanel)			
			EntsList:SetPos(0, 25);
			EntsList:SetSize(110, 180);
			EntsList:SetMultiSelect(false);
			for k, v in g.pairs(fentsGetAll()) do
				if(not SH.custe[v]) then
					local i = EntsList:AddLine(v);
					i:SetTooltip(v);
				end
			end
		end
		EList();
		
		local EntsListC;
		local function EListC()
			EntsListC = vgui.Create("DListView", menu.custepanel);
			EntsListC:SetPos(225, 25);
			EntsListC:SetSize(110, 180);
			EntsList:SetMultiSelect(false);
			for k, v in g.pairs(SH.custe) do
				local i = EntsListC:AddLine(k);
				i:SetTooltip(k);
			end
		end
		
		EListC();
		
		local EntsListAdd = vgui.Create("DButton", menu.custepanel);
		EntsListAdd:SetPos(20, 215);
		EntsListAdd:SetText("Add");
		EntsListAdd.DoClick = function()
			if(EntsList:GetSelected() and EntsList:GetSelected()[1]) then
				for k, v in g.pairs(fentsGetAll()) do 
					if(v == EntsList:GetSelected()[1]:GetValue()) then
						SH.custe[v] = true;
						
						local t = SH.data.GetOptionTab("ESPEnts") or {};
						t[v] = true;
						SH.data.SetOptionTab("ESPEnts", t);
						
						me:ChatPrint("Added " .. v);
					end	
				end	
			end
			EList();
			EListC();
		end
			
		local EntsListRem = vgui.Create("DButton", menu.custepanel);
		EntsListRem:SetPos(240, 215);
		EntsListRem:SetText("Remove");
		EntsListRem.DoClick = function()
			if(EntsListC:GetSelectedItems() and EntsListC:GetSelectedItems()[1]) then
				for k, v in g.pairs(SH.custe) do 
					if(k == EntsListC:GetSelectedItems()[1]:GetValue()) then
						SH.custe[k] = nil;
						
						local t = SH.data.GetOptionTab("ESPEnts") or {};
						t[k] = nil;
						SH.data.SetOptionTab("ESPEnts", t);
						
						me:ChatPrint("Removed " .. k);
					end
				end
			end
			EListC();
			EList();
		end
		
		local EntsListClr = vgui.Create("DButton", menu.custepanel);
		EntsListClr:SetPos(135, 145);
		EntsListClr:SetText("Clear");
		EntsListClr.DoClick = function()
			SH.custe = {};
			SH.data.SetOptionTab("ESPEnts", SH.custe);
			EListC();
			EList();
		end
	end
	
	if(menu.configpanel) then
		local ConfigList;
		local function CList()
			ConfigList = vgui.Create("DComboBox", menu.configpanel)
			ConfigList:SetPos(0, 25);
			ConfigList:SetSize(305, 175);
			--ConfigList:SetMultiple(false);
			for k, v in g.pairs(SH.configs) do
				ConfigList:AddChoice(k);
			end
		end
		CList();
		
		local ConfigListUse = vgui.Create("DButton", menu.configpanel);
		ConfigListUse:SetPos(5, 215);
		ConfigListUse:SetSize(85, 20);
		ConfigListUse:SetText("Use Selected");
		ConfigListUse.DoClick = function()
			if(ConfigList:GetSelectedItems() and ConfigList:GetSelectedItems()[1]) then
				local txt = ConfigList:GetSelectedItems()[1]:GetText();
				if(SH.configs[txt]) then
					for k, v in g.pairs(SH.configs[txt]) do
						if(SH.tvars[v[1]] and SH.tvars[v[1]][2]) then
							g.RunConsoleCommand(SH.tvars[v[1]][2], v[2]);
						end
					end
					me:ChatPrint("Enabled " .. txt .. " config!");
				end
			end
		end
		
		local ConfigListDelete = vgui.Create("DButton", menu.configpanel);
		ConfigListDelete:SetPos(110, 215);
		ConfigListDelete:SetSize(85, 20);
		ConfigListDelete:SetText("Delete Selected");
		ConfigListDelete.DoClick = function()
			if(ConfigList:GetSelectedItems() and ConfigList:GetSelectedItems()[1]) then
				local txt = ConfigList:GetSelectedItems()[1]:GetText();
				if(txt == "Default") then
					me:ChatPrint("You can't delete the default configuration!");
					return;
				end
				
				local t = SH.data.GetOptionTab("Configs") or {};
				t[txt] = nil;
				SH.data.SetOptionTab("Configs", t);
				
				SH.configs[txt] = nil;
				me:ChatPrint("Deleted config " .. txt);
				CList();
			end
		end
		
		local ConfigListSave = vgui.Create("DButton", menu.configpanel);
		ConfigListSave:SetPos(215, 215);
		ConfigListSave:SetSize(85, 20);
		ConfigListSave:SetText("Save Current");
		ConfigListSave.DoClick = function()
			g.gui.EnableScreenClicker(true);
			SH.vars.chatting = true;
			g.Derma_StringRequest("Config Name", "Enter a name for this configuration.",
			((ConfigList:GetSelectedItems() and ConfigList:GetSelectedItems()[1]) and ConfigList:GetSelectedItems()[1]:GetText()) or "",
			function(n)
				g.gui.EnableScreenClicker(false);
				SH.vars.chatting = false;
				
				if(not n or g.string.len(n) < 2) then
					me:ChatPrint("Please enter a config name!");
					return;
				end
				
				local ge = "";
				for k, v in g.pairs(SH.tvars) do
					ge = ge .. k .. "=" .. v[1] .. "`";
				end
				
				local t = SH.data.GetOptionTab("Configs") or {};
				t[n] = ge;
				SH.data.SetOptionTab("Configs", t);
				
				local t = {};
				for k, v in g.pairs(SH.tvars) do
					g.table.insert(t, {k, v[1]});
				end
				SH.configs[n] = t;
				me:ChatPrint("Saved config " .. n);
				CList();
			end, function() g.gui.EnableScreenClicker(false); SH.vars.chatting = false; end, "Submit", "Cancel");
		end
	end
	
	if(menu.loggerpanel) then
		local FnLogList = vgui.Create("DListView", menu.loggerpanel);
		FnLogList:SetPos(0, 25);
		FnLogList:SetSize(305, 300);
		FnLogList:SetMultiSelect(false);
		local ColTime = FnLogList:AddColumn("Time");
		local ColFn = FnLogList:AddColumn("Function");
		local ColArgs = FnLogList:AddColumn("Arguments");
		local ColStat = FnLogList:AddColumn("Status");
		FnLogList.OnClickLine = function(prnt, line, sel)
			if(g.table.HasValue(SH.fnblock, line:GetValue(2))) then
				for k, v in g.pairs(SH.fnblock) do
					if(v == line:GetValue(2)) then
						g.table.remove(SH.fnblock, k);
						me:ChatPrint("Function " .. line:GetValue(2) .. " unblocked.");
					end
				end
			else
				g.table.insert(SH.fnblock, line:GetValue(2));
				me:ChatPrint("Function " .. line:GetValue(2) .. " blocked.");
			end
		end
		
		ColTime:SetFixedWidth(50);
		ColFn:SetFixedWidth(125);
		ColArgs:SetFixedWidth(65);
		ColStat:SetFixedWidth(50);
		
		for k, v in g.pairs(SH.fnlogs) do
			local ln = FnLogList:AddLine(v.time, v.func, v.args, v.status);
			ln:SetTooltip("Time: " .. v.time .. "\nFunction: " .. v.func .. "\nArguments: " .. v.args .. "\nStatus: " .. v.status);
		end
		
		--timer.Simple(0, FnLogList.VBar.SetScroll, FnLogList.VBar, 20000000)
	end
end

SH:RegisterCommand("+sh_menu", SH.Menu);
SH:RegisterCommand("-sh_menu", function()
	--SelectedWindow = "Aimbot";
	if(menu.frame) then
		menu.frame:Remove();
		menu = {};
	end
	
	g.gui.EnableScreenClicker(false);
	local dframe = vgui.Create("DFrame");
	dframe:SetSize(0,0);
	dframe:SetVisible(true);
	dframe:MakePopup();
	g.timer.Simple(.1, function()
		dframe:Remove();
	end);
end);

function SH.UpdateMenu()
		local umenu = vgui.Create("DFrame");
		umenu:SetSize(500, 550);
		umenu:SetPos(10, 10);
		umenu:ShowCloseButton(false);
		umenu:SetTitle("SethHack Credits");
		umenu:MakePopup();

		local ulabel = vgui.Create("DTextEntry", umenu);
		ulabel:SetPos(10, 25);
		ulabel:SetSize(480, 450);
		ulabel:SetEditable(false);
		ulabel:SetMultiline(true);

		local ubutton = vgui.Create("DButton", umenu);
		ubutton:SetPos(25, 485);
		ubutton:SetSize(450, 50);
		ubutton:SetText("Close");
		function ubutton:DoClick()
			umenu:Remove();
			umenu = nil;
		end

		ulabel:SetText([[
            Welcome to SethHack v4! A Garry's Mod Aimbot.
            Rebuilt and Converted by: The ICEMANE;
            Coded by: Seth
		]]);
end

print(SH.GetCVNum("sh_color_menu_r"),
SH.GetCVNum("sh_color_menu_g"),
SH.GetCVNum("sh_color_menu_b"),
SH.GetCVNum("sh_color_menu_a"))
