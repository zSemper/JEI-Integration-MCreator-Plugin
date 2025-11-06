<#assign io = field$io>

(
    new Object() {
        public int getFluidStackAmount(Object fluid) {
            <#if io == "Input">
		        if(fluid instanceof SizedFluidIngredient sized) {
			        return sized.ingredient().isEmpty() ? 0 : sized.amount();
		        } else if(fluid instanceof Optional<?> opt) {
			        if(opt.isPresent()) {
        				Object o = opt.get();
				        if(opt.get() instanceof SizedFluidIngredient sizedO) {
					        return sizedO.ingredient().isEmpty() ? 0 : sizedO.amount();
				        }
			        }
		        }
		        return 0;
            <#elseif io == "Output">
                return recipe.value().${field$name}Fluid${io}().getAmount();
            </#if>
        }
    }.getFluidStackAmount(recipe.value().${field$name}Fluid${io}())
)