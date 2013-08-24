package entities;
 
import com.haxepunk.Entity;
import com.haxepunk.masks.Grid;
import com.haxepunk.graphics.prototype.Rect;
import com.haxepunk.graphics.Tilemap;
 
private class Obstacle
{
    public var column(default, null):Int;
    public var row(default, null):Int;
    public var solid(default, null):Bool;
    public var id(default, null):Int;
    public var data(default, null):Dynamic;

    public function new(column:Int, row:Int, solid:Bool, id:Int, ?data:Dynamic) {
        this.column = column;
        this.row = row;
        this.solid = solid;
        this.id = id;
        this.data = data;
    }
}

class Level extends Entity
{
    public static inline var NoObstacleID = -1;

    public function new(map:Tilemap, grid:Grid)
    {
        super(0, 0);
        this.map = map;
        graphic = map;
        this.grid = grid;
        mask = grid;
        type = "level";
        obstacles = new Array<Obstacle>();
    }

    public function isSolid(column:Int, row:Int):Bool {
        if (column < 0 || column > grid.columns - 1)
            return true;
        if (row < 0 || row > grid.rows - 1)
            return true;
        for( obstacle in obstacles ){
            if (obstacle.column == column && obstacle.row == row && obstacle.solid)
            {
                return true;
            }
        }
        return grid.getTile(column, row);
    }

    public function markObstacle(column:Int, row:Int, solid:Bool, id:Int)
    {
        var obstacle = new Obstacle(column, row, solid, id);
        obstacles.push(obstacle);
    }

    public function getObstacles(column:Int, row:Int):Array<Int> {
        var colliders = new Array<Int>();
        for( obstacle in obstacles ){
           if (obstacle.column == column && obstacle.row == row)
           {
               colliders.push(obstacle.id);
           }
        }
        return colliders;
    }

    public function removeObstacle(id:Int)
    {
        var removable:Obstacle = null;
        for( obstacle in obstacles ){
           if (obstacle.id == id)
           {
               removable = obstacle;
               break;
           }
        }

        if (removable != null)
        {
            obstacles.remove(removable);
        }
    }

    var map:Tilemap;
    var grid:Grid;
    var obstacles:Array<Obstacle>;
}
