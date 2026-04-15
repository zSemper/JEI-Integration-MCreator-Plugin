package ${package}.recipe;

<#compress>

<#assign pureIO = data.getRecipePures()>
<#assign varsIO = data.getRecipeVars()>

import java.util.Optional;
import java.util.List;
import javax.annotation.Nullable;

public record ${name}Recipe(${varsIO?join(", ")}) implements Recipe<RecipeInput> {
    @Override
    public @NotNull RecipeType<?> getType() {
        return ${JavaModName}RecipeTypes.${data.getModElement().getRegistryName()?c_upper_case}_TYPE.get();
    }

    @Override
    public @NotNull RecipeSerializer<?> getSerializer() {
        return ${JavaModName}RecipeTypes.${data.getModElement().getRegistryName()?c_upper_case}_SERIALIZER.get();
    }

    <#if data.hasOutputType("Item")>
        public @NotNull ItemStack getItemStackResult(String output) {
            <#list data.slotList as slot>
                <#if slot.io == "Output" && slot.type == "Item">
                    <#if slot.optional>
                        if(output.equals("${slot.name}") && ${slot.name}${slot.type}${slot.io}.isPresent()) {
                            return ${slot.name}${slot.type}${slot.io}.get();
                        }
                    <#else>
                        if(output.equals("${slot.name}")) {
                            return ${slot.name}${slot.type}${slot.io};
                        }
                    </#if>
                </#if>
            </#list>
            return ItemStack.EMPTY;
        }
    </#if>

    <#if data.hasOutputType("Fluid")>
        public @NotNull FluidStack getFluidStackResult(String output) {
            <#list data.slotList as slot>
                <#if slot.io == "Output" && slot.type == "Fluid">
                    <#if slot.optional>
                        if(output.equals("${slot.name}") && ${slot.name}${slot.type}${slot.io}.isPresent()) {
                            return ${slot.name}${slot.type}${slot.io}.get();
                        }
                    <#else>
                        if(output.equals("${slot.name}")) {
                            return ${slot.name}${slot.type}${slot.io};
                        }
                    </#if>
                </#if>
            </#list>
            return FluidStack.EMPTY;
        }
    </#if>

    <#if data.hasOutputType("Logic")>
        public @NotNull boolean getBooleanResult(String output) {
            <#list data.slotList as slot>
                <#if slot.io == "Output" && slot.type == "Logic">
                    if(output.equals("${slot.name}")) {
                        return ${slot.name}${slot.type}${slot.io};
                    }
                </#if>
            </#list>
            return false;
        }
    </#if>

    <#if data.hasOutputType("Number")>
        public @NotNull double getDoubleResult(String output) {
            <#list data.slotList as slot>
                <#if slot.io == "Output" && slot.type == "Number">
                    if(output.equals("${slot.name}")) {
                        return ${slot.name}${slot.type}${slot.io};
                    }
                </#if>
            </#list>
            return 0.0d;
        }
    </#if>

    <#if data.hasOutputType("Text")>
        public @NotNull String getStringResult(String output) {
            <#list data.slotList as slot>
                <#if slot.io == "Output" && slot.type == "Text">
                    if(output.equals("${slot.name}")) {
                        return ${slot.name}${slot.type}${slot.io};
                    }
                </#if>
            </#list>
            return "";
        }
    </#if>

    public static class Serializer implements RecipeSerializer<${name}Recipe> {
        private static final MapCodec<${name}Recipe> CODEC = RecordCodecBuilder.mapCodec(instance ->
            instance.group(
                <#assign ingre = []>

                <#list data.slotList as slot>
                    <#if slot.type == "Item">
                        <#if slot.io == "Input">
                            <#if slot.singleItem>
                                <#if slot.optional>
                                    <#assign ingre += ["Ingredient.CODEC.optionalFieldOf(\"${slot.name}\").forGetter(${name}Recipe::${slot.name}${slot.type}${slot.io})"]>
                                <#else>
                                    <#assign ingre += ["Ingredient.CODEC.fieldOf(\"${slot.name}\").forGetter(${name}Recipe::${slot.name}${slot.type}${slot.io})"]>
                                </#if>
                            <#else>
                                <#if slot.optional>
                                    <#assign ingre += ["SizedIngredient.FLAT_CODEC.optionalFieldOf(\"${slot.name}\").forGetter(${name}Recipe::${slot.name}${slot.type}${slot.io})"]>
                                <#else>
                                    <#assign ingre += ["SizedIngredient.FLAT_CODEC.fieldOf(\"${slot.name}\").forGetter(${name}Recipe::${slot.name}${slot.type}${slot.io})"]>
                                </#if>
                            </#if>

                        <#elseif slot.io == "Output">
                            <#if slot.optional>
                                <#assign ingre += ["ItemStack.CODEC.optionalFieldOf(\"${slot.name}\").forGetter(${name}Recipe::${slot.name}${slot.type}${slot.io})"]>
                            <#else>
                                <#assign ingre += ["ItemStack.CODEC.fieldOf(\"${slot.name}\").forGetter(${name}Recipe::${slot.name}${slot.type}${slot.io})"]>
                            </#if>
                        </#if>
                    <#elseif slot.type == "Fluid">
                        <#if slot.io == "Input">
                            <#if slot.optional>
                                <#assign ingre += ["SizedFluidIngredient.FLAT_CODEC.optionalFieldOf(\"${slot.name}\").forGetter(${name}Recipe::${slot.name}${slot.type}${slot.io})"]>
                            <#else>
                                <#assign ingre += ["SizedFluidIngredient.FLAT_CODEC.fieldOf(\"${slot.name}\").forGetter(${name}Recipe::${slot.name}${slot.type}${slot.io})"]>
                            </#if>
                        <#elseif slot.io == "Output">
                            <#if slot.optional>
                                <#assign ingre += ["FluidStack.CODEC.optionalFieldOf(\"${slot.name}\").forGetter(${name}Recipe::${slot.name}${slot.type}${slot.io})"]>
                            <#else>
                                <#assign ingre += ["FluidStack.CODEC.fieldOf(\"${slot.name}\").forGetter(${name}Recipe::${slot.name}${slot.type}${slot.io})"]>
                            </#if>
                        </#if>
                    <#elseif slot.type == "Logic">
                        <#if slot.optional>
                            <#assign ingre += ["Codec.BOOL.optionalFieldOf(\"${slot.name}\", ${slot.defaultBoolean}).forGetter(${name}Recipe::${slot.name}${slot.type}${slot.io})"]>
                        <#else>
                            <#assign ingre += ["Codec.BOOL.fieldOf(\"${slot.name}\").forGetter(${name}Recipe::${slot.name}${slot.type}${slot.io})"]>
                        </#if>
                    <#elseif slot.type == "Number">
                        <#if slot.optional>
                            <#assign ingre += ["Codec.DOUBLE.optionalFieldOf(\"${slot.name}\", ${slot.defaultDouble}d).forGetter(${name}Recipe::${slot.name}${slot.type}${slot.io})"]>
                        <#else>
                            <#assign ingre += ["Codec.DOUBLE.fieldOf(\"${slot.name}\").forGetter(${name}Recipe::${slot.name}${slot.type}${slot.io})"]>
                        </#if>
                    <#elseif slot.type == "Text">
                        <#if slot.optional>
                            <#assign ingre += ["Codec.STRING.optionalFieldOf(\"${slot.name}\", \"${slot.defaultString}\").forGetter(${name}Recipe::${slot.name}${slot.type}${slot.io})"]>
                        <#else>
                            <#assign ingre += ["Codec.STRING.fieldOf(\"${slot.name}\").forGetter(${name}Recipe::${slot.name}${slot.type}${slot.io})"]>
                        </#if>
                    </#if>
                </#list>

                ${ingre?join(", ")}
            ).apply(instance, ${name}Recipe::new)
        );

        @Override
        public @NotNull MapCodec<${name}Recipe> codec() {
            return CODEC;
        }

        @Override
        public @NotNull StreamCodec<RegistryFriendlyByteBuf, ${name}Recipe> streamCodec() {
            return ByteBufCodecs.fromCodecWithRegistries(CODEC.codec());
        }
    }

    // Unused
    @Override
    public boolean matches(@NotNull RecipeInput recipeInput, @NotNull Level level) {
        return false;
    }

    // Unused
    @Override
    public boolean canCraftInDimensions(int width, int height) {
        return width * height >= 1;
    }

    // Unused
    @Override
    public @NotNull ItemStack getResultItem(HolderLookup.Provider provider) {
        return ItemStack.EMPTY;
    }

    // Unused
    @Override
    public ItemStack assemble(@NotNull RecipeInput recipeInput, @NotNull HolderLookup.Provider provider) {
        return ItemStack.EMPTY;
    }
}</#compress>