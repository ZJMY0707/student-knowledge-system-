package studentknowledge.client;

import javafx.application.Application;
import javafx.scene.Scene;
import javafx.scene.control.Label;
import javafx.scene.layout.StackPane;
import javafx.stage.Stage;

public class MainWindow extends Application {
    @Override
    public void start(Stage primaryStage) {
        Label label = new Label("📚 学生知识库系统 - 客户端启动成功");
        label.setStyle("-fx-font-size: 20px; -fx-text-fill: #2c3e50;");
        StackPane root = new StackPane(label);
        Scene scene = new Scene(root, 800, 600);
        primaryStage.setTitle("知识库系统");
        primaryStage.setScene(scene);
        primaryStage.show();
    }

    public static void main(String[] args) {
        launch(args);
    }
}