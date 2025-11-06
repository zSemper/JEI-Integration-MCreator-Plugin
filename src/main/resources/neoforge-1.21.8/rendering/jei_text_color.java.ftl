<#assign color = field$HEX>

<#if color?contains("#")>
    ${color?replace("#", "0x")}
<#else>
    <#assign color = "0x" + color>
    ${color}
</#if>