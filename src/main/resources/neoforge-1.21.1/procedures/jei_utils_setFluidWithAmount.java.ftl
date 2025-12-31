new Object() {
    void setFluidWithAmount(BlockPos pos, int tank, FluidStack stack) {
        if (world instanceof ILevelExtension extension && !stack.isEmpty()) {
            IFluidHandler fluidHandler = extension.getCapability(Capabilities.FluidHandler.BLOCK, pos, null);
            if (fluidHandler != null) {
                int fluidAmount = fluidHandler.getFluidInTank(tank).getAmount() + stack.getAmount();
                if (fluidAmount > fluidHandler.getTankCapacity(tank)) {
                    fluidAmount = fluidHandler.getTankCapacity(tank);
                }

			    try {
				    var method = fluidHandler.getClass().getMethod("getTank", int.class);
				    method.setAccessible(true);
				    Object tankObj = method.invoke(fluidHandler, tank);
				    if (tankObj instanceof FluidTank fTank) {
				         fTank.setFluid(new FluidStack(stack.getFluid(), fluidAmount));
				    } else {
				        if (fluidHandler instanceof FluidTank fTankA) {
				            fTankA.setFluid(new FluidStack(stack.getFluid(), fluidAmount));
				        } else {
				            fluidHandler.fill(stack.copy(), IFluidHandler.FluidAction.EXECUTE);
				        }
				    }
			    } catch (NoSuchMethodException fallback) {
				    if (fluidHandler instanceof FluidTank fTankF) {
				        fTankF.setFluid(new FluidStack(stack.getFluid(), fluidAmount));
				    } else {
				        fluidHandler.fill(stack.copy(), IFluidHandler.FluidAction.EXECUTE);
				    }
			    } catch (IllegalAccessException | InvocationTargetException e) {
				    e.printStackTrace();
			    }
            }
        }
    }
}.setFluidWithAmount(BlockPos.containing(${input$x}, ${input$y}, ${input$z}), ${opt.toInt(input$tank)}, ${input$fluid});
