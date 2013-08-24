package utils;

import flash.geom.Point;
import haxe.xml.Fast;
import openfl.Assets;

class LevelLoader {

    public var bomb(default, null):Point;
    public var robot(default, null):Point;
    public var dispose(default, null):Point;
    public var layout(default, null):String;
    
    public function new() {
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
            if (obj.att.name == "bomb")
                bomb = new Point(x, y);
            if (obj.att.name == "robot")
                robot = new Point(x, y);
            if (obj.att.name == "dispose")
                dispose = new Point(x, y);
        }
    }
}
