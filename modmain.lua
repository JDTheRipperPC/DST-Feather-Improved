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
