<#assign io = field$io>

<#if io == "Input">
    new Object() {
        String getItemStackName(Object item) {
            if (item instanceof SizedIngredient sized) {
                return sized.ingredient().isEmpty() ? "" : sized.getItems()[0].getHoverName().getString();
            } else if (item instanceof Ingredient ingre) {
                return ingre.isEmpty() ? "" : ingre.getItems()[0].getHoverName().getString();
            } else if (item instanceof Optional<?> opt && opt.isPresent) {
                if (opt.get() instanceof SizedIngredient sized) {
                    return sized.ingredient().isEmpty() ? "" : sizedO.getItems()[0].getHoverName().getString();
                } else if (opt.get() instanceof Ingredient ingre) {
                    return ingre.isEmpty() ? "" : ingreO.getItems()[0].getHoverName().getString();
                }
            }
            return 0;
        }
    }.getItemStackName(recipe.value().${field$name}Item${io}())
<#elseif io == "Output">
    RecipeUtils.unwrap(recipe.value().${field$name}Item${io}(), ItemStack.class, ItemStack.EMPTY).getHoverName().getString()
</#if>