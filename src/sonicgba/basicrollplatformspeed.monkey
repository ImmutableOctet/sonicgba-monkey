Strict

Public

' Imports:
Import lib.myapi

Import sonicgba.gimmickobject
Import sonicgba.playerobject
'Import sonicgba.playerknuckles
Import sonicgba.stagemanager

Import com.sega.mobile.framework.device.mfgraphics
Import com.sega.mobile.framework.device.mfimage

' Classes:

' This acts as a base-class for the "RollPlatformSpeed" classes.
' This class is an extension based on shared/duplicate code.
Class BasicRollPlatformSpeed Extends GimmickObject Abstract
	Public
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 3072
		Const COLLISION_HEIGHT:Int = 960
		
		Const COLLISION_OFFSET_Y:Int = 256
		
		Const DRAW_OFFSET_Y:Int = 768
	Protected
		' Constant variable(s):
		Const RING_RANGE:Int = 16
		
		' Extensions:
		Const MAX_DEGREE_SCALED:= (360 Shl 6) ' 23040
		
		' Fields:
		Field direction:Bool
		
		Field radius:Int
		
		Field centerX:Int
		Field centerY:Int
		
		Field offsetY2:Int
		
		Field ring1PosX:Int
		Field ring1PosY:Int
		
		Field ring2PosX:Int
		Field ring2PosY:Int
		
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			If (Self.mWidth > Self.mHeight) Then
				Self.radius = Self.mWidth
				Self.direction = False
			Else
				Self.radius = Self.mHeight
				Self.direction = True
			EndIf
			
			Self.centerX = Self.posX
			Self.centerY = Self.posY
			
			If (rolllinkImage = Null) Then
				rolllinkImage = MFImage.createImage("/gimmick/roll_ring.png")
			EndIf
			
			loadPlatformImage()
		End
		
		' Methods:
		
		' Extensions:
		Method onSetOffsetY2:Int(value:Int)
			Return value
		End
	Public
		' Methods:
		
		' Extensions:
		Method logic_BasicRollPlatformSpeed:Void(degree:Int)
			If (StageManager.getCurrentZoneId() >= 3 And StageManager.getCurrentZoneId() <= 6) Then
				Self.offsetY2 = onSetOffsetY2(GimmickObject.PLATFORM_OFFSET_Y)
			EndIf
			
			Local thisDegree:= (degree + ((Self.iLeft * MAX_DEGREE_SCALED) / RING_RANGE))
			
			Local preX:= Self.posX
			Local preY:= Self.posY
			
			thisDegree = ((thisDegree + MAX_DEGREE_SCALED) Mod MAX_DEGREE_SCALED)
			
			If (Not Self.direction) Then
				thisDegree = (((-thisDegree) + MAX_DEGREE_SCALED) Mod MAX_DEGREE_SCALED)
			EndIf
			
			Self.posX = ((Self.centerX * 100) + (Self.radius * MyAPI.dCos(thisDegree Shr 6))) / 100
			Self.posY = ((Self.centerY * 100) + (Self.radius * MyAPI.dSin(thisDegree Shr 6))) / 100
			
			Self.ring1PosX = ((Self.centerX * 100) + ((Self.radius / 3) * MyAPI.dCos(thisDegree Shr 6))) / 100
			Self.ring1PosY = ((Self.centerY * 100) + ((Self.radius / 3) * MyAPI.dSin(thisDegree Shr 6))) / 100
			
			Self.ring2PosX = ((Self.centerX * 100) + (((Self.radius * 2) / 3) * MyAPI.dCos(thisDegree Shr 6))) / 100
			Self.ring2PosY = ((Self.centerY * 100) + (((Self.radius * 2) / 3) * MyAPI.dSin(thisDegree Shr 6))) / 100
			
			checkWithPlayer(preX, preY, Self.posX, Self.posY)
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If (Not player.isFootOnObject(Self)) Then
				Select (direction)
					Case DIRECTION_DOWN
						player.beStop(Self.collisionRect.y0, DIRECTION_DOWN, Self) ' direction
						
						Self.used = True
					Case DIRECTION_NONE
						If (player.getMoveDistance().y > 0 And player.getCollisionRect().y1 < Self.collisionRect.y1) Then
							player.beStop(Self.collisionRect.y0, DIRECTION_DOWN, Self)
							
							Self.used = True
						EndIf
					Default
						' Nothing so far.
				End Select
			EndIf
		End
		
		Method draw:Void(g:MFGraphics)
			If (StageManager.getCurrentZoneId() = 6 Or StageManager.getCurrentZoneId() = 4) Then
				drawInMap(g, rolllinkImage, 0, 0, RING_RANGE, RING_RANGE, 0, Self.centerX, Self.centerY, VCENTER|HCENTER)
				drawInMap(g, rolllinkImage, RING_RANGE, 0, RING_RANGE, RING_RANGE, 0, Self.ring1PosX, Self.ring1PosY, VCENTER|HCENTER)
				drawInMap(g, rolllinkImage, RING_RANGE, 0, RING_RANGE, RING_RANGE, 0, Self.ring2PosX, Self.ring2PosY, VCENTER|HCENTER)
			EndIf
			
			drawInMap(g, platformImage, Self.posX, Self.posY, VCENTER|HCENTER)
			
			drawCollisionRect(g)
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), ((y + COLLISION_OFFSET_Y) - DRAW_OFFSET_Y) + Self.offsetY2, COLLISION_WIDTH, COLLISION_HEIGHT) ' PlayerObject.HEIGHT
		End
		
		Method getPaintLayer:Int()
			Return DRAW_BEFORE_SONIC
		End
End