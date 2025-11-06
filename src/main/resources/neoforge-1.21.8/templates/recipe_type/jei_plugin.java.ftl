<#include "../mcitems.ftl">

package ${package}.init;

import mezz.jei.api.recipe.types.IRecipeType;

<#compress>
@JeiPlugin
public class ${JavaModName}JeiPlugin implements IModPlugin {
    <#list recipe_types as type>
        public static IRecipeType<RecipeHolder<${type.getModElement().getName()}Recipe>> ${type.getModElement().getName()}CategoryType = IRecipeType.create(${type.getModElement().getName()}JeiCategory.UID, (Class<RecipeHolder<${type.getModElement().getName()}Recipe>>) (Class<?>) ${type.getModElement().getName()}Recipe.class);
    </#list>

    @Override
    public ResourceLocation getPluginUid() {
    	return ResourceLocation.parse("${modid}:jei_plugin");
    }

	@Override
	public void registerCategories(IRecipeCategoryRegistration registration) {
	    <#list recipe_types as type>
	        registration.addRecipeCategories(new ${type.getModElement().getName()}JeiCategory(registration.getJeiHelpers().getGuiHelper()));
	    </#list>
	}

	@Override
	public void registerRecipes(IRecipeRegistration registration) {
	    <#list recipe_types as type>
            registration.addRecipes(${type.getModElement().getName()}CategoryType, ${JavaModName}RecipeTypes.recipeMap.byType(${type.getModElement().getName()}Recipe.Type.INSTANCE).stream().collect(Collectors.toList()));
        </#list>
	}

	@Override
	public void registerRecipeCatalysts(IRecipeCatalystRegistration registration) {
	    <#list recipe_types as type>
	        <#if type.enableTables>
	            registration.addCraftingStations(${type.getModElement().getName()}CategoryType, VanillaTypes.ITEM_STACK, List.of(
	                <#list type.tables as block>
	                    new ItemStack(${mappedMCItemToItem(block)})<#sep>,
	                </#list>
	            ));
	        </#if>
	    </#list>
	}

    @Override
    public void registerGuiHandlers(IGuiHandlerRegistration registration) {
        <#list recipe_types as type>
            <#if type.enableClickArea>
                <#list type.clickAreaList as ca>
                    registration.addRecipeClickArea(${ca.clickGui}Screen.class, ${ca.clickX}, ${ca.clickY}, ${ca.clickWidth}, ${ca.clickHeight}, ${type.getModElement().getName()}CategoryType);
                </#list>
            </#if>
        </#list>
    }
}</#compress>
