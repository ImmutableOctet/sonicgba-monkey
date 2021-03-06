Strict

Public

' Friends:
Friend sonicgba.gimmickobject

' Imports:
Private
	Import lib.constutil
	
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class Block Extends GimmickObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 128
		Const COLLISION_HEIGHT:Int = 128
		
		Const Y_OFFSET:Int = 1024
		
		' Fields:
		Field collisionHeight:Int
		Field collisionWidth:Int
		
		Field direct:Int
		
		Field width__block:Int
		Field height__block:Int
		
		Field isActive:Bool
	Protected
		' Constructor(s):
		Method New(x:Int, y:Int, width__block:Int, height__block:Int, direct:Int)
			Super.New(GIMMICK_BLOCK, x, y, 0, 0, width__block, height__block)
			
			Self.height__block = 0
			
			Self.posX = x
			Self.posY = (y + Y_OFFSET)
			
			Self.width__block = (width__block * 8) Shl 6
			Self.collisionWidth = Self.width__block
			Self.height__block = (height__block * 4) Shl 6
			Self.direct = direct
			Self.isActive = False
		End
		
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width__block:Int, height__block:Int)
			Super.New(id, x, y, left, top, width__block, height__block)
			
			Self.height__block = 0
			Self.direct = Self.iLeft
			
			Self.isActive = False
		End
	Public
		' Methods:
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If (direction = 1 Or direction = 0) Then
				player.beStop(0, direction, Self)
			EndIf
			
			If (direction <> 2 And direction <> 3) Then
				Return
			EndIf
			
			If (player.getFootPositionY() >= Self.collisionRect.y0 + ((Self.mHeight * 3) / 4)) Then
				player.beStop(0, direction, Self)
			ElseIf (player.getVelX() > 0 And direction = 3) Then
				player.setFootPositionY(Self.collisionRect.y0 - (COLLISION_HEIGHT / 2))
			ElseIf (player.getVelX() < 0 And direction = 2) Then
				player.setFootPositionY(Self.collisionRect.y0 - (COLLISION_HEIGHT / 2))
			EndIf
		End
		
		Method logic:Void()
			If (Self.collisionRect.collisionChk(player.getCollisionRect()) And player.collisionState = PlayerObject.COLLISION_STATE_ON_OBJECT) Then
				player.moveOnObject(player.footPointX + PickValue((Self.direct = 0), -COLLISION_WIDTH, COLLISION_WIDTH), player.footPointY)
				
				Self.isActive = True
				
				player.isOnBlock = True
			EndIf
		End
		
		Method doWhileNoCollision:Void()
			' Empty implementation.
		End
		
		Method draw:Void(g:MFGraphics)
			drawCollisionRect(g)
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x, y, Self.mWidth, Self.mHeight)
		End
End