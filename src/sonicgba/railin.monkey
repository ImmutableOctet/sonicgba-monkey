Strict

Public

' Friends:
Friend sonicgba.gimmickobject
Friend sonicgba.railout

' Imports:
Private
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
Public

' Classes:
Class RailIn Extends GimmickObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 2560
		Const COLLISION_HEIGHT:Int = 2560
		
		Const IMAGE_HEIGHT:Int = 1536
	Public
		' Global variable(s):
		Global railInOutImage:MFImage
		
		' Functions:
		Function MakeImage:MFImage()
			If (railInOutImage = Null) Then
				railInOutImage = MFImage.createImage("/gimmick/gimmick_67_68.png")
			EndIf
			
			Return railInOutImage
		End
		
		Function releaseAllResource:Void()
			railInOutImage = Null
		End
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			MakeImage()
		End
	Public
		' Methods:
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH/2), y - (COLLISION_HEIGHT/2), COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method doWhileCollision:Void(p:PlayerObject, direction:Int)
			Select (direction)
				Case DIRECTION_DOWN
					' This behavior may change in the future:
					If (p = player And Not Self.used) Then
						p.railIn(Self.posX, Self.posY) ' player
						
						Self.used = True
					EndIf
				Case DIRECTION_RIGHT, DIRECTION_LEFT
					' Magic number: 0 (Not really sure)
					p.beStop(0, direction, Self) ' player
				Default
					' Nothing so far.
			End
		End
		
		Method getPaintLayer:Int()
			Return DRAW_BEFORE_BEFORE_SONIC
		End
		
		Method doWhileRail:Void(player:PlayerObject, direction:Int)
			' Magic number: Player animation ID; likely defined in 'PlayerObject'.
			player.setAnimationId(21)
		End
		
		Method draw:Void(graphics:MFGraphics)
			drawInMap(graphics, railInOutImage, Self.posX, (Self.posY - COLLISION_HEIGHT) + IMAGE_HEIGHT, 17)
			
			drawCollisionRect(graphics)
		End
		
		Method doWhileNoCollision:Void()
			Self.used = False
		End
End