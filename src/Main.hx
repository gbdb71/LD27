import com.haxepunk.Engine;
import level.LevelCollection;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Input;
import com.haxepunk.HXP;
import scenes.PuzzleScene;

class Main extends Engine
{

	override public function init()
	{
        Input.define("left", [Key.A, Key.LEFT]);
        Input.define("right", [Key.D, Key.RIGHT]);
        Input.define("up", [Key.W, Key.UP]);
        Input.define("down", [Key.S, Key.DOWN]);
        Input.define("reset", [Key.R]);

#if debug
		HXP.console.enable();
#end
        HXP.screen.scale = 4;

        var levels = LevelCollection.getAllLevels();
		HXP.scene = new PuzzleScene(levels, 0);
	}

	public static function main() { new Main(); }

}
