Strict

Public

' Friends:
Friend sonicgba.gimmickobject

' Imports:
Private
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
	Import sonicgba.ropestart
Public

' Classes:
Class RopeTurn Extends GimmickObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:= RopeStart.COLLISION_WIDTH
		Const COLLISION_HEIGHT:= RopeStart.COLLISION_HEIGHT
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
		End
	Public
		' Methods:
		Method doWhileNoCollision:Void()
			Self.used = False
		End
		
		Method doWhileRail:Void(player:PlayerObject, direction:Int)
			If (Not Self.used And player.outOfControl) Then
				' Optimization potential; dynamic cast.
				Local start:= RopeStart(player.outOfControlObject)
				
				If (start <> Null) Then
					If (start.degree > 90) Then
						start.posX = Self.posX
						start.posY = Self.posY
						
						start.turn()
						
						Self.used = True
					EndIf
				EndIf
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			collisionRect.setRect(x - (COLLISION_WIDTH/2), y, COLLISION_WIDTH, COLLISION_HEIGHT)
			
			Return
		End
End