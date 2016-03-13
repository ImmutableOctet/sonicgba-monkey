Strict

Public

' Imports:
Import sonicgba.gimmickobject
Import sonicgba.playerobject
Import sonicgba.ropestart

' Classes:
Class RopeTurn Extends GimmickObject
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
		
		Method doWhileRail:Void(var1:PlayerObject, var2:Int)
			' Likely a dynamic cast potential performance hit.
			' (Potentially unsafe usage if that's true)
			Local var3:= RopeStart(var1.outOfControlObject)
			
			If (var3.degree > 90) Then
				var3.posX = Self.posX
				var3.posY = Self.posY
				
				var3.turn()
				
				Self.used = True
				
				Return
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			' Most likely centered with a width of 1024, and a height of 2560.
			' Not completely sure, but it seems like a safe bet.
			collisionRect.setRect(x - 512, y, 1024, 2560)
			
			Return
		End
End