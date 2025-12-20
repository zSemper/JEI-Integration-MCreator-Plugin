package ${package}.init;

import mezz.jei.api.recipe.RecipeType;

<#include "../mcitems.ftl">

@JeiPlugin
public class ${JavaModName}JeiPlugin implements IModPlugin {
    private static final String UID = "${modid}";
    <#list recipe_types as type>
        public static RecipeType<RecipeHolder<${type.getModElement().getName()}Recipe>> ${type.getModElement().getRegistryName()?c_upper_case}_JEI_CATEGORY = RecipeType.create(UID, "${type.getModElement().getRegistryName()}", (Class<RecipeHolder<${type.getModElement().getName()}Recipe>>) (Class<?>) ${type.getModElement().getName()}Recipe.class);
    </#list>

    @Override
    public ResourceLocation getPluginUid() {
    	return ResourceLocation.fromNamespaceAndPath(UID, "jei_plugin");
    }

	@Override
	public void registerCategories(IRecipeCategoryRegistration registration) {
	    <#list recipe_types as type>
	        registration.addRecipeCategories(new ${type.getModElement().getName()}JeiCategory(registration.getJeiHelpers().getGuiHelper()));
	    </#list>
	}

	@Override
	public void registerRecipes(IRecipeRegistration registration) {
		RecipeManager recipeManager = Objects.requireNonNull(Minecraft.getInstance().level).getRecipeManager();

		<#list recipe_types as type>
            registration.addRecipes(${type.getModElement().getRegistryName()?c_upper_case}_JEI_CATEGORY, recipeManager.getAllRecipesFor(${type.getModElement().getName()}Recipe.Type.INSTANCE));
		</#list>
	}

	@Override
	public void registerRecipeCatalysts(IRecipeCatalystRegistration registration) {
	    <#list recipe_types as type>
	        <#if type.enableTables>
	            <#list type.tables as block>
	                registration.addRecipeCatalyst(new ItemStack(${mappedMCItemToItem(block)}), ${type.getModElement().getRegistryName()?c_upper_case}_JEI_CATEGORY);
	            </#list>
	        </#if>
	    </#list>
	}

    @Override
    public void registerGuiHandlers(IGuiHandlerRegistration registration) {
        <#list recipe_types as type>
            <#if type.enableClickArea>
                <#list type.clickAreaList as ca>
                    registration.addRecipeClickArea(${ca.clickGui}Screen.class, ${ca.clickX}, ${ca.clickY}, ${ca.clickWidth}, ${ca.clickHeight}, ${type.getModElement().getRegistryName()?c_upper_case}_JEI_CATEGORY);
                </#list>
            </#if>
        </#list>
    }
}