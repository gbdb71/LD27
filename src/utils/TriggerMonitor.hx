package utils;

import com.haxepunk.Entity;
import level.Pawn;

class TriggerMonitor {
    public var onTileArrive:OnTileArrive;

    var pawn:Pawn;
    var dirX:Int;
    var dirY:Int;

    var lastGridX:Int;
    var lastGridY:Int;

    public function new(pawn:Pawn) {
        this.pawn = pawn;
    }

    public function setCompensation(dirX:Int, dirY:Int)
    {
        this.dirX = dirX;
        this.dirY = dirY;
    }

    public function update()
    {
        if (onTileArrive == null)
            return;

        var gridX = pawn.column;
        var gridY = pawn.row;
        if (dirX < 0)
            gridX += 1;
        if (dirY < 0)
            gridY += 1;
        if (lastGridX == gridX && lastGridY == gridY)
        {
            return;
        }

        onTileArrive(lastGridX, lastGridY, gridX, gridY);
        lastGridX = gridX;
        lastGridY = gridY;
    }
}
