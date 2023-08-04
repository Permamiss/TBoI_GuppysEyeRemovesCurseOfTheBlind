local GuppysEyeRemovesBlindCurse = RegisterMod("Guppy's Eye Isn't Blind", 1)
local COB_MASK = LevelCurse.CURSE_OF_BLIND

local function removeCurseOfBlind()
	local bitMask = Game():GetLevel():GetCurses()

	if COB_MASK & bitMask == COB_MASK then -- if Curse of the Blind is found within the total curses, then
		Game():GetLevel():RemoveCurses(COB_MASK)
	end
end

---@param pickup EntityPickup
---@param collider Entity
function GuppysEyeRemovesBlindCurse:BeforePickupCollision(pickup, collider)
	if collider:ToPlayer() and pickup.Type == EntityType.ENTITY_PICKUP and pickup.SubType == CollectibleType.COLLECTIBLE_GUPPYS_EYE then -- if player collided with Guppy's Eye, then
		removeCurseOfBlind()
	end
end

function GuppysEyeRemovesBlindCurse:OnNewFloor()
	for i = 0, Game():GetNumPlayers() - 1 do
		if Game():GetPlayer(i):HasCollectible(CollectibleType.COLLECTIBLE_GUPPYS_EYE) then -- if any player has Guppy's Eye, then
			removeCurseOfBlind()
		end
	end
end

---@param isContinued boolean
function GuppysEyeRemovesBlindCurse:OnGameStart(isContinued)
	if isContinued then -- if an existing run was continued, do the check for the curse
		GuppysEyeRemovesBlindCurse:OnNewFloor()
	end
end

GuppysEyeRemovesBlindCurse:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, GuppysEyeRemovesBlindCurse.BeforePickupCollision, PickupVariant.PICKUP_COLLECTIBLE)
GuppysEyeRemovesBlindCurse:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, GuppysEyeRemovesBlindCurse.OnNewFloor)
GuppysEyeRemovesBlindCurse:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, GuppysEyeRemovesBlindCurse.OnGameStart)