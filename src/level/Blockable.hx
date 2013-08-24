package level;

interface Blockable
{
    function isSolid(column:Int, row:Int, originColumn:Int, originRow:Int):Bool;
}
