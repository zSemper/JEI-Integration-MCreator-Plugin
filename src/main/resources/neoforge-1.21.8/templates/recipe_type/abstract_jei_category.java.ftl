package ${package}.integration.jei;

public abstract class AbstractJeiCategory<T> implements IRecipeCategory<T> {
    private final IRecipeType<T> recipeType;
    private final Component title;
    private final IDrawable background;
    private final IDrawable icon;

    public AbstractJeiCategory(IRecipeType<T> recipeType, String title, IDrawable background, IDrawable icon) {
        this.recipeType = recipeType;
        this.title = Component.translatable("jei.${modid}." + title);
        this.background = background;
        this.icon = icon;
    }

    protected static IDrawable background(IGuiHelper helper, String id, int u, int v, int width, int height) {
        var bid = ResourceLocation.fromNamespaceAndPath("${modid}", "textures/screens/" + id + ".png");
        return helper.createDrawable(bid, u, v, width, height);
    }

    protected static IDrawable icon(IGuiHelper helper, ItemLike item) {
        return helper.createDrawableIngredient(VanillaTypes.ITEM_STACK, new ItemStack(item));
    }

    @Override
    public final IRecipeType<T> getRecipeType() {
        return recipeType;
    }

    public abstract Item[] getCatalysts();

    protected static Item[] catalysts(Item... items) {
        return items;
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