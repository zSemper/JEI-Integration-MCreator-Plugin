<#assign io = field$io>

<#if io == "Input">
    new Object() {
        int getFluidStackAmount(Object fluid) {
            if (fluid instanceof SizedFluidIngredient sized) {
                return sized.ingredient().isEmpty() ? 0 : sized.amount();
            } else if (fluid instanceof Optional<?> opt && opt.isPresent()) {
                if (opt.get() instanceof SizedFluidIngredient sized) {
                    return sized.ingredient().isEmpty() ? 0 : sized.amount();
                }
            }
            return 0;
        }.getFluidStackAmount(recipe.value().${field$name}Fluid${io}())
    }
<#elseif io == "Output">
    RecipeUtils.unwrap(recipe.value().${field$name}Fluid${io}(), FluidStack.class, FluidStack.EMPTY).getAmount()
</#if>