<#-- Retrieve all values from the else if blocks -->
<#assign inputIF = input_list$IF>
<#assign statementDO = statement_list$DO>

<#-- Remove entry at index 0 since it is the if block -->
<#assign ifList = inputIF[1..]>
<#assign doList = statementDO[1..]>
<#assign elseList = statement_list$ELSE>

if(${input$IF0}) {
    ${statement$DO0}
}

<#-- Check if ifList and doList have content to generate the else if section-->
<#if 0 < ifList?size && 0 < doList?size>
    <#list ifList as if>
        <#assign i = if?index>

        else if (${if}) {
            ${doList[i]}
        }
    </#list>
</#if>

<#-- Check if elseList has content to generate the else section -->
<#if 0 < elseList?size>
    else {
        ${elseList[0]}
    }
</#if>