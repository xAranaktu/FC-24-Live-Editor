require 'imports/core/consts' 
require 'imports/career_mode/helpers'

local FCECareerModeUserManager = {}

function FCECareerModeUserManager:new()
    local o = setmetatable({}, self)

    -- lua metatable
    self.__index = self
    self.__name = "FCE::CareerMode::UserManager"

    self.offsets = {
        mUserInfo = 0x18
    }

    self.user_info_offsets = {
        mUserType = 0x1EC,
        mPlayerType = 0x1F0,
        mPlayerId = 0x1F8,
    }

    return o
end

function FCECareerModeUserManager:GetAddr()
    return GetManagerObjByTypeId(ENUM_FCEGameModesFCECareerModeUserManager)
end

function FCECareerModeUserManager:GetUserInfo(mgr)
    if (mgr == nil) then
        mgr = self:GetAddr()
    end
    if (mgr == 0) then return 0 end

    return MEMORY:ReadPointer(mgr + self.offsets.mUserInfo)
end

-- Return true if in Manager Career Mode
function FCECareerModeUserManager:IsManagerCareer() 
    local user_info = self:GetUserInfo(self:GetAddr())
    if (user_info == 0) then return false end

    return MEMORY:ReadInt(user_info + self.user_info_offsets.mUserType) == 1
end

-- Return true if in Player Career Mode
function FCECareerModeUserManager:IsPlayerCareer() 
    local user_info = self:GetUserInfo(self:GetAddr())
    if (user_info == 0) then return false end

    return MEMORY:ReadInt(user_info + self.user_info_offsets.mUserType) == 2
end

-- Return User PlayerID in Player Career Mode
function FCECareerModeUserManager:GetPAPID()
    local result = 0
    if (self:IsPlayerCareer()) then
        return MEMORY:ReadInt(self:GetUserInfo(self:GetAddr()) + self.user_info_offsets.mPlayerId)
    end

    return result
end

function FCECareerModeUserManager:PlayerIsVPRO()
    local user_info = self:GetUserInfo(self:GetAddr())
    if (user_info == 0) then return false end

    return MEMORY:ReadInt(user_info + self.user_info_offsets.mPlayerType) == 0
end

function FCECareerModeUserManager:PlayerIsRealPlayer()
    local user_info = self:GetUserInfo(self:GetAddr())
    if (user_info == 0) then return false end

    return MEMORY:ReadInt(user_info + self.user_info_offsets.mPlayerType) == 1
end

function FCECareerModeUserManager:PlayerIsCreatedPlayer()
    local user_info = self:GetUserInfo(self:GetAddr())
    if (user_info == 0) then return false end

    return MEMORY:ReadInt(user_info + self.user_info_offsets.mPlayerType) == 2
end

return FCECareerModeUserManager;
