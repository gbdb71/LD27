package entities;
 
import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.prototype.Rect;
import level.Blockable;
import scenes.PuzzleScene;
 
class Ramp extends Entity implements Blockable
{
    var dirX:Int;
    var dirY:Int;

    public function new(x:Float, y:Float, dirX:Int, dirY:Int)
    {
        super(x, y);
        this.dirX = dirX;
        this.dirY = dirY;
        addGraphic(new Rect(8, 8, 0x222222));
        var indi = new Rect(2, 2, 0xFFFFFF);
        indi.x = dirX * 2 + 3;
        indi.y = dirY * 2 + 3;
        addGraphic(indi);
    }

    public function isSolid(column:Int, row:Int, originColumn:Int, originRow:Int):Bool
    {
        var thisColumn = PuzzleScene.toColumn(x);
        var thisRow = PuzzleScene.toRow(y);
        if(column != thisColumn || row != thisRow)
            return false;

        var dirX = HXP.sign(column - originColumn);
        var dirY = HXP.sign(row - originRow);
        return !(dirX == this.dirX && dirY == this.dirY);
    }
}
