package entities;
 
import com.haxepunk.Entity;
import com.haxepunk.Sfx;
import com.haxepunk.graphics.Emitter;
import flash.display.BitmapData;
import com.haxepunk.utils.Ease;
import com.haxepunk.graphics.Image;
import scenes.PuzzleScene;
import level.Blockable;
 
class Breakable extends Entity implements Blockable
{
    var collapsed:Bool;
    var emitter:Emitter;
    var sfx:Sfx;

    public function new(x:Float, y:Float)
    {
        super(x, y);
        sfx = new Sfx("sfx/collapse_breakable.mp3");
        graphic = new Image("gfx/breakable.png");

        emitter = new Emitter(new BitmapData(4,4, false, 0xFF8800), 2, 2);
        emitter.relative = false;

        var name = "dust";
        emitter.newType(name, [0]);
        emitter.setAlpha(name, 1, 0);
        emitter.setMotion(name, 0, 5, 1, 360, 5, 0.5, Ease.quadOut);
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
        graphic = emitter;
        for (i in 0...10)
        {
            emitter.emitInRectangle("dust", x, y,8,8);
        }

        collapsed = true;
        sfx.play();
    }
}
