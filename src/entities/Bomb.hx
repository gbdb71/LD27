package entities;
 
import com.haxepunk.Entity;
import com.haxepunk.graphics.prototype.Rect;
import utils.SlideBehaviour;
 
class Bomb extends Entity
{
    public var isMoving(get,never):Bool;
    public var onMoveFinished(never,set):Void->Void;

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

    public function move(toX:Float, toY:Float)
    {
        slideBehaviour.move(toX, toY, null);
    }

    public override function update()
    {
        super.update();
        slideBehaviour.update();
    }
}
