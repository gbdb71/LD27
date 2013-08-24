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

    var gridX = 8;
    var gridY = 8;

    public function new()
    {
        super();
    }

    public override function begin()
    {
        robot = new Robot(5 * gridX, 7 * gridY);
        add(robot);

        var map = new Tilemap("gfx/leveltiles.png", Math.floor(HXP.screen.width / HXP.screen.scale), Math.floor(HXP.screen.height / HXP.screen.scale), gridX, gridY);
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

        bomb = new Bomb(5 * gridX, 9 * gridY);
        add(bomb);

        level.markObstacle(5, 9, true, BombID);
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
    }

    var robot:Robot;
    var level:Level;
    var bomb:Bomb;
}
