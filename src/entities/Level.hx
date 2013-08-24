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

    var map:Tilemap;
    var grid:Grid;
}
