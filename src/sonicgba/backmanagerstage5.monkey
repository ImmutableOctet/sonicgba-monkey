Strict

Public

' Imports:
Private
	Import gameengine.def
	
	Import lib.myapi
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
	
	Import sonicgba.backgroundmanager
Public

' Classes:
Class BackManagerStage5 Extends BackGroundManager
	Private
		' Constant variable(s):
		Const CLOUD_X:= 0
		Const CLOUD_Y:= 0
		
		Const CLOUD_ANCHOR:= 20
		
		' Global variable(s):
		Global BG_WIDTH:Int = 256
		Global IMAGE_WIDTH:Int = BG_WIDTH
		
		' Fields:
		Field backImage:MFImage
		Field cloudImage:MFImage
		
		Field cloudPosX:Int = CLOUD_X
	Public
		' Constructor(s):
		Method New()
			Self.backImage = MFImage.createImage("/map/stage5_bg_0.png")
			Self.cloudImage = MFImage.createImage("/map/stage5_bg_1.png")
			
			IMAGE_WIDTH = MyAPI.zoomIn(Self.cloudImage.getWidth(), True)
			BG_WIDTH = MyAPI.zoomIn(Self.backImage.getWidth(), True)
		End
		
		' Methods:
		Method close:Void()
			Self.backImage = Null
			Self.cloudImage = Null
		End
		
		Method draw:Void(graphics:MFGraphics)
			' Not sure what "anchor" actually is, but it's the name of the final argument.
			MyAPI.drawImage(graphics, Self.backImage, CLOUD_X, CLOUD_Y, CLOUD_ANCHOR)
			
			If (BG_WIDTH < Def.SCREEN_WIDTH) Then
				MyAPI.drawImage(graphics, Self.backImage, BG_WIDTH, CLOUD_Y, CLOUD_ANCHOR)
			EndIf
			
			If (Not GameObject.IsGamePause) Then
				Self.cloudPosX += 1
				Self.cloudPosX Mod= IMAGE_WIDTH
			EndIf
			
			For Local j:= -IMAGE_WIDTH Until (MapManager.CAMERA_WIDTH + Self.cloudPosX) Step IMAGE_WIDTH
				MyAPI.drawImage(graphics, Self.cloudImage, Self.cloudPosX + j, CLOUD_Y, CLOUD_ANCHOR)
			Next
		End
End