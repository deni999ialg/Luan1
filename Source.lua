-- Customize the script settings here
local commandPrefix = "/" -- Change this to your desired prefix
local commandUrl = "http://localhost:3000/commands.json" -- Replace with your server URL

local HttpService = game:GetService("HttpService")
local commandList = {}

-- Function to fetch and load commands from the web
local function loadCommandsFromWeb()
    local success, response = pcall(function()
        return HttpService:GetAsync(commandUrl) -- Fetch the JSON file from the web
    end)

    if success then
        -- Parse the JSON response into a Lua table
        local commandsData = HttpService:JSONDecode(response)
        for command, funcCode in pairs(commandsData) do
            -- Create a Lua function from the string code using loadstring
            local func, err = loadstring(funcCode)
            if func then
                commandList[command] = func
            else
                warn("Failed to load command '" .. command .. "': " .. err)
            end
        end
    else
        warn("Failed to fetch commands from web: " .. response)
    end
end

-- Function to create the command bar UI
local function createCommandBar()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CommandBarGui"
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local commandBar = Instance.new("Frame")
    commandBar.Size = UDim2.new(0.3, 0, 0.05, 0)  -- Adjust the size of the command bar
    commandBar.Position = UDim2.new(0.35, 0, 0.9, 0)  -- Position it near the bottom center
    commandBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  -- Black background
    commandBar.Parent = screenGui

    local inputBox = Instance.new("TextBox")
    inputBox.Size = UDim2.new(1, 0, 1, 0)
    inputBox.BackgroundTransparency = 0.5
    inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    inputBox.PlaceholderText = "Type a command..."
    inputBox.Text = ""
    inputBox.ClearTextOnFocus = false
    inputBox.Parent = commandBar

    inputBox.FocusLost:Connect(function(_, enterPressed)
        if enterPressed then
            local input = inputBox.Text:lower()
            if input:sub(1, #commandPrefix) == commandPrefix then
                local command = input:sub(#commandPrefix + 1) -- Remove the prefix
                if commandList[command] then
                    commandList[command]()  -- Execute the command
                    inputBox.Text = ""  -- Clear input box
                else
                    print("Command not found: " .. command)
                end
            end
        end
    end)
    
    -- Tweening for UI animations (Optional)
    local tweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tweenGoal = {Position = UDim2.new(0.35, 0, 0.85, 0)}
    local tween = tweenService:Create(commandBar, tweenInfo, tweenGoal)
    tween:Play()
end

-- Initialize the command bar and load commands from the web
loadCommandsFromWeb()
createCommandBar()
