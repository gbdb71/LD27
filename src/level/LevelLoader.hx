package level;

import flash.geom.Point;
import haxe.xml.Fast;
import openfl.Assets;

typedef RampDef = {point:Point, dirX:Int, dirY:Int};
typedef DoorDef = {point:Point, name:String};
typedef SwitchDef = {point:Point, target:String};

class LevelLoader {

    public var bomb(default, null):Point;
    public var robot(default, null):Point;
    public var dispose(default, null):Point;
    public var breakaway(default, null):Array<Point>;
    public var ramps(default, null):Array<RampDef>;
    public var doors(default, null):Array<DoorDef>;
    public var switches(default, null):Array<SwitchDef>;
    public var layout(default, null):String;
    
    public function new() {
        breakaway = new Array<Point>();
        ramps = new Array<RampDef>();
        doors = new Array<DoorDef>();
        switches = new Array<SwitchDef>();
    }

    public function parse(filename:String)
    {
        var levelData = Assets.getText(filename);
        var xmlData = Xml.parse(levelData);
        var levelXml = new Fast(xmlData).node.map;
        var tileWidth = Std.parseInt(levelXml.att.tilewidth);
        var tileHeight = Std.parseInt(levelXml.att.tileheight);
        var tileData = levelXml.nodes.layer.first().node.data;
        layout = StringTools.trim(tileData.innerData);

        var objects = levelXml.nodes.objectgroup.first().nodes.object;
        for (obj in objects)
        {
            var x = Math.floor(Std.parseInt(obj.att.x) / tileWidth);
            var y = Math.floor(Std.parseInt(obj.att.y) / tileHeight);
            if (obj.att.type == "bomb")
                bomb = new Point(x, y);
            else if (obj.att.type == "robot")
                robot = new Point(x, y);
            else if (obj.att.type == "dispose")
                dispose = new Point(x, y);
            else if (obj.att.type == "breakable")
            {
                var breakable = new Point(x, y);
                breakaway.push(breakable);
            }
            else if (obj.att.type == "ramp")
            {
                var point = new Point(x, y);
                var dirX = 0;
                var dirY = 0;
                for (prop in obj.node.properties.nodes.property)
                {
                    if (prop.att.name == "dirX")
                        dirX = Std.parseInt(prop.att.value);
                    if (prop.att.name == "dirY")
                        dirY = Std.parseInt(prop.att.value);
                }
                var ramp:RampDef = { point : point, dirX:dirX, dirY:dirY};
                ramps.push(ramp);
            }
            else if (obj.att.type == "door")
            {
                var point = new Point(x, y);
                var name = obj.att.name;
                var door:DoorDef = { point : point, name:name };
                doors.push(door);
            }
            else if (obj.att.type == "switch")
            {
                var point = new Point(x, y);
                var target = obj.node.properties.nodes.property.first().att.value;
                var swtch:SwitchDef = { point : point, target:target };
                switches.push(swtch);
            }
        }
    }
}
