import std.stdio;
import raylib;
import game;

void main()
{
    immutable int WIDTH = 1500;
    immutable int HEIGHT = 1000;

    InitWindow(WIDTH, HEIGHT, "Xonix - DLang");
    SetTargetFPS(60);
    scope (exit)
        CloseWindow();

    Game game = new Game(WIDTH, HEIGHT, 150, 100);

    while (!WindowShouldClose())
    {
        game.update();

        BeginDrawing();
        scope (exit)
            EndDrawing();

        ClearBackground(Colors.BLUE);

        game.draw();
    }
}
