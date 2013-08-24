package entities;
 
import com.haxepunk.Entity;
import com.haxepunk.utils.Input;
import com.haxepunk.graphics.prototype.Circle;
import flash.geom.Point;
 
class Robot extends Entity
{
    private static inline var speed:Float = 1;

    var moving:Bool;
    var moveDir:Point;

    public function new(x:Float, y:Float)
    {
        super(x, y);
        graphic = new Circle(4, 0xAAAAAA);
        setHitbox(8, 8);
        type="robot";
    }

    private function handleInput() {
        var moveX = 0;
        var moveY = 0;
        if (Input.check("left"))
        {
            moveX -= 1;
        }    
        if (Input.check("right"))
        {
            moveX += 1;
        }    
        if (Input.check("up"))
        {
            moveY -= 1;
        }    
        if (Input.check("down"))
        {
            moveY += 1;
        }

        var validMove = !(moveX != 0 && moveY != 0) && moveX + moveY != 0;
        if (!validMove)
            return;

        moving = true;
        moveDir = new Point(moveX, moveY);
    }

    public override function moveCollideX(e:Entity):Bool
    {
        moving = false;
        return true;
    }

    public override function moveCollideY(e:Entity):Bool
    {
        moving = false;
        return true;
    }

    public override function update()
    {
        super.update();
        if (!moving)
        {
            handleInput();
        }
        else
        {
            moveBy(moveDir.x * speed, moveDir.y * speed, "level");
        }
    }
}
