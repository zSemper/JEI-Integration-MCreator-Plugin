(
    new Object() {
        public ${field$type} getRandomResult(
            <#if field$type == "boolean">
                List<Boolean> list
            <#elseif field$type == "double">
                List<Double> list
            <#else>
                List<${field$type}> list
            </#if>
        ) {
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

            if (list.size() > 0) {
                int index = Mth.nextInt(RandomSource.create(), 0, list.size() - 1);
                content = list.get(index);
            }
            return content;
        }
    }.getRandomResult(${input$list})
)