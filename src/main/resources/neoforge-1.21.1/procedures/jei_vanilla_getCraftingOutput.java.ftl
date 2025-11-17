<#include "mcitems.ftl">
/*@ItemStack*/

(
    new Object() {
        public ItemStack getCraftingResult(List<ItemStack> inputs) {
            CraftingInput input = CraftingInput.of(3, 3, inputs);

            if(world instanceof Level level) {
                @Nullable
                RecipeHolder<CraftingRecipe> recipe = level.getRecipeManager().getRecipeFor(RecipeType.CRAFTING, input, level).orElse(null);
                if(recipe != null) {
                    return recipe.value().assemble(input, level.registryAccess());
                }
            }
            return ItemStack.EMPTY;
        }
    }.getCraftingResult(
        List.of(
            ${mappedMCItemToItemStackCode(input$r1c1)}, ${mappedMCItemToItemStackCode(input$r1c2)}, ${mappedMCItemToItemStackCode(input$r1c3)},
            ${mappedMCItemToItemStackCode(input$r2c1)}, ${mappedMCItemToItemStackCode(input$r2c2)}, ${mappedMCItemToItemStackCode(input$r2c3)},
            ${mappedMCItemToItemStackCode(input$r3c1)}, ${mappedMCItemToItemStackCode(input$r3c2)}, ${mappedMCItemToItemStackCode(input$r3c3)}
        )
    )
)