package entities;
 
import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Text;
import de.polygonal.Printf;
 
class Timer extends Entity
{
    private static inline var countSpeed:Float = 50;
    
    var timerText:Text;
    var timer:Float;
    var timerTarget:Float;
    var speed:Float;

    public function new(x:Float, y:Float, timeout:Float)
    {
        super(x, y);
        timer = timeout * 1000;
        timerTarget = timer;
        timerText = new Text("");
        graphic = timerText;
        speed = countSpeed;
        updateText();
    }

    public function isDone():Bool
    {
        return timer <= 0;
    }

    public function sub(amount:Float, speed:Float):Bool {
        if (timerTarget <= 0)
            return false;

        timerTarget -= amount * 1000;
        this.speed = speed;
        updateText();
        return true;
    }

    function updateText()
    {
        var seconds = Math.floor(timer / 1000);
        var miliseconds = timer - seconds * 1000;
        
        var text = Printf.format("'%02d\"%03d", [seconds, miliseconds]);
        timerText.text = text;
        timerText.x = -timerText.textWidth;
    }

    public override function update()
    {
        super.update();
        if (timer != timerTarget)
        {
            var direction = HXP.sign(timerTarget - timer);
            timer += speed * direction;
            var newDirection = HXP.sign(timerTarget - timer);
            if (direction != newDirection)
            {
                timer = timerTarget;
            }
            updateText();
        }
    }
}
