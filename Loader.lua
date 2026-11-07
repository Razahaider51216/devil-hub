-- DEVIL HUB LOADER
-- ใช้กับ executor: paste แล้วกด Execute

-- Place check
if game.PlaceId ~= 8304191830 then
    warn("[DEVIL HUB] Wrong game — Anime Defenders only (PlaceId: 8304191830)")
    return
end

-- Kill old instance
if game.CoreGui:FindFirstChild("DevilHub") then
    game.CoreGui:FindFirstChild("DevilHub"):Destroy()
end

-- Load main script
local ok, err = pcall(function()
    loadstring(readfile("DevilHub.lua"))()
end)

if not ok then
    warn("[DEVIL HUB] Load failed: " .. tostring(err))
    -- fallback: try from same folder
    pcall(function()
        loadstring(readfile("script/DevilHub.lua"))()
    end)
end
