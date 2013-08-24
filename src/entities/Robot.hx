package entities;
 
import com.haxepunk.Entity;
import level.Level;
import com.haxepunk.graphics.Emitter;
import scenes.PuzzleScene;
import com.haxepunk.graphics.prototype.Circle;
import com.haxepunk.utils.Ease;
import com.haxepunk.HXP;
import utils.SlideBehaviour;
import utils.TriggerMonitor;
import level.Pawn;
import flash.display.BitmapData;
 
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
    var emitter:Emitter;
    var dirX:Int;
    var dirY:Int;
    var level:Level;

    public function new(x:Float, y:Float, level:Level)
    {
        super(x, y);
        graphic =  new Circle(4, 0xAAAAAA);
        this.level = level;
        type="robot";
        slideBehaviour = new SlideBehaviour(this);
        slideBehaviour.onMoveFinished = onFinished;
        monitor = new TriggerMonitor(this);
        monitor.onTileArrive = onArrive;
        emitter = new Emitter(new BitmapData(1,1, false, 0xFFFFFFFF), 2, 2);
        emitter.relative = false;

        var name = "horizontalA";
        emitter.newType(name, [0]);
        emitter.setAlpha(name, 1, 0);
        emitter.setMotion(name, 155, 5, 1, 50, 5, 0.5, Ease.quadOut);
        name = "horizontalB";
        emitter.newType(name, [0]);
        emitter.setAlpha(name, 1, 0);
        emitter.setMotion(name, -25, 5, 1, 50, 5, 0.5, Ease.quadOut);
        var name = "verticalA";
        emitter.newType(name, [0]);
        emitter.setAlpha(name, 1, 0);
        emitter.setMotion(name, 65, 5, 1, 50, 5, 0.5, Ease.quadOut);
        name = "verticalB";
        emitter.newType(name, [0]);
        emitter.setAlpha(name, 1, 0);
        emitter.setMotion(name, 255, 5, 1, 50, 5, 0.5, Ease.quadOut);

        addGraphic(emitter);
    }

    function onArrive(fromCol:Int, fromRow:Int, toCol:Int, toRow:Int)
    {
        onTileArrive(fromCol, fromRow, toCol, toRow);
    }

    function onFinished()
    {
        var particleType = "horizontal";
        if (dirX != 0)
        {
            particleType = "vertical";
        }
        for (i in 0...5)
        {
            emitter.emit(particleType + "A", x + 4 + dirX * 4, y + 4 + dirY * 4);
            emitter.emit(particleType + "B", x + 4 + dirX * 4, y + 4 + dirY * 4);
        }
        level.shiver(dirX, dirY);
        monitor.setCompensation(0,0);
        if (onMoveFinished != null)
            onMoveFinished();
    }

    public function move(toColumn:Int, toRow:Int)
    {
        var toX = PuzzleScene.toX(toColumn);
        var toY = PuzzleScene.toY(toRow);
        dirX = HXP.sign(toX - x);
        dirY = HXP.sign(toY - y);
        monitor.setCompensation(dirX, dirY);
        slideBehaviour.move(toX, toY, Ease.quadIn);
    }

    public override function update()
    {
        super.update();
        slideBehaviour.update();
        monitor.update();
    }
}
