package entities;
 
import com.haxepunk.Entity;
import entities.Bomb;
import scenes.PuzzleScene;
import level.Sensor;
import level.Pawn;

import com.haxepunk.graphics.prototype.Rect;
 
class Disposer extends Entity implements Sensor
{
    public function new(x:Float, y:Float)
    {
        super(x, y);
        graphic = new Rect(8, 8, 0x22FF22);
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
