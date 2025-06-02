-- خدمات اللعبة
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

-- حالة الضرب
local AttackEnabled = false

-- إنشاء الواجهة
local gui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
gui.Name = "AkalAutoHit"

-- الإطار الأساسي مع الصورة
local frame = Instance.new("ImageLabel", gui)
frame.Size = UDim2.new(0, 260, 0, 160)
frame.Position = UDim2.new(0, 20, 0.5, -80)
frame.BackgroundTransparency = 0.1
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
frame.Image = "https://cdn.discordapp.com/avatars/1078373118814466068/c31be8f0946cd9ba4b3b7f4233062807.webp?size=2048"
frame.ScaleType = Enum.ScaleType.Crop

-- زر التشغيل/الإيقاف
local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(0, 200, 0, 50)
toggle.Position = UDim2.new(0.5, -100, 1, -60)
toggle.Text = "تشغيل الأوتو"
toggle.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle.Font = Enum.Font.SourceSansBold
toggle.TextSize = 20

-- تفعيل/إيقاف الضرب
toggle.MouseButton1Click:Connect(function()
    AttackEnabled = not AttackEnabled
    toggle.Text = AttackEnabled and "إيقاف الأوتو" or "تشغيل الأوتو"

    if AttackEnabled then
        spawn(function()
            while AttackEnabled do
                local closest, dist = nil, math.huge
                for _, mob in pairs(workspace.Enemies:GetChildren()) do
                    if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                        local d = (mob.HumanoidRootPart.Position - LP.Character.HumanoidRootPart.Position).Magnitude
                        if d < dist and d < 100 then
                            closest = mob
                            dist = d
                        end
                    end
                end

                if closest then
                    pcall(function()
                        local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")
                        remote:FireServer("Attack", closest)
                    end)
                end
                wait(0.001)
            end
        end)
    end
end)

-- زر لإظهار/إخفاء الواجهة بزر Shift
UIS.InputBegan:Connect(function(key)
    if key.KeyCode == Enum.KeyCode.RightShift then
        gui.Enabled = not gui.Enabled
    end
end)