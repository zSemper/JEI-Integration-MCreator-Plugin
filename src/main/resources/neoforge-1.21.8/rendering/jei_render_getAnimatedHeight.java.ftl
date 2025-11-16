<#assign dur = input$duration>
<#assign hei = input$height>

(
	((int) (minecraft.level.getGameTime() % ${dur}) * (${hei} + 1)) / ${dur}
)