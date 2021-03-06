package entities;
 
import com.haxepunk.HXP;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.Sfx;
import com.haxepunk.graphics.Spritemap;
import scenes.PuzzleScene;
import com.haxepunk.Entity;
import com.haxepunk.graphics.prototype.Rect;
import utils.SlideBehaviour;
import utils.TriggerMonitor;
import level.Pawn;
import level.Blockable;
import flash.display.BitmapData;
import com.haxepunk.utils.Ease;
 
class Bomb extends Entity implements Pawn implements Blockable
{
    public var isMoving(get,never):Bool;
    public var onMoveFinished:Void->Void;
    public var onTileArrive:OnTileArrive;
    public var column(get,set):Int;
    public var row(get,set):Int;
    public var isDisposed(get,never):Bool;

    function set_column(value):Int
    {
        x = PuzzleScene.toX(value);
        return value;
    }

    function get_column():Int
    {
        return PuzzleScene.toColumn(x);
    }

    function set_row(value):Int
    {
        y = PuzzleScene.toY(value);
        return value;
    }

    function get_row():Int
    {
        return PuzzleScene.toRow(y);
    }

    function get_isMoving():Bool
    {
        return slideBehaviour.isMoving || disposing;
    }

    function get_isDisposed()
    {
        return graphic == null;
    }

    var slideBehaviour:SlideBehaviour;
    var triggerMonitor:TriggerMonitor;
    var sprite:Spritemap;
    var disposing:Bool;
    var explodeSound:Sfx;
    var emitter:Emitter;

    public function new(x:Float, y:Float)
    {
        super(x, y);
        explodeSound = new Sfx("sfx/bomb_explode_safely.mp3");
        sprite = new Spritemap("gfx/bomb.png", 8, 8);
        sprite.add("idle", [0, 0, 0, 0, 1, 2, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 2, 0, 0, 1, 1, 1, 1], 3, true);
        sprite.add("fall", [3,4,5], 10, false);
        graphic = sprite;
        sprite.play("idle");
        type="bomb";
        slideBehaviour = new SlideBehaviour(this);
        slideBehaviour.onMoveFinished = onFinished;
        triggerMonitor = new TriggerMonitor(this);
        triggerMonitor.onTileArrive = onArrive;

        emitter = new Emitter(new BitmapData(1,1, false, 0xFFFFFF), 2, 2);
        emitter.relative = false;

        var name = "safesparks";
        emitter.newType(name, [0]);
        emitter.setAlpha(name, 1, 0);
        emitter.setColor(name, 0xFF9900, 0x333333);
        emitter.setMotion(name, 65, 10, 1, 50, 5, 0.5, Ease.quadOut);
        var name = "safesmoke";
        emitter.newType(name, [0]);
        emitter.setAlpha(name, 1, 0);
        emitter.setColor(name, 0x222222, 0x000000);
        emitter.setMotion(name, 65, 10, 1, 50, 5, 0.5, Ease.quadOut);
    }

    function onArrive(fromCol:Int, fromRow:Int, toCol:Int, toRow:Int)
    {
        onTileArrive(fromCol, fromRow, toCol, toRow);
    }

    function onFinished()
    {
        triggerMonitor.setCompensation(0,0);
        if (onMoveFinished != null)
            onMoveFinished();
    }

    public function move(column:Int, row:Int)
    {
        var toX = PuzzleScene.toX(column);
        var toY = PuzzleScene.toY(row);
        triggerMonitor.setCompensation(HXP.sign(toX - x), HXP.sign(toY - y));
        slideBehaviour.move(toX, toY, null);
    }

    public function isSolid(column:Int, row:Int, originColumn:Int, originRow:Int):Bool
    {
        return graphic != null && column == this.column && row == this.row;
    }

    public override function update()
    {
        super.update();
        slideBehaviour.update();
        triggerMonitor.update();
    }

    function onAnimationFinished()
    {
        graphic = emitter;
        for (i in 0...10)
        {
            emitter.emitInRectangle("safesparks", x, y + 6, 8, 2);
            emitter.emitInRectangle("safesmoke", x, y + 6, 8, 2);
        }
        explodeSound.complete = function()
        {
            disposing = false;
            graphic = null;
        }
        explodeSound.play();
    }

    public function dispose()
    {
        disposing = true;
        slideBehaviour.stop();
        sprite.play("fall");
        sprite.callbackFunc = onAnimationFinished;
    }
}
