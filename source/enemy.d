import cell;
import game;
import std.random;
import std.conv;
import raylib;

class Enemy
{
    Vec2 pos;
    Vec2 vel;
    Game game;

    this(Game game)
    {
        this.game = game;
        pos.x = uniform!"[]"(3, game.CELLS_X - 3);
        pos.y = uniform!"[]"(3, game.CELLS_Y - 3);

        vel.x = uniform!"[]"(-1, 1);
        vel.y = uniform!"[]"(-1, 1);
    }

    void update()
    {
        // Player trail hit
        if (game.grid[pos.y][pos.x] == Cell.TRAIL || game.grid[pos.y][pos.x] == Cell.PLAYER)
        {
            game.gameOver = true;
        }

        // bouncing horizontally
        int nextX = pos.x + vel.x;
        if (nextX < 0 || nextX >= game.CELLS_X || game.grid[pos.y][nextX] == Cell.FILLED)
        {
            vel.x *= -1;
        }
        else
        {
            pos.x = nextX;
        }

        // bouncing vertically
        int nextY = pos.y + vel.y;
        if (nextY < 0 || nextY >= game.CELLS_Y || game.grid[nextY][pos.x] == Cell.FILLED)
        {
            vel.y *= -1;
        }
        else
        {
            pos.y = nextY;
        }

    }

    void draw()
    {
        // Enemy 
        DrawRectangle(to!int(pos.x * game.W), to!int(pos.y * game.H), game.W, game.H, Colors.PINK);
    }
}
