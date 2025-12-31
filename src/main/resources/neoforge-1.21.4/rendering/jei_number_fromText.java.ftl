new Object() {
    double convert(String str) {
        try {
            return Double.parseDouble(str.trim());
        } catch(Exception ignored) {}
        return 0;
    }
}.convert(${input$text})