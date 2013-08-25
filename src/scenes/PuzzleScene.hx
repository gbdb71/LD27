package scenes;
 
import com.haxepunk.Scene;
import entities.Switch;
import entities.Door;
import entities.Ramp;
import entities.Disposer;
import utils.TriggerMonitor;
import flash.display.Loader;
import com.haxepunk.utils.Input;
import com.haxepunk.masks.Grid;
import com.haxepunk.graphics.Tilemap;
import com.haxepunk.HXP;
import com.haxepunk.graphics.prototype.Circle;
import com.haxepunk.graphics.prototype.Rect;
import com.haxepunk.utils.Ease;
import entities.Robot;
import entities.Bomb;
import entities.Timer;
import entities.Breakable;
import level.LevelLoader;
import level.Level;
import level.Blockable;
import utils.DoorControl;
 
class PuzzleScene extends Scene
{
    private static inline var BombID:Int = 0;
    private static inline var DisposalID:Int = 1;
    private static inline var BreakableID:Int = 2;

    private static inline var EntityLayer:Int = 0;
    private static inline var DisposalLayer:Int = 1;
    private static inline var LevelLayer:Int = 2;
    private static inline var HudLayer:Int = -1;

    public static inline var gridWidth = 8;
    public static inline var gridHeight = 8;
    public static inline function toColumn(value:Float):Int
    {
        return Math.floor(value / gridWidth);
    }
    public static inline function toRow(value:Float):Int
    {
        return Math.floor(value / gridHeight);
    }
    public static inline function toX(value:Int):Float
    {
        return value * gridWidth;
    }
    public static inline function toY(value:Int):Float
    {
        return value * gridHeight;
    }

    var playAreaWidth = 160;
    var playAreaHeight = 120;
    var levelTimer = 10;
    var moveTime = 1;

    public function new()
    {
        super();
    }

    public override function begin()
    {
        doorControl = new DoorControl();
        var levelLoader = new LevelLoader();
        levelLoader.parse("levels/bomb-block.tmx");

        var map = new Tilemap("gfx/leveltiles.png", playAreaWidth, playAreaHeight, gridWidth, gridHeight);
        map.loadFrom2DArray(levelLoader.tilemap);
        var grid = new Grid(map.width, map.height, map.tileWidth, map.tileHeight);
        grid.loadFromString(levelLoader.layout);
        level = new Level(map, grid);
        add(level);
        level.layer = LevelLayer;

        robot = new Robot(levelLoader.robot.x * gridWidth, levelLoader.robot.y * gridHeight, level);
        add(robot);
        robot.layer = EntityLayer;
        level.addPawn(robot);

        var bombX = Math.floor(levelLoader.bomb.x);
        var bombY = Math.floor(levelLoader.bomb.y);
        bomb = new Bomb(bombX * gridWidth, bombY * gridHeight);
        add(bomb);
        bomb.layer = EntityLayer;
        level.addObstacle(bomb);
        level.addPawn(bomb);

        var disposeX = Math.floor(levelLoader.dispose.x);
        var disposeY = Math.floor(levelLoader.dispose.y);
        var dispose = new Disposer(disposeX * gridWidth, disposeY * gridHeight);
        dispose.layer = DisposalLayer;
        level.addSensor(dispose);
        add(dispose);

        for (breakPos in levelLoader.breakaway)
        {
            var breakX = Math.floor(breakPos.x);
            var breakY = Math.floor(breakPos.y);
            var breakable = new Breakable(breakX * gridWidth, breakY * gridHeight);
            level.addObstacle(breakable);
            add(breakable);
            breakable.layer = EntityLayer;
        }

        for (rampDef in levelLoader.ramps)
        {
            var rampX = Math.floor(rampDef.point.x);
            var rampY = Math.floor(rampDef.point.y);
            var ramp = new Ramp(toX(rampX), toY(rampY), rampDef.dirX, rampDef.dirY);
            level.addObstacle(ramp);
            add(ramp);
            ramp.layer = DisposalLayer;
        }

        for (doorDef in levelLoader.doors)
        {
            var doorX = Math.floor(doorDef.point.x);
            var doorY = Math.floor(doorDef.point.y);
            var door = new Door(toX(doorX), toY(doorY));
            level.addObstacle(door);
            add(door);
            doorControl.add(doorDef.name, door);
            door.layer = EntityLayer;
        }

        for (switchDef in levelLoader.switches)
        {
            var switchX = Math.floor(switchDef.point.x);
            var switchY = Math.floor(switchDef.point.y);
            var swtch = new Switch(toX(switchX), toY(switchY), switchDef.target, doorControl);
            level.addSensor(swtch);
            add(swtch);
            swtch.layer = DisposalLayer;
        }

        timer = new Timer(playAreaWidth, 1, 10);
        add(timer);
        timer.layer = HudLayer;
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
        if (!validMove || robot.isMoving || bomb.isMoving)
            return;

        moveRobot(moveX, moveY);
    }

    private function onRobotMoveFinished(dirX:Int, dirY:Int) {
        var robotColliderX = robot.column + dirX;
        var robotColliderY = robot.row + dirY;

        var obstacles = level.getObstacles(robotColliderX, robotColliderY);
        for (blockable in obstacles)
        {
            if (blockable == bomb)
            {
                moveBomb(bomb, dirX, dirY);
            }
            else if (Std.is(blockable, Breakable))
            {
                var breakable = cast(blockable, Breakable);
                breakable.collapse();
            }
        }
    }

    private function moveRobot(dirX:Int, dirY:Int) {
        var startX = robot.column;
        var startY = robot.row;
        var target = level.sweep(startX, startY, dirX, dirY);

        if (target.x == startX && target.y == startY)
        {
            return;
        }
        
        if (!timer.sub(moveTime))
        {
            return;
        }

        robot.move(target.x, target.y);
        robot.onMoveFinished = function() {
            onRobotMoveFinished(dirX, dirY);
        }
    }

    private function moveBomb(bomb:Bomb, dirX:Int, dirY:Int) {
        var startX = bomb.column;
        var startY = bomb.row;
        var target = level.sweep(startX, startY, dirX, dirY);
        if (target.x == startX && target.y == startY)
        {
            return;
        }
        bomb.move(target.x, target.y);
    }

    public override function update()
    {
        super.update();
        handleInput();

        if (Input.check("reset"))
        {
            resetPrime = true;
        }
        else if (resetPrime)
        {
            resetPrime = false;
            HXP.scene = new PuzzleScene();
        }
    }

    var robot:Robot;
    var level:Level;
    var bomb:Bomb;
    var resetPrime:Bool;
    var timer:Timer;
    var doorControl:DoorControl;
}
