package utils;

import com.haxepunk.Entity;
import com.haxepunk.Tween;
import com.haxepunk.utils.Ease;
import com.haxepunk.tweens.motion.LinearMotion;

class SlideBehaviour {
    private static inline var speed:Float = 50;

    var moveTween:LinearMotion;
    public var isMoving(default, null):Bool;
    public var onMoveFinished:Void->Void;

    private var entity:Entity;

    public function new(entity:Entity)
    {
        this.entity = entity;
        moveTween = new LinearMotion(moveComplete);
        entity.addTween(moveTween);
    }

    private function moveComplete(tween:Dynamic) {
        isMoving = false;
        entity.x = moveTween.x;
        entity.y = moveTween.y;
        if (onMoveFinished != null)
        {
            onMoveFinished();
        }
    }

    public function move(toX:Float, toY:Float, ease:EaseFunction)
    {
        if (!isMoving)
        {
            moveTween.setMotionSpeed(entity.x, entity.y, toX, toY, speed, ease);
            isMoving = true;
        }
    }

    public function stop()
    {
        if (isMoving)
        {
            isMoving = false;
            moveTween.cancel();
        }
    }

    public function update()
    {
        if (isMoving)
        {
            entity.x = moveTween.x;
            entity.y = moveTween.y;
        }
    }
}
