<#assign io = field$io>

(
    new Object(){
        public String getItemStackName(Object item) {
            <#if io == "Input">
                if(item instanceof SizedIngredient sized) {
                    return sized.ingredient().isEmpty() ? "" : sized.ingredient().getValues().get(0).getName().getString();
                } else if(item instanceof Ingredient ingre) {
                    return ingre.isEmpty() ? "" : ingre.getValues().get(0).getName().getString();
                } else if(item instanceof Optional<?> opt) {
                    if(opt.isPresent()) {
                        Object o = opt.get();
                        if(o instanceof SizedIngredient sizedO) {
                            return sizedO.ingredient().isEmpty() ? "" : sizedO.ingredient().getValues().get(0).getName().getString();
                        } else if(o instanceof Ingredient ingreO) {
                            return ingreO.isEmpty() ? "" : ingreO.getValues().get(0).getName().getString();
                        }
                    }
                }
                return "";
            <#elseif io == "Output">
                return recipe.value().${field$name}Item${io}().getHoverName().getString();
            </#if>
        }
    }.getItemStackName(recipe.value().${field$name}Item${io}())
)