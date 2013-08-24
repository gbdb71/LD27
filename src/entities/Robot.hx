package entities;
 
import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.Tween;
import com.haxepunk.utils.Ease;
import com.haxepunk.tweens.motion.LinearMotion;
 
class Robot extends Entity
{
    private static inline var speed:Float = 50;

    var moveTween:LinearMotion;
    public var isMoving(default, null):Bool;
    public var onMoveFinished:Void->Void;

    public function new(x:Float, y:Float, graphic:Graphic)
    {
        super(x, y);
        this.graphic = graphic;
        setHitbox(8, 8);
        moveTween = new LinearMotion(moveComplete);
        addTween(moveTween);
        type="robot";
    }

    private function moveComplete(tween:Dynamic) {
        isMoving = false;
        x = moveTween.x;
        y = moveTween.y;
        if (onMoveFinished != null)
        {
            onMoveFinished();
        }
    }

    public function move(toX:Float, toY:Float, ease:EaseFunction)
    {
        if (!isMoving)
        {
            moveTween.setMotionSpeed(x, y, toX, toY, speed, ease);
            isMoving = true;
        }
    }

    public override function update()
    {
        super.update();
        if (isMoving)
        {
            x = moveTween.x;
            y = moveTween.y;
        }
    }
}
