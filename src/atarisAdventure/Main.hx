package atarisAdventure;

import flambe.asset.File;
import flambe.display.Font;
import flambe.display.TextSprite;
import flambe.Entity;
import flambe.input.PointerEvent;
import flambe.System;
import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import flambe.util.SignalConnection;
import haxe.xml.Fast;

import atarisAdventure.utils.AssetName;
import atarisAdventure.pxlSq.Utils;

class Main
{
	private static var assetPack: AssetPack;
	private static var titleFont: Font;
		
	private static var titleScreenEntity: Entity;
	private static var mainGameScreenEntity: Entity;
	
	private static var headerBG: FillSprite;
	private static var headerText: TextSprite;
	
	private static var adventureEngine: AdventureEngine;
	
	private static var titleScreenSignalConnection: SignalConnection;
	
	private static inline var DEFAULT_BACKGROUND_TITLE_HEIGHT = 100;
	
	private static inline var DEFAULT_BACKGROUND_HEIGHT = 50;
	
    private static function main ()
    {
        // Wind up all platform-specific stuff
        System.init();

        // Load up the compiled pack in the assets directory named "bootstrap"
        var manifest = Manifest.fromAssets("bootstrap");
        var loader = System.loadAssetPack(manifest);
        loader.get(onSuccess);
    }

    private static function onSuccess (pack :AssetPack)
    {
        // Add a solid color background
        var background = new FillSprite(0x202020, System.stage.width, System.stage.height);
        System.root.addChild(new Entity().add(background));

        // Add a plane that moves along the screen
        //var plane = new ImageSprite(pack.getTexture("plane"));
        //plane.x._ = 30;
        //plane.y.animateTo(200, 6);
        //System.root.addChild(new Entity().add(plane));
		
		assetPack = pack;
		titleFont = new Font(assetPack, AssetName.FONT_BEBASNEUE);
		
		createTitleScreen();
		createMainGameScreen();
		
		//showTitleScreen();
		showMainGameScreen();
    }
	
	private static function createTitleScreen() {
		titleScreenEntity = new Entity();
		
		var titleEntity: Entity = new Entity();
		var titleBG: FillSprite = new FillSprite(0xFFFFFF, System.stage.width, DEFAULT_BACKGROUND_TITLE_HEIGHT);
		titleBG.y._ = System.stage.height / 2 - (titleBG.height._ / 2);
		titleEntity.add(titleBG);
		
		var atarisText: TextSprite = new TextSprite(titleFont, "Ataris");
		atarisText.centerAnchor();
		atarisText.x._ = System.stage.width / 2;
		atarisText.y._ = titleBG.height._ / 2 - (atarisText.getNaturalHeight() / 2);
		titleEntity.addChild(new Entity().add(atarisText));		
		
		var adventureText: TextSprite = new TextSprite(titleFont, "Adventure");
		adventureText.centerAnchor();
		adventureText.x._ = System.stage.width / 2;
		adventureText.y._ = titleBG.height._ / 2 + (adventureText.getNaturalHeight() / 2);
		titleEntity.addChild(new Entity().add(adventureText));
		
		titleScreenEntity.addChild(titleEntity);
	}
	
	private static function createMainGameScreen() {
		mainGameScreenEntity = new Entity();
		
		adventureEngine = new AdventureEngine();
		adventureEngine.Init(titleFont, assetPack.getFile(AssetName.XML_ATARIS_ADVENTURE));
		mainGameScreenEntity.add(adventureEngine);
		
		//var headerEntity: Entity = new Entity();
		//headerBG = new FillSprite(0xFFFFFF, System.stage.width * 0.8, 200);
		//headerBG.x._ = System.stage.width / 2 - (headerBG.width._ / 2);
		//headerBG.y._ = System.stage.height * 0.3 - (headerBG.height._ / 2);
		////headerBG.setAlpha(0);
		//headerEntity.add(headerBG);
		//
		//headerText = new TextSprite(titleFont, "\"You see, sir. Your caravan will give me opportunities to seek out the truth of who I am and where I came from. I woke up in the middle of the desert with no memories and your caravan is the first help I could find. I just want to survive and find out who I am.\"");
		//headerText.setXY(10, 10);
		//headerText.setWrapWidth(500);
		////headerText.setAlpha(0);
		//headerEntity.addChild(new Entity().add(headerText));
		//
		//mainGameScreenEntity.addChild(headerEntity);
	}
	
	private static function showTitleScreen() {		
		titleScreenSignalConnection = System.pointer.down.connect(
			function(event: PointerEvent) {
				showMainGameScreen();
			}
		);
		
		System.root.addChild(titleScreenEntity);
	}
	
	private static function showMainGameScreen() {
		//var script: Script = new Script();
		//script.run(new Sequence([
				//new AnimateTo(headerBG.alpha, 1, 1),
				//new AnimateTo(headerText.alpha, 1, 1)
			//])
		//);
		//
		//mainGameScreenEntity.add(script);
		//mainGameScreenEntity.addChild(new Entity().add(script));
		
		System.root.removeChild(titleScreenEntity);
		System.root.addChild(mainGameScreenEntity);
	}
}
