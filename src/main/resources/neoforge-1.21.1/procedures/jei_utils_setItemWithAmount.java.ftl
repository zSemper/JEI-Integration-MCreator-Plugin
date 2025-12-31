<#include "mcitems.ftl">

new Object() {
    void setItemWithAmount(BlockPos pos, int slot, ItemStack stack) {
        if (world instanceof ILevelExtension extension && !stack.isEmpty()) {
            IItemHandler itemHandler = extension.getCapability(Capabilities.ItemHandler.BLOCK, pos, null);
            if (itemHandler != null) {
                int itemAmount = itemHandler.getStackInSlot(slot).getCount() + stack.getCount();
                if (itemAmount > 64) {
                    itemAmount = 64;
                }

                if (itemHandler instanceof IItemHandlerModifiable modify) {
                    modify.setStackInSlot(slot, new ItemStack(stack.getItem(), itemAmount));
                }
            }
        }
    }
}.setItemWithAmount(BlockPos.containing(${input$x}, ${input$y}, ${input$z}), ${opt.toInt(input$slot)}, ${mappedMCItemToItemStackCode(input$item)});
