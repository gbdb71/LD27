package scenes;
 
import com.haxepunk.Scene;
import com.haxepunk.Tween;
import com.haxepunk.utils.Ease;
import com.haxepunk.tweens.misc.ColorTween;
import com.haxepunk.utils.Input;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Text;
import level.LevelCollection;
import scenes.PuzzleScene;
 
class Intro extends Scene
{

    var titleText:Text;
    var promptText:Text;
    var continuePrimed:Bool;
    var fadeTween:ColorTween;

    public function new()
    {
        super();
    }

    public override function begin()
    {
        HXP.screen.scale = 2;

        titleText = new Text("Last second hero");
        titleText.scale = 2;
        titleText.x = titleText.textWidth / -2;
        var title = addGraphic(titleText);
        title.x = 80;
        title.y = 20;

        promptText = new Text("Click here to continue...");
        promptText.x = promptText.textWidth / -2;
        var prompt = addGraphic(promptText);
        prompt.x = 160;
        prompt.y = 200;

        fadeTween = new ColorTween(onPromptFade, TweenType.Persist);
        fadeTween.alpha = 1;
        addTween(fadeTween);
    }

    function onPromptFade(Void):Void
    {
        var levels = LevelCollection.getAllLevels();
	    HXP.scene = new PuzzleScene(levels, 0);
    }

    public override function update()
    {
        if (Input.mouseDown)
        {
            continuePrimed = true;
        }
        else if (continuePrimed)
        {
            continuePrimed = false;
            fadeTween.tween(1, 0xFFFFFF, 0xFFFFFF, 1, 0, Ease.quadInOut);
        }

        promptText.alpha = fadeTween.alpha;
    }

}
