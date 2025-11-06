(
	new Object() {
		public FluidStack getFluidInTank(LevelAccessor level, BlockPos pos, int tank) {
		    FluidStack stack = FluidStack.EMPTY;
			if (level instanceof ILevelExtension extension) {
				IFluidHandler fluidHandler = extension.getCapability(Capabilities.FluidHandler.BLOCK, pos, null);
				if (fluidHandler != null) {
					stack = fluidHandler.getFluidInTank(tank);
				}
			}
			return stack;
		}
	}.getFluidInTank(world, BlockPos.containing(${input$x}, ${input$y}, ${input$z}), ${opt.toInt(input$tank)})
)