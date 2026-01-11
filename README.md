# Hitler
Lovely-End
local Window = Rayfield:CreateWindow({
   Name = "Rayfield Example Window",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Rayfield Interface Suite",
   LoadingSubtitle = "by Sirius",
   ShowText = "Rayfield", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})
-- LocalScript (put in StarterPlayerScripts or StarterGui)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")

local MESSAGE = "Lovely-end"    -- Göndermek istediğiniz mesaj
local WAIT_BEFORE = 0.5         -- Oyuncu yüklenmesi için bekleme (saniye)
local CHANNEL_WAIT = 5          -- Chat kanalı gelmesi için maksimum bekleme (saniye)

local function tryClassicChat(msg)
    -- Klasik sohbet eventi (çoğu oyunda bulunur)
    local events = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    if not events then return false end
    local say = events:FindFirstChild("SayMessageRequest")
    if not say then return false end

    local ok, err = pcall(function()
        say:FireServer(msg, "All") -- "All" veya hedef kanal adı
    end)
    if not ok then
        warn("Classic chat gönderilemedi:", err)
    end
    return ok
end

local function tryTextChat(msg)
    -- Yeni TextChatService yolu (bazı oyunlarda kullanılır)
    local config = TextChatService and TextChatService.ChatInputBarConfiguration
    if not config then return false end

    local channel = config.TargetTextChannel
    local start = os.clock()
    while not channel and (os.clock() - start) < CHANNEL_WAIT do
        -- TargetTextChannel yüklendiğinde tetiklenir
        local ev = config:GetPropertyChangedSignal("TargetTextChannel")
        ev:Wait()
        channel = config.TargetTextChannel
    end

    if not channel then
        return false
    end

    local ok, err = pcall(function()
        channel:SendAsync(msg)
    end)
    if not ok then
        warn("TextChatService:SendAsync başarısız:", err)
    end
    return ok
end

-- Başlangıç
task.wait(WAIT_BEFORE)

-- İstisnalar/izinler: otomatik chat bazı oyunlarda engellenmiş olabilir.
local sent = false
-- Önce klasik chat'i dene (en yaygın)
sent = tryClassicChat(MESSAGE)

-- Eğer klasik çalışmadıysa TextChatService'i dene
if not sent then
    sent = tryTextChat(MESSAGE)
end

if not sent then
    warn("Mesaj gönderilemedi — ne klasik chat ne de TextChatService uygun durumda.")
end
