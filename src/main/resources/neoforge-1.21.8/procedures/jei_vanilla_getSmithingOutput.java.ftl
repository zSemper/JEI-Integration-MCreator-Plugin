/*@ItemStack*/

<#include "mcitems.ftl">

new Object() {
    public ItemStack getSmithingResult(ItemStack template, ItemStack base, ItemStack addition) {
        SmithingRecipeInput input = new SmithingRecipeInput(template, base, addition);

        if (world instanceof ServerLevel level) {
            @Nullable
            RecipeHolder<SmithingRecipe> recipe = level.recipeAccess().getRecipeFor(RecipeType.SMITHING, input, level).orElse(null);
            if (recipe != null) {
                return recipe.value().assemble(input, level.registryAccess());
            }
        }
        return ItemStack.EMPTY;
    }
}.getSmithingResult(${mappedMCItemToItemStackCode(input$template)}, ${mappedMCItemToItemStackCode(input$base)}, ${mappedMCItemToItemStackCode(input$addition)})