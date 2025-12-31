<#include "mcitems.ftl">

new Object() {
    boolean contains(
        <#if field$type == "boolean">
            List<Boolean> list,
        <#elseif field$type == "double">
            List<Double> list,
        <#else>
            List<${field$type}> list,
        </#if>
    ${field$type} check) {
        boolean contains = false;
        if (list.size() > 0) {
            for (${field$type} o : list) {
                <#if field$type == "ItemStack">
                    if(o.is(check.getItem())) {
                <#elseif field$type == "FluidStack">
                    if(o.is(check.getFluid())) {
                <#elseif field$type == "String">
                    if(o.equals(check)) {
                <#else>
                    if(o == check) {
                </#if>
                    contains = true;
                    break;
                }
            }
        }
        return contains;
     }
}.contains(${input$list},
<#if field$type == "ItemStack">
    ${mappedMCItemToItemStackCode(input$check)})
<#else>
    ${input$check})
</#if>