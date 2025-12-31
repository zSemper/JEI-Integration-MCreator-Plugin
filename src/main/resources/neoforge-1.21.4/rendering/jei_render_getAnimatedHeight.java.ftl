<#assign dur = input$duration>
<#assign hei = input$height>

((int) (ticks % ${dur}) * (${hei} + 1)) / ${dur}