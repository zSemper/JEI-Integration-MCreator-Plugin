package net.zsemper.jeii.elements;

import net.mcreator.blockly.BlocklyCompileNote;
import net.mcreator.blockly.data.BlocklyLoader;
import net.mcreator.blockly.data.ToolboxBlock;
import net.mcreator.blockly.data.ToolboxType;
import net.mcreator.blockly.java.BlocklyToJava;
import net.mcreator.generator.blockly.BlocklyBlockCodeGenerator;
import net.mcreator.generator.blockly.OutputBlockCodeGenerator;
import net.mcreator.generator.blockly.ProceduralBlockCodeGenerator;
import net.mcreator.generator.template.TemplateGeneratorException;
import net.mcreator.minecraft.ElementUtil;
import net.mcreator.ui.MCreator;
import net.mcreator.ui.blockly.BlocklyEditorToolbar;
import net.mcreator.ui.blockly.BlocklyPanel;
import net.mcreator.ui.blockly.CompileNotesPanel;
import net.mcreator.ui.component.JEmptyBox;
import net.mcreator.ui.component.util.ComponentUtils;
import net.mcreator.ui.component.util.PanelUtils;
import net.mcreator.ui.dialogs.TypedTextureSelectorDialog;
import net.mcreator.ui.help.HelpUtils;
import net.mcreator.ui.init.L10N;
import net.mcreator.ui.minecraft.MCItemHolder;
import net.mcreator.ui.minecraft.MCItemListField;
import net.mcreator.ui.minecraft.TextureSelectionButton;
import net.mcreator.ui.modgui.IBlocklyPanelHolder;
import net.mcreator.ui.modgui.ModElementGUI;
import net.mcreator.ui.validation.component.VTextField;
import net.mcreator.ui.workspace.resources.TextureType;
import net.mcreator.util.StringUtils;
import net.mcreator.util.TestUtil;
import net.mcreator.workspace.elements.ModElement;
import net.zsemper.jeii.parts.ClickList;
import net.zsemper.jeii.parts.SlotList;
import net.zsemper.jeii.utils.Constants;
import net.zsemper.jeii.utils.GuiUtils;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.swing.*;
import java.awt.*;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class RecipeTypeGUI extends ModElementGUI<RecipeType> implements IBlocklyPanelHolder {
    // JEI Texture
    private final TextureSelectionButton texture;
    private final JSpinner x;
    private final JSpinner y;
    private final JSpinner width;
    private final JSpinner height;

    // JEI Outside
    private final MCItemHolder icon;
    private final JCheckBox enableTables;
    private final MCItemListField tables;
    private final VTextField title;

    // Clickable Gui
    private final JCheckBox enableClickArea;
    private final ClickList clickAreaList;

    // Slots
    private final SlotList slotList;

    // Blockly
    private final JCheckBox enableRendering;

    private final CompileNotesPanel compileNotesPanel;
    private final List<BlocklyChangedListener> changeListeners;
    private final BlocklyPanel blocklyPanel;
    private final Map<String, ToolboxBlock> externalBlocks;

    public RecipeTypeGUI(MCreator mcreator, @Nonnull ModElement modElement, boolean editingMode) {
        super(mcreator, modElement, editingMode);

        // JEI Texture
        texture = new TextureSelectionButton(new TypedTextureSelectorDialog(mcreator, TextureType.SCREEN), 258);
        texture.setOpaque(false);
        x = new JSpinner(new SpinnerNumberModel(0, 0, 256, 1));
        y = new JSpinner(new SpinnerNumberModel(0, 0, 256, 1));
        width = new JSpinner(new SpinnerNumberModel(0, 0, 256, 1));
        height = new JSpinner(new SpinnerNumberModel(0, 0, 256, 1));

        // JEI Outside
        icon = new MCItemHolder(mcreator, ElementUtil::loadBlocksAndItems);
        enableTables = new JCheckBox();
        tables = new MCItemListField(mcreator, ElementUtil::loadBlocksAndItems, false, false);
        tables.setEnabled(false);
        title = new VTextField();

        // Clickable Gui
        enableClickArea = new JCheckBox();
        clickAreaList = new ClickList(mcreator, this);
        clickAreaList.setEnabled(false);

        // Slots
        slotList = new SlotList(mcreator, this);

        // Blockly
        enableRendering = new JCheckBox();

        compileNotesPanel = new CompileNotesPanel();
        changeListeners = new ArrayList<>();
        blocklyPanel = new BlocklyPanel(mcreator, Constants.RENDER_EDITOR);
        externalBlocks = BlocklyLoader.INSTANCE.getBlockLoader(Constants.RENDER_EDITOR).getDefinedBlocks();

        this.initGUI();
        super.finalizeGUI();
    }

    @Override
    public void addBlocklyChangedListener(BlocklyChangedListener listener) {
        changeListeners.add(listener);
    }

    @Override
    public Set<BlocklyPanel> getBlocklyPanels() {
        return Set.of(this.blocklyPanel);
    }

    @Override
    public synchronized List<BlocklyCompileNote> regenerateBlockAssemblies(boolean jsEventTriggeredChange) {
        BlocklyBlockCodeGenerator generator = new BlocklyBlockCodeGenerator(externalBlocks, mcreator.getGeneratorStats().getBlocklyBlocks(Constants.RENDER_EDITOR));
        BlocklyToJava code;

        try {
            code = new BlocklyToJava(
                    mcreator.getWorkspace(),
                    modElement,
                    Constants.RENDER_EDITOR,
                    blocklyPanel.getXML(),
                    null,
                    new ProceduralBlockCodeGenerator(generator),
                    new OutputBlockCodeGenerator(generator)
            );
        } catch (TemplateGeneratorException e) {
            TestUtil.failIfTestingEnvironment();
            return List.of();
        }

        List<BlocklyCompileNote> compileNotes = code.getCompileNotes();
        SwingUtilities.invokeLater(() -> compileNotesPanel.updateCompileNotes(compileNotes));
        changeListeners.forEach(l -> l.blocklyChanged(blocklyPanel, jsEventTriggeredChange));
        return compileNotes;
    }

    @Override
    protected void initGUI() {
        JLabel enableRenderLabel = L10N.label("elementGui.recipeType.enableRender", Constants.NO_PARAMS);
        BlocklyEditorToolbar toolbar = new BlocklyEditorToolbar(mcreator, Constants.RENDER_EDITOR, blocklyPanel);

        ComponentUtils.deriveFont(title, 16);
        ComponentUtils.deriveFont(enableRenderLabel, 16);

        blocklyPanel.addTaskToRunAfterLoaded(() -> {
            BlocklyLoader.INSTANCE.getBlockLoader(Constants.RENDER_EDITOR).loadBlocksAndCategoriesInPanel(blocklyPanel, ToolboxType.EMPTY);

            blocklyPanel.addChangeListener(
                    changeEvent -> new Thread(() -> regenerateBlockAssemblies(changeEvent.getSource() instanceof BlocklyPanel), "RenderRegenerate").start()
            );

            if (!isEditingMode()) {
                blocklyPanel.setXML("<xml xmlns=\"https://developers.google.com/blockly/xml\"><block type=\"render_start\" deletable=\"false\" x=\"40\" y=\"40\"></block></xml>");
            }
        });

        enableTables.addActionListener(e -> tables.setEnabled(enableTables.isSelected()));

        enableClickArea.addActionListener(e -> clickAreaList.setEnabled(enableClickArea.isSelected()));

        // Globals
        JPanel gProps = new JPanel(new BorderLayout(2, 2));
        JPanel gSlots = new JPanel(new BorderLayout(2, 2));
        JPanel gRender = new JPanel(new BorderLayout(2, 2));
        gProps.setOpaque(false);
        gSlots.setOpaque(false);
        gRender.setOpaque(false);



        // Properties Main
        JPanel mPropsProp = new JPanel();
        mPropsProp.setLayout(new BoxLayout(mPropsProp, BoxLayout.X_AXIS));
        mPropsProp.setOpaque(false);

        // Properties Texture
        JPanel mPropsTex = new JPanel();
        mPropsTex.setLayout(new FlowLayout());
        mPropsTex.setOpaque(false);
        mPropsTex.add(texture);

        // Properties Settings
        JPanel mPropsSet = new JPanel(new GridLayout(4, 2, 2, 2));
        mPropsSet.setPreferredSize(GuiUtils.PANEL_DIMENSION(4, 2));
        mPropsSet.setOpaque(false);
        mPropsSet.add(HelpUtils.wrapWithHelpButton(this.withEntry("recipe_type/title"), L10N.label("elementGui.recipeType.title", Constants.NO_PARAMS)));
        mPropsSet.add(title);
        mPropsSet.add(HelpUtils.wrapWithHelpButton(this.withEntry("recipe_type/icon"), L10N.label("elementGui.recipeType.icon", Constants.NO_PARAMS)));
        mPropsSet.add(icon);
        mPropsSet.add(HelpUtils.wrapWithHelpButton(this.withEntry("recipe_type/tables"), L10N.label("elementGui.recipeType.enableTables", Constants.NO_PARAMS)));
        mPropsSet.add(enableTables);
        mPropsSet.add(L10N.label("elementGui.recipeType.tables", Constants.NO_PARAMS));
        mPropsSet.add(tables);

        // Properties Position
        JPanel mPropsPos = new JPanel(new GridLayout(2, 4, 4, 4));
        mPropsPos.setPreferredSize(GuiUtils.PANEL_DIMENSION(120, Constants.HEIGHT,2, 4));
        mPropsPos.setOpaque(false);
        mPropsPos.add(new JLabel(Constants.Translatable.X));
        mPropsPos.add(x);
        mPropsPos.add(new JLabel(Constants.Translatable.Y));
        mPropsPos.add(y);
        mPropsPos.add(new JLabel(Constants.Translatable.WIDTH));
        mPropsPos.add(width);
        mPropsPos.add(new JLabel(Constants.Translatable.HEIGHT));
        mPropsPos.add(height);

        // Properties Base
        JPanel mPropsBase = new JPanel();
        mPropsBase.setLayout(new BoxLayout(mPropsBase, BoxLayout.Y_AXIS));
        mPropsBase.setOpaque(false);
        mPropsBase.add(mPropsSet);
        mPropsBase.add(new JEmptyBox(10, 30));
        mPropsBase.add(HelpUtils.wrapWithHelpButton(this.withEntry("recipe_type/texture"), L10N.label("elementGui.recipeType.texture", Constants.NO_PARAMS)));
        mPropsBase.add(mPropsPos);

        mPropsProp.add(GuiUtils.BORDER_PANEL("elementGui.recipeType.jeiTexture", mPropsTex));
        mPropsProp.add(GuiUtils.BORDER_PANEL("elementGui.recipeType.properties", mPropsBase));

        // Click Areas
        JPanel mPropsClickEnable = new JPanel(new FlowLayout(FlowLayout.LEFT));
        mPropsClickEnable.setOpaque(false);
        mPropsClickEnable.add(HelpUtils.wrapWithHelpButton(this.withEntry("recipe_type/click_area"), L10N.label("elementGui.recipeType.enableClickArea", Constants.NO_PARAMS)));
        mPropsClickEnable.add(enableClickArea);

        JPanel mPropsClick = new JPanel(new BorderLayout());
        mPropsClick.setOpaque(false);
        mPropsClick.setBorder(GuiUtils.BORDER("elementGui.recipeType.clickAreas", mPropsClick));
        mPropsClick.add(PanelUtils.northAndCenterElement(mPropsClickEnable, clickAreaList));
        mPropsClick.setPreferredSize(new Dimension(mPropsClick.getPreferredSize().width, 260));

        JPanel mPropsMain = new JPanel();
        mPropsMain.setOpaque(false);
        mPropsMain.setLayout(new BoxLayout(mPropsMain, BoxLayout.Y_AXIS));

        mPropsMain.add(mPropsProp);
        mPropsMain.add(mPropsClick);

        gProps.add(PanelUtils.totalCenterInPanel(mPropsMain));



        // Slots
        JPanel mSlots = new JPanel(new BorderLayout());
        mSlots.setOpaque(false);
        mSlots.setBorder(GuiUtils.EMPTY_BORDER(10));
        mSlots.add(slotList);
        gSlots.add(mSlots);



        // Render (Blockly)
        JPanel mRenderMain = new JPanel(new BorderLayout());
        mRenderMain.setOpaque(false);

        JPanel mRenderEnable = new JPanel(new FlowLayout(FlowLayout.LEFT));
        mRenderEnable.setOpaque(false);
        mRenderEnable.add(HelpUtils.wrapWithHelpButton(this.withEntry("recipe_type/render"), enableRenderLabel));
        mRenderEnable.add(enableRendering);

        blocklyPanel.setPreferredSize(new Dimension(150, 150));
        JPanel mRenderBlockly = new JPanel(new GridLayout());
        mRenderBlockly.setOpaque(false);
        mRenderBlockly.setBorder(GuiUtils.BORDER("elementGui.recipeType.blocklyRender", mRenderBlockly));
        toolbar.setTemplateLibButtonWidth(157);
        mRenderBlockly.add(PanelUtils.northAndCenterElement(toolbar, blocklyPanel));

        mRenderMain.add("North", mRenderEnable);
        mRenderMain.add("Center", mRenderBlockly);
        mRenderMain.add("South", compileNotesPanel);

        gRender.add(mRenderMain);



        // Add pages
        addPage(L10N.t("elementGui.recipeType.pageProperties", Constants.NO_PARAMS), gProps);
        addPage(L10N.t("elementGui.recipeType.pageSlots", Constants.NO_PARAMS), gSlots);
        addPage(L10N.t("elementGui.recipeType.pageDraw", Constants.NO_PARAMS), gRender);

        if (!isEditingMode()) {
            title.setText(StringUtils.machineToReadableName(modElement.getName()));
            tables.setEnabled(enableTables.isSelected() && Constants.JEI(mcreator));
            clickAreaList.setEnabled(enableClickArea.isSelected() && Constants.JEI(mcreator));
            enableJEIRequired(Constants.JEI(mcreator));
        }
    }

    @Override
    public RecipeType getElementFromGUI() {
        RecipeType element = new RecipeType(modElement);
        element.name = modElement.getName();

        element.texture = texture.getTextureHolder();
        element.x = (int) x.getValue();
        element.y = (int) y.getValue();
        element.width = (int) width.getValue();
        element.height = (int) height.getValue();

        element.icon = icon.getBlock();
        element.enableTables = enableTables.isSelected();
        element.tables = tables.getListElements();
        element.title = title.getText();

        element.slotList = slotList.getEntries();

        element.enableRendering = enableRendering.isSelected();
        element.renderXML = blocklyPanel.getXML();

        element.enableClickArea = enableClickArea.isSelected();
        element.clickAreaList = clickAreaList.getEntries();
        return element;
    }

    @Override
    protected void openInEditingMode(RecipeType element) {
        texture.setTexture(element.texture);
        x.setValue(element.x);
        y.setValue(element.y);
        width.setValue(element.width);
        height.setValue(element.height);

        icon.setBlock(element.icon);
        enableTables.setSelected(element.enableTables);
        tables.setListElements(element.tables);
        title.setText(element.title);

        slotList.setEntries(element.slotList);

        enableTables.setSelected(element.enableTables);
        clickAreaList.setEntries(element.clickAreaList);

        enableRendering.setSelected(element.enableRendering);
        blocklyPanel.addTaskToRunAfterLoaded(() -> blocklyPanel.setXML(element.renderXML));

        enableJEIRequired(Constants.JEI(mcreator));
        tables.setEnabled(enableTables.isSelected() && Constants.JEI(mcreator));
        enableClickArea.setSelected(element.enableClickArea);
        clickAreaList.setEnabled(enableClickArea.isSelected() && Constants.JEI(mcreator));
    }

    @Nullable
    @Override
    public URI contextURL() throws URISyntaxException {
        return new URI(Constants.WIKI + "recipe_types");
    }

    private void enableJEIRequired(boolean enabled) {
        texture.setEnabled(enabled);
        x.setEnabled(enabled);
        y.setEnabled(enabled);
        width.setEnabled(enabled);
        height.setEnabled(enabled);

        icon.setEnabled(enabled);
        enableTables.setEnabled(enabled);
        title.setEnabled(enabled);

        enableRendering.setEnabled(enabled);

        enableClickArea.setEnabled(enabled);
    }
}
