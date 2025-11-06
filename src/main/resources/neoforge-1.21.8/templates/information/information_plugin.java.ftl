<#include "../mcitems.ftl">
package ${package}.init;

@JeiPlugin
public class ${JavaModName}Information implements IModPlugin {

    @Override
    public ResourceLocation getPluginUid() {
    	return ResourceLocation.parse("${modid}:information");
    }

    @Override
    public void registerRecipes(IRecipeRegistration registration) {
        <#list informations as info>
            registration.addIngredientInfo(
                <#if info.type == "Item">
                    List.of(
                        <#list info.items as item>
                            ${mappedMCItemToItemStackCode(item)}<#sep>,
                        </#list>
                    ), VanillaTypes.ITEM_STACK, Component.translatable("jei.${modid}.${info.getModElement().getRegistryName()}")
                <#elseif info.type == "Fluid">
                    List.of(
                        <#list info.fluids as fluid>
                            new FluidStack(${fluid}, 1000)<#sep>,
                        </#list>
                    ), NeoForgeTypes.FLUID_STACK, Component.translatable("jei.${modid}.${info.getModElement().getRegistryName()}")
                </#if>
            );
        </#list>
    }
}