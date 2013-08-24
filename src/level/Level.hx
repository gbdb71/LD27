package level;
 
import com.haxepunk.Entity;
import com.haxepunk.Tween;
import com.haxepunk.masks.Grid;
import com.haxepunk.graphics.prototype.Rect;
import com.haxepunk.graphics.Tilemap;
 
class Level extends Entity
{
    public function new(map:Tilemap, grid:Grid)
    {
        super(0, 0);
        this.map = map;
        graphic = map;
        this.grid = grid;
        mask = grid;
        type = "level";
        obstacles = new Array<Blockable>();
        sensors = new Array<Sensor>();
        pawns = new Array<Pawn>();
    }

    function isSolid(startX:Int, startY:Int, column:Int, row:Int):Bool {
        if (column < 0 || column > grid.columns - 1)
            return true;
        if (row < 0 || row > grid.rows - 1)
            return true;
        for( obstacle in obstacles ){
            if (obstacle.isSolid(column, row, startX, startY))
            {
                return true;
            }
        }
        return grid.getTile(column, row);
    }

    public function sweep(startX:Int, startY:Int, dirX:Int, dirY:Int)
    {
        var currentX = startX;
        var currentY = startY;
        do
        {
            currentX += dirX;
            currentY += dirY;
        }
        while (!isSolid(startX, startY, currentX, currentY));

        currentX -= dirX;
        currentY -= dirY;

        return { x : currentX, y : currentY };
    }

    public function getObstacles(column:Int, row:Int):Array<Blockable> {
        var colliders = new Array<Blockable>();
        for( obstacle in obstacles ){
           if (obstacle.isSolid(column, row, column, row))
           {
               colliders.push(obstacle);
           }
        }
        return colliders;
    }

    public function addObstacle(obstacle:Blockable)
    {
        obstacles.push(obstacle);
    }

    public function removeObstacle(obstacle:Blockable)
    {
        obstacles.remove(obstacle);
    }

    public function addSensor(sensor:Sensor)
    {
        sensors.push(sensor);
    }

    public function removeSensor(sensor:Sensor)
    {
        sensors.remove(sensor);
    }

    public function addPawn(pawn:Pawn)
    {
        pawn.onTileArrive = function(fromCol:Int, fromRow:Int, toCol:Int, toRow:Int)
        {
            onPawnMove(pawn, fromCol, fromRow, toCol, toRow);
        }
        pawns.push(pawn);
    }

    public function removePawn(pawn:Pawn)
    {
        if (pawns.remove(pawn))
        {
            pawn.onTileArrive = null;
        }
    }

    function onPawnMove(pawn:Pawn, fromCol:Int, fromRow:Int, toCol:Int, toRow:Int)
    {
        for (sensor in sensors)
        {
            sensor.onTile(pawn, toCol, toRow);
        }
    }

    public function shiver(dirX:Int, dirY:Int)
    {
        shiverFrame = 10;
        shiverDir = dirY;
    }

    public override function update()
    {
        super.update();
        if (shiverFrame > 0)
        {
            var val = shiverFrame % 2 * 5 - 2.5;
            if (shiverDir == 0)
                map.x = val;
            else
                map.y = val;

            shiverFrame -= 1;
            if (shiverFrame == 0)
            {
                if (shiverDir == 0)
                    map.x = 0;
                else
                    map.y = 0;
            }
        }
    }

    var map:Tilemap;
    var grid:Grid;
    var obstacles:Array<Blockable>;
    var sensors:Array<Sensor>;
    var pawns:Array<Pawn>;
    var shiverFrame:Int;
    var shiverDir:Int;
}
