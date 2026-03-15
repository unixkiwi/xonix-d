import std.stdio;
import raylib;

void main()
{
    immutable int WIDTH = 1500;
    immutable int HEIGHT = 1000;

    InitWindow(WIDTH, HEIGHT, "Xonix - DLang");
    SetTargetFPS(60);
    scope (exit)
        CloseWindow();

    while (!WindowShouldClose())
    {
        BeginDrawing();
        scope (exit)
            EndDrawing();

        ClearBackground(Colors.DARKGREEN);
    }
}
