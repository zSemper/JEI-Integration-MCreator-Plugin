package ${package}.init;

@EventBusSubscriber
public class ${JavaModName}RecipeTypes {
    public static final DeferredRegister<RecipeType<?>> RECIPE_TYPES = DeferredRegister.create(BuiltInRegistries.RECIPE_TYPE, "${modid}");
    public static final DeferredRegister<RecipeSerializer<?>> RECIPE_SERIALIZER = DeferredRegister.create(BuiltInRegistries.RECIPE_SERIALIZER, "${modid}");
    private static RecipeMap recipeMap = null;

    @SubscribeEvent
    public static void register(FMLConstructModEvent event) {
        IEventBus bus = ModList.get().getModContainerById("${modid}").get().getEventBus();
		event.enqueueWork(() -> {
		    RECIPE_TYPES.register(bus);
		    RECIPE_SERIALIZER.register(bus);
		});
    }

    <#list recipe_types as type>
        public static final Supplier<RecipeType<${type.getModElement().getName()}Recipe>> ${type.getModElement().getRegistryName()?c_upper_case}_TYPE = recipeType("${type.getModElement().getRegistryName()}");
    </#list>

    <#list recipe_types as type>
        public static final Supplier<RecipeSerializer<${type.getModElement().getName()}Recipe>> ${type.getModElement().getRegistryName()?c_upper_case}_SERIALIZER = recipeSerializer("${type.getModElement().getRegistryName()}", ${type.getModElement().getName()}Recipe.Serializer::new);
    </#list>

    private static <T extends Recipe<?>> DeferredHolder<RecipeType<?>, RecipeType<T>> recipeType(String registryName) {
        return RECIPE_TYPES.register(registryName, () -> new RecipeType<T>() {
            @Override
            public String toString() {
                return registryName;
            }
        });
    }

    private static <T extends Recipe<?>> DeferredHolder<RecipeSerializer<?>, RecipeSerializer<T>> recipeSerializer(String name, Supplier<RecipeSerializer<T>> serializer) {
        return RECIPE_SERIALIZER.register(name, serializer);
    }

    @SubscribeEvent
    public static void sync(OnDatapackSyncEvent event) {
        <#list recipe_types as type>
            event.sendRecipes(${type.getModElement().getRegistryName()?c_upper_case}_TYPE.get());
        </#list>
    }

    public static <I extends RecipeInput, R extends Recipe<I>> Stream<RecipeHolder<R>> getRecipes(RecipeType<R> recipeType) {
        if (recipeMap != null) {
            return recipeMap.byType(recipeType).stream();
        }
        return Stream.empty();
    }

    @EventBusSubscriber(value = Dist.CLIENT)
    private static class RecipeSync {
        @SubscribeEvent
        public static void receive(RecipesReceivedEvent event) {
            recipeMap = event.getRecipeMap();
        }

        @SubscribeEvent
        public static void clear(ClientPlayerNetworkEvent.LoggingOut event) {
            recipeMap = null;
        }
    }
}