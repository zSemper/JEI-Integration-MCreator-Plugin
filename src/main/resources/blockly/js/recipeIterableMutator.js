Blockly.Extensions.registerMutator(
    "iterable_mutator",
    customRepeatingInput(
        "iterable_mutator_container",
        "iterable_mutator_input",
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

            input.appendField(javabridge.t("blockly.block.ingredient_mutator.ingredient_input"));
        },
        // Returns MCItem instead of dummy input
        true,

        // Field name checks
        [ "type", "name" ],

        // Disabled if mutator is empty
        true
    ),
    undefined,
    [ "iterable_mutator_input" ]
);



function customRepeatingInput(mutatorContainer, mutatorInput, inputName, inputProvider, isProperInput = true, fieldNames = [], disableIfEmpty) {
    return {
        mutationToDom: function () {
            const container = document.createElement('mutation');
            container.setAttribute('inputs', this.inputCount_);
            return container;
        },

        domToMutation: function (xmlElement) {
            this.inputCount_ = parseInt(xmlElement.getAttribute('inputs'), 10);
            this.updateShape_();
        },

        saveExtraState: function () {
            return {
                'inputCount': this.inputCount_
            };
        },

        loadExtraState: function (state) {
            this.inputCount_ = state['inputCount'];
            this.updateShape_();
        },

        decompose: function (workspace) {
            const containerBlock = workspace.newBlock(mutatorContainer);
            containerBlock.initSvg();
            let connection = containerBlock.getInput('STACK').connection;
            for (let i = 0; i < this.inputCount_; i++) {
                const inputBlock = workspace.newBlock(mutatorInput);
                inputBlock.initSvg();
                connection.connect(inputBlock.previousConnection);
                connection = inputBlock.nextConnection;
            }
            return containerBlock;
        },

        compose: function (containerBlock) {
            let inputBlock = containerBlock.getInputTargetBlock('STACK');
            // Count number of inputs.
            const connections = [];
            const fieldValues = [];
            while (inputBlock && !inputBlock.isInsertionMarker()) {
                connections.push(inputBlock.valueConnection_);
                fieldValues.push(inputBlock.fieldValues_);
                inputBlock = inputBlock.nextConnection && inputBlock.nextConnection.targetBlock();
            }
            if (isProperInput) {
                for (let i = 0; i < this.inputCount_; i++) {
                    const connection = this.getInput(inputName + i) && this.getInput(inputName + i).connection.targetConnection;
                    if (connection && connections.indexOf(connection) === -1) {
                        connection.disconnect();
                    }
                }
            }
            this.inputCount_ = connections.length;
            this.updateShape_();
            for (let i = 0; i < this.inputCount_; i++) {
                if (isProperInput) {
                    Blockly.Mutator.reconnect(connections[i], this, inputName + i);
                }
                if (fieldValues[i]) {
                    for (let j = 0; j < fieldNames.length; j++) {
                        if (fieldValues[i][j] != null)
                            this.getField(fieldNames[j] + i).setValue(fieldValues[i][j]);
                    }
                }
            }
        },

        saveConnections: function (containerBlock) {
            let inputBlock = containerBlock.getInputTargetBlock('STACK');
            let i = 0;
            while (inputBlock) {
                if (!inputBlock.isInsertionMarker()) {
                    const input = this.getInput(inputName + i);
                    if (input) {
                        if (isProperInput) {
                            inputBlock.valueConnection_ = input.connection.targetConnection;
                        }
                        inputBlock.fieldValues_ = [];
                        for (let j = 0; j < fieldNames.length; j++) {
                            const currentFieldName = fieldNames[j] + i;
                            inputBlock.fieldValues_[j] = this.getFieldValue(currentFieldName);
                        }
                    }
                    i++;
                }
                inputBlock = inputBlock.getNextBlock();
            }
        },

        updateShape_: function () {
            this.handleEmptyInput_(disableIfEmpty);

            for (let i = 0; i < this.inputCount_; i++) {
                if (!this.getInput(inputName + i))
                    inputProvider(this, inputName, i);
            }

            for (let i = this.inputCount_; this.getInput(inputName + i); i++) {
                this.removeInput(inputName + i);
            }

            if (this.getInput('foreach')) {
                this.moveInputBefore('foreach', null);
            }
        },

        handleEmptyInput_: function (disableIfEmpty) {
            if (disableIfEmpty === undefined) {
                if (this.inputCount_ && this.getInput('EMPTY')) {
                    this.removeInput('EMPTY');
                } else if (!this.inputCount_ && !this.getInput('EMPTY')) {
                    this.appendDummyInput('EMPTY').appendField(javabridge.t('blockly.block.' + this.type + '.empty'));
                }
            } else if (disableIfEmpty) {
                this.setWarningText(this.inputCount_ ? null : javabridge.t('blockly.block.' + this.type + '.empty'));
                this.setEnabled(this.inputCount_);
            }
        }
    }
}