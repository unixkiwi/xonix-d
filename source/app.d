import std.stdio;
import raylib;
import grid;

void main()
{
    immutable int WIDTH = 1500;
    immutable int HEIGHT = 1000;

    InitWindow(WIDTH, HEIGHT, "Xonix - DLang");
    SetTargetFPS(60);
    scope (exit)
        CloseWindow();

    Grid grid = new Grid(WIDTH, HEIGHT, 150, 100);

    while (!WindowShouldClose())
    {
        BeginDrawing();
        scope (exit)
            EndDrawing();

        ClearBackground(Colors.BLUE);

        grid.draw();
    }
}
