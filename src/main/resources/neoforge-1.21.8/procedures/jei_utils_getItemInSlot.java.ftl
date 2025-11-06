/*@ItemStack*/
(
    new Object() {
        public ItemStack getItemInSlot(LevelAccessor level, BlockPos pos, int slot) {
            ItemStack stack = ItemStack.EMPTY;
	        if(level instanceof ILevelExtension extension) {
		        IItemHandler itemHandler = extension.getCapability(Capabilities.ItemHandler.BLOCK, pos, null);
		        if(itemHandler != null) {
		            stack = itemHandler.getStackInSlot(slot);
		        }
	        }
	        return stack;
        }
    }.getItemInSlot(world, BlockPos.containing(${input$x}, ${input$y}, ${input$z}), ${opt.toInt(input$slot)})
)