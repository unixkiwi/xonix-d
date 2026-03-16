import cell;
import std.stdio;
import std.conv;
import raylib;
import enemy;
import std.array;
import std.algorithm;

struct Vec2
{
    int x;
    int y;
}

enum Direction
{
    UP,
    DOWN,
    LEFT,
    RIGHT
}

class Game
{
    int W;
    int H;
    int CELLS_X;
    int CELLS_Y;
    float CANVAS_WIDTH;
    float CANVAS_HEIGHT;
    Cell[][] grid;
    Vec2 player;
    Direction playerDir;
    Enemy[] enemies;
    immutable int ENEMY_COUNT = 3;
    bool gameOver = false;
    immutable float TICK_RATE = 0.04;
    float tickTimer = TICK_RATE;

    this(int window_w, int window_h, int CELLS_X, int CELLS_Y)
    {
        this.W = window_w / CELLS_X;
        this.H = window_h / CELLS_Y;
        this.CELLS_X = CELLS_X;
        this.CELLS_Y = CELLS_Y;
        CANVAS_WIDTH = CELLS_X * W;
        CANVAS_HEIGHT = CELLS_Y * H;

        grid = new Cell[][](CELLS_Y, CELLS_X);
        player.x = to!int(CELLS_X / 2);
        player.y = 1;
        playerDir = Direction.DOWN;

        foreach (int i; 0 .. ENEMY_COUNT)
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

    void update(float dt)
    {
        tickTimer -= dt;

        // Input
        if (IsKeyDown(KeyboardKey.KEY_LEFT))
            playerDir = Direction.LEFT;
        else if (IsKeyDown(KeyboardKey.KEY_RIGHT))
            playerDir = Direction.RIGHT;
        else if (IsKeyDown(KeyboardKey.KEY_UP))
            playerDir = Direction.UP;
        else if (IsKeyDown(KeyboardKey.KEY_DOWN))
            playerDir = Direction.DOWN;

        if (tickTimer <= 0)
        {
            Vec2 playerBefore = player;

            switch (playerDir)
            {
            case Direction.UP:
                player.y--;
                break;
            case Direction.DOWN:
                player.y++;
                break;
            case Direction.LEFT:
                player.x--;
                break;
            case Direction.RIGHT:
                player.x++;
                break;
            default:
                player.y++;
                break;
            }

            if (!(player.x >= CELLS_X || player.x < 0 || player.y >= CELLS_Y || player.y < 0) && !(
                    grid[playerBefore.y][playerBefore.x] == Cell.FILLED))
            {
                // Clear player pos
                grid[playerBefore.y][playerBefore.x] = Cell.TRAIL;
            }

            // Check for boundaries
            if (player.x >= CELLS_X)
                player.x = CELLS_X - 1;
            if (player.x < 0)
                player.x = 0;
            if (player.y >= CELLS_Y)
                player.y = CELLS_Y - 1;
            if (player.y < 0)
                player.y = 0;

            if (grid[playerBefore.y][playerBefore.x] == Cell.TRAIL && grid[player.y][player.x] == Cell
                .FILLED)
            {
                fill();
            }
            else if (grid[player.y][player.x] == Cell.TRAIL)
            {
                gameOver = true;
            }

            // Enemy Update
            foreach (ref enemy; enemies)
            {
                enemy.update();
            }

            tickTimer += TICK_RATE;
        }
    }

    void draw()
    {
        if (gameOver)
        {
            DrawText("Game Over!\nPress R to restart!", to!int(CELLS_X / 2) * W - 100, to!int(
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
                case Cell.PLAYER:
                    color = Colors.RED;
                    break;
                default:
                    color = Colors.LIME;
                }

                DrawRectangle(to!int(index * W), to!int(
                        colIndex * H), W, H, color);
                if (colIndex == player.y && index == player.x)
                {
                    DrawRectangle(to!int(index * W), to!int(
                            colIndex * H), W, H, Colors.RED);
                }
            }
        }

        // Enemy draw
        foreach (ref enemy; enemies)
        {
            enemy.draw();
        }

    }

    void fill()
    {
        foreach (y; 0 .. CELLS_Y)
        {
            foreach (x; 0 .. CELLS_X)
            {
                if (grid[y][x] == Cell.TRAIL)
                    grid[y][x] = Cell.FILLED;
            }
        }

        bool[][] visited = new bool[][](CELLS_Y, CELLS_X);

        Vec2[] stack;
        foreach (ref enemy; enemies)
        {
            stack ~= enemy.pos;
        }

        while (stack.length > 0)
        {
            Vec2 pos = stack[$ - 1];
            stack.popBack();

            if (pos.x < 0 || pos.x >= CELLS_X || pos.y < 0 || pos.y >= CELLS_Y)
                continue;
            if (visited[pos.y][pos.x] || grid[pos.y][pos.x] != Cell.EMPTY)
                continue;

            visited[pos.y][pos.x] = true;

            stack ~= Vec2(pos.x + 1, pos.y);
            stack ~= Vec2(pos.x - 1, pos.y);
            stack ~= Vec2(pos.x, pos.y + 1);
            stack ~= Vec2(pos.x, pos.y - 1);
        }

        foreach (y; 0 .. CELLS_Y)
        {
            foreach (x; 0 .. CELLS_X)
            {
                if (grid[y][x] == Cell.EMPTY && !visited[y][x])
                {
                    grid[y][x] = Cell.FILLED;
                }
            }
        }
    }
}
