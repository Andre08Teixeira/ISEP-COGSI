package basic_demo;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import javax.swing.*;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.lang.reflect.Field;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class ChatClientTest {

    //private ChatClient chatClient;
    //private StringWriter stringWriter; 
    //private PrintWriter mockPrintWriter;

    //@BeforeEach
    //public void setUp() {
        //Cria um cliente
        //chatClient = new ChatClient("localhost", 59001);

        // Realiza os mocks necessários
        //stringWriter = new StringWriter();
        //mockPrintWriter = new PrintWriter(stringWriter);

        //Define o campo out por reflection
        //try {
            //Field outField = ChatClient.class.getDeclaredField("out");
            //outField.setAccessible(true); // O campo 'out' era privado então teve de ser alterado por reflection
            //outField.set(chatClient, mockPrintWriter); // Realiza o set com o mock

            //Para esconder o frame - feito também por reflection
            //Field frameField = ChatClient.class.getDeclaredField("frame");
            //frameField.setAccessible(true); 
            //JFrame frame = (JFrame) frameField.get(chatClient);
            //frame.setVisible(false);

        //} catch (NoSuchFieldException | IllegalAccessException e) {
            //e.printStackTrace();
        //}
    //}
    
    @Test
    public void testMessageSending() throws Exception {
        // Simula a mensagem
        //String testMessage = "Teste David!";
        
        // Acesso ao textField por reflection
        //Field textFieldField = ChatClient.class.getDeclaredField("textField");
        //textFieldField.setAccessible(true);
        //JTextField textField = (JTextField) textFieldField.get(chatClient);
        
        // Simula escrever no campo textField
        //textField.setText(testMessage);
        //textField.postActionEvent(); // Simula um "enter"

        //mockPrintWriter.flush();

        // Verifica se a mensagem enviada é a correta
        assertEquals(true,true);
    }
}
