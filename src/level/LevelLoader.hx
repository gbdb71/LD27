package level;

import flash.geom.Point;
import haxe.xml.Fast;
import openfl.Assets;

class LevelLoader {

    public var bomb(default, null):Point;
    public var robot(default, null):Point;
    public var dispose(default, null):Point;
    public var breakaway(default, null):Array<Point>;
    public var layout(default, null):String;
    
    public function new() {
        breakaway = new Array<Point>();
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
        }
    }
}
