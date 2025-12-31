<#assign io = field$io>

<#if io == "Input">
    new Object() {
        String getFluidStackName(Object fluid) {
            if (fluid instanceof SizedFluidIngredient sized) {
                return sized.ingredient().isEmpty() ? "" : sized.getFluids()[0].getHoverName().getString();
            } else if (fluid instanceof Optional<?> opt && opt.isPresent()) {
                if (opt.get() instanceof SizedFluidIngredient sized) {
                    return sized.ingredient().isEmpty() ? "" : sized.getFluids()[0].getHoverName().getString();
                }
            }
            return 0;
        }.getFluidStackName(recipe.value().${field$name}Fluid${io}())
    }
<#elseif io == "Output">
    RecipeUtils.unwrap(recipe.value().${field$name}Fluid${io}(), FluidStack.class, FluidStack.EMPTY).getHoverName().getString()
</#if>