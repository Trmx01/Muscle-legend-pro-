-- Muscle Legends GUI Script - Mobile-Friendly Version
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Create the GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MuscleLegendGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- If we're not on mobile, parent to CoreGui for better persistence
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = game.CoreGui
elseif gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
end

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 350)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Title bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

-- Add title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamSemibold
Title.Text = "Muscle Legends Hub"
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Close button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
CloseButton.BorderSizePixel = 0
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.Parent = TitleBar

-- Minimize button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -60, 0, 0)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 180)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 18
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Text = "-"
MinimizeButton.Parent = TitleBar

-- Content Frame for tabs
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, 0, 1, -60)
ContentFrame.Position = UDim2.new(0, 0, 0, 60)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Tab buttons frame
local TabButtons = Instance.new("Frame")
TabButtons.Name = "TabButtons"
TabButtons.Size = UDim2.new(1, 0, 0, 30)
TabButtons.Position = UDim2.new(0, 0, 0, 30)
TabButtons.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
TabButtons.BorderSizePixel = 0
TabButtons.Parent = MainFrame

-- Create tab buttons
local tabs = {"Main", "Gym", "Pets", "Tools", "Settings"}
local tabFrames = {}
local tabButtons = {}

for i, tabName in ipairs(tabs) do
    -- Create tab button
    local TabButton = Instance.new("TextButton")
    TabButton.Name = tabName .. "Button"
    TabButton.Size = UDim2.new(0, 60, 1, 0)
    TabButton.Position = UDim2.new(0, (i-1) * 60, 0, 0)
    TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    TabButton.BorderSizePixel = 0
    TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabButton.TextSize = 14
    TabButton.Font = Enum.Font.GothamSemibold
    TabButton.Text = tabName
    TabButton.Parent = TabButtons
    
    -- Create tab content frame
    local TabFrame = Instance.new("ScrollingFrame")
    TabFrame.Name = tabName .. "Tab"
    TabFrame.Size = UDim2.new(1, 0, 1, 0)
    TabFrame.BackgroundTransparency = 1
    TabFrame.BorderSizePixel = 0
    TabFrame.ScrollBarThickness = 4
    TabFrame.Visible = i == 1 -- Only first tab visible by default
    TabFrame.Parent = ContentFrame
    TabFrame.CanvasSize = UDim2.new(0, 0, 0, 0) -- Will adjust as we add content
    TabFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    TabFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    -- Store the frames and buttons
    tabFrames[tabName] = TabFrame
    tabButtons[tabName] = TabButton
    
    -- Button functionality
    TabButton.MouseButton1Click:Connect(function()
        -- Hide all tabs
        for _, frame in pairs(tabFrames) do
            frame.Visible = false
        end
        
        -- Reset all button colors
        for _, button in pairs(tabButtons) do
            button.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            button.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        
        -- Show selected tab and highlight button
        TabFrame.Visible = true
        TabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
end

-- Helper function to create sections in tabs
local function CreateSection(tabName, sectionName)
    local tab = tabFrames[tabName]
    
    -- Find the Y position for the new section (after existing content)
    local yOffset = 10
    for _, child in ipairs(tab:GetChildren()) do
        if child:IsA("Frame") then
            yOffset = yOffset + child.Size.Y.Offset + 10
        end
    end
    
    local SectionFrame = Instance.new("Frame")
    SectionFrame.Name = sectionName .. "Section"
    SectionFrame.Size = UDim2.new(1, -20, 0, 30) -- Will grow as we add elements
    SectionFrame.Position = UDim2.new(0, 10, 0, yOffset)
    SectionFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    SectionFrame.BorderSizePixel = 0
    SectionFrame.Parent = tab
    
    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Name = "Title"
    SectionTitle.Size = UDim2.new(1, 0, 0, 30)
    SectionTitle.BackgroundTransparency = 1
    SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    SectionTitle.TextSize = 16
    SectionTitle.Font = Enum.Font.GothamSemibold
    SectionTitle.Text = "  " .. sectionName
    SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    SectionTitle.Parent = SectionFrame
    
    local ContentHolder = Instance.new("Frame")
    ContentHolder.Name = "Content"
    ContentHolder.Size = UDim2.new(1, 0, 1, -30)
    ContentHolder.Position = UDim2.new(0, 0, 0, 30)
    ContentHolder.BackgroundTransparency = 1
    ContentHolder.Parent = SectionFrame
    
    return SectionFrame, ContentHolder
end

-- Helper function to create toggles
local function CreateToggle(section, name, callback)
    local contentHolder = section:FindFirstChild("Content")
    
    -- Find the Y position for the new toggle
    local yOffset = 10
    for _, child in ipairs(contentHolder:GetChildren()) do
        if child:IsA("Frame") then
            yOffset = yOffset + child.Size.Y.Offset + 10
        end
    end
    
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = name .. "Toggle"
    ToggleFrame.Size = UDim2.new(1, -20, 0, 30)
    ToggleFrame.Position = UDim2.new(0, 10, 0, yOffset)
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Parent = contentHolder
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Name = "Label"
    ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    ToggleLabel.TextSize = 14
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.Text = name
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = ToggleFrame
    
    local ToggleButton = Instance.new("Frame")
    ToggleButton.Name = "Button"
    ToggleButton.Size = UDim2.new(0, 40, 0, 20)
    ToggleButton.Position = UDim2.new(1, -45, 0.5, -10)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Parent = ToggleFrame
    
    local ToggleIndicator = Instance.new("Frame")
    ToggleIndicator.Name = "Indicator"
    ToggleIndicator.Size = UDim2.new(0, 16, 0, 16)
    ToggleIndicator.Position = UDim2.new(0, 2, 0.5, -8)
    ToggleIndicator.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    ToggleIndicator.BorderSizePixel = 0
    ToggleIndicator.Parent = ToggleButton
    
    -- Make the entire toggle clickable
    local ToggleClickRegion = Instance.new("TextButton")
    ToggleClickRegion.Name = "ClickRegion"
    ToggleClickRegion.Size = UDim2.new(1, 0, 1, 0)
    ToggleClickRegion.BackgroundTransparency = 1
    ToggleClickRegion.Text = ""
    ToggleClickRegion.Parent = ToggleFrame
    
    -- Track toggle state
    local enabled = false
    
    -- Toggle function
    local function updateToggle()
        enabled = not enabled
        
        if enabled then
            ToggleIndicator:TweenPosition(
                UDim2.new(0, 22, 0.5, -8),
                Enum.EasingDirection.InOut,
                Enum.EasingStyle.Quad,
                0.15,
                true
            )
            ToggleIndicator.BackgroundColor3 = Color3.fromRGB(0, 200, 170)
            ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 80, 70)
        else
            ToggleIndicator:TweenPosition(
                UDim2.new(0, 2, 0.5, -8),
                Enum.EasingDirection.InOut,
                Enum.EasingStyle.Quad,
                0.15,
                true
            )
            ToggleIndicator.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        end
        
        callback(enabled)
    end
    
    ToggleClickRegion.MouseButton1Click:Connect(updateToggle)
    
    -- Resize the section to accommodate the new toggle
    section.Size = UDim2.new(1, -20, 0, section:FindFirstChild("Title").Size.Y.Offset + contentHolder.Size.Y.Offset + yOffset + ToggleFrame.Size.Y.Offset + 10)
    
    return {
        SetState = function(state)
            if state ~= enabled then
                updateToggle()
            end
        end
    }
end

-- Helper function to create buttons
local function CreateButton(section, name, callback)
    local contentHolder = section:FindFirstChild("Content")
    
    -- Find the Y position for the new button
    local yOffset = 10
    for _, child in ipairs(contentHolder:GetChildren()) do
        if child:IsA("Frame") then
            yOffset = yOffset + child.Size.Y.Offset + 10
        end
    end
    
    local ButtonFrame = Instance.new("Frame")
    ButtonFrame.Name = name .. "Button"
    ButtonFrame.Size = UDim2.new(1, -20, 0, 30)
    ButtonFrame.Position = UDim2.new(0, 10, 0, yOffset)
    ButtonFrame.BackgroundTransparency = 1
    ButtonFrame.Parent = contentHolder
    
    local Button = Instance.new("TextButton")
    Button.Name = "Button"
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.BackgroundColor3 = Color3.fromRGB(60, 90, 120)
    Button.BorderSizePixel = 0
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 14
    Button.Font = Enum.Font.GothamSemibold
    Button.Text = name
    Button.Parent = ButtonFrame
    
    Button.MouseButton1Click:Connect(callback)
    
    -- Resize the section to accommodate the new button
    section.Size = UDim2.new(1, -20, 0, section:FindFirstChild("Title").Size.Y.Offset + contentHolder.Size.Y.Offset + yOffset + ButtonFrame.Size.Y.Offset + 10)
    
    return Button
end

-- Helper function to create dropdowns
local function CreateDropdown(section, name, options, callback)
    local contentHolder = section:FindFirstChild("Content")
    
    -- Find the Y position for the new dropdown
    local yOffset = 10
    for _, child in ipairs(contentHolder:GetChildren()) do
        if child:IsA("Frame") then
            yOffset = yOffset + child.Size.Y.Offset + 10
        end
    end
    
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Name = name .. "Dropdown"
    DropdownFrame.Size = UDim2.new(1, -20, 0, 60) -- Height will change when opened
    DropdownFrame.Position = UDim2.new(0, 10, 0, yOffset)
    DropdownFrame.BackgroundTransparency = 1
    DropdownFrame.Parent = contentHolder
    
    local DropdownLabel = Instance.new("TextLabel")
    DropdownLabel.Name = "Label"
    DropdownLabel.Size = UDim2.new(1, 0, 0, 20)
    DropdownLabel.BackgroundTransparency = 1
    DropdownLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    DropdownLabel.TextSize = 14
    DropdownLabel.Font = Enum.Font.Gotham
    DropdownLabel.Text = name
    DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
    DropdownLabel.Parent = DropdownFrame
    
    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Name = "Button"
    DropdownButton.Size = UDim2.new(1, 0, 0, 30)
    DropdownButton.Position = UDim2.new(0, 0, 0, 20)
    DropdownButton.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    DropdownButton.BorderSizePixel = 0
    DropdownButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    DropdownButton.TextSize = 14
    DropdownButton.Font = Enum.Font.Gotham
    DropdownButton.Text = "Select..."
    DropdownButton.Parent = DropdownFrame
    
    local DropdownList = Instance.new("Frame")
    DropdownList.Name = "List"
    DropdownList.Size = UDim2.new(1, 0, 0, #options * 30)
    DropdownList.Position = UDim2.new(0, 0, 0, 50)
    DropdownList.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    DropdownList.BorderSizePixel = 0
    DropdownList.Visible = false
    DropdownList.ZIndex = 10
    DropdownList.Parent = DropdownFrame
    
    local selectedOption = nil
    
    for i, option in ipairs(options) do
        local OptionButton = Instance.new("TextButton")
        OptionButton.Name = option
        OptionButton.Size = UDim2.new(1, 0, 0, 30)
        OptionButton.Position = UDim2.new(0, 0, 0, (i-1) * 30)
        OptionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        OptionButton.BorderSizePixel = 0
        OptionButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        OptionButton.TextSize = 14
        OptionButton.Font = Enum.Font.Gotham
        OptionButton.Text = option
        OptionButton.ZIndex = 11
        OptionButton.Parent = DropdownList
        
        OptionButton.MouseButton1Click:Connect(function()
            selectedOption = option
            DropdownButton.Text = option
            DropdownList.Visible = false
            callback(option)
            
            -- Resize dropdown when closing
            DropdownFrame.Size = UDim2.new(1, -20, 0, 60)
            
            -- Resize the section after closing dropdown
            section.Size = UDim2.new(1, -20, 0, section:FindFirstChild("Title").Size.Y.Offset + contentHolder.Size.Y.Offset + yOffset + DropdownFrame.Size.Y.Offset + 10)
        end)
    end
    
    local dropdownOpen = false
    
    DropdownButton.MouseButton1Click:Connect(function()
        dropdownOpen = not dropdownOpen
        DropdownList.Visible = dropdownOpen
        
        if dropdownOpen then
            -- Resize dropdown when opening
            DropdownFrame.Size = UDim2.new(1, -20, 0, 60 + DropdownList.Size.Y.Offset)
            
            -- Resize the section when opening dropdown
            section.Size = UDim2.new(1, -20, 0, section:FindFirstChild("Title").Size.Y.Offset + contentHolder.Size.Y.Offset + yOffset + DropdownFrame.Size.Y.Offset + 10)
        else
            -- Resize dropdown when closing
            DropdownFrame.Size = UDim2.new(1, -20, 0, 60)
            
            -- Resize the section after closing dropdown
            section.Size = UDim2.new(1, -20, 0, section:FindFirstChild("Title").Size.Y.Offset + contentHolder.Size.Y.Offset + yOffset + DropdownFrame.Size.Y.Offset + 10)
        end
    end)
    
    -- Resize the section to accommodate the new dropdown (closed state)
    section.Size = UDim2.new(1, -20, 0, section:FindFirstChild("Title").Size.Y.Offset + contentHolder.Size.Y.Offset + yOffset + DropdownFrame.Size.Y.Offset + 10)
    
    return {
        SetValue = function(option)
            if table.find(options, option) then
                selectedOption = option
                DropdownButton.Text = option
                callback(option)
            end
        end,
        GetValue = function()
            return selectedOption
        end
    }
end

-- Function for saving state when minimized
local function CreateIconButton()
    local IconButton = Instance.new("ImageButton")
    IconButton.Name = "IconButton"
    IconButton.Size = UDim2.new(0, 50, 0, 50)
    IconButton.Position = UDim2.new(0, 10, 0, 10)
    IconButton.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    IconButton.BorderSizePixel = 0
    IconButton.Visible = false
    IconButton.Image = "rbxassetid://6026568198" -- Dumbbell icon
    IconButton.Parent = ScreenGui
    
    -- Make the button draggable
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        IconButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    IconButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = IconButton.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    IconButton.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    return IconButton
end

-- Create the icon button for minimized state
local IconButton = CreateIconButton()

-- Make main frame draggable
do
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- Close and minimize button functionality
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

MinimizeButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    IconButton.Visible = true
end)

IconButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    IconButton.Visible = false
end)

-- Variables for functionality
local autoStrength = false
local autoFarm = false
local autoRebirth = false
local farmSpecificGym = false
local selectedGym = nil
local autoBuyPets = false
local selectedEgg = nil
local lockPosition = false
local originalPosition = nil

-- Main Tab
local mainSection, mainContent = CreateSection("Main", "Farming")

-- Auto Strength Toggle
local autoStrengthToggle = CreateToggle(mainSection, "Auto Strength", function(state)
    autoStrength = state
    
    if state then
        spawn(function()
            while autoStrength and wait(0.01) do
                local args = {
                    [1] = "Strength"
                }
                ReplicatedStorage.RemoteEvent:FireServer(unpack(args))
            end
        end)
    end
end)

-- Fast Auto Farm Toggle
local autoFarmToggle = CreateToggle(mainSection, "Fast Auto Farm", function(state)
    autoFarm = state
    
    if state then
        spawn(function()
            while autoFarm and wait(0.01) do
                for i = 1, 10 do
                    local args = {
                        [1] = "Rep"
                    }
                    ReplicatedStorage.RemoteEvent.Strength:FireServer(unpack(args))
                end
            end
        end)
    end
end)

-- Fast Rebirth Toggle
local autoRebirthToggle = CreateToggle(mainSection, "Fast Rebirth", function(state)
    autoRebirth = state
    
    if state then
        spawn(function()
            while autoRebirth and wait(0.5) do
                local args = {
                    [1] = "Rebirth"
                }
                ReplicatedStorage.RemoteFunction:InvokeServer(unpack(args))
            end
        end)
    end
end)

-- Gym Tab
local gymSection, gymContent = CreateSection("Gym", "Gym Settings")

-- Gym Locations
local gyms = {
    "Starter Gym",
    "Beach Gym",
    "Jungle Gym",
    "Mythical Gym",
    "Legends Gym"
}

local gymLocations = {
    ["Starter Gym"] = CFrame.new(96, 13, -126),
    ["Beach Gym"] = CFrame.new(-12, 13, -1807),
    ["Jungle Gym"] = CFrame.new(-16, 13, -3687),
    ["Mythical Gym"] = CFrame.new(-17, 13, -5574),
    ["Legends Gym"] = CFrame.new(-10, 13, -7679)
}

-- Gym Dropdown
local gymDropdown = CreateDropdown(gymSection, "Select Gym", gyms, function(option)
    selectedGym = option
    print("Selected gym: " .. selectedGym)
end)

-- Farm at Selected Gym Toggle
local farmGymToggle = CreateToggle(gymSection, "Farm at Selected Gym", function(state)
    farmSpecificGym = state
    
    if state and selectedGym then
        spawn(function()
            while farmSpecificGym and selectedGym and wait(0.1) do
                local character = Player.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = character.HumanoidRootPart
                    
                    if gymLocations[selectedGym] and (rootPart.Position - gymLocations[selectedGym].Position).Magnitude > 10 then
                        rootPart.CFrame = gymLocations[selectedGym]
                    end
                    
                    -- Train at the gym
                    local args = {
                        [1] = "Rep"
                    }
                    ReplicatedStorage.RemoteEvent.Strength:FireServer(unpack(args))
                end
            end
        end)
    end
end)

-- Lock Position Toggle
local lockPositionToggle = CreateToggle(gymSection, "Lock Position", function(state)
    lockPosition = state
    
    if state then
        local character = Player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            originalPosition = character.HumanoidRootPart.CFrame
            
            spawn(function()
                while lockPosition and wait(0.1) do
                    character = Player.Character
                    if character and character:FindFirstChild("HumanoidRootPart") and originalPosition then
                        character.HumanoidRootPart.CFrame = originalPosition
                    else
                        lockPosition = false
                        lockPositionToggle.SetState(false)
                    end
                end
            end)
        end
    else
        originalPosition = nil
    end
end)

-- Pets Tab
local petsSection, petsContent = CreateSection("Pets", "Pet Settings")

-- Eggs list
local eggs = {
    "Common Egg",
    "Uncommon Egg",
    "Rare Egg",
    "Epic Egg",
    "Legendary Egg",
    "Golden Egg"
}

-- Egg Dropdown
local eggDropdown = CreateDropdown(petsSection,
