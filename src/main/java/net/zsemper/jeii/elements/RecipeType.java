package net.zsemper.jeii.elements;

import net.mcreator.blockly.data.BlocklyLoader;
import net.mcreator.blockly.data.BlocklyXML;
import net.mcreator.blockly.java.BlocklyToJava;
import net.mcreator.element.GeneratableElement;
import net.mcreator.element.parts.MItemBlock;
import net.mcreator.element.parts.TextureHolder;
import net.mcreator.generator.Generator;
import net.mcreator.generator.blockly.BlocklyBlockCodeGenerator;
import net.mcreator.generator.blockly.OutputBlockCodeGenerator;
import net.mcreator.generator.blockly.ProceduralBlockCodeGenerator;
import net.mcreator.generator.template.IAdditionalTemplateDataProvider;
import net.mcreator.ui.workspace.resources.TextureType;
import net.mcreator.workspace.elements.ModElement;
import net.mcreator.workspace.references.ModElementReference;
import net.mcreator.workspace.references.TextureReference;
import net.zsemper.jeii.utils.Constants;
import org.jetbrains.annotations.Nullable;

import java.util.*;

public class RecipeType extends GeneratableElement {
    public String name;

    // JEI Texture
    @TextureReference(TextureType.SCREEN)
    public TextureHolder texture;
    public int x;
    public int y;
    public int width;
    public int height;

    // JEI Outside
    public MItemBlock icon;
    public boolean enableTables;
    public List<MItemBlock> tables;
    public String title;

    // Slots
    public List<SlotListEntry> slotList;

    // GUI Renderer
    @BlocklyXML("rendering")
    public String renderXML;
    public boolean enableRendering;

    // Clickable Gui
    public boolean enableClickArea;
    public List<ClickListEntry> clickAreaList;

    public static class SlotListEntry {
        public SlotListEntry() {}

        public String io;
        public String type;
        public String name;
        public int x;
        public int y;
        public boolean singleItem;
        public int height;
        public boolean fullTank;
        public int tankCapacity;
        public boolean optional;
        @TextureReference(TextureType.SCREEN)
        public TextureHolder resource;
        public String custom;
        public int resourceWidth;
        public int resourceHeight;

        public boolean defaultBoolean;
        public double defaultDouble;
        public String defaultString;

        private String buildPure() {
            return name + type + io;
        }

        public String buildVar() {
            String output = "";
            switch (type) {
                case "Item" -> {
                    if (io.equals("Input")) {
                        if (singleItem) {
                            if (optional) {
                                output = "Optional<Ingredient> " + buildPure();
                            } else {
                                output = "Ingredient " + buildPure();
                            }
                        } else {
                            if (optional) {
                                output = "Optional<SizedIngredient> " + buildPure();
                            } else {
                                output = "SizedIngredient " + buildPure();
                            }
                        }
                    } else if (io.equals("Output")) {
                        if (optional) {
                            output = "Optional<ItemStack> " + buildPure();
                        } else {
                            output = "ItemStack " + buildPure();
                        }
                    }
                }
                case "Fluid" -> {
                    if (io.equals("Input")) {
                        if (optional) {
                            output = "Optional<SizedFluidIngredient> " + buildPure();
                        } else {
                            output = "SizedFluidIngredient " + buildPure();
                        }
                    } else if (io.equals("Output")) {
                        if (optional) {
                            output = "Optional<FluidStack> " + buildPure();
                        } else {
                            output = "FluidStack " + buildPure();
                        }
                    }
                }
                case "Logic" -> output = "boolean " + buildPure();
                case "Number" -> output = "double " + buildPure();
                case "Text" -> output = "String " + buildPure();
            }
            return output;
        }
    }

    @SuppressWarnings("unused") // Used in recipe.java.ftl to get all variables
    public List<String> getRecipeVars() {
        List<String> vars = new ArrayList<>();
        for (var entry : slotList) {
            vars.add(entry.buildVar());
        }
        return vars;
    }

    @SuppressWarnings("unused") // Used in recipe.java.ftl to get all pure variable names
    public List<String> getRecipePures() {
        List<String> pure = new ArrayList<>();
        for (var entry : slotList) {
            pure.add(entry.buildPure());
        }
        return pure;
    }

    public static class ClickListEntry {
        public ClickListEntry() {}

        @ModElementReference
        public String clickGui;
        public int clickX;
        public int clickY;
        public int clickWidth;
        public int clickHeight;
    }

    public RecipeType(ModElement element) {
        super(element);
    }

    @SuppressWarnings("unused") // Used in recipe_type.definition.yaml for translation
    public String getTitle() {
        return title;
    }

    @SuppressWarnings("unused") // Used in recipe.java.ftl to only include output getter methods that are needed
    public boolean hasOutputType(String type) {
        for (var entry : slotList) {
            if (entry.type.equals(type) && entry.io.equals("Output")) {
                return true;
            }
        }
        return false;
    }

    @Override
    @Nullable
    public IAdditionalTemplateDataProvider getAdditionalTemplateData() {
        ModElement modElement = this.getModElement();
        Generator generator = this.getModElement().getGenerator();

        return additionalData -> {
            BlocklyBlockCodeGenerator blocklyBlockCodeGenerator = new BlocklyBlockCodeGenerator(
                BlocklyLoader.INSTANCE.getBlockLoader(Constants.RENDER_EDITOR).getDefinedBlocks(),
                generator.getGeneratorStats().getBlocklyBlocks(Constants.RENDER_EDITOR),
                generator.getTemplateGeneratorFromName(Constants.RENDER_EDITOR.registryName()),
                additionalData
            ).setTemplateExtension(
                modElement.getGeneratorConfiguration().getGeneratorFlavor().getBaseLanguage().name().toLowerCase(Locale.ENGLISH)
            );

            BlocklyToJava code = new BlocklyToJava(
                modElement.getWorkspace(),
                modElement,
                Constants.RENDER_EDITOR,
                this.renderXML,
                generator.getTemplateGeneratorFromName(Constants.RENDER_EDITOR.registryName()),
                new ProceduralBlockCodeGenerator(blocklyBlockCodeGenerator),
                new OutputBlockCodeGenerator(blocklyBlockCodeGenerator)
            );
            additionalData.put("code", code.getGeneratedCode());
        };
    }
}