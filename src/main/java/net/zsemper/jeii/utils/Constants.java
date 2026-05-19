package net.zsemper.jeii.utils;

import net.mcreator.ui.MCreator;
import net.mcreator.ui.blockly.BlocklyEditorType;
import net.mcreator.ui.init.L10N;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.awt.*;

public final class Constants {
    /*
     * if true unlocks developer tools normally hidden to the user
     *
     * false by default
     */
    public static final boolean DEV_MODE = false;

    // Plugin Logger
    public static final Logger LOG = LogManager.getLogger("JEI Integration");

    // JEI Dependency
    public static boolean JEI(MCreator mcreator) {
        return mcreator.getWorkspaceSettings().getDependencies().contains("jei");
    }

    public static final String RENDER_XML = "<xml xmlns=\"https://developers.google.com/blockly/xml\"><block type=\"render_start\" deletable=\"false\" x=\"40\" y=\"40\"></block></xml>";

    // Wiki
    public static final String WIKI = "https://zsemper.github.io/plugins/jei_integration/elements/";

    // No Parameter
    public static final Object[] NO_PARAMS = new Object[0];

    // Blockly Editor Type for Editor in Recipe Type
    public static final BlocklyEditorType RENDER_EDITOR = new BlocklyEditorType("rendering", "rend", "render_start");

    // JComponent Dimension Settings
    public static final int WIDTH = 200;
    public static final int HEIGHT = 30;
    public static final Dimension DIMENSION = new Dimension(90, HEIGHT);

    // Common Translatable
    public static class Translatable {
        public static String X = L10N.t("gui.common.x", NO_PARAMS);
        public static String Y = L10N.t("gui.common.y", NO_PARAMS);
        public static String WIDTH = L10N.t("gui.common.width", NO_PARAMS);
        public static String HEIGHT = L10N.t("gui.common.height", NO_PARAMS);
    }
}
