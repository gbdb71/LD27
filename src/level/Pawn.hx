package level;

// previousCol, previousRow, newCol, newRow
typedef OnTileArrive = Int->Int->Int->Int->Void;

interface Pawn
{
    var row(get,set):Int;
    var column(get,set):Int;
    var onTileArrive:OnTileArrive;
}
