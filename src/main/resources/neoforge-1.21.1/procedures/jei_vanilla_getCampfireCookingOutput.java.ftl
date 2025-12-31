/*@ItemStack*/

<#include "mcitems.ftl">

new Object() {
    ItemStack getCampfireCookingResult(ItemStack item) {
        SingleRecipeInput input = new SingleRecipeInput(item);

        if (world instanceof Level level) {
            @Nullable
            RecipeHolder<CampfireCookingRecipe> recipe = level.getRecipeManager().getRecipeFor(RecipeType.CAMPFIRE_COOKING, input, level).orElse(null);
            if (recipe != null) {
                return recipe.value().assemble(input, level.registryAccess());
            }
        }
        return ItemStack.EMPTY;
    }
}.getCampfireCookingResult(${mappedMCItemToItemStackCode(input$item)})