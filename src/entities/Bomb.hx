package entities;
 
import com.haxepunk.HXP;
import scenes.PuzzleScene;
import com.haxepunk.Entity;
import com.haxepunk.graphics.prototype.Rect;
import utils.SlideBehaviour;
import level.Pawn;
import level.Blockable;
 
class Bomb extends Entity implements Pawn implements Blockable
{
    public var isMoving(get,never):Bool;
    public var onMoveFinished(never,set):Void->Void;
    public var onTileArrive:Int->Int->Int->Int;
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

    public var directionX(default, null):Int;
    public var directionY(default, null):Int;

    function set_onMoveFinished(value):Void->Void
    {
        return slideBehaviour.onMoveFinished = value;
    }

    function get_isMoving():Bool
    {
        return slideBehaviour.isMoving;
    }

    var slideBehaviour:SlideBehaviour;

    public function new(x:Float, y:Float)
    {
        super(x, y);
        graphic = new Rect(8, 8, 0xFF2222);
        type="bomb";
        slideBehaviour = new SlideBehaviour(this);
    }

    public function move(column:Int, row:Int)
    {
        var toX = PuzzleScene.toX(column);
        var toY = PuzzleScene.toY(row);
        directionX = HXP.sign(toX - x);
        directionY = HXP.sign(toY - y);
        slideBehaviour.move(toX, toY, null);
    }

    public function isSolid(column:Int, row:Int, originColumn:Int, originRow:Int):Bool
    {
        return column == this.column && row == this.row;
    }

    public override function update()
    {
        super.update();
        slideBehaviour.update();
    }

    public function dispose()
    {
        slideBehaviour.stop();
        graphic = null;
    }
}
