<#assign dur = input$duration>
<#assign wid = input$width>

(
	((int) (minecraft.level.getGameTime() % ${dur}) * (${wid} + 1)) / ${dur}
)