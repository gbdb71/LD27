package scenes;
 
import com.haxepunk.Scene;
import com.haxepunk.Tween;
import com.haxepunk.utils.Ease;
import com.haxepunk.tweens.misc.ColorTween;
import com.haxepunk.utils.Input;
import com.haxepunk.HXP;
import com.haxepunk.Sfx;
import com.haxepunk.graphics.Text;
import level.LevelCollection;
import scenes.PuzzleScene;
 
class GameComplete extends Scene
{

    var titleText:Text;
    var promptText:Text;
    var ldText:Text;
    var continuePrimed:Bool;
    var fadeTween:ColorTween;
    var words:Array<String>;
    var wordsIndex = 0;
    var presentSound:Sfx;
    var bigPresentSound:Sfx;

    public function new()
    {
        super();
        words = ["Thank", " you", " for", " playing!"];
        presentSound = new Sfx("sfx/bomb_explode_safely.mp3");
        bigPresentSound = new Sfx("sfx/bomb_explode.mp3");
    }

    public override function begin()
    {
        HXP.screen.scale = 2;

        titleText = new Text("Game complete");
        titleText.scale = 2;
        titleText.x = titleText.textWidth / -2;
        var title = addGraphic(titleText);
        title.x = 95;
        title.y = 80;

        promptText = new Text("Thank you for playing!");
        promptText.x = promptText.textWidth / -2;
        promptText.text = "";
        var prompt = addGraphic(promptText);
        prompt.x = 160;
        prompt.y = 120;
        HXP.alarm(2, nextPrompt);
    }

    function nextPrompt(Void)
    {
        promptText.text += words[wordsIndex];
        wordsIndex += 1;
        if (wordsIndex < words.length)
        {
            presentSound.play();
            HXP.alarm(0.5, nextPrompt);
        }
        else
            bigPresentSound.play();
    }

    public override function update()
    {
        super.update();
    }

}
