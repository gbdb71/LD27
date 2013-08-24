package scenes;
 
import com.haxepunk.Scene;
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
 
class PuzzleScene extends Scene
{
    private static inline var BombID:Int = 0;
    private static inline var DisposalID:Int = 1;

    private static inline var EntityLayer:Int = 0;
    private static inline var DisposalLayer:Int = 1;
    private static inline var LevelLayer:Int = 2;

    var gridX = 8;
    var gridY = 8;
    var playAreaWidth = 160;
    var playAreaHeight = 120;

    public function new()
    {
        super();
    }

    public override function begin()
    {
        robot = new Robot(5 * gridX, 7 * gridY);
        add(robot);
        robot.layer = EntityLayer;

        var map = new Tilemap("gfx/leveltiles.png", playAreaWidth, playAreaHeight, gridX, gridY);
        map.setTile(10, 7, 0);
        map.setTile(9, 2, 0);
        map.setTile(2, 3, 0);
        map.setTile(3, 8, 0);
        var grid = new Grid(map.width, map.height, map.tileWidth, map.tileHeight);
        grid.setTile(10, 7, true);
        grid.setTile(9, 2, true);
        grid.setTile(2, 3, true);
        grid.setTile(3, 8, true);
        level = new Level(map, grid);
        add(level);
        level.layer = LevelLayer;

        bomb = new Bomb(5 * gridX, 9 * gridY);
        add(bomb);
        bomb.layer = EntityLayer;

        level.markObstacle(5, 9, true, BombID);
        level.markObstacle(15, 14, false, DisposalID);
        var disposeIndicator = addGraphic(new Rect(8, 8, 0x00FF00));
        disposeIndicator.x = 15 * gridX;
        disposeIndicator.y = 14 * gridY;
        disposeIndicator.layer = DisposalLayer;
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
        var robotColliderX = Math.floor(robot.x / gridX) + dirX;
        var robotColliderY = Math.floor(robot.y / gridY) + dirY;

        var obstacleID = level.getObstacle(robotColliderX, robotColliderY);
        if (obstacleID == BombID)
        {
            moveBomb(dirX, dirY);
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

    public override function update()
    {
        super.update();
        handleInput();
        if (bomb.isMoving)
        {
            var tileX = Math.floor(bomb.x / gridX);
            var tileY = Math.floor(bomb.y / gridY);
            if(level.getObstacle(tileX, tileY) == DisposalID)
            {
                bomb.x = tileX * gridX;
                bomb.y = tileY * gridY;
                bomb.dispose();
                level.removeObstacle(BombID);
            }
        }

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
}
