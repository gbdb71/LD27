package level;

interface Pawn
{
    var row(get,set):Int;
    var column(get,set):Int;
    // previousCol, previousRow, newCol, newRow
    var onTileArrive:Int->Int->Int->Int;
}
