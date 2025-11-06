{
    List<Component> components = new ArrayList<>();

    <#list input_list$entry as entry>
        components.add(Component.literal(${entry}));
    </#list>

    if(mouseX > ${input$xPos} && mouseX < ${input$xPos} + ${input$width} && mouseY > ${input$yPos} && mouseY < ${input$yPos} + ${input$height}) {
        guiGraphics.renderComponentTooltip(font, components, (int) mouseX, (int) mouseY);
    }
}
