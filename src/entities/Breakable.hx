package entities;
 
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import scenes.PuzzleScene;
import level.Blockable;
import com.haxepunk.graphics.prototype.Rect;
 
class Breakable extends Entity implements Blockable
{
    var collapsed:Bool;

    public function new(x:Float, y:Float)
    {
        super(x, y);
        graphic = new Image("gfx/breakable.png");
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
