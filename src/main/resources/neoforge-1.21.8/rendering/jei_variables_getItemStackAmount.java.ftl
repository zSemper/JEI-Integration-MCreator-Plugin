<#assign io = field$io>

(
    new Object(){
        public int getItemStackAmount(Object item) {
            <#if io == "Input">
                if(item instanceof SizedIngredient sized) {
                    return sized.ingredient().isEmpty() ? 0 : sized.count();
                } else if(item instanceof Ingredient ingre) {
                    return ingre.isEmpty() ? 0 : 1;
                } else if(item instanceof Optional<?> opt) {
                    if(opt.isPresent()) {
                        Object o = opt.get();
                        if(o instanceof SizedIngredient sizedO) {
                            return sizedO.ingredient().isEmpty() ? 0 : sizedO.count();
                        } else if(o instanceof Ingredient ingreO) {
                            return ingreO.isEmpty() ? 0 : 1;
                        }
                    }
                }
                return 0;
            <#elseif io == "Output">
                return recipe.value().${field$name}Item${io}().getCount();
            </#if>
        }
    }.getItemStackAmount(recipe.value().${field$name}Item${io}())
)