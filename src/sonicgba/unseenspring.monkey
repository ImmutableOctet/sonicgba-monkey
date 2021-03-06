Strict

Public

' Friends:
Friend sonicgba.gimmickobject
Friend sonicgba.spring

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	Import lib.soundsystem
	
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
	Import sonicgba.spring
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class UnseenSpring Extends GimmickObject ' Spring
	Private
		' Constant variable(s):
		Const COLLISION_HEIGHT:Int = 1024
		Const COLLISION_WIDTH:Int = 64
		
		' Global variable(s):
		Global SPRING_POWER:Int = Spring.SPRING_POWER[0]
		
		' Fields:
		Field drawer:AnimationDrawer
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			If (Spring.springAnimation = Null) Then
				Spring.springAnimation = New Animation("/animation/se_bane_kiro")
			End
			
			Self.drawer = Spring.springAnimation.getDrawer(16, False, 0)
		End
	Public
		' Methods:
		Method draw:Void(graphics:MFGraphics)
			If (player.isInWater) Then
				SPRING_POWER = Spring.SPRING_INWATER_POWER[0]
			Else
				SPRING_POWER = Spring.SPRING_POWER[0]
			EndIf
			
			' Not sure what ID 17 is, but it's probably something like "activated spring":
			If (Self.drawer.getActionId() = 17) Then
				drawInMap(graphics, Self.drawer, Self.posX, Self.posY)
				
				If (Self.drawer.checkEnd()) Then
					Self.drawer.setActionId(16)
				EndIf
			EndIf
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If (player.collisionState = PlayerObject.COLLISION_STATE_WALK) Then
				player.beSpring(SPRING_POWER, DIRECTION_DOWN)
				
				' Magic number: 17
				Self.drawer.setActionId(17)
				
				soundInstance.playSe(SoundSystem.SE_148)
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH/2), y - (COLLISION_HEIGHT/2), COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method close:Void()
			Self.drawer = Null
		End
End