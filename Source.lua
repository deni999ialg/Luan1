-- Customize the script settings here
local commandPrefix = "/" -- Change this to your desired prefix
local commandUrl = "http://localhost:3000/commands.json" -- Replace with your server URL
-- Table to store user roles (Replace with actual role-checking logic)
local userRoles = {
    ["Admin"] = true, -- Replace with actual player role logic
    ["User"] = false,
}

-- Function to check if a user is allowed to execute a command
local function hasPermission(role)
    return userRoles[role] or false
end

-- Example: Restrict a command
commandList["adminCommand"] = function()
    if hasPermission("Admin") then
        print("Admin command executed!")
    else
        print("You do not have permission to use this command.")
    end
end
local HttpService = game:GetService("HttpService")
local commandList = {}
-- Function to add an alias for an existing command
local function addCommandAlias(alias, originalCommand)
    if commandList[originalCommand] then
        commandList[alias] = commandList[originalCommand]
    else
        warn("Original command '" .. originalCommand .. "' does not exist.")
    end
end

-- Example: Add an alias
addCommandAlias("h", "help") -- Users can now use `/h` as an alias for `/help`
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
-- Function to display available commands
local function showHelp()
    print("Available Commands:")
    for command, _ in pairs(commandList) do
        print("- " .. command)
    end
end

-- Add the help command to the command list
commandList["help"] = showHelp

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
-- Function to log executed commands
local function logCommand(command)
    print("Command executed: " .. command .. " at " .. os.date("%Y-%m-%d %H:%M:%S"))
end

-- Modify the command execution to include logging
inputBox.FocusLost:Connect(function(_, enterPressed)
    if enterPressed then
        local input = inputBox.Text:lower()
        if input:sub(1, #commandPrefix) == commandPrefix then
            local command = input:sub(#commandPrefix + 1) -- Remove the prefix
            if commandList[command] then
                commandList[command]()  -- Execute the command
                logCommand(command)    -- Log the command
                inputBox.Text = ""     -- Clear input box
            else
                print("Command not found: " .. command)
            end
        end
    end
end)
    -- Function to suggest commands
local function autocomplete(input)
    local suggestions = {}
    for command, _ in pairs(commandList) do
        if command:sub(1, #input) == input then
            table.insert(suggestions, command)
        end
    end
    return suggestions
end

-- Example usage of autocomplete
local input = "he"
local suggestions = autocomplete(input)
print("Suggestions for '" .. input .. "': " .. table.concat(suggestions, ", "))
    
    -- Tweening for UI animations (Optional)
    local tweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tweenGoal = {Position = UDim2.new(0.35, 0, 0.85, 0)}
    local tween = tweenService:Create(commandBar, tweenInfo, tweenGoal)
    tween:Play()
end
-- Function to suggest commands

-- Example usage of autocomplete

-- Initialize the command bar and load commands from the web
loadCommandsFromWeb()
createCommandBar()

