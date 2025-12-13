package net.zsemper.jeii.elements;

import net.mcreator.minecraft.ElementUtil;
import net.mcreator.ui.MCreator;
import net.mcreator.ui.component.JStringListField;
import net.mcreator.ui.component.util.PanelUtils;
import net.mcreator.ui.help.HelpUtils;
import net.mcreator.ui.init.L10N;
import net.mcreator.ui.minecraft.FluidListField;
import net.mcreator.ui.minecraft.MCItemListField;
import net.mcreator.ui.modgui.ModElementGUI;
import net.mcreator.workspace.elements.ModElement;
import net.zsemper.jeii.utils.Constants;
import net.zsemper.jeii.utils.GuiUtils;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.swing.*;
import java.awt.*;
import java.net.URI;
import java.net.URISyntaxException;

public class InformationGUI extends ModElementGUI<Information> {
    private final JComboBox<String> type;
    private final MCItemListField items;
    private final FluidListField fluids;
    private final JStringListField info;

    public InformationGUI(MCreator mcreator, @Nonnull ModElement modElement, boolean editingMode) {
        super(mcreator, modElement, editingMode);

        type = new JComboBox<>(new String[]{"Item", "Fluid"});
        items = new MCItemListField(mcreator, ElementUtil::loadBlocksAndItems, false, false);
        fluids = new FluidListField(mcreator);
        info = new JStringListField(mcreator, null);

        this.initGUI();
        super.finalizeGUI();
    }

    @Override
    protected void initGUI() {
        // Global
        JPanel global = new JPanel(new BorderLayout(2, 2));
        global.setOpaque(false);

        // Main
        JPanel main = new JPanel();
        main.setLayout(new BoxLayout(main, BoxLayout.Y_AXIS));
        main.setOpaque(false);

        // Type
        JPanel typePanel = new JPanel(new GridLayout(1, 2));
        typePanel.setOpaque(false);
        typePanel.add(L10N.label("elementGui.information.type", Constants.NO_PARAMS));
        type.setPreferredSize(new Dimension(250, 34));
        typePanel.add(type);
        typePanel.setBorder(GuiUtils.EMPTY_BORDER(4));
        main.add(typePanel);

        // Items
        JPanel itemPanel = new JPanel(new GridLayout(1, 2));
        itemPanel.setOpaque(false);
        itemPanel.add(HelpUtils.wrapWithHelpButton(this.withEntry("information/items"), L10N.label("elementGui.information.items", Constants.NO_PARAMS)));
        items.setPreferredSize(new Dimension(250, 34));
        itemPanel.add(items);
        itemPanel.setBorder(GuiUtils.EMPTY_BORDER(4));
        main.add(itemPanel);

        // Fluids
        JPanel fluidPanel = new JPanel(new GridLayout(1, 2));
        fluidPanel.setOpaque(false);
        fluidPanel.add(HelpUtils.wrapWithHelpButton(this.withEntry("information/fluids"), L10N.label("elementGui.information.fluids", Constants.NO_PARAMS)));
        fluids.setPreferredSize(new Dimension(250, 34));
        fluidPanel.add(fluids);
        fluidPanel.setBorder(GuiUtils.EMPTY_BORDER(4));
        main.add(fluidPanel);

        JComponent infoLabel = HelpUtils.wrapWithHelpButton(this.withEntry("information/info"), L10N.label("elementGui.information.info", Constants.NO_PARAMS));
        infoLabel.setBorder(GuiUtils.EMPTY_BORDER(4));

        main.add(infoLabel);
        info.setPreferredSize(new Dimension(400, 40));
        info.setBorder(GuiUtils.EMPTY_BORDER(4));
        main.add(info);

        fluidPanel.setVisible(false);
        type.addActionListener(e -> {
            if (type.getSelectedItem().equals("Item")) {
                itemPanel.setVisible(true);
                fluidPanel.setVisible(false);
            } else {
                itemPanel.setVisible(false);
                fluidPanel.setVisible(true);
            }
        });

        global.add(PanelUtils.totalCenterInPanel(GuiUtils.BORDER_PANEL("elementGui.information.information", main)));
        addPage(global);
    }

    @Override
    protected void openInEditingMode(Information element) {
        type.setSelectedItem(element.type);
        if (element.items != null) {
            items.setListElements(element.items);
        }
        if (element.fluids != null) {
            fluids.setListElements(element.fluids);
        }
        info.setTextList(element.info);
    }

    @Override
    public Information getElementFromGUI() {
        Information element = new Information(modElement);
        element.type = (String) type.getSelectedItem();
        if(!items.getListElements().isEmpty()) {
            element.items = items.getListElements();
        }
        if(!fluids.getListElements().isEmpty()) {
            element.fluids = fluids.getListElements();
        }
        element.info = info.getTextList();
        return element;
    }

    @Nullable
    @Override
    public URI contextURL() throws URISyntaxException {
        return new URI(Constants.WIKI + "jei_information");
    }
}
