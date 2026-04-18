package ${package}.integration.jei;

<#include "../mcitems.ftl">

import mezz.jei.api.recipe.RecipeType;

public class ${name}JeiCategory extends AbstractJeiCategory<RecipeHolder<${name}Recipe>> {
    public ${name}JeiCategory(IGuiHelper helper) {
        super(
            RecipeType.createFromVanilla(${JavaModName}RecipeTypes.${data.getModElement().getRegistryName()?c_upper_case}_TYPE.get()),
            "${data.getModElement().getRegistryName()}",
            background(helper, "${data.texture}", ${data.x}, ${data.y}, ${data.width}, ${data.height}),
            <#if data.icon == "">
                icon(helper, Blocks.BARRIER)
            <#else>
                icon(helper, ${mappedMCItemToItem(data.icon)})
            </#if>
        );
    }

    @Override
    public Item[] getCatalysts() {
        return catalysts(
            <#list data.tables as table>
                ${mappedMCItemToItem(table)}<#sep>,
            </#list>
        );
    }

    @Override
    public void setRecipe(IRecipeLayoutBuilder builder, RecipeHolder<${name}Recipe> recipe) {
        <#list data.slotList as slot>
            <#if slot.io == "Input">
                <#if slot.type == "Item">
                    builder.addSlot(RecipeIngredientRole.INPUT, ${slot.x}, ${slot.y}).addIngredients(VanillaTypes.ITEM_STACK, RecipeUtils.getItemStacks(recipe.value().${slot.name}ItemInput()));
                <#elseif slot.type == "Fluid">
                    builder.addSlot(RecipeIngredientRole.INPUT, ${slot.x}, ${slot.y}).addIngredients(NeoForgeTypes.FLUID_STACK, RecipeUtils.getFluidStacks(recipe.value().${slot.name}FluidInput()))
                    <#if slot.fullTank>
                        .setFluidRenderer(${slot.tankCapacity}, false, 16, ${slot.height});
                    <#else>
                        .setFluidRenderer(1, false, 16, ${slot.height});
                    </#if>
                </#if>
            <#elseif slot.io == "Output">
                <#if slot.type == "Item">
                    builder.addSlot(RecipeIngredientRole.OUTPUT, ${slot.x}, ${slot.y}).addItemStack(recipe.value().getItemStackResult("${slot.name}"));
                <#elseif slot.type == "Fluid">
                    builder.addSlot(RecipeIngredientRole.OUTPUT, ${slot.x}, ${slot.y}).addFluidStack(recipe.value().getFluidStackResult("${slot.name}").getFluid(), (long) recipe.value().getFluidStackResult("${slot.name}").getAmount())
                    <#if slot.fullTank>
                        .setFluidRenderer(${slot.tankCapacity}, false, 16, ${slot.height});
                    <#else>
                        .setFluidRenderer(1, false, 16, ${slot.height});
                    </#if>
                </#if>
            <#elseif slot.io == "Custom">
                ${slot.custom}
            </#if>
        </#list>
    }

    @Override
    public void draw(RecipeHolder<${name}Recipe> recipe, GuiGraphics guiGraphics, double mouseX, double mouseY) {
        <#if data.enableRendering>
            Font font = Minecraft.getInstance().font;
            long ticks = Minecraft.getInstance().level.getGameTime();

            <#list data.slotList as slot>
                <#if slot.io == "Render">
                    ResourceLocation ${slot.name}Resource = ResourceLocation.parse("${modid}:textures/screens/${slot.resource}.png");
                    int ${slot.name}Width = ${slot.resourceWidth}, ${slot.name}Height = ${slot.resourceHeight};
                </#if>
            </#list>

            ${code}
        </#if>
    }
}