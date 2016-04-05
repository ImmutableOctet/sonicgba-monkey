Strict

Public

' Imports:
Import special.specialobject
Import special.ssdef

Import com.sega.mobile.framework.device.mfgraphics

' Classes:
Class UsableObject Extends SpecialObject Implements SSDef Abstract
	Protected
		' Fields:
		Field used:Bool
	Public
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, z:Int, used:Bool=False)
			Super.New(id, x, y, z)
			
			Self.used = used
		End
		
		' Methods (Abstract):
		Method onUse:Void(collisionObj:SpecialObject) Abstract
		
		' Methods (Implemented):
		Method close:Void()
			' Empty implementation.
		End
		
		Method doWhileCollision:Void(collisionObj:SpecialObject)
			If (Not Self.used) Then
				onUse(collisionObj)
				
				Self.used = True
			EndIf
		End
		
		Method draw:Void(g:MFGraphics)
			' Empty implementation.
		End
		
		Method logic:Void()
			' Empty implementation.
		End
		
		Method refreshCollision:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (SSDef.PLAYER_MOVE_WIDTH / 2), y - (SSDef.PLAYER_MOVE_HEIGHT / 2), SSDef.PLAYER_MOVE_WIDTH, SSDef.PLAYER_MOVE_HEIGHT)
		End
End