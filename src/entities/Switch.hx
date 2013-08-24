package entities;
 
import com.haxepunk.Entity;
import scenes.PuzzleScene;
import utils.DoorControl;
import com.haxepunk.graphics.prototype.Circle;
import level.Pawn;
import level.Sensor;
 
class Switch extends Entity implements Sensor
{
    var col:Int;
    var row:Int;
    var control:DoorControl;
    var channel:String;
    var spent:Bool;

    public function new(x:Float, y:Float, channel:String, control:DoorControl)
    {
        super(x, y);
        graphic = new Circle(4, 0x225522);
        
        this.control = control;
        this.channel = channel;
        col = PuzzleScene.toColumn(x);
        row = PuzzleScene.toColumn(y);
    }

    public function onTile(pawn:Pawn, col:Int, row:Int):Void
    {
        if (!spent && col == this.col && row == this.row)
        {
            spent = true;
            control.setOpen(channel, true);
        }
    }
}
