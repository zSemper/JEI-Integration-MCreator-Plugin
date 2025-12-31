<#assign io = field$io>

<#if io == "Input">
    new Object() {
        int getItemStackAmount(Object item) {
            if (item instanceof SizedIngredient sized) {
                return sized.ingredient().isEmpty() ? 0 : sized.count();
            } else if (item instanceof Ingredient ingre) {
                return ingre.isEmpty() ? 0 : 1;
            } else if (item instanceof Optional<?> opt && opt.isPresent) {
                if (opt.get() instanceof SizedIngredient sized) {
                    return sized.ingredient().isEmpty() ? 0 : sized.count();
                } else if (opt.get() instanceof Ingredient ingre) {
                    return ingre.isEmpty() ? 0 : 1;
                }
            }
            return 0;
        }
    }.getItemStackAmount(recipe.value().${field$name}Item${io}())
<#elseif io == "Output">
    RecipeUtils.unwrap(recipe.value().${field$name}Item${io}(), ItemStack.class, ItemStack.EMPTY).getCount()
</#if>