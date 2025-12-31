/*@ItemStack*/

<#include "mcitems.ftl">

new Object() {
    ItemStack getSmeltingResult(ItemStack item) {
        SingleRecipeInput input = new SingleRecipeInput(item);

        if (world instanceof Level level) {
            @Nullable
            RecipeHolder<SmeltingRecipe> recipe = level.getRecipeManager().getRecipeFor(RecipeType.SMELTING, input, level).orElse(null);
            if (recipe != null) {
                return recipe.value().assemble(input, level.registryAccess());
            }
        }
        return ItemStack.EMPTY;
    }
}.getSmeltingResult(${mappedMCItemToItemStackCode(input$item)})
