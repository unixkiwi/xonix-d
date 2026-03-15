import cell;
import std.stdio;
import std.conv;
import raylib;

class Grid
{
    int W;
    int H;
    int CELLS_X;
    int CELLS_Y;
    Cell[][] grid;

    this(int window_w, int window_h, int CELLS_X, int CELLS_Y)
    {
        this.W = window_w / CELLS_X;
        this.H = window_h / CELLS_Y;
        this.CELLS_X = CELLS_X;
        this.CELLS_Y = CELLS_Y;

        grid = new Cell[][](CELLS_Y, CELLS_X);

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

    void draw()
    {
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
                default:
                    color = Colors.LIME;
                }

                DrawRectangle(to!int(index * W), to!int(
                        colIndex * H), W, H, color);
            }
        }
    }
}
