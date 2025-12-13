<#include "mcitems.ftl">
<#assign recipeName = field$recipe?replace("CUSTOM:", "")>
/*@ItemStack*/(

<#assign typeArray = field_list$type>
<#assign nameArray = field_list$name>
<#assign consumeArray = field_list$consume>

    new Object() {
        public ItemStack getResult(
            <#assign head = []>
            <#list input_list$entry as entry>
                <#assign i = entry?index>

                <#if typeArray[i] == "MCItem">
                    <#assign head += ["ItemStack ${nameArray[i]}ItemInput"]>
                <#elseif typeArray[i] == "FluidStack">
                    <#assign head += ["FluidStack ${nameArray[i]}FluidInput"]>
                <#elseif typeArray[i] == "Boolean">
                    <#assign head += ["boolean ${nameArray[i]}LogicInput"]>
                <#elseif typeArray[i] == "Number">
                    <#assign head += ["double[] ${nameArray[i]}NumberInput"]>
                <#elseif typeArray[i] == "String">
                    <#assign head += ["String ${nameArray[i]}StringInput"]>
                </#if>
            </#list>
            ${head?join(", ")}
        ) {
            ItemStack result = ItemStack.EMPTY;
            boolean recipeInputNotConsumed = true;

            for(${recipeName}Recipe recipe : RecipeUtils.getRecipes(world, ${recipeName}Recipe.Type.INSTANCE)) {
                boolean _itemMatch = true
                    <#list input_list$entry as entry>
                        <#assign i = entry?index>

                        <#if typeArray[i] == "MCItem">
                            && RecipeUtils.validate(${nameArray[i]}ItemInput, recipe.${nameArray[i]}ItemInput())
                        </#if>
                    </#list>
                ;
                boolean _fluidMatch = true
                    <#list input_list$entry as entry>
                        <#assign i = entry?index>

                        <#if typeArray[i] == "FluidStack">
                            && RecipeUtils.validate(${nameArray[i]}FluidInput, recipe.${nameArray[i]}FluidInput())
                        </#if>
                    </#list>
                ;
                boolean _logicMatch = true
                    <#list input_list$entry as entry>
                        <#assign i = entry?index>

                        <#if typeArray[i] == "Boolean">
                            && RecipeUtils.validate(${nameArray[i]}LogicInput, recipe.${nameArray[i]}LogicInput())
                        </#if>
                    </#list>
                ;
                boolean _numberMatch = true
                    <#list input_list$entry as entry>
                        <#assign i = entry?index>

                        <#if typeArray[i] == "Number">
                            && RecipeUtils.validate(${nameArray[i]}NumberInput, recipe.${nameArray[i]}NumberInput())
                        </#if>
                    </#list>
                ;
                boolean _textMatch = true
                    <#list input_list$entry as entry>
                        <#assign i = entry?index>

                        <#if typeArray[i] == "String">
                            && RecipeUtils.validate(${nameArray[i]}TextInput, recipe.${nameArray[i]}TextInput())
                        </#if>
                    </#list>
                ;

                if(_itemMatch && _fluidMatch && _logicMatch && _numberMatch && _textMatch) {
                    result = recipe.getItemStackResult("${field$name}");

                    if(recipeInputNotConsumed) {
                        <#list input_list$entry as entry>
                            <#assign i = entry?index>

                            <#if consumeArray[i] == "TRUE">
                                <#if typeArray[i] == "MCItem">
                                    ${nameArray[i]}ItemInput.shrink(RecipeUtils.amount(recipe.${nameArray[i]}ItemInput()));
                                <#elseif typeArray[i] == "FluidStack">
                                    ${nameArray[i]}FluidInput.shrink(RecipeUtils.amount(recipe.${nameArray[i]}FluidInput()));
                                <#elseif typeArray[i] == "Number">
                                    ${nameArray[i]}NumberInput[0] -= RecipeUtils.amount(recipe.${nameArray[i]}NumberInput());
                                </#if>
                            </#if>
                        </#list>

                        recipeInputNotConsumed = false;
                    }

                    break;
                }
            }
        return result;
        }
    }.getResult(
        <#list input_list$entry as entry>
            <#assign i = entry?index>

            <#if typeArray[i] == "MCItem">
                ${mappedMCItemToItemStackCode(entry)}<#sep>,
            <#elseif typeArray[i] == "Number">
                <#if entry?contains("_")>
                    ${entry?replace("[0]", "")}<#sep>,
                <#else>
                    new double[]{${entry}}<#sep>,
                </#if>
            <#else>
                ${entry}<#sep>,
            </#if>
        </#list>
    )
)