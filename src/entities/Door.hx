package entities;
 
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.HXP;
import com.haxepunk.graphics.prototype.Rect;
import level.Blockable;
import scenes.PuzzleScene;
 
class Door extends Entity implements Blockable
{
    var open:Bool;
    var sprite:Spritemap;

    public function new(x:Float, y:Float)
    {
        super(x, y);
        sprite = new Spritemap("gfx/door.png", 8, 8);
        sprite.add("idle", [0, 1], 5, true);
        sprite.add("open", [2, 3, 4, 5, 6, 7, 8], 10, false);
        graphic = sprite;
        sprite.play("idle");
    }

    public function isSolid(column:Int, row:Int, originColumn:Int, originRow:Int):Bool
    {
        var thisColumn = PuzzleScene.toColumn(x);
        var thisRow = PuzzleScene.toRow(y);
        return !open && column == thisColumn && row == thisRow;
    }

    function onOpened()
    {
        graphic = null;
        sprite.callbackFunc = null;
    }

    public function setOpen(open:Bool)
    {
        this.open = open;
        if (open)
        {
            sprite.play("open");
            sprite.callbackFunc = onOpened;
        }
        else
        {
            graphic = sprite;
            sprite.play("idle");
        }
    }
}
