package entities;
 
import com.haxepunk.Entity;
import flash.geom.Rectangle;
import com.haxepunk.graphics.Canvas;
import com.haxepunk.HXP;

 
class ExplosionFlash extends Entity
{
    var canvas:Canvas;
    var alpha:Float;

    public function new()
    {
        super(0,0);
        canvas = new Canvas(HXP.width, HXP.height);
        canvas.fill(new Rectangle(0, 0, canvas.width, canvas.height), 0xFFFFFF, 1);
        canvas.alpha = alpha = 0;
        graphic = canvas;
    }

    public function flash()
    {
        alpha = 1;
    }

    public override function update()
    {
        if (alpha > 0)
        {
            alpha -= 0.01;
            canvas.alpha = alpha;
        }
    }
}
