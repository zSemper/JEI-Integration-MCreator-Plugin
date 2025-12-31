<#include "mcitems.ftl">

<#assign recipeName = field$recipe?replace("CUSTOM:", "")>
<#assign typeArray = field_list$type>
<#assign nameArray = field_list$name>

for (${recipeName}Recipe recipeIterator : RecipeUtils.getRecipes(world, ${recipeName}Recipe.Type.INSTANCE)) {
    boolean _itemMatch${cbi} = true
        <#list input_list$entry as entry>
            <#assign i = entry?index>

            <#if typeArray[i] == "MCItem">
                 && RecipeUtils.validate(${mappedMCItemToItemStackCode(entry)}, recipeIterator.${nameArray[i]}ItemInput())
            </#if>
        </#list>
    ;
    boolean _fluidMatch${cbi} = true
        <#list input_list$entry as entry>
            <#assign i = entry?index>

            <#if typeArray[i] == "FluidStack">
                 && RecipeUtils.validate(${entry}, recipeIterator.${nameArray[i]}FluidInput())
            </#if>
        </#list>
    ;
    boolean _logicMatch${cbi}= true
        <#list input_list$entry as entry>
            <#assign i = entry?index>

            <#if typeArray[i] == "Boolean">
                 && RecipeUtils.validate(${entry}, recipeIterator.${nameArray[i]}LogicInput())
            </#if>
        </#list>
    ;
    boolean _numberMatch${cbi} = true
        <#list input_list$entry as entry>
            <#assign i = entry?index>

            <#if typeArray[i] == "Number">
                <#if entry?contains("_")>
                     && RecipeUtils.validate(${entry?replace("[0]", "")}, recipeIterator.${nameArray[i]}NumberInput())
                <#else>
                     && RecipeUtils.validate(new double[]{${entry}}, recipeIterator.${nameArray[i]}NumberInput())
                </#if>
            </#if>
        </#list>
    ;
    boolean _textMatch${cbi} = true
        <#list input_list$entry as entry>
            <#assign i = entry?index>

            <#if typeArray[i] == "String">
                 && RecipeUtils.validate(${entry}, recipeIterator.${nameArray[i]}TextInput())
            </#if>
        </#list>
    ;

    if (_itemMatch${cbi} && _fluidMatch${cbi} && _logicMatch${cbi} && _numberMatch${cbi} && _textMatch${cbi}) {
        ${statement$foreach}
    }
}