<#assign en = []>

<#assign en += ["${input$text}"]>
<#assign en += input_list$entry>

"" + ${en?join(" + ")}