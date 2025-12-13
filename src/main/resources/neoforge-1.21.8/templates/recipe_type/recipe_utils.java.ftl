package ${package}.recipe;

public class RecipeUtils {
    private RecipeUtils() {
        throw new AssertionError("Recipe Utils should NEVER be initialized");
    }

    // Returns a list of all recipes from the given recipe type
    public static <I extends RecipeInput, R extends Recipe<I>> List<R> getRecipes(LevelAccessor world, RecipeType<R> type) {
        List<R> recipes = new ArrayList<>();

        if(world instanceof ServerLevel serverLevel) {
            recipes.addAll(serverLevel.recipeAccess().recipeMap().byType(type).stream().map(RecipeHolder::value).toList());
        } else if(world instanceof ClientLevel) {
            recipes.addAll(${JavaModName}RecipeTypes.recipeMap.byType(type).stream().map(RecipeHolder::value).toList());
        }

        return recipes;
    }

    // Generic method for handling Optional<>
    public static <T> T unwrap(Object value, Class<T> clazz, T defaultValue) {
        if (value == null) {
            return defaultValue;
        }

        if (clazz.isInstance(value)) {
            return clazz.cast(value);
        }

        if (value instanceof Optional<?> opt && opt.isPresent()) {
            if (clazz.isInstance(opt.get())) {
                return clazz.cast(opt.get());
            }
        }

        return defaultValue;
    }

    // Gets all inputs from the recipe object as a List<ItemStack> of all possible values
    public static List<ItemStack> getItemStacks(Object in) {
        List<ItemStack> stacks = new ArrayList<>();
        if (in instanceof SizedIngredient sized) {
            for (int i = 0; i < sized.ingredient().getValues().size(); i++) {
                stacks.add(new ItemStack(sized.ingredient().getValues().get(i), sized.count()));
            }
        } else if (in instanceof Ingredient ingre) {
            for (int i = 0; i < ingre.getValues().size(); i++) {
                stacks.add(new ItemStack(ingre.getValues().get(i)));
            }
        } else if (in instanceof Optional<?> opt) {
            if (opt.isPresent()) {
                if (opt.get() instanceof SizedIngredient sizedO) {
                    for (int i = 0; i < sizedO.ingredient().getValues().size(); i++) {
                  	    stacks.add(new ItemStack(sizedO.ingredient().getValues().get(i), sizedO.count()));
                  	}
                } else if (opt.get() instanceof Ingredient ingreO) {
                    for (int i = 0; i < ingreO.getValues().size(); i++) {
                  	    stacks.add(new ItemStack(ingreO.getValues().get(i)));
                  	}
                }
            }
        }
        return stacks;
    }

    // Gets all inputs from the recipe object as a List<FluidStack> of all possible values
	public static List<FluidStack> getFluidStacks(Object in) {
		List<FluidStack> stacks = new ArrayList<>();
		if (in instanceof SizedFluidIngredient sized) {
			for (int i = 0; i < sized.ingredient().fluids().size(); i++) {
				stacks.add(new FluidStack(sized.ingredient().fluids().get(i).value(), sized.amount()));
			}
		} else if (in instanceof Optional<?> opt) {
			if (opt.isPresent() && opt.get() instanceof SizedFluidIngredient sizedO) {
			    for(int i = 0; i < sizedO.ingredient().fluids().size(); i++) {
			        stacks.add(new FluidStack(sizedO.ingredient().fluids().get(i).value(), sizedO.amount()));
			    }
			}
		}
		return stacks;
	}

    // Validates a recipe ingredient with it's given recipe input
	public static boolean validate(Object given, Object recipe) {
		// Test Item
		if (given instanceof ItemStack item) {
			if (recipe instanceof SizedIngredient sIngre) {
				return sIngre.test(item);
			} else if (recipe instanceof Ingredient ingre) {
				return ingre.test(item);
			} else if (recipe instanceof Optional<?> opt) {
				if (item.isEmpty()) {
					return opt.isEmpty();
				}
				if (opt.isPresent()) {
					if (opt.get() instanceof SizedIngredient sIngred) {
						return sIngred.test(item);
					} else if (opt.get() instanceof Ingredient ingred) {
						return ingred.test(item);
					}
				}
				return false;
			}
		}

		// Test Fluid
		if (given instanceof FluidStack fluid) {
			if (recipe instanceof SizedFluidIngredient ingre) {
				return ingre.test(fluid);
			} else if (recipe instanceof Optional<?> opt) {
				if (fluid.isEmpty()) {
					return opt.isEmpty();
				}
				if (opt.isPresent()) {
					if (opt.get() instanceof SizedFluidIngredient ingred) {
						return ingred.test(fluid);
					}
				}
				return false;
			}
		}

		// Test boolean
		if (given instanceof Boolean bool && recipe instanceof Boolean rec) {
			return bool.equals(rec);
		}

		// Test double
		if (given instanceof double[] doub && recipe instanceof Double rec) {
			return doub[0] >= rec;
		}

		// Test String
		if (given instanceof String str && recipe instanceof String rec) {
			return str.equals(rec);
		}
		return false;
	}

    // Returns the recipe ingredient amount
	public static int amount(Object recipe) {
		if (recipe instanceof SizedIngredient sized) {
			return sized.count();
		} else if (recipe instanceof Ingredient) {
			return 1;
		} else if (recipe instanceof Optional<?> opt) {
			if (opt.isPresent()) {
				if (opt.get() instanceof SizedIngredient sizedO) {
					return sizedO.count();
				} else if (opt.get() instanceof Ingredient) {
					return 1;
				}
			}
		}

		if (recipe instanceof SizedFluidIngredient sizedF) {
			return sizedF.amount();
		} else if (recipe instanceof Optional<?> opt) {
			if (opt.isPresent()) {
				if (opt.get() instanceof SizedFluidIngredient sizedFO) {
					return sizedFO.amount();
				}
			}
		}
		if (recipe instanceof Double doub) {
			return doub.intValue();
		}

		return 0;
	}
}