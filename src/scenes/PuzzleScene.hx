package scenes;
 
import com.haxepunk.Scene;
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
import entities.Level;
import entities.Timer;
import entities.Breakable;
import utils.LevelLoader;
 
class PuzzleScene extends Scene
{
    private static inline var BombID:Int = 0;
    private static inline var DisposalID:Int = 1;
    private static inline var BreakableID:Int = 2;

    private static inline var EntityLayer:Int = 0;
    private static inline var DisposalLayer:Int = 1;
    private static inline var LevelLayer:Int = 2;

    var gridX = 8;
    var gridY = 8;
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
        var levelLoader = new LevelLoader();
        levelLoader.parse("levels/level1.tmx");
        robot = new Robot(levelLoader.robot.x * gridX, levelLoader.robot.y * gridY);
        add(robot);
        robot.layer = EntityLayer;

        var map = new Tilemap("gfx/leveltiles.png", playAreaWidth, playAreaHeight, gridX, gridY);
        map.loadFromString(levelLoader.layout);
        var grid = new Grid(map.width, map.height, map.tileWidth, map.tileHeight);
        grid.loadFromString(levelLoader.layout);
        level = new Level(map, grid);
        add(level);
        level.layer = LevelLayer;

        var bombX = Math.floor(levelLoader.bomb.x);
        var bombY = Math.floor(levelLoader.bomb.y);
        bomb = new Bomb(bombX * gridX, bombY * gridY);
        add(bomb);
        bomb.layer = EntityLayer;
        level.markObstacle(bombX, bombY, true, BombID);
        bombTriggerMonitor = new TriggerMonitor(bomb, level, gridX, gridY);
        bombTriggerMonitor.onTrigger = checkBombTrigger;

        var disposeX = Math.floor(levelLoader.dispose.x);
        var disposeY = Math.floor(levelLoader.dispose.y);
        level.markObstacle(disposeX, disposeY, false, DisposalID);
        var disposeIndicator = addGraphic(new Rect(8, 8, 0x00FF00));
        disposeIndicator.x = disposeX * gridX;
        disposeIndicator.y = disposeY * gridY;
        disposeIndicator.layer = DisposalLayer;

        breakables = new Array<Breakable>();
        for (breakPos in levelLoader.breakaway)
        {
            var breakX = Math.floor(breakPos.x);
            var breakY = Math.floor(breakPos.y);
            var breakable = new Breakable(breakX * gridX, breakY * gridY);
            level.markObstacle(breakX, breakY, true, BreakableID);
            add(breakable);
            breakables.push(breakable);
        }

        timer = new Timer(playAreaWidth, 1, 10);
        add(timer);
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

        if (timer.sub(moveTime))
        {
            moveRobot(moveX, moveY);
        }
    }

    private function onRobotMoveFinished(dirX:Int, dirY:Int) {
        var robotColliderX = Math.floor(robot.x / gridX) + dirX;
        var robotColliderY = Math.floor(robot.y / gridY) + dirY;

        var obstacles = level.getObstacles(robotColliderX, robotColliderY);
        for (id in obstacles)
        {
            if (id == BombID)
            {
                moveBomb(dirX, dirY);
            }
            else if (id == BreakableID)
            {
            }
        }
    }

    private function moveRobot(dirX:Int, dirY:Int) {
        var startX = Math.floor(robot.x / gridX);
        var startY = Math.floor(robot.y / gridY);
        var target = determineSlide(startX, startY, dirX, dirY);

        if (target.x == startX && target.y == startY)
        {
            return;
        }
        robot.move(target.x * gridX, target.y * gridY);
        robot.onMoveFinished = function() {
            onRobotMoveFinished(dirX, dirY);
        }
    }

    private function moveBomb(dirX:Int, dirY:Int) {
        var startX = Math.floor(bomb.x / gridX);
        var startY = Math.floor(bomb.y / gridY);
        var target = determineSlide(startX, startY, dirX, dirY);
        if (target.x == startX && target.y == startY)
        {
            return;
        }
        level.removeObstacle(BombID);
        level.markObstacle(target.x, target.y, true, BombID);
        bomb.move(target.x * gridX, target.y * gridY);
        bombTriggerMonitor.setCompensation(dirX, dirY);
        bomb.onMoveFinished = function()
        {
            bombTriggerMonitor.setCompensation(0, 0);
        }
    }

    private function determineSlide(startX:Int, startY:Int, dirX:Int, dirY:Int):Dynamic
    {
        var currentX = startX;
        var currentY = startY;
        do
        {
            currentX += dirX;
            currentY += dirY;
        }
        while (!level.isSolid(currentX, currentY));

        currentX -= dirX;
        currentY -= dirY;

        return { x : currentX, y : currentY };
    }

    function checkBombTrigger(triggerIDs:Array<Int>)
    {
        for (id in triggerIDs)
        {
            if(id == DisposalID)
            {
                bomb.dispose();
                level.removeObstacle(BombID);
                break;
            }
        }
    }

    public override function update()
    {
        super.update();
        handleInput();
        bombTriggerMonitor.update();

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
    var bombTriggerMonitor:TriggerMonitor;
    var breakables:Array<Breakable>;
}
