package ${package}.init;

@EventBusSubscriber(modid = ${JavaModName}.MODID)
public class ${JavaModName}RecipeTypes {
    public static final DeferredRegister<RecipeType<?>> RECIPE_TYPES = DeferredRegister.create(BuiltInRegistries.RECIPE_TYPE, "${modid}");
    public static final DeferredRegister<RecipeSerializer<?>> RECIPE_SERIALIZER = DeferredRegister.create(BuiltInRegistries.RECIPE_SERIALIZER, "${modid}");

    @SubscribeEvent
    public static void init(FMLConstructModEvent event) {
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
}