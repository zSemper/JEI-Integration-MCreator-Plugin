/**
 * Mutator for recipe ingredients with output
 */
Blockly.Blocks["ingredient_mutator_container"] = {
    init: function () {
        this.appendDummyInput()
            .appendField(javabridge.t("blockly.block.ingredient_mutator.container"));
        this.appendStatementInput("STACK");
        this.contextMenu = false;
        this.setColour("#67a55b");
    }
};

Blockly.Blocks["ingredient_mutator_input"] = {
    init: function () {
        this.appendDummyInput()
            .appendField(javabridge.t("blockly.block.ingredient_mutator.input"));
        this.setPreviousStatement(true);
        this.setNextStatement(true);
        this.contextMenu = false;
        this.setColour("#67a55b");
    }
};

Blockly.Extensions.registerMutator(
    "ingredient_mutator",
    simpleRepeatingInputMixin(
        "ingredient_mutator_container",
        "ingredient_mutator_input",
        "entry",

        // List item builder
        function (thisBlock, inputName, index) {
            const input = thisBlock
                .appendValueInput(inputName + index)
                .setCheck("MCItem")
                .setAlign(Blockly.Input.Align.RIGHT);

            // Dropdown change input type check
            input.appendField(javabridge.t("blockly.block.ingredient_mutator.ingredient_type"))
            input.appendField(
                new Blockly.FieldDropdown(
                    [
                        [ "Item", "MCItem" ],
                        [ "Fluid", "FluidStack" ],
                        [ "Logic", "Boolean" ],
                        [ "Number", "Number" ],
                        [ "Text", "String" ]
                    ],
                    function (newType) {
                        this.getSourceBlock()
                            .getInput(inputName + index)
                            .setCheck(newType);
                    }
                ),
                "type" + index
            );

            // Ingredient name for input
            input.appendField(javabridge.t("blockly.block.ingredient_mutator.ingredient_name"));
            input.appendField(
                new Blockly.FieldTextInput("name"),
                "name" + index
            );

            // Consume given ItemStack/FluidStack if checked
            input.appendField(javabridge.t("blockly.block.ingredient_mutator.ingredient_consume"));
            input.appendField(
                new Blockly.FieldCheckbox("FALSE"),
                "consume" + index
            );

            input.appendField(javabridge.t("blockly.block.ingredient_mutator.ingredient_input"));
        },
        // Returns MCItem instead of dummy input
        true,

        // Field name checks
        [ "type", "name", "consume" ],

        // Disabled if mutator is empty
        true
    ),
    undefined,
    [ "ingredient_mutator_input" ]
);


/**
 * Mutator for recipe ingredients
 */
Blockly.Blocks["iterable_mutator_container"] = {
    init: function () {
        this.appendDummyInput()
            .appendField(javabridge.t("blockly.block.ingredient_mutator.container"));
        this.appendStatementInput("STACK");
        this.contextMenu = false;
        this.setColour("#67a55b");
    }
};

Blockly.Blocks["iterable_mutator_input"] = {
    init: function () {
        this.appendDummyInput()
            .appendField(javabridge.t("blockly.block.ingredient_mutator.input"));
        this.setPreviousStatement(true);
        this.setNextStatement(true);
        this.contextMenu = false;
        this.setColour("#67a55b");
    }
};

/**
 * Render Blockly: Text Join
 */
Blockly.Blocks["text_mutator_container"] = {
    init: function () {
        this.appendDummyInput().appendField(javabridge.t("blockly.block.text_mutator.container"));
        this.appendStatementInput("STACK");
        this.contextMenu = false;
        this.setColour("#5ba58c");
    }
};

Blockly.Blocks["text_mutator_input"] = {
    init: function () {
        this.appendDummyInput().appendField(javabridge.t("blockly.block.text_mutator.input"));
        this.setPreviousStatement(true);
        this.setNextStatement(true);
        this.contextMenu = false;
        this.fieldValues_ = [];
        this.setColour("#5ba58c");
    }
};

Blockly.Extensions.registerMutator(
    "text_mutator",
    simpleRepeatingInputMixin(
        "text_mutator_container",
        "text_mutator_input",
        "entry",
        function(thisBlock, inputName, index) {
            thisBlock.appendValueInput(inputName + index)
                     .setCheck(null)
                     .setAlign(Blockly.Input.Align.RIGHT);
        }),
    undefined,
    [ "text_mutator_input" ]
);


/**
 * Render Blockly: Render Tooltip
 */
 Blockly.Blocks["tooltip_mutator_container"] = {
    init: function () {
        this.appendDummyInput().appendField(javabridge.t("blockly.block.tooltip_mutator.container"));
        this.appendStatementInput("STACK");
        this.contextMenu = false;
        this.setColour("#67a55b");
    }
 };

 Blockly.Blocks["tooltip_mutator_input"] = {
    init: function () {
        this.appendDummyInput().appendField(javabridge.t("blockly.block.tooltip_mutator.input"));
        this.setPreviousStatement(true);
        this.setNextStatement(true);
        this.contextMenu = false;
        this.setColour("#67a55b")
    }
 };

 Blockly.Extensions.registerMutator(
     "tooltip_mutator",
     simpleRepeatingInputMixin(
         "tooltip_mutator_container",
         "tooltip_mutator_input",
         "entry",
         function(thisBlock, inputName, index) {
             var visIndex = index + 1;
             thisBlock.appendValueInput(inputName + index)
                      .setCheck("String")
                      .setAlign(Blockly.Input.Align.RIGHT)
                      .appendField(javabridge.t("blockly.block.tooltip_mutator.line") + " " + visIndex + ":");
         }),
     undefined,
     [ "tooltip_mutator_input" ]
 );