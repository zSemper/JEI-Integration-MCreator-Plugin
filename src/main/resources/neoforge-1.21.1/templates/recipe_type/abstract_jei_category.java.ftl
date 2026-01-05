package ${package}.integration.jei;

import mezz.jei.api.recipe.RecipeType;

public abstract class AbstractJeiCategory<T> implements IRecipeCategory<T> {
    private final RecipeType<T> recipeType;
    private final Component title;
    private final IDrawable background;
    private final IDrawable icon;

    public AbstractJeiCategory(RecipeType<T> recipeType, String title, IDrawable background, IDrawable icon) {
        this.recipeType = recipeType;
        this.title = Component.translatable(title);
        this.background = background;
        this.icon = icon;
    }

    @Override
    public final RecipeType<T> getRecipeType() {
        return recipeType;
    }

    @Override
    public final Component getTitle() {
        return title;
    }

    @Override
    public final IDrawable getIcon() {
        return icon;
    }

    @Override
    public final int getWidth() {
        return background.getWidth();
    }

    @Override
    public final int getHeight() {
        return background.getHeight();
    }

    @Override
    public final void draw(T recipe, IRecipeSlotsView recipeSlotsView, GuiGraphics guiGraphics, double mouseX, double mouseY) {
        background.draw(guiGraphics);
        draw(recipe, guiGraphics, mouseX, mouseY);
    }

    public abstract void draw(T recipe, GuiGraphics guiGraphics, double mouseX, double mouseY);

    @Override
    public final void setRecipe(IRecipeLayoutBuilder builder, T recipe, IFocusGroup focuses) {
        setRecipe(builder, recipe);
    }

    public abstract void setRecipe(IRecipeLayoutBuilder builder, T recipe);
}