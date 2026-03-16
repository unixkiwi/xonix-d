import std.stdio;
import std.math;
import raylib;
import game;

void main()
{
    immutable int WIDTH = 75;
    immutable int HEIGHT = 75;

    SetConfigFlags(ConfigFlags.FLAG_WINDOW_RESIZABLE);
    InitWindow(WIDTH, HEIGHT, "Xonix - DLang");
    SetTargetFPS(60);
    scope (exit)
        CloseWindow();

    Game game = new Game(800, 600, WIDTH, HEIGHT);

    while (!WindowShouldClose())
    {
        float dt = GetFrameTime();

        if (game.gameOver)
        {
            if (IsKeyPressed(KeyboardKey.KEY_R))
                game = new Game(800, 600, WIDTH, HEIGHT);
        }
        else
        {
            game.update(dt);
        }

        BeginDrawing();

        scope (exit)
        {
            EndDrawing();
        }

        ClearBackground(Colors.BLUE);

        game.draw();
    }
}
