Strict

Public

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	
	Import sonicgba.gameobject
	Import sonicgba.mapmanager
	Import sonicgba.sonicdef
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class StarEffect ' Implements SonicDef
	Private
		' Constant variable(s):
		Const MAX_VELOCITY:= -720
		Const MOVE_POWER:= -360
		
		' Fields:
		Field drawer:AnimationDrawer
		
		Field x:Int, y:Int
		Field velX:Int
	Public
		' Constructor(s):
		Method New(animation:Animation, actionId:Int, x:Int, y:Int)
			Self.drawer = animation.getDrawer(actionId, False, 0)
			
			Self.x = x
			Self.y = y
		End
		
		' Methods:
		Method close:Void()
			Self.drawer = Null
		End
		
		Method draw:Bool(graphics:MFGraphics)
			Const DOUBLE_MOVE_POWER:= (MOVE_POWER*2)
			
			If (Not GameObject.IsGamePause) Then
				velX += MOVE_POWER
				
				If (velX < DOUBLE_MOVE_POWER*2) Then
					velX = DOUBLE_MOVE_POWER*2
				EndIf
				
				x += velX
			EndIf
			
			Local camera:= MapManager.getCamera()
			
			drawer.draw(graphics, (x Shr 6) - camera.x, (y Shr 6) - camera.y)
			
			Return drawer.checkEnd()
		End
End