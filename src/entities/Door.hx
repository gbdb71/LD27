package entities;
 
import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.prototype.Rect;
import level.Blockable;
import scenes.PuzzleScene;
 
class Door extends Entity implements Blockable
{
    var open:Bool;
    var image:Rect;

    public function new(x:Float, y:Float)
    {
        super(x, y);
        image = new Rect(8, 8, 0x663300);
        addGraphic(image);
    }

    public function isSolid(column:Int, row:Int, originColumn:Int, originRow:Int):Bool
    {
        var thisColumn = PuzzleScene.toColumn(x);
        var thisRow = PuzzleScene.toRow(y);
        return !open && column == thisColumn && row == thisRow;
    }

    public function setOpen(open:Bool)
    {
        this.open = open;
        if (open)
        {
            graphic = null;
        }
        else
        {
            graphic = image;
        }
    }
}
