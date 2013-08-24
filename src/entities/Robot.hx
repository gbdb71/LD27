package entities;
 
import com.haxepunk.Entity;
import com.haxepunk.Tween;
import com.haxepunk.utils.Ease;
import com.haxepunk.tweens.motion.LinearMotion;
import com.haxepunk.graphics.prototype.Circle;
 
class Robot extends Entity
{
    private static inline var speed:Float = 50;

    var moveTween:LinearMotion;
    public var isMoving(default, null):Bool;

    public function new(x:Float, y:Float)
    {
        super(x, y);
        graphic = new Circle(4, 0xAAAAAA);
        setHitbox(8, 8);
        moveTween = new LinearMotion(moveComplete);
        addTween(moveTween);
        type="robot";
    }

    private function moveComplete(tween:Dynamic) {
        isMoving = false;
        x = moveTween.x;
        y = moveTween.y;
    }

    public function move(toX:Float, toY:Float)
    {
        if (!isMoving)
        {
            moveTween.setMotionSpeed(x, y, toX, toY, speed, Ease.quadIn);
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
