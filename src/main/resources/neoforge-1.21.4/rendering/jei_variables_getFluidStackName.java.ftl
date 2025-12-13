<#assign io = field$io>

(
    new Object() {
        public String getFluidStackName(Object fluid) {
            <#if io == "Input">
		        if(fluid instanceof SizedFluidIngredient sized) {
			        return sized.ingredient().isEmpty() ? "" : new FluidStack(sized.ingredient().fluids().get(0).value(), 1).getHoverName().getString();
		        } else if(fluid instanceof Optional<?> opt && opt.isPresent()) {
			        if(opt.get() instanceof SizedFluidIngredient sizedO) {
					    return sizedO.ingredient().isEmpty() ? "" : new FluidStack(sized.ingredient().fluids().get(0).value(), 1).getHoverName().getString();
			        }
		        }
		        return "";
            <#elseif io == "Output">
                return RecipeUtils.unwrap(recipe.value().${field$name}Fluid${io}(), FluidStack.class, FluidStack.EMPTY).getHoverName().getString();
            </#if>
        }
    }.getFluidStackName(recipe.value().${field$name}Fluid${io}())
)