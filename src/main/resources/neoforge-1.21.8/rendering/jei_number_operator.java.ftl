<#assign codeEvt = field$operator>
<#assign r1 = input$in1>
<#assign r2 = input$in2>

<#if codeEvt?contains("Math.")>
    <#assign code = codeEvt + "(" + r1 + ", " + r2 + ")">
<#elseif codeEvt == "double/">
    <#assign code = "(double)" + r1 + "/" + r2>
<#else>
    <#assign code = r1 + field$operator + r2>
</#if>

(
    ${code}
)