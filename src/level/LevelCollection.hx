package level;
import openfl.Assets;

class LevelCollection {
    public static function getAllLevels():Array<String> {
        var levels = Assets.getText("levels/_list.txt");
        return StringTools.trim(levels).split("\n");
    }
}
