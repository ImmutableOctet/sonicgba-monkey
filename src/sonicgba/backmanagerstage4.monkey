Strict

Public

' Imports:
Private
	Import gameengine.def
	
	Import common.waveinverteffect
	
	Import lib.myapi
	
	Import sonicgba.backgroundmanager
	Import sonicgba.mapmanager
	Import sonicgba.stagemanager
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
Public

' Classes:
Class BackManagerStage4 Extends BackGroundManager
	Private
		' Constant variable(s):
		Const IMAGE_WIDTH:Int = 240
		Const IMAGE_HEIGHT:Int = 512
		
		' Fields:
		Field image:MFImage
		
		Field speedx:Int
		Field speedy:Int
	Public
		' Constructor(s):
		Method New(subid:Int)
			Self.speedx = 0
			Self.speedy = 0
			
			Self.image = MFImage.createImage("/map/stage4_bg.png")
			
			If (subid = 0) Then
				Self.speedx = 637
				Self.speedy = 9
			Else
				Self.speedx = 535
				Self.speedy = 7
			EndIf
		End
		
		' Methods:
		Method close:Void()
			If (MFImage.releaseImage(Self.image)) Then
				Self.image = Null
			EndIf
		End
		
		Method draw:Void(g:MFGraphics)
			'Print("Skipping background.")
			
			Return
			
			Local camera:= MapManager.getCamera()
			
			Local cameraX:= camera.x
			Local cameraY:= camera.y
			
			Local waterLevel:= StageManager.getWaterLevel()
			
			For Local i:= 0 Until MapManager.CAMERA_HEIGHT Step IMAGE_HEIGHT
				For Local j:= 0 Until MapManager.CAMERA_WIDTH Step IMAGE_WIDTH
					' Magic numbers: 40, 2
					WaveInvertEffect.drawImage(g, Self.image, (-(cameraX / Self.speedx)) + j, -(cameraY / Self.speedy), 0, 0, IMAGE_WIDTH, 40, 2)
				Next
			Next
			
			g.setClip(0, 0, SCREEN_WIDTH, waterLevel - cameraY)
			
			For Local i:= 0 Until MapManager.CAMERA_HEIGHT Step IMAGE_HEIGHT
				For Local j:= 0 Until MapManager.CAMERA_WIDTH Step IMAGE_WIDTH
					MyAPI.drawImage(g, Self.image, (-(cameraX / Self.speedx)) + j, -(cameraY / Self.speedy), 0)
				End
			End
			
			g.setClip(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
		End
End