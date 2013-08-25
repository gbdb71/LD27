package entities;
 
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.HXP;
import com.haxepunk.graphics.prototype.Rect;
import level.Blockable;
import scenes.PuzzleScene;
 
class Ramp extends Entity implements Blockable
{
    var dirX:Int;
    var dirY:Int;
    var sprite:Spritemap;

    public function new(x:Float, y:Float, dirX:Int, dirY:Int)
    {
        super(x, y);
        this.dirX = dirX;
        this.dirY = dirY;
        sprite = new Spritemap("gfx/ramp.png", 8, 8);
        sprite.add("right", [0]);
        sprite.add("left", [1]);
        sprite.add("up", [2]);
        sprite.add("down", [3]);
        var play = "";
        if (dirX > 0)
            play = "right";
        else if (dirX < 0)
            play = "left";
        else if (dirY < 0)
            play = "up";
        else if (dirY > 0)
            play = "down";
        sprite.play(play);
        graphic = sprite;
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
