<#include "mcitems.ftl">

<#assign depsBuilder = []>

<#if field$dependencies != "empty">
    <#assign deps = {}>
    <#assign vals = {}>
    <#assign names = field_list$name>
    <#assign depNames = []>

    <#list field$dependencies?split("-") as dep>
        <#assign pair = dep?split(", type: ")>
        <#assign deps += {pair[0] : pair[1]}>
        <#assign depNames += [pair[0]]>
    </#list>

    <#list input_list$arg as arg>
        <#assign vals += {names[arg?index] : arg}>
    </#list>

    <#list depNames as dn>
        <#if deps[dn] == "itemstack">
            <#assign depsBuilder += [mappedMCItemToItemStackCode(vals[dn])]>
        <#elseif deps[dn] == "blockstate">
            <#assign depsBuilder += [mappedBlockToBlockStateCode(vals[dn])]>
        <#else>
            <#assign depsBuilder += [vals[dn]]>
        </#if>
    </#list>
</#if>

${field$procedure}Procedure.execute(
    <#list depsBuilder as dep>
        ${dep}<#sep>,
    </#list>
)