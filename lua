-- Rayfield UI yükleme
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Pencere oluşturma
local Window = Rayfield:CreateWindow({
   Name = "Lovely-Hub",
   LoadingTitle = "Rayfield UI",
   LoadingSubtitle = "by Lovely",
   ConfigurationSaving = {
      Enabled = false
   }
})

-- Tab oluşturma
local Tab = Window:CreateTab("Zaman", 4483362458)

-- Slider ile saat ayarlama
Tab:CreateSlider({
   Name = "Oyun Saati",
   Range = {0, 24},
   Increment = 0.1,
   Suffix = "Saat",
   CurrentValue = game:GetService("Lighting").ClockTime,
   Flag = "TimeSlider",
   Callback = function(Value)
       game:GetService("Lighting").ClockTime = Value
   end,
})
