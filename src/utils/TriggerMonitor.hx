package utils;

import com.haxepunk.Entity;
import entities.Level;

class TriggerMonitor {
    public var onTrigger:Array<Int>->Void;

    var entity:Entity;
    var level:Level;
    var gridWidth:Int;
    var gridHeight:Int;
    var dirX:Int;
    var dirY:Int;

    var lastGridX:Int;
    var lastGridY:Int;

    public function new(entity:Entity, level:Level, gridWidth:Int, gridHeight:Int) {
        this.entity = entity;
        this.level = level;
        this.gridWidth = gridWidth;
        this.gridHeight = gridHeight;
    }

    public function setCompensation(dirX:Int, dirY:Int)
    {
        this.dirX = dirX;
        this.dirY = dirY;
    }

    public function update()
    {
        if (onTrigger == null)
            return;

        var gridX = Math.floor(entity.x / gridWidth);
        var gridY = Math.floor(entity.y / gridHeight);
        if (dirX < 0)
            gridX += 1;
        if (dirY < 0)
            gridY += 1;
        if (lastGridX == gridX || lastGridY == gridY)
        {
            return;
        }

        var obstacles = level.getObstacles(gridX, gridY);
        if (obstacles.length > 0)
        {
            onTrigger(obstacles);
        }
    }
}
