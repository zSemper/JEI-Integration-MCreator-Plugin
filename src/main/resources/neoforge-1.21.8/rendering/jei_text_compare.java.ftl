<#assign operator = field$compare?replace("null", "")>

(
    ${operator}${input$in1}.equals(${input$in2})
)