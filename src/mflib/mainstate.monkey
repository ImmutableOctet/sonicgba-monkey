Strict

Public

' Imports:
Private
	'Import gameengine.def
	'Import gameengine.key
	
	Import lib.soundsystem
	
	Import platformstandard.standard2
	
	Import state.state
	Import state.titlestate
	
	Import com.sega.mflib.main
	Import com.sega.mobile.framework.mfgamestate
	Import com.sega.mobile.framework.device.mfdevice
	Import com.sega.mobile.framework.device.mfgraphics
	
	Import sonicgba.playerobject
	Import sonicgba.stagemanager
	
	Import mojo.app
Public

' Classes:
Class MainState Implements MFGameState, Def
	Public
		' Constant variable(s):
		Const FRAME_SKIP:Int = 63
	Private
		' Constant variable(s):
		Const MF_VERSION:String = ""
		
		' Global variable(s):
		Global gameVersion:String
		
		' Fields:
		Field main:Main
		Field pauseFlag:Bool
	Public
		' Constructor(s):
		Method New(main:Main)
			Self.pauseFlag = False
			Self.main = main
		End
		
		' Methods:
		Method getFrameTime:Int()
			If (Main.BULLET_TIME) Then
				Return 1008
			EndIf
			
			Return FRAME_SKIP
		End
		
		Method onEnter:Void()
			State.stateInit()
			PlayerObject.setCharacter(0)
			StageManager.setStageID(0)
			State.setState(0)
			
			gameVersion = "ver: 1.0"
			
			MFDevice.setUseMultitouch(True)
			MFDevice.setAntiAlias(False)
			MFDevice.setFilterBitmap(False)
			MFDevice.setVibrationFlag(True)
			
			Self.main.isResumeFromOtherActivity = False
		End
		
		Method onExit:Void()
			' Empty implementation.
		End
		
		Method onPause:Void()
			State.pauseTrigger()
			
			Self.pauseFlag = True
		End
		
		Method onRender:Void(g:MFGraphics)
			State.stateDraw(g)
		End
	
		Method onTick:Void()
			pauseCheck()
			
			State.stateLogic()
			State.getMain(Self.main)
			Standard2.getMain(Self.main)
			
			pauseCheck()
		End
		
		Method onResume:Void()
			SoundSystem.getInstance().updateVolumeState()
		End
		
		Method onVolumeDown:Void()
			' Empty implementation.
		End
		
		Method onVolumeUp:Void()
			' Empty implementation.
		End
		
		Method onRender:Void(g:MFGraphics, layer:Int)
			TitleState.drawTitle(g, layer)
		End
	Private
		' Methods:
		Method pauseCheck:Void()
			If (Self.pauseFlag) Then
				'Key.clear()
				State.statePause()
				
				Self.pauseFlag = False
			EndIf
		End
End