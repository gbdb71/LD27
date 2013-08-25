package entities;
 
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import entities.Bomb;
import scenes.PuzzleScene;
import level.Sensor;
import level.Pawn;

class Disposer extends Entity implements Sensor
{
    public function new(x:Float, y:Float)
    {
        super(x, y);
        graphic = new Image("gfx/disposal.png");
    }

    public function onTile(pawn:Pawn, col:Int, row:Int)
    {
        if (Std.is(pawn, Bomb))
        {
            var thisCol = PuzzleScene.toColumn(x);
            var thisRow = PuzzleScene.toRow(y);
            if (thisCol == col && thisRow == row)
            {
                var bomb = cast(pawn, Bomb);
                bomb.dispose();
            }
        }
    }
}
