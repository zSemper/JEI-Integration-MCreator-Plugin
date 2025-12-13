<#assign io = field$io>

(
    new Object() {
        public int getFluidStackAmount(Object fluid) {
            <#if io == "Input">
		        if(fluid instanceof SizedFluidIngredient sized) {
			        return sized.ingredient().fluids().isEmpty() ? 0 : sized.amount();
		        } else if(fluid instanceof Optional<?> opt && opt.isPresent()) {
			        if(opt.get() instanceof SizedFluidIngredient sizedO) {
					    return sizedO.ingredient().fluids().isEmpty() ? 0 : sizedO.amount();
			        }
		        }
		        return 0;
            <#elseif io == "Output">
                return RecipeUtils.unwrap(recipe.value().${field$name}Fluid${io}(), FluidStack.class, FluidStack.EMPTY).getAmount();
            </#if>
        }
    }.getFluidStackAmount(recipe.value().${field$name}Fluid${io}())
)