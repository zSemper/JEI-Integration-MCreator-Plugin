(
    new Object() {
        public String format(double number, String format) {
            java.text.DecimalFormatSymbols symbols = new java.text.DecimalFormatSymbols();
            symbols.setGroupingSeparator('.');
            java.text.DecimalFormat formatter = new java.text.DecimalFormat(format, symbols);
            return formatter.format(number);
        }
    }.format(${input$number}, ${input$format})
)