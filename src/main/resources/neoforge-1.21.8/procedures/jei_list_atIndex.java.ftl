(
    new Object() {
        public ${field$type} get(
            <#if field$type == "boolean">
                List<Boolean> list,
            <#elseif field$type == "double">
                List<Double> list,
            <#else>
                List<${field$type}> list,
            </#if>
        int index) {
            ${field$type} content =
            <#if field$type == "ItemStack">
                ItemStack.EMPTY;
            <#elseif field$type == "FluidStack">
                FluidStack.EMPTY;
            <#elseif field$type == "boolean">
                false;
            <#elseif field$type == "double">
                0d;
            <#elseif field$type == "String">
                "";
            </#if>

            if (list.size() > index) {
                content = list.get(${input$index});
            }
            return content;
        }
    }.get(${input$list}, ${opt.toInt(input$index)})
)