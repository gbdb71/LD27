package scenes;
 
import com.haxepunk.Scene;
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
        var robot = new Robot(5 * gridX, 7 * gridY);
        add(robot);

        var map = new Tilemap("gfx/leveltiles.png", HXP.screen.width, HXP.screen.height, gridX, gridY);
        map.setTile(10, 7, 0);
        map.setTile(9, 2, 0);
        map.setTile(2, 3, 0);
        map.setTile(3, 8, 0);
        var grid = new Grid(map.width, map.height, map.tileWidth, map.tileHeight);
        grid.setTile(10, 7, true);
        grid.setTile(9, 2, true);
        grid.setTile(2, 3, true);
        grid.setTile(3, 8, true);
        var level = new Level(map, grid);
        add(level);
    }

}
