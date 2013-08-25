package entities;
 
import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;
import de.polygonal.Printf;
 
class LevelIndex extends Entity
{
    var index:Text;

    public function new(x:Float, y:Float)
    {
        super(x, y);
        index = new Text("");
        graphic = index;
    }

    public function setIndex(current:Int, total:Int)
    {
        var text = Printf.format("%02d/%02d", [current, total]);
        index.text = text;
        index.x = -index.textWidth;
    }
}
