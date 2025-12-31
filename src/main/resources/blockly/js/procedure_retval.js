Blockly.Extensions.register("procedure_dependencies_onchange_mixin_modified",
    function () {
        const block = this;

        block.getField("dependencies").setVisible(false);

        block.setOnChange(
            function (changeEvent) {
                if ((changeEvent.type !== Blockly.Events.BLOCK_CHANGE || changeEvent.element !== "field") &&
                    changeEvent.type !== Blockly.Events.BLOCK_MOVE &&
                    changeEvent.type !== Blockly.Events.BLOCK_DELETE &&
                    changeEvent.type !== Blockly.Events.BLOCK_CREATE) {
                    return;
                }

                const dependencies = javabridge.getDependencies(block.getFieldValue("procedure"));

                const group = Blockly.Events.getGroup();
                // Makes it so the block change and the unplug event get undone together.
                Blockly.Events.setGroup(changeEvent.group);
                for (let i = 0; block.getField("name" + i); i++) {
                    const previousType = block.getInput("arg" + i).connection.getCheck();
                    let dependencyType = null;
                    for (const dep of dependencies) {
                        if (dep.getName() === block.getFieldValue("name" + i)) {
                            dependencyType = dep.getBlocklyType();
                            if (dependencyType === "") {
                                dependencyType = [];
                            }
                            break;
                        }
                    }
                    // Set input checks from dependency type
                    block.getInput("arg" + i).setCheck(dependencyType);
                    const newType = block.getInput("arg" + i).connection.getCheck();
                    // Fire change event if block existed earlier and previous input type was different
                    // This is the reason we check changeEvent.element above
                    if (changeEvent.type === Blockly.Events.BLOCK_CHANGE && JSON.stringify(previousType) !== JSON.stringify(newType)) {
                        const inputCheckChange = new Blockly.Events.BlockChange(block, null, "arg" + i, previousType, newType);
                        inputCheckChange.run = function (forward) {
                            const blocklyBlock = block.blockId && block.getEventWorkspace_().getBlockById(block.blockId);
                            if (blocklyBlock) {
                                blocklyBlock.getInput(block.name).setCheck(forward ? block.newValue : block.oldValue);
                            }
                        };
                        Blockly.Events.fire(inputCheckChange);
                    }
                }
                Blockly.Events.setGroup(group);

                if (dependencies.length === 0) {
                    block.getField("dependencies").setValue("empty");
                } else {
                    block.getField("dependencies").setValue(dependencies.join("-"));
                }
            }
        );
    }
);