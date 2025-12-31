<#include "mcelements.ftl">

new Object() {
	FluidStack getFluidInTank(BlockPos pos, int tank) {
		FluidStack stack = FluidStack.EMPTY;
		if (world instanceof ILevelExtension extension) {
			IFluidHandler fluidHandler = extension.getCapability(Capabilities.FluidHandler.BLOCK, pos, null);
			if (fluidHandler != null) {
				stack = fluidHandler.getFluidInTank(tank);
			}
		}
	    return stack;
    }
}.getFluidInTank(BlockPos.containing(${input$x}, ${input$y}, ${input$z}), ${opt.toInt(input$tank)})