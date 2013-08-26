package entities;
 
import com.haxepunk.Entity;
import flash.geom.Rectangle;
import com.haxepunk.graphics.Canvas;
import com.haxepunk.HXP;

 
class FadeScreen extends Entity
{
    public var idle:Bool;

    var canvas:Canvas;
    var alpha:Float;
    var dir:Int;

    public function new()
    {
        super(0,0);
        canvas = new Canvas(HXP.width, HXP.height);
        canvas.fill(new Rectangle(0, 0, canvas.width, canvas.height), 0x333333, 1);
        canvas.alpha = alpha = 0;
        graphic = canvas;
        idle = true;
    }

    public function flash(forward:Bool)
    {
        if (forward)
        {
            dir = 1;
            alpha = 0;
        }
        else
        {
            dir = -1;
            alpha = 1;
        }
        idle = false;
    }

    public override function update()
    {
        var shouldRun = (dir > 0 && alpha < 1) || (dir < 0 && alpha > 0);
        if (shouldRun)
        {
            alpha += 0.01 * dir;
            canvas.alpha = alpha;
        }
        else
            idle = true;
    }
}
