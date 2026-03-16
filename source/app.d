import std.stdio;
import std.math;
import raylib;
import game;

void main()
{
    immutable int WIDTH = 1500;
    immutable int HEIGHT = 1000;

    SetConfigFlags(ConfigFlags.FLAG_WINDOW_RESIZABLE);
    InitWindow(WIDTH, HEIGHT, "Xonix - DLang");
    SetTargetFPS(60);
    scope (exit)
        CloseWindow();

    Game game = new Game(WIDTH, HEIGHT, 150, 100);

    while (!WindowShouldClose())
    {
        game.update();

        Camera2D camera;
        camera.offset = Vector2(0, 0);
        camera.target = Vector2(0, 0);
        camera.rotation = 0;

        float zoomW = cast(float) GetScreenWidth() / game.CANVAS_WIDTH;
        float zoomH = cast(float) GetScreenHeight() / game.CANVAS_HEIGHT;
        camera.zoom = fmin(zoomW, zoomH);

        BeginDrawing();
        BeginMode2D(camera);

        scope (exit)
        {
            EndMode2D();
            EndDrawing();
        }

        ClearBackground(Colors.BLUE);

        game.draw();
    }
}
