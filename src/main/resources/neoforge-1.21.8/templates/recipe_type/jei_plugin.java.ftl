package ${package}.init;

<#include "../mcitems.ftl">

@JeiPlugin
public class ${JavaModName}JeiPlugin implements IModPlugin {
    <#list recipe_types as type>
        public static ${type.getModElement().getName()}JeiCategory ${type.getModElement().getRegistryName()?c_upper_case}_JEI_CATEGORY;
    </#list>

    @Override
    public ResourceLocation getPluginUid() {
    	return ResourceLocation.fromNamespaceAndPath("${modid}", "jei_plugin");
    }

	@Override
	public void registerCategories(IRecipeCategoryRegistration registration) {
	    IGuiHelper helper = registration.getJeiHelpers().getGuiHelper();

	    <#list recipe_types as type>
	        registration.addRecipeCategories(${type.getModElement().getRegistryName()?c_upper_case}_JEI_CATEGORY = new ${type.getModElement().getName()}JeiCategory(helper));
	    </#list>
	}

	@Override
	public void registerRecipes(IRecipeRegistration registration) {
	    <#list recipe_types as type>
            registration.addRecipes(${type.getModElement().getRegistryName()?c_upper_case}_JEI_CATEGORY.getRecipeType(), ${JavaModName}RecipeTypes.getRecipes(${JavaModName}RecipeTypes.${type.getModElement().getRegistryName()?c_upper_case}_TYPE.get()).toList());
        </#list>
	}

	@Override
	public void registerRecipeCatalysts(IRecipeCatalystRegistration registration) {
        <#list recipe_types as type>
            registration.addCraftingStation(${type.getModElement().getRegistryName()?c_upper_case}_JEI_CATEGORY.getRecipeType(), ${type.getModElement().getRegistryName()?c_upper_case}_JEI_CATEGORY.getCatalysts());
        </#list>
	}

    @Override
    public void registerGuiHandlers(IGuiHandlerRegistration registration) {
        <#list recipe_types as type>
            <#if type.enableClickArea>
                <#list type.clickAreaList as ca>
                    registration.addRecipeClickArea(${ca.clickGui}Screen.class, ${ca.clickX}, ${ca.clickY}, ${ca.clickWidth}, ${ca.clickHeight}, ${type.getModElement().getRegistryName()?c_upper_case}_JEI_CATEGORY.getRecipeType());
                </#list>
            </#if>
        </#list>
    }
}