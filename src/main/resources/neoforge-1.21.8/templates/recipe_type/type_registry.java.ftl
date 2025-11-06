package ${package}.init;

@EventBusSubscriber
public class ${JavaModName}RecipeTypes {
    public static final DeferredRegister<RecipeType<?>> RECIPE_TYPES = DeferredRegister.create(BuiltInRegistries.RECIPE_TYPE, "${modid}");
    public static final DeferredRegister<RecipeSerializer<?>> SERIALIZERS = DeferredRegister.create(BuiltInRegistries.RECIPE_SERIALIZER, "${modid}");
    public static RecipeMap recipeMap = null;

    @SubscribeEvent
    public static void register(FMLConstructModEvent event) {
        IEventBus bus = ModList.get().getModContainerById("${modid}").get().getEventBus();
		event.enqueueWork(() -> {
		    RECIPE_TYPES.register(bus);
		    SERIALIZERS.register(bus);

            <#list recipe_types as type>
                RECIPE_TYPES.register("${type.getModElement().getRegistryName()}", () -> ${type.getModElement().getName()}Recipe.Type.INSTANCE);
                SERIALIZERS.register("${type.getModElement().getRegistryName()}", () -> ${type.getModElement().getName()}Recipe.Serializer.INSTANCE);
            </#list>
		});
    }

    @SubscribeEvent
    public static void sync(OnDatapackSyncEvent event) {
        <#list recipe_types as type>
            event.sendRecipes(${type.getModElement().getName()}Recipe.Type.INSTANCE);
        </#list>
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