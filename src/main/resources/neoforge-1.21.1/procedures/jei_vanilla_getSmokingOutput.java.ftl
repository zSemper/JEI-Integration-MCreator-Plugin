/*@ItemStack*/

<#include "mcitems.ftl">

new Object() {
    ItemStack getSmokingResult(ItemStack item) {
        SingleRecipeInput input = new SingleRecipeInput(item);

        if (world instanceof Level level) {
            @Nullable
            RecipeHolder<SmokingRecipe> recipe = level.getRecipeManager().getRecipeFor(RecipeType.SMOKING, input, level).orElse(null);
            if (recipe != null) {
                return recipe.value().assemble(input, level.registryAccess());
            }
        }
        return ItemStack.EMPTY;
    }
}.getSmokingResult(${mappedMCItemToItemStackCode(input$item)})