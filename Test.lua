-- Zeno Hub | Delta Executor | Key Fixed
local Players,RunService,UIS,TS,Cam,lp =
    game:GetService("Players"),game:GetService("RunService"),
    game:GetService("UserInputService"),game:GetService("TweenService"),
    workspace.CurrentCamera,game:GetService("Players").LocalPlayer

local KEYS = {["ZENO-FREE-0001"]=true,["ZENO-ALPHA-2024"]=true}
local verified = false

local CFG = {
    Aim=false,Silent=false,Box=true,Tracer=true,
    Name=true,HP=true,Dist=true,Fov=true,
    Smooth=0.15,FovR=100,MaxDist=500,
    Part="Head",Team=true,
    BCol=Color3.fromRGB(255,60,60),
    TCol=Color3.fromRGB(60,200,255),
}

-- drawing pool
local pool={}
local function D(t,p) local d=Drawing.new(t) for k,v in pairs(p) do pcall(function()d[k]=v end) end return d end
local function gc(pl)
    if pool[pl] then return pool[pl] end
    local t={box={}}
    for i=1,4 do t.box[i]=D("Line",{Visible=false,Color=CFG.BCol,Thickness=1}) end
    t.tr=D("Line",{Visible=false,Color=CFG.TCol,Thickness=1})
    t.nm=D("Text",{Visible=false,Size=13,Center=true,Outline=true,OutlineColor=Color3.new(0,0,0)})
    t.hb=D("Line",{Visible=false,Color=Color3.new(0,0,0),Thickness=4})
    t.hf=D("Line",{Visible=false,Thickness=3})
    t.ds=D("Text",{Visible=false,Size=11,Center=true,Outline=true,OutlineColor=Color3.new(0,0,0)})
    pool[pl]=t return t
end
local function hide(t)
    if not t then return end
    for _,l in ipairs(t.box) do pcall(function()l.Visible=false end) end
    for _,k in ipairs({"tr","nm","hb","hf","ds"}) do pcall(function()t[k].Visible=false end) end
end
Players.PlayerRemoving:Connect(function(p)
    if not pool[p] then return end
    hide(pool[p])
    for _,l in ipairs(pool[p].box) do pcall(function()l:Remove()end) end
            local d=math.floor((root.Position-Cam.CFrame.Position).Magnitude)
            pcall(function()t.ds.Text=d.."m" t.ds.Position=Vector2.new(bb.bc.X,bb.bc.Y+2) t.ds.Color=Color3.fromRGB(200,200,200) t.ds.Visible=true end)
        end
    else pcall(function()t.ds.Visible=false end) end
end

-- ═══ UI ═══
local C={bg=Color3.fromRGB(15,15,20),panel=Color3.fromRGB(22,22,30),
         acc=Color3.fromRGB(120,60,220),acc2=Color3.fromRGB(80,30,180),
         txt=Color3.fromRGB(230,230,240),sub=Color3.fromRGB(140,140,160),
         on=Color3.fromRGB(100,220,100),off=Color3.fromRGB(220,70,70),inp=Color3.fromRGB(30,30,40)}
local function mk(cls,p,par) local o=Instance.new(cls) for k,v in pairs(p) do o[k]=v end if par then o.Parent=par end return o end
local function cr(r,p) mk("UICorner",{CornerRadius=UDim.new(0,r)},p) end
local function sk(t,c,p) mk("UIStroke",{Thickness=t,Color=c,ApplyStrokeMode=Enum.ApplyStrokeMode.Border},p) end

local sg=mk("ScreenGui",{
    Name="ZenoHub",ResetOnSpawn=false,
    IgnoreGuiInset=true,
    -- FIX: DisplayOrder tinggi supaya button sik tertutup game UI
    DisplayOrder=999,
},lp:WaitForChild("PlayerGui"))

-- ═══ KEY GATE ═══
local kg=mk("Frame",{
    Size=UDim2.new(0,300,0,200),
    Position=UDim2.new(.5,-150,.5,-100),
    BackgroundColor3=C.bg,BorderSizePixel=0,
    -- FIX: Active=true + ZIndex tinggi
    Active=true,ZIndex=10,
},sg)
cr(10,kg) sk(1,C.acc,kg)

mk("TextLabel",{
    Size=UDim2.new(1,0,0,38),ZIndex=11,
    BackgroundTransparency=1,Text="⚡ ZENO HUB",
    TextColor3=C.acc,Font=Enum.Font.GothamBold,TextSize=18,
},kg)
mk("TextLabel",{
    Size=UDim2.new(1,-16,0,16),Position=UDim2.new(0,8,0,40),ZIndex=11,
    BackgroundTransparency=1,Text="Masukkan key untuk aktifkan",
    TextColor3=C.sub,Font=Enum.Font.Gotham,TextSize=12,
    TextXAlignment=Enum.TextXAlignment.Left,
},kg)
cr(8,kbtn)

-- ═══ VERIFY FUNCTION ═══
local lastTap=0
local function tryVerify()
    -- debounce 0.5s supaya sik double fire
    local now=tick()
    if now-lastTap < 0.5 then return end
    lastTap=now

    local input=kb.Text:gsub("^%s+",""):gsub("%s+$","")  -- trim whitespace
    if KEYS[input] then
        verified=true
        kg.Visible=false
        hub.Visible=true
    else
        ks.Text="❌ Key salah. Cuba lagi."
        -- flash red
        kbtn.BackgroundColor3=C.off
        task.wait(0.3)
        kbtn.BackgroundColor3=C.acc
    end
end

-- FIX: guna TIGA event serentak — cover semua input method Delta
kbtn.MouseButton1Click:Connect(tryVerify)   -- PC/emulator
kbtn.Activated:Connect(tryVerify)           -- touch primary
kbtn.TouchTap:Connect(tryVerify)            -- touch fallback

-- enter key fallback
kb.FocusLost:Connect(function(enter) if enter then tryVerify() end end)

-- ═══ MAIN HUB ═══
local hub=mk("Frame",{
    Size=UDim2.new(0,300,0,440),
    Position=UDim2.new(.5,-150,.5,-220),
    BackgroundColor3=C.bg,BorderSizePixel=0,
    Active=true,Visible=false,ZIndex=10,
},sg)
cr(12,hub) sk(1,C.acc,hub)

local function sec(title)
    local s=mk("Frame",{Size=UDim2.new(1,0,0,28),BackgroundColor3=C.panel,BorderSizePixel=0,AutomaticSize=Enum.AutomaticSize.Y,ZIndex=11},scr)
    cr(7,s) sk(1,C.acc2,s)
    mk("TextLabel",{Size=UDim2.new(1,-8,0,26),Position=UDim2.new(0,8,0,0),ZIndex=12,BackgroundTransparency=1,Text=title,TextColor3=C.acc,Font=Enum.Font.GothamBold,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left},s)
    local lst=mk("Frame",{Size=UDim2.new(1,-10,0,0),Position=UDim2.new(0,5,0,28),BackgroundTransparency=1,AutomaticSize=Enum.AutomaticSize.Y,ZIndex=11},s)
    mk("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,4)},lst)
    return lst
end

local function tog(par,lbl,key,ord)
    local row=mk("Frame",{Size=UDim2.new(1,0,0,30),BackgroundTransparency=1,LayoutOrder=ord,ZIndex=12},par)
    mk("TextLabel",{Size=UDim2.new(1,-48,1,0),ZIndex=13,BackgroundTransparency=1,Text=lbl,TextColor3=C.txt,Font=Enum.Font.Gotham,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left},row)
    local pill=mk("Frame",{Size=UDim2.new(0,40,0,20),Position=UDim2.new(1,-42,0.5,-10),BackgroundColor3=CFG[key] and C.on or C.off,BorderSizePixel=0,ZIndex=13},row) cr(10,pill)
    local dot=mk("Frame",{Size=UDim2.new(0,16,0,16),Position=CFG[key] and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,2,0.5,-8),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,ZIndex=14},pill) cr(8,dot)
    local btn=mk("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",ZIndex=15,AutoButtonColor=false},pill)
    local function flip()
        CFG[key]=not CFG[key] local on=CFG[key]
        pill.BackgroundColor3=on and C.on or C.off
        TS:Create(dot,TweenInfo.new(.12),{Position=on and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,2,0.5,-8)}):Play()
    end
    btn.MouseButton1Click:Connect(flip)
    btn.Activated:Connect(flip)
    btn.TouchTap:Connect(flip)
end

local function sld(par,lbl,key,mn,mx,ord,fmt)
    local row=mk("Frame",{Size=UDim2.new(1,0,0,44),BackgroundTransparency=1,LayoutOrder=ord,ZIndex=12},par)
    local vl=mk("TextLabel",{Size=UDim2.new(1,0,0,16),ZIndex=13,BackgroundTransparency=1,Text=lbl..": "..(fmt and fmt(CFG[key]) or CFG[key]),TextColor3=C.txt,Font=Enum.Font.Gotham,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left},row)
    local tr=mk("Frame",{Size=UDim2.new(1,0,0,7),Position=UDim2.new(0,0,0,22),BackgroundColor3=C.inp,BorderSizePixel=0,ZIndex=13},row) cr(4,tr)
    local fi=mk("Frame",{Size=UDim2.new((CFG[key]-mn)/(mx-mn),0,1,0),BackgroundColor3=C.acc,BorderSizePixel=0,ZIndex=14},tr) cr(4,fi)
    local sd=false
    local function upd(x) local r=math.clamp((x-tr.AbsolutePosition.X)/tr.AbsoluteSize.X,0,1) local v=math.floor(mn+r*(mx-mn)) CFG[key]=v fi.Size=UDim2.new(r,0,1,0) vl.Text=lbl..": "..(fmt and fmt(v) or v) end
    tr.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sd=true upd(i.Position.X) end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sd=false end end)
    UIS.InputChanged:Connect(function(i) if sd and(i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch)then upd(i.Position.X) end end)
end

local function dd(par,lbl,key,opts,ord)
    local row=mk("Frame",{Size=UDim2.new(1,0,0,30),BackgroundTransparency=1,LayoutOrder=ord,ZIndex=12},par)
    mk("TextLabel",{Size=UDim2.new(.55,0,1,0),ZIndex=13,BackgroundTransparency=1,Text=lbl,TextColor3=C.txt,Font=Enum.Font.Gotham,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left},row)
    local btn=mk("TextButton",{Size=UDim2.new(.43,0,0,24),Position=UDim2.new(.57,0,.5,-12),ZIndex=13,BackgroundColor3=C.inp,TextColor3=C.acc,Font=Enum.Font.GothamMono,TextSize=11,Text=CFG[key].." ▾",BorderSizePixel=0,AutoButtonColor=true},row) cr(5,btn)
    local idx=1 for i,v in ipairs(opts) do if v==CFG[key] then idx=i end end
    btn.Activated:Connect(cyc)
    btn.TouchTap:Connect(cyc)
end

local a=sec("🎯 AIM BOT")
tog(a,"Auto Aim","Aim",1) tog(a,"Silent Aim","Silent",2) tog(a,"Team Check","Team",3)
sld(a,"Smooth","Smooth",0,1,4,function(v)return string.format("%.2f",v)end)
sld(a,"FOV","FovR",20,300,5)
dd(a,"Part","Part",{"Head","HumanoidRootPart","UpperTorso"},6)

local e=sec("👁 ESP")
tog(e,"Box","Box",1) tog(e,"Tracer","Tracer",2) tog(e,"Names","Name",3)
tog(e,"Health","HP",4) tog(e,"Distance","Dist",5) tog(e,"FOV Box","Fov",6)
sld(e,"Max Dist","MaxDist",50,1000,7)

local open=true
local function setHub(o) open=o scr.Visible=o hub.Size=o and UDim2.new(0,300,0,440) or UDim2.new(0,300,0,40) end
local function mflip() setHub(not open) minB.Text=open and "—" or "□" end
minB.MouseButton1Click:Connect(mflip) minB.Activated:Connect(mflip) minB.TouchTap:Connect(mflip)
local function cls() hub.Visible=false end
clsB.MouseButton1Click:Connect(cls) clsB.Activated:Connect(cls) clsB.TouchTap:Connect(cls)

RunService.RenderStepped:Connect(function()
    if not verified then return end
    fovDraw()
    if CFG.Silent then local _,h=bestTarget() if h then doAim(h) end
    elseif CFG.Aim then local _,h=bestTarget() if h then doSmooth(h) end end
    for _,p in ipairs(Players:GetPlayers()) do
        if p==lp then continue end
        local t=gc(p)
        if(CFG.Team and p.Team==lp.Team)or not alive(p) then hide(t) continue end
        local c=p.Character local r=c and c:FindFirstChild("HumanoidRootPart")
        if not r or(r.Position-Cam.CFrame.Position).Magnitude>CFG.MaxDist then hide(t) continue end
        local bb=bbox(p) if not bb then hide(t) continue end
        espDraw(t,bb,p)
    end
end)

pcall(function()getgenv().ZenoHub={cfg=CFG} end)
pcall(function()_G.ZenoHub={cfg=CFG} end)
print("[ZenoHub] loaded — masukkan key untuk start")
