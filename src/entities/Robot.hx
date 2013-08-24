package entities;
 
import com.haxepunk.Entity;
import com.haxepunk.graphics.prototype.Circle;
import com.haxepunk.utils.Ease;
import utils.SlideBehaviour;
 
class Robot extends Entity
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
        graphic =  new Circle(4, 0xAAAAAA);
        type="robot";
        slideBehaviour = new SlideBehaviour(this);
    }

    public function move(toX:Float, toY:Float)
    {
        slideBehaviour.move(toX, toY, Ease.quadIn);
    }

    public override function update()
    {
        super.update();
        slideBehaviour.update();
    }
}
