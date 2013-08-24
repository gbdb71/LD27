package entities;
 
import com.haxepunk.Entity;
import scenes.PuzzleScene;
import level.Blockable;
import com.haxepunk.graphics.prototype.Rect;
 
class Breakable extends Entity implements Blockable
{
    var collapsed:Bool;

    public function new(x:Float, y:Float)
    {
        super(x, y);
        graphic = new Rect(8, 8, 0x2222FF);
    }

    public function isSolid(column:Int, row:Int, originColumn:Int, originRow:Int):Bool
    {
        if (collapsed)
            return false;

        var thisColumn = PuzzleScene.toColumn(x);
        var thisRow = PuzzleScene.toRow(y);
        return column == thisColumn && row == thisRow;
    }

    public function collapse()
    {
        graphic = null;
        collapsed = true;
    }
}
