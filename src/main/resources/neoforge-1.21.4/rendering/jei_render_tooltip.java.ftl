if(mouseX > ${input$xPos} && mouseX < ${input$xPos} + ${input$width} && mouseY > ${input$yPos} && mouseY < ${input$yPos} + ${input$height}) {
    guiGraphics.renderComponentTooltip(font, List.of(
        <#list input_list$entry as entry>
            Component.literal(${entry})<#sep>,
        </#list>
    ), (int) mouseX, (int) mouseY);
}
