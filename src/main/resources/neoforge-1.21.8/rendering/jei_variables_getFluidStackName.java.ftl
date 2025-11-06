<#assign io = field$io>

(
    new Object() {
        public String getFluidStackName(Object fluid) {
            <#if io == "Input">
		        if(fluid instanceof SizedFluidIngredient sized) {
			        return sized.ingredient().isEmpty() ? "" : new FluidStack(sized.ingredient().fluids().get(0).value(), 1).getHoverName().getString();
		        } else if(fluid instanceof Optional<?> opt) {
			        if(opt.isPresent()) {
        				Object o = opt.get();
				        if(opt.get() instanceof SizedFluidIngredient sizedO) {
					        return sizedO.ingredient().isEmpty() ? "" : new FluidStack(sized.ingredient().fluids().get(0).value(), 1).getHoverName().getString();
				        }
			        }
		        }
		        return "";
            <#elseif io == "Output">
                return recipe.value().${field$name}Fluid${io}().getHoverName().getString();
            </#if>
        }
    }.getFluidStackName(recipe.value().${field$name}Fluid${io}())
)