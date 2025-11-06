package ${package}.recipe;

public class RecipeUtils {
    private RecipeUtils() {
        throw new AssertionError("Recipe Utils should NEVER be initialized");
    }

    // Gets all inputs from the recipe object as a List<ItemStack> of all possible values
    public static List<ItemStack> getItemStacks(Object in) {
        if(in instanceof SizedIngredient sized) {
            return Arrays.asList(sized.getItems());
        } else if(in instanceof Ingredient ingre) {
            return Arrays.asList(ingre.getItems());
        } else if(in instanceof Optional<?> opt) {
            if(opt.isPresent()) {
                if(opt.get() instanceof SizedIngredient sizedO) {
                    return Arrays.asList(sizedO.getItems());
                } else if(opt.get() instanceof Ingredient ingreO) {
                    return Arrays.asList(ingreO.getItems());
                }
            }
        }
        return new ArrayList<>();
    }

    // Gets all inputs from the recipe object as a List<FluidStack> of all possible values
	public static List<FluidStack> getFluidStacks(Object in) {
		if(in instanceof SizedFluidIngredient sized) {
			return Arrays.asList(sized.getFluids());
		} else if(in instanceof Optional<?> opt) {
			if(opt.isPresent()) {
				if(opt.get() instanceof SizedFluidIngredient sizedO) {
					return Arrays.asList(sizedO.getFluids());
				}
			}
		}
		return new ArrayList<>();
	}

	// Validates a recipe ingredient with it's given recipe input
	public static boolean validate(Object given, Object recipe) {
		// Test Item
		if(given instanceof ItemStack item) {
			if(recipe instanceof SizedIngredient sIngre) {
				return sIngre.test(item);
			} else if(recipe instanceof Ingredient ingre) {
			    return ingre.test(item);
			} else if(recipe instanceof Optional<?> opt) {
				if(item.isEmpty()) {
					return opt.isEmpty();
				}
                if(opt.isPresent()) {
				    if(opt.get() instanceof SizedIngredient sIngred) {
					    return sIngred.test(item);
				    } else if(opt.get() instanceof Ingredient ingred) {
				        return ingred.test(item);
				    }
                }
				return false;
			}
		}

		// Test Fluid
		if(given instanceof FluidStack fluid) {
			if(recipe instanceof SizedFluidIngredient ingre) {
				return ingre.test(fluid);
			} else if(recipe instanceof Optional<?> opt) {
				if(fluid.isEmpty()) {
					return opt.isEmpty();
				}
                if(opt.isPresent()) {
				    if(opt.get() instanceof SizedFluidIngredient ingred) {
					    return ingred.test(fluid);
				    }
                }
				return false;
			}
		}

		// Test boolean
		if(given instanceof Boolean bool && recipe instanceof Boolean rec) {
			return bool.equals(rec);
		}

		// Test double
		if(given instanceof double[] doub && recipe instanceof Double rec) {
			return doub[0] >= rec;
		}

		// Test String
		if(given instanceof String str && recipe instanceof String rec) {
			return str.equals(rec);
		}

		return false;
	}

	// Returns the recipe ingredient amount
	public static int amount(Object recipe) {
        if(recipe instanceof SizedIngredient sized) {
            return sized.count();
        } else if(recipe instanceof Ingredient) {
            return 1;
        } else if(recipe instanceof Optional<?> opt) {
            if(opt.isPresent()) {
                if(opt.get() instanceof SizedIngredient sizedO) {
                    return sizedO.count();
                } else if(opt.get() instanceof Ingredient) {
                    return 1;
                }
            }
        }

        if(recipe instanceof SizedFluidIngredient sizedF) {
            return sizedF.amount();
        } else if(recipe instanceof Optional<?> opt) {
            if(opt.isPresent()) {
                if(opt.get() instanceof SizedFluidIngredient sizedFO) {
                    return sizedFO.amount();
                }
            }
        }

        if(recipe instanceof Double doub) {
            return doub.intValue();
        }

        return 0;
	}
}