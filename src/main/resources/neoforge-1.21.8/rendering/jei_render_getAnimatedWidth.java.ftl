<#assign dur = input$duration>
<#assign wid = input$width>

(
	((int) (ticks % ${dur}) * (${wid} + 1)) / ${dur}
)