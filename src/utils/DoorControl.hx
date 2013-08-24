package utils;

import entities.Door;

typedef DoorBucket = Array<Door>;

class DoorControl {
    var channels:Map<String, DoorBucket>;

    public function new() {
        channels = new Map<String, DoorBucket>();
    }

    public function add(name:String, door:Door) {
        var bucket:DoorBucket = channels.get(name);
        if (bucket == null)
        {
            bucket = new DoorBucket();
            channels.set(name, bucket);
        }
        bucket.push(door);
    }

    public function setOpen(name:String, open:Bool)
    {
        var bucket:DoorBucket = channels.get(name);
        if (bucket == null)
        {
            return;
        }

        for (door in bucket)
        {
            door.setOpen(open);
        }
    }
}
