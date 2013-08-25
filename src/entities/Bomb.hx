package entities;
 
import com.haxepunk.HXP;
import com.haxepunk.graphics.Spritemap;
import scenes.PuzzleScene;
import com.haxepunk.Entity;
import com.haxepunk.graphics.prototype.Rect;
import utils.SlideBehaviour;
import utils.TriggerMonitor;
import level.Pawn;
import level.Blockable;
 
class Bomb extends Entity implements Pawn implements Blockable
{
    public var isMoving(get,never):Bool;
    public var onMoveFinished:Void->Void;
    public var onTileArrive:OnTileArrive;
    public var column(get,set):Int;
    public var row(get,set):Int;

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
        return slideBehaviour.isMoving;
    }

    var slideBehaviour:SlideBehaviour;
    var triggerMonitor:TriggerMonitor;
    var sprite:Spritemap;

    public function new(x:Float, y:Float)
    {
        super(x, y);
        sprite = new Spritemap("gfx/bomb.png", 8, 8);
        sprite.add("idle", [0, 0, 0, 0, 1, 2, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 2, 0, 0, 1, 1, 1, 1], 3, true);
        graphic = sprite;
        sprite.play("idle");
        type="bomb";
        slideBehaviour = new SlideBehaviour(this);
        slideBehaviour.onMoveFinished = onFinished;
        triggerMonitor = new TriggerMonitor(this);
        triggerMonitor.onTileArrive = onArrive;
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

    public function dispose()
    {
        slideBehaviour.stop();
        graphic = null;
    }
}
