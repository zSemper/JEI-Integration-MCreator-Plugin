<#include "mcitems.ftl">
/*@ItemStack*/

(
    new Object() {
        public ItemStack getBlastingResult(ItemStack item) {
            SingleRecipeInput input = new SingleRecipeInput(item);

            if(world instanceof Level level) {
                @Nullable
                RecipeHolder<BlastingRecipe> recipe = level.getRecipeManager().getRecipeFor(RecipeType.BLASTING, input, level).orElse(null);
                if(recipe != null) {
                    return recipe.value().assemble(input, level.registryAccess());
                }
            }
            return ItemStack.EMPTY;
        }
    }.getBlastingResult(${mappedMCItemToItemStackCode(input$item)})
)