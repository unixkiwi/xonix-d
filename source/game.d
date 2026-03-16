import cell;
import std.stdio;
import std.conv;
import raylib;
import enemy;

struct Vec2
{
    int x;
    int y;
}

class Game
{
    int W;
    int H;
    int CELLS_X;
    int CELLS_Y;
    Cell[][] grid;
    Vec2 player;
    Enemy[] enemies;
    bool gameOver = false;

    this(int window_w, int window_h, int CELLS_X, int CELLS_Y)
    {
        this.W = window_w / CELLS_X;
        this.H = window_h / CELLS_Y;
        this.CELLS_X = CELLS_X;
        this.CELLS_Y = CELLS_Y;

        grid = new Cell[][](CELLS_Y, CELLS_X);
        player.x = to!int(CELLS_X / 2);
        player.y = 1;

        foreach (int i; 0 .. 3)
        {
            enemies ~= new Enemy(this);
        }

        for (int colIndex = 0; colIndex < CELLS_Y; colIndex++)
        {
            for (int index = 0; index < CELLS_X; index++)
            {
                if (index < 2 || index > CELLS_X - 3 || colIndex < 2 || colIndex > CELLS_Y - 3)
                {
                    grid[colIndex][index] = Cell.FILLED;
                }
                else
                {
                    grid[colIndex][index] = Cell.EMPTY;
                }
            }
        }
    }

    void update()
    {
        Vec2 playerBefore = player;

        // Input
        if (IsKeyDown(KeyboardKey.KEY_LEFT))
            player.x -= 1;
        else if (IsKeyDown(KeyboardKey.KEY_RIGHT))
            player.x += 1;
        else if (IsKeyDown(KeyboardKey.KEY_UP))
            player.y -= 1;
        else if (IsKeyDown(KeyboardKey.KEY_DOWN))
            player.y += 1;

        // Check for boundaries
        if (player.x >= CELLS_X)
            player.x = CELLS_X - 1;
        if (player.x < 0)
            player.x = 0;
        if (player.y >= CELLS_Y)
            player.y = CELLS_Y - 1;
        if (player.y < 0)
            player.y = 0;

        if (!(playerBefore == player))
        {
            // Clear player pos
            grid[playerBefore.y][playerBefore.x] = Cell.TRAIL;
        }

        // Check for trail
        if (grid[player.y][player.x] == Cell.TRAIL)
            gameOver = true;

        // Enemy Update
        foreach (ref enemy; enemies)
        {
            enemy.update();
        }

        // Move player on grid
        grid[player.y][player.x] = Cell.PLAYER;
    }

    void draw()
    {
        if (gameOver)
        {
            DrawText("Game Over!", to!int(CELLS_X / 2) * W - 100, to!int(
                    CELLS_Y / 2) * H, 50, Colors
                    .BLACK);

            return;
        }

        foreach (colIndex, ref Cell[] row; grid)
        {
            foreach (index, ref Cell cell; row)
            {
                Color color;
                switch (cell)
                {
                case Cell.EMPTY:
                    color = Colors.LIGHTGRAY;
                    break;
                case Cell.FILLED:
                    color = Colors.DARKGRAY;
                    break;
                case Cell.TRAIL:
                    color = Colors.GREEN;
                    break;
                case Cell.OLD_TRAIL:
                    color = Colors.DARKGREEN;
                    break;
                case Cell.PLAYER:
                    color = Colors.RED;
                    break;
                default:
                    color = Colors.LIME;
                }

                DrawRectangle(to!int(index * W), to!int(
                        colIndex * H), W, H, color);
            }
        }

        // Enemy draw
        foreach (ref enemy; enemies)
        {
            enemy.draw();
        }

    }
}
