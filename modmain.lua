local Ingredient = GLOBAL.Ingredient

-- TODO:
--   enable/disable the bird feather fall via mod config.
--   set custom feather fall time via mod config.
--   set custom feather amount via mod config.


-- get the original recipe, if the recipe not exists print message
local original_recipe = GLOBAL.AllRecipes["featherpencil"]
if not original_recipe then
    print("A recipe for 'featherpencil' does not exists!")
    return
end


-- Feather Pencil using "crimson" feather
local featherpencil_robin = AddRecipe(
    "featherpencil_robin",
    {
        Ingredient("twigs", 1),
        Ingredient("charcoal", 1),
        Ingredient("feather_robin", 1)
    },
    original_recipe.tab,
    original_recipe.level,
    original_recipe.placer,
    original_recipe.min_spacing,
    original_recipe.nounlock,
    original_recipe.numtogive,
    original_recipe.builder_tag,
    original_recipe.atlas,
    original_recipe.image,
    original_recipe.testfn,
    "featherpencil"
)
-- sort index below original recipe
featherpencil_robin.sortkey = original_recipe.sortkey + 0.5

-- Feather Pencil using "Azure" feather
local featherpencil_robin_winter = AddRecipe(
    "featherpencil_robin_winter",
    {
        Ingredient("twigs", 1),
        Ingredient("charcoal", 1),
        Ingredient("feather_robin_winter", 1)
    },
    original_recipe.tab,
    original_recipe.level,
    original_recipe.placer,
    original_recipe.min_spacing,
    original_recipe.nounlock,
    original_recipe.numtogive,
    original_recipe.builder_tag,
    original_recipe.atlas,
    original_recipe.image,
    original_recipe.testfn,
    "featherpencil"
)
-- sort index below original recipe
featherpencil_robin_winter.sortkey = original_recipe.sortkey + 0.75


local function ShouldSleep(inst)
    local bird = GetBird(inst)
    return GLOBAL.TheWorld.state.isnight and GetHunger(bird) >= 0.33
end

local function ShouldWake(inst)
    local bird = GetBird(inst)
    return GLOBAL.TheWorld.state.isday or GetHunger(bird) < 0.33
end

---
---
---
---
---

local CAGE_STATES =
{
    DEAD = "_death",
    SKELETON = "_skeleton",
    EMPTY = "_empty",
    FULL = "_bird",
}

local function SetBirdType(inst, bird)
    inst.bird_type = bird
    inst.AnimState:AddOverrideBuild(inst.bird_type.."_build")
end

local function SetCageState(inst, state)
    inst.CAGE_STATE = state
end

local function GetCageState(inst)
    return inst.CAGE_STATE
end

--Only use for hit and idle anims
local function PlayStateAnim(inst, anim, loop)
    inst.AnimState:PlayAnimation(anim..inst.CAGE_STATE, loop)
end

--Only use for hit and idle anims
local function PushStateAnim(inst, anim, loop)
    inst.AnimState:PushAnimation(anim..inst.CAGE_STATE, loop)
end

local function GetBird(inst)
    return (inst.components.occupiable and inst.components.occupiable:GetOccupant()) or nil
end

local function GetHunger(bird)
    return (bird and bird.components.perishable and bird.components.perishable:GetPercent()) or 1
end

-- NOTE: maybe we should replace this for the original function
local function DigestFoodMod(inst, food)
    if food.components.edible.foodtype == GLOBAL.FOODTYPE.MEAT then
        inst.components.lootdropper:SpawnLootPrefab("bird_egg")
    else
        local seed_name = string.lower(food.prefab .. "_seeds")
        if GLOBAL.Prefabs[seed_name] ~= nil then
            local num_seeds = math.random(1, 5)  -- TODO: use mod settings for min and max values
            for k = 1, num_seeds do
                inst.components.lootdropper:SpawnLootPrefab(seed_name)
            end
            if math.random() < 0.75 then
                inst.components.lootdropper:SpawnLootPrefab("seeds")
            end
        else
            if math.random() < 0.33 then
                local loot = inst.components.lootdropper:SpawnLootPrefab("guano")
                loot.Transform:SetScale(.33, .33, .33)
            end
        end
	end
    local bird = GetBird(inst)
    if bird and bird:IsValid() and bird.components.perishable then
        bird.components.perishable:SetPercent(1)
    end
end

-- NOTE: maybe we should replace this for the original function
local function OnGetItemMod(inst, giver, item)
    if inst.components.sleeper and inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end

    if item.components.edible ~= nil and
        (   item.components.edible.foodtype == GLOBAL.FOODTYPE.MEAT
            or item.prefab == "seeds"
            or GLOBAL.Prefabs[string.lower(item.prefab .. "_seeds")] ~= nil
        ) then
        inst.AnimState:PlayAnimation("peck")
        inst.AnimState:PushAnimation("peck")
        inst.AnimState:PushAnimation("peck")
        inst.AnimState:PushAnimation("hop")
        PushStateAnim(inst, "idle", true)
		
        inst:DoTaskInTime(60 * GLOBAL.FRAMES, DigestFoodMod, item)
    end
end

function find_bird(var1)

    local bird_names =
	{
	    "robin_winter",
	    "crow",
	    "robin",
	    "canary",
	}
    
    for i=1,4 do
	local var2 = string.match (var1, bird_names[i])
	if var2 ~= nil then
	    return var2
	end
    end
end

local function ShouldSleep(inst)
    local bird = GetBird(inst)
    return GLOBAL.TheWorld.state.isnight and GetHunger(bird) >= 0.33
end

local function ShouldWake(inst)
    local bird = GetBird(inst)
    return GLOBAL.TheWorld.state.isday or GetHunger(bird) < 0.33
end

local function DoAnimationTask(inst)
    local bird = GetBird(inst)
    local hunger = GetHunger(bird)
    local rand = math.random()

    if hunger < 0.33 then
        if rand < 0.75 then
            inst.AnimState:PlayAnimation("idle_bird3")

            inst:DoTaskInTime(5 * GLOBAL.FRAMES, function() inst.SoundEmitter:PlaySound("dontstarve/birds/wingflap_cage") end)
            inst:DoTaskInTime(15 * GLOBAL.FRAMES, function() inst.SoundEmitter:PlaySound("dontstarve/birds/wingflap_cage") end)
            inst:DoTaskInTime(28 * GLOBAL.FRAMES, function() inst.SoundEmitter:PlaySound("dontstarve/birds/wingflap_cage") end)

            inst:DoTaskInTime(4 * GLOBAL.FRAMES, function() inst.SoundEmitter:PlaySound(bird.sounds.chirp) end)
            inst:DoTaskInTime(27 * GLOBAL.FRAMES, function() inst.SoundEmitter:PlaySound(bird.sounds.chirp) end)
            inst:DoTaskInTime(42 * GLOBAL.FRAMES, function() inst.SoundEmitter:PlaySound(bird.sounds.chirp) end)
            inst:DoTaskInTime(100 * GLOBAL.FRAMES, function() inst.SoundEmitter:PlaySound(bird.sounds.chirp) end)
        end
    elseif hunger < 0.66 then
        if rand < 0.5 then

            inst:DoTaskInTime(26 * GLOBAL.FRAMES, function() inst.SoundEmitter:PlaySound(bird.sounds.chirp) end)
            inst:DoTaskInTime(81 * GLOBAL.FRAMES, function() inst.SoundEmitter:PlaySound(bird.sounds.chirp) end)
            inst:DoTaskInTime(96 * GLOBAL.FRAMES, function() inst.SoundEmitter:PlaySound(bird.sounds.chirp) end)
        end
    else
        if rand < 0.5 then
            inst.AnimState:PlayAnimation("caw")
            if inst.chirpsound then
                inst.SoundEmitter:PlaySound(inst.chirpsound)
            end
        elseif rand < 0.6 then
            inst.AnimState:PlayAnimation("flap")
            inst.SoundEmitter:PlaySound("dontstarve/birds/wingflap_cage")
        else
            inst.AnimState:PlayAnimation("hop")
        end
	end
    PushStateAnim(inst, "idle", true)
end
local function StartAnimationTask(inst)
    inst.AnimationTask = inst:DoPeriodicTask(6, DoAnimationTask)
end

local function StopAnimationTask(inst)
    if inst.AnimationTask then
        inst.AnimationTask:Cancel()
        inst.AnimationTask = nil
    end
end

local function OnOccupied(inst, bird)
    SetCageState(inst, CAGE_STATES.FULL)
    -- add feathers and initialize it
    inst:AddComponent("feathers") -- component from "/scripts/components/feathers.lua"
    -- "Create" a Feathers class in order to drop feathers periodically
    local var = tostring(inst.components.occupiable.occupant)
    local nam = find_bird(var)
    inst.components.feathers.birdname = nam
	
    inst:AddComponent("sleeper")
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetWakeTest(ShouldWake)

    
    inst.components.trader:Enable()

    
    SetBirdType(inst, bird.prefab)

    inst.chirpsound = bird.sounds and bird.sounds.chirp
    inst.AnimState:PlayAnimation("flap")
    inst.SoundEmitter:PlaySound("dontstarve/birds/wingflap_cage")
    PushStateAnim(inst, "idle", true)
	
	
    StartAnimationTask(inst)
end

local function OnEmptied(inst, bird)
    inst.components.feathers.birdname = nil
    inst:RemoveComponent("feathers")
	
    SetCageState(inst, CAGE_STATES.EMPTY)

    inst:RemoveComponent("sleeper")

    inst.components.trader:Disable()

    PlayStateAnim(inst,"idle", true)

    StopAnimationTask(inst)
end

local function OnBirdStarve(inst, bird)
	if inst.components.feathers then
		inst.components.feathers.birdname = nil
		inst:RemoveComponent("feathers")
	end
	
    SetCageState(inst, CAGE_STATES.DEAD)
    
    inst.AnimState:PlayAnimation("death")
    PushStateAnim(inst, "idle", false)

    local loot = GLOBAL.SpawnPrefab("smallmeat")
    inst.components.inventory:GiveItem(loot)
    inst.components.shelf:PutItemOnShelf(loot)
end


function birdcagePrefabPostInit(inst)
    if inst and inst.components.trader then
	inst.components.trader.onaccept = OnGetItemMod
    end
    
    if inst and inst.components.occupiable then
	inst.components.occupiable.onoccupied = OnOccupied
	inst.components.occupiable.onperishfn = OnBirdStarve
    end
    
    if inst and inst.components.occupiable then
	inst.components.occupiable.onemptied = OnEmptied
    end
end

AddPrefabPostInit("birdcage", birdcagePrefabPostInit)



function featherPRefabPostInit(inst)
    if not inst:HasTag("feather") then
	inst:AddTag("feather")
    end
end

AddPrefabPostInit("feather_crow", featherPrefabPostInit)
AddPrefabPostInit("feather_robin", featherPrefabPostInit)
AddPrefabPostInit("feather_robin_winter", featherPrefabPostInit)
AddPrefabPostInit("feather_canary", featherPrefabPostInit)
