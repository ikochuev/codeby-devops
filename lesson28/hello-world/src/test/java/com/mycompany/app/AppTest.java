package com.mycompany.app;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertEquals;
public class AppTest {
    @Test void testAppConstructor() {
        App app1 = new App(); App app2 = new App();
        assertEquals(app1.getMessage(), app2.getMessage());
    }
    @Test void testAppMessage() {
        assertEquals("Hello World!", new App().getMessage());
    }
}
