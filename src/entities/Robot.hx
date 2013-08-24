package entities;
 
import com.haxepunk.Entity;
import scenes.PuzzleScene;
import com.haxepunk.graphics.prototype.Circle;
import com.haxepunk.utils.Ease;
import com.haxepunk.HXP;
import utils.SlideBehaviour;
import utils.TriggerMonitor;
import level.Pawn;
 
class Robot extends Entity implements Pawn
{
    public var isMoving(get,never):Bool;
    public var onMoveFinished:Void->Void;
    public var onTileArrive:OnTileArrive;
    public var column(get,set):Int;
    public var row(get,set):Int;

    function set_column(value):Int
    {
        x = PuzzleScene.toX(value);
        return value;
    }

    function get_column():Int
    {
        return PuzzleScene.toColumn(x);
    }

    function set_row(value):Int
    {
        y = PuzzleScene.toY(value);
        return value;
    }

    function get_row():Int
    {
        return PuzzleScene.toRow(y);
    }


    function get_isMoving():Bool
    {
        return slideBehaviour.isMoving;
    }

    var slideBehaviour:SlideBehaviour;
    var monitor:TriggerMonitor;

    public function new(x:Float, y:Float)
    {
        super(x, y);
        graphic =  new Circle(4, 0xAAAAAA);
        type="robot";
        slideBehaviour = new SlideBehaviour(this);
        slideBehaviour.onMoveFinished = onFinished;
        monitor = new TriggerMonitor(this);
        monitor.onTileArrive = onArrive;
    }

    function onArrive(fromCol:Int, fromRow:Int, toCol:Int, toRow:Int)
    {
        onTileArrive(fromCol, fromRow, toCol, toRow);
    }

    function onFinished()
    {
        monitor.setCompensation(0,0);
        if (onMoveFinished != null)
            onMoveFinished();
    }

    public function move(toColumn:Int, toRow:Int)
    {
        var toX = PuzzleScene.toX(toColumn);
        var toY = PuzzleScene.toY(toRow);
        monitor.setCompensation(HXP.sign(toX - x), HXP.sign(toY - y));
        slideBehaviour.move(toX, toY, Ease.quadIn);
    }

    public override function update()
    {
        super.update();
        slideBehaviour.update();
        monitor.update();
    }
}
