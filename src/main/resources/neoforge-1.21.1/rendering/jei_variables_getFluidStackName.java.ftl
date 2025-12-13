<#assign io = field$io>

(
    new Object() {
        public String getFluidStackName(Object fluid) {
            <#if io == "Input">
		        if(fluid instanceof SizedFluidIngredient sized) {
			        return sized.ingredient().isEmpty() ? "" : sized.getFluids()[0].getHoverName().getString();
		        } else if(fluid instanceof Optional<?> opt && opt.isPresent()) {
			        if(opt.get() instanceof SizedFluidIngredient sizedO) {
					    return sizedO.ingredient().isEmpty() ? "" : sizedO.getFluids()[0].getHoverName().getString();
			        }
		        }
		        return "";
            <#elseif io == "Output">
                return RecipeUtils.unwrap(recipe.value().${field$name}Fluid${io}(), FluidStack.class, FluidStack.EMPTY).getHoverName().getString();
            </#if>
        }
    }.getFluidStackName(recipe.value().${field$name}Fluid${io}())
)