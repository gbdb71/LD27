package entities;
 
import com.haxepunk.Entity;
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
    }

    public function isSolid(column:Int, row:Int):Bool {
        if (column < 0 || column > grid.columns - 1)
            return true;
        if (row < 0 || row > grid.rows - 1)
            return true;
        return grid.getTile(column, row);
    }

    var map:Tilemap;
    var grid:Grid;
}
