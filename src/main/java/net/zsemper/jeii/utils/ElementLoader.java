package net.zsemper.jeii.utils;

import net.mcreator.element.ModElementType;
import net.zsemper.jeii.elements.*;

import static net.mcreator.element.ModElementTypeLoader.register;

public class ElementLoader {
    public static ModElementType<?> RECIPE_TYPE;
    public static ModElementType<?> RECIPE;

    /*
     * Information Mod Element will be removed for version mcreator 2025.4/2026.1
     * and will be moved together with requested and unreleased features into its own plugin
     * as it does not fit the style and future plans of this plugin anymore.
     */
    public static ModElementType<?> INFORMATION;

    public static void load() {
        RECIPE_TYPE = register(new ModElementType<>("recipe_type", 'R', RecipeTypeGUI::new, RecipeType.class));
        RECIPE = register(new ModElementType<>("custom_recipe", 'C', RecipeGUI::new, Recipe.class));
        INFORMATION = register(new ModElementType<>("information", 'I', InformationGUI::new, Information.class));
    }
}
