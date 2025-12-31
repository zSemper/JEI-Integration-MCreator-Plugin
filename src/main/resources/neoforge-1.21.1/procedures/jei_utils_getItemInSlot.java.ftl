/*@ItemStack*/

<#include "mcelements.ftl">

new Object() {
    ItemStack getItemInSlot(BlockPos pos, int slot) {
        ItemStack stack = ItemStack.EMPTY;
	    if (world instanceof ILevelExtension extension) {
		    IItemHandler itemHandler = extension.getCapability(Capabilities.ItemHandler.BLOCK, pos, null);
		    if (itemHandler != null) {
		        stack = itemHandler.getStackInSlot(slot);
		    }
	    }
	    return stack;
    }
}.getItemInSlot(BlockPos.containing(${input$x}, ${input$y}, ${input$z}), ${opt.toInt(input$slot)})