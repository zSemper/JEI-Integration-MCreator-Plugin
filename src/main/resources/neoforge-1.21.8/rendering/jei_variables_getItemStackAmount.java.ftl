<#assign io = field$io>

(
    new Object(){
        public int getItemStackAmount(Object item) {
            <#if io == "Input">
                if(item instanceof SizedIngredient sized) {
                    return sized.ingredient().isEmpty() ? 0 : sized.count();
                } else if(item instanceof Ingredient ingre) {
                    return ingre.isEmpty() ? 0 : 1;
                } else if(item instanceof Optional<?> opt && opt.isPresent()) {
                    if(opt.get() instanceof SizedIngredient sizedO) {
                        return sizedO.ingredient().isEmpty() ? 0 : sizedO.count();
                    } else if(opt.get() instanceof Ingredient ingreO) {
                        return ingreO.isEmpty() ? 0 : 1;
                    }
                }
                return 0;
            <#elseif io == "Output">
                return RecipeUtils.unwrap(recipe.value().${field$name}Item${io}(), ItemStack.class, ItemStack.EMPTY).getCount();
            </#if>
        }
    }.getItemStackAmount(recipe.value().${field$name}Item${io}())
)