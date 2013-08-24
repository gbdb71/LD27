package scenes;
 
import com.haxepunk.Scene;
import com.haxepunk.utils.Input;
import com.haxepunk.masks.Grid;
import com.haxepunk.graphics.Tilemap;
import com.haxepunk.HXP;
import entities.Robot;
import entities.Level;
 
class PuzzleScene extends Scene
{
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
        if (!validMove || robot.isMoving)
            return;

        moveRobot(moveX, moveY);
    }

    private function moveRobot(dirX:Int, dirY:Int) {
        var startRobotTileX = Math.floor(robot.x / gridX);
        var startRobotTileY = Math.floor(robot.y / gridY);
        var robotTileX:Int = startRobotTileX;
        var robotTileY:Int = startRobotTileY;
        while (!level.isSolid(robotTileX, robotTileY))
        {
            robotTileX += dirX;
            robotTileY += dirY;
        }
        robotTileX -= dirX;
        robotTileY -= dirY;

        if (robotTileX == startRobotTileX && robotTileY == startRobotTileY)
        {
            return;
        }
        robot.move(robotTileX * gridX, robotTileY * gridY);
    }


    public override function update()
    {
        super.update();
        handleInput();
    }

    var robot:Robot;
    var level:Level;
}
