package entities;
 
import com.haxepunk.Entity;
import com.haxepunk.graphics.prototype.Rect;
 
class Breakable extends Entity
{
    public function new(x:Float, y:Float)
    {
        super(x, y);
        graphic = new Rect(8, 8, 0x2222FF);
    }
}
