<#include "../mcitems.ftl">

<#assign recipeType = w.hasElementsOfType("recipe_type")?then(w.getGElementsOfType("recipe_type")?filter(recipeType -> recipeType.name == data.category), "")>
<#assign type = recipeType?has_content?then(recipeType[0], "")>

<#compress>
{
    "type": "${modid}:${data.recipeType}",
    <#list data.inputs as input>
        <#if input.type == "Item">
            <#if type != "">
                <#assign singleIndex = -1>

                <#list type.slotList as slot>
                    <#if input.name == slot.name && slot.io == "Input">
                        <#assign singleIndex = slot?index>
                        <#break>
                    </#if>
                </#list>

                <#if singleIndex != -1>
                    <#if type.slotList.get(singleIndex).singleItem>
                        "${input.name}": "${mappedMCItemToRegistryName(input.itemId, true)}",
                    <#else>
                        "${input.name}": {
                            "ingredient": "${mappedMCItemToRegistryName(input.itemId, true)}",
                            "count": ${input.itemAmount}
                        },
                    </#if>
                <#else>
                    "${input.name}": {
                        "ingredient": "${mappedMCItemToRegistryName(input.itemId, true)}",
                        "count": ${input.itemAmount}
                    },
                </#if>
            <#else>
                "${input.name}": {
                    "ingredient": "${mappedMCItemToRegistryName(input.itemId, true)}",
                    "count": ${input.itemAmount}
                },
            </#if>
        <#elseif input.type == "Fluid">
            "${input.name}": {
                <#assign registryFluid = mappedMCItemToRegistryName(input.fluidId, true)>
                <#if registryFluid?contains("_get()")>
                    <#assign fluid = registryFluid?replace("_get()", "")>
                <#else>
                    <#assign fluid = registryFluid>
                </#if>
                "ingredient": "${fluid}",
                "amount": ${input.fluidAmount}
            },
        <#elseif input.type == "Logic">
            "${input.name}": ${input.logic},
        <#elseif input.type == "Number">
            "${input.name}": ${input.number},
        <#elseif input.type == "Text">
            "${input.name}": "${input.text}",
        </#if>
    </#list>
        <#list data.outputs as output>
            <#if output.type == "Item">
                "${output.name}": {
                    ${mappedMCItemToItemObjectJSON(output.itemId, "id")},
                    "count": ${output.itemAmount}
                },
            <#elseif output.type == "Fluid">
                "${output.name}": {
                    <#assign registryFluid = mappedMCItemToItemObjectJSON(output.fluidId, "id")>
                    <#if registryFluid?contains("_get()")>
                        <#assign fluid = registryFluid?replace("_get()", "")>
                    <#else>
                        <#assign fluid = registryFluid>
                    </#if>
                    ${fluid},
                    "amount": ${output.fluidAmount}
                },
            <#elseif output.type == "Logic">
                "${output.name}": ${output.logic},
            <#elseif output.type == "Number">
                "${output.name}": ${output.number},
            <#elseif output.type == "Text">
                "${output.name}": "${output.text}",
            </#if>
        </#list>
    "category": [
        "misc"
    ]
}
</#compress>