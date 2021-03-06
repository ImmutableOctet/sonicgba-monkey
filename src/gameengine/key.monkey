Strict

Public

' Imports:
Private
	Import lib.myapi
	
	Import gameengine.def
	Import gameengine.touchdirectkey
	Import gameengine.touchkeyrange
	
	' This import may be removed at a later date.
	' Used for 'SpecialMap.MAP_HEIGHT'.
	Import special.specialmap
	
	Import com.sega.mobile.framework.device.mfdevice
	Import com.sega.mobile.framework.device.mfgamepad
	Import com.sega.mobile.framework.ui.mfslidesensor
	Import com.sega.mobile.framework.ui.mftouchkey
Public

' Classes:
Class Key
	Private
		' Global variable(s):
		Global keyFunction:Bool = True
		
		Global keyState:Int = 0
		
		Global KEY:Int = 0
		Global KEY_before:Int = 0
		Global KEY_get:Int = 0
		Global KEY_press:Int = 0
		
		Global pause_x:Int = (SCREEN_WIDTH - PAUSE_WIDTH)
		Global pause_y:Int = 0
		
		Global touchgamekey_5a:MFTouchKey
		Global touchgamekey_5b:MFTouchKey
		Global touchgamekey_do1:MFTouchKey
		Global touchgamekey_do2:MFTouchKey
		Global touchgamekey_ld:MFTouchKey
		Global touchgamekey_le:MFTouchKey
		Global touchgamekey_lu:MFTouchKey
		Global touchgamekey_rd:MFTouchKey
		Global touchgamekey_ri:MFTouchKey
		Global touchgamekey_ru:MFTouchKey
		Global touchgamekey_up1:MFTouchKey
		Global touchgamekey_up2:MFTouchKey
		Global touchkey_a:MFTouchKey
		Global touchkey_any:MFTouchKey
		Global touchkey_b:MFTouchKey
		Global touchkey_pound:MFTouchKey
		Global touchkey_s1:MFTouchKey
		Global touchkey_s2:MFTouchKey
		Global touchkey_star:MFTouchKey
	Public
		' Constant variable(s):
		Const B_S2:Int = 2
		Const B_BACK:Int = 524288
		Const B_SPIN2:Int = 2097152
		Const B_PAUSE:Int = 4194304
		Const B_NULL:Int = 8388608
		Const B_HIGH_JUMP:Int = 16777216
		Const B_LOOK:Int = 33554432
		
		Const PAUSE_WIDTH:Int = 60
		Const PAUSE_HEIGHT:Int = 30
		
		Const TOUCH_WIDTH:Int = 20
		Const TOUCH_HEIGHT:Int = 20
		
		Const TYPE_GAME_MODE:Int = 1
		Const TYPE_SP_MODE:Int = 0
		
		' Global variable(s):
		Global B_1:Int = 128 ' MFGamePad.KEY_NUM_1
		Global B_2:Int = 256 ' MFGamePad.KEY_NUM_2
		Global B_3:Int = 512 ' MFGamePad.KEY_NUM_3
		Global B_4:Int = 1024 ' MFGamePad.KEY_NUM_4
		Global B_5:Int = 2048 ' MFGamePad.KEY_NUM_5
		Global B_6:Int = 4096 ' MFGamePad.KEY_NUM_6
		Global B_7:Int = 8192 ' MFGamePad.KEY_NUM_7
		Global B_8:Int = 16384 ' MFGamePad.KEY_NUM_8
		Global B_9:Int = 32768 ' MFGamePad.KEY_NUM_9
		Global B_0:Int = 131072 ' MFGamePad.KEY_NUM_0
		
		Global B_UP:Int = 4 ' MFGamePad.KEY_PAD_UP
		Global B_DOWN:Int = 8 ' MFGamePad.KEY_PAD_DOWN
		Global B_LEFT:Int = 16 ' MFGamePad.KEY_PAD_LEFT
		Global B_RIGHT:Int = 32 ' MFGamePad.KEY_PAD_RIGHT
		Global B_SEL:Int = 64 ' MFGamePad.KEY_PAD_CONFIRM
		
		Global B_ST:Int = 65536 ' MFGamePad.KEY_NUM_STAR
		Global B_PO:Int = 262144 ' MFGamePad.KEY_NUM_POUND
		Global B_S1:Int = 1 ' MFGamePad.KEY_S1
		
		Global DIR_UP:Int = 1
		Global DIR_DOWN:Int = 2
		Global DIR_LEFT:Int = 4
		Global DIR_RIGHT:Int = 8
		
		Global gDown:Int
		Global gLeft:Int
		Global gRight:Int
		Global gSelect:Int
		Global gUp:Int
		
		Global slidesensorcharacterrecord:MFSlideSensor
		Global slidesensorcharsel:MFSlideSensor
		Global slidesensorhelp:MFSlideSensor
		Global slidesensormenuoption:MFSlideSensor
		Global slidesensorstagesel:MFSlideSensor
		
		Global touchgamepauseitem:TouchKeyRange[]
		Global touchmenuoptionitems:TouchKeyRange[]
		Global touchmenuoptionlanguageitems:TouchKeyRange[]
		Global touchstageselectitem:TouchKeyRange[]
		
		Global touchcharsel:TouchKeyRange
		Global touchcharselleftarrow:TouchKeyRange
		Global touchcharselreturn:TouchKeyRange
		Global touchcharselrightarrow:TouchKeyRange
		Global touchcharsElselect:TouchKeyRange
		Global touchConfirmNo:TouchKeyRange
		Global touchConfirmYes:TouchKeyRange
		Global touchdirectgamekey:TouchDirectKey
		Global touchgame:TouchKeyRange
		Global touchGameKeyA:TouchKeyRange
		Global touchgameover:TouchKeyRange
		Global touchgameoverno:TouchKeyRange
		Global touchgameoveryres:TouchKeyRange
		Global touchgamepause:TouchKeyRange
		Global touchgamepausereturn:TouchKeyRange
		Global touchhelpdown:TouchKeyRange
		Global touchhelpdownarrow:TouchKeyRange
		Global touchhelpleft:TouchKeyRange
		Global touchhelpleftarrow:TouchKeyRange
		Global touchhelpreturn:TouchKeyRange
		Global touchhelpright:TouchKeyRange
		Global touchhelprightarrow:TouchKeyRange
		Global touchhelpup:TouchKeyRange
		Global touchhelpuparrow:TouchKeyRange
		Global touchintergraderecord:TouchKeyRange
		Global touchintergraderecordleftarrow:TouchKeyRange
		Global touchintergraderecordreturn:TouchKeyRange
		Global touchintergraderecordrightarrow:TouchKeyRange
		Global touchintergraderecordupdate:TouchKeyRange
		Global touchinterruptreturn:TouchKeyRange
		Global touchitemsselect2:TouchKeyRange
		Global touchitemsselect2_1:TouchKeyRange
		Global touchitemsselect2_2:TouchKeyRange
		Global touchitemsselect2_return:TouchKeyRange
		Global touchitemsselect3:TouchKeyRange
		Global touchitemsselect3_1:TouchKeyRange
		Global touchitemsselect3_2:TouchKeyRange
		Global touchitemsselect3_3:TouchKeyRange
		Global touchitemsselect3_return:TouchKeyRange
		Global touchkey_pause:TouchKeyRange
		Global touchmainmenu:TouchKeyRange
		Global touchMainmenuDown:TouchKeyRange
		Global touchmainmenudown:TouchKeyRange
		Global touchmainmenuend:TouchKeyRange
		Global touchmainmenuitem:TouchKeyRange
		Global touchmainmenuoption:TouchKeyRange
		Global touchmainmenurace:TouchKeyRange
		Global touchmainmenureturn:TouchKeyRange
		Global touchMainmenuSel:TouchKeyRange
		Global touchmainmenustart:TouchKeyRange
		Global touchMainmenuUp:TouchKeyRange
		Global touchmainmenuup:TouchKeyRange
		Global touchmenucon:TouchKeyRange
		Global touchmenunew:TouchKeyRange
		Global touchmenuoption:TouchKeyRange
		Global touchmenuoptiondownarrow:TouchKeyRange
		Global touchmenuoptionlanguage:TouchKeyRange
		Global touchmenuoptionlanguagereturn:TouchKeyRange
		Global touchmenuoptionreturn:TouchKeyRange
		Global touchmenuoptionuparrow:TouchKeyRange
		Global touchopening:TouchKeyRange
		Global touchopeningskip:TouchKeyRange
		Global touchoptiondif:TouchKeyRange
		Global touchoptionrein:TouchKeyRange
		Global touchoptionreout:TouchKeyRange
		Global touchoptionsein:TouchKeyRange
		Global touchoptionseout:TouchKeyRange
		Global touchoptionso:TouchKeyRange
		Global touchoptiontimein:TouchKeyRange
		Global touchoptiontimeout:TouchKeyRange
		Global touchoptionvolcut:TouchKeyRange
		Global touchoptionvolplus:TouchKeyRange
		Global touchpage:TouchKeyRange
		Global touchpause1:TouchKeyRange
		Global touchpause2:TouchKeyRange
		Global touchpause3:TouchKeyRange
		Global touchpause4:TouchKeyRange
		Global touchpausearrowdown:TouchKeyRange
		Global touchpausearrowdownsingle:TouchKeyRange
		Global touchpausearrowup:TouchKeyRange
		Global touchpausearrowupsingle:TouchKeyRange
		Global touchpauseopsein:TouchKeyRange
		Global touchpauseopseout:TouchKeyRange
		Global touchpauseopsound:TouchKeyRange
		Global touchpauseoption:TouchKeyRange
		Global touchpauseoptionhelp:TouchKeyRange
		Global touchpauseoptionkeyset:TouchKeyRange
		Global touchpauseoptionreturn:TouchKeyRange
		Global touchpauseoptionsound:TouchKeyRange
		Global touchpauseoptionspset:TouchKeyRange
		Global touchpauseoptionvib:TouchKeyRange
		Global touchpauseopvolcut:TouchKeyRange
		Global touchpauseopvolplus:TouchKeyRange
		Global touchproracemode:TouchKeyRange
		Global touchproracemoderecord:TouchKeyRange
		Global touchproracemodereturn:TouchKeyRange
		Global touchproracemodestart:TouchKeyRange
		Global touchscoreupdate:TouchKeyRange
		Global touchscoreupdateno:TouchKeyRange
		Global touchscoreupdatereturn:TouchKeyRange
		Global touchscoreupdateyes:TouchKeyRange
		Global touchsecondensure:TouchKeyRange
		Global touchsecondensureno:TouchKeyRange
		Global touchsecondensurereturn:TouchKeyRange
		Global touchsecondensureyes:TouchKeyRange
		Global touchsel1:TouchKeyRange
		Global touchsel2:TouchKeyRange
		Global touchsel3:TouchKeyRange
		Global touchsel4:TouchKeyRange
		Global touchsel5:TouchKeyRange
		Global touchsel6:TouchKeyRange
		Global touchselarrowdown:TouchKeyRange
		Global touchselarrowup:TouchKeyRange
		Global touchspstage:TouchKeyRange
		Global touchspstagepause:TouchKeyRange
		Global touchstageselect:TouchKeyRange
		Global touchstageselectdownarrow:TouchKeyRange
		Global touchstageselectreturn:TouchKeyRange
		Global touchstageselectuparrow:TouchKeyRange
		Global touchstartgame:TouchKeyRange
		Global touchstartgamecontinue:TouchKeyRange
		Global touchstartgamenew:TouchKeyRange
		Global touchstartgamereturn:TouchKeyRange
		
		' Functions:
		Function touchsoftkeyInit:Void()
			If (touchkey_s1 = Null Or touchkey_s2 = Null) Then
				touchkey_s1 = New MFTouchKey(0, MyAPI.zoomOut(SCREEN_HEIGHT - TOUCH_WIDTH), MyAPI.zoomOut(TOUCH_WIDTH), MyAPI.zoomOut(TOUCH_WIDTH), B_S1) ' 1
				touchkey_s2 = New MFTouchKey(MyAPI.zoomOut(SCREEN_WIDTH - TOUCH_WIDTH), MyAPI.zoomOut(SCREEN_HEIGHT - TOUCH_WIDTH), MyAPI.zoomOut(TOUCH_WIDTH), MyAPI.zoomOut(TOUCH_WIDTH), B_S2)
				
				MFDevice.addComponent(touchkey_s1)
				MFDevice.addComponent(touchkey_s2)
			EndIf
		End
		
		Function touchsoftkeyClose:Void()
			MFDevice.removeComponent(touchkey_s1)
			MFDevice.removeComponent(touchkey_s2)
			
			touchkey_s1 = Null
			touchkey_s2 = Null
		End
		
		Function touchanykeyInit:Void()
			If (touchkey_any = Null) Then
				touchkey_any = New MFTouchKey(0, 0, MyAPI.zoomOut(SCREEN_WIDTH), MyAPI.zoomOut(SCREEN_HEIGHT), B_SEL)
				
				MFDevice.addComponent(touchkey_any)
			EndIf
		End
		
		Function touchanykeyClose:Void()
			If (touchkey_any <> Null) Then
				MFDevice.removeComponent(touchkey_any)
				
				touchkey_any = Null
			EndIf
		End
		
		Function touchactiongamekeyInit:Void()
			If (touchkey_a = Null Or touchkey_b = Null) Then
				touchkey_a = New MFTouchKey(MyAPI.zoomOut(SCREEN_WIDTH - 42), MyAPI.zoomOut(103), MyAPI.zoomOut(40), MyAPI.zoomOut(40), B_HIGH_JUMP)
				touchkey_b = New MFTouchKey(MyAPI.zoomOut(SCREEN_WIDTH - 87), MyAPI.zoomOut(118), MyAPI.zoomOut(40), MyAPI.zoomOut(40), B_SEL)
				
				MFDevice.addComponent(touchkey_a)
				MFDevice.addComponent(touchkey_b)
			EndIf
			
			If (touchGameKeyA = Null) Then
				touchGameKeyA = New TouchKeyRange(SCREEN_WIDTH - 42, 103, 40, 40)
				
				MFDevice.addComponent(touchGameKeyA)
			EndIf
			
			touchstarpoundkeyInit()
		End
		
		Function touchstarpoundkeyInit:Void()
			' Empty implementation.
		End
		
		Function touchstarpoundkeyClose:Void()
			' Empty implementation.
		End
		
		Function touchactionmenukeyInit:Void()
			If (touchkey_a = Null Or touchkey_b = Null) Then
				touchkey_a = New MFTouchKey(MyAPI.zoomOut(SCREEN_WIDTH - 42), MyAPI.zoomOut(103), MyAPI.zoomOut(40), MyAPI.zoomOut(40), B_SEL)
				touchkey_b = New MFTouchKey(MyAPI.zoomOut(SCREEN_WIDTH - 87), MyAPI.zoomOut(118), MyAPI.zoomOut(40), MyAPI.zoomOut(40), B_SPIN2)
				
				MFDevice.addComponent(touchkey_a)
				MFDevice.addComponent(touchkey_b)
			EndIf
		End
		
		Function touchkeyboardInit:Void()
			If (touchdirectgamekey = Null) Then
				touchdirectgamekey = New TouchDirectKey(MyAPI.zoomOut(32), MyAPI.zoomOut(128), MyAPI.zoomOut(80), MyAPI.zoomOut(4), B_SEL)
				
				MFDevice.addComponent(touchdirectgamekey)
			EndIf
			
			touchactionmenukeyInit()
			touchstarpoundkeyInit()
		End
		
		Function touchkeyboardReset:Void()
			touchdirectgamekey.reset()
			
			touchkey_a.reset()
			touchkey_b.reset()
			
			MFGamePad.resetKeys()
		End
		
		Function touchkeyboardClose:Void()
			If (touchdirectgamekey <> Null) Then
				MFDevice.removeComponent(touchdirectgamekey)
				
				touchdirectgamekey = Null
			EndIf
			
			If (touchdirectgamekey <> Null) Then
				MFDevice.removeComponent(touchdirectgamekey)
				
				touchdirectgamekey = Null
			EndIf
			
			MFDevice.removeComponent(touchkey_a)
			MFDevice.removeComponent(touchkey_b)
			
			touchkey_a = Null
			touchkey_b = Null
		End
		
		Function touchSpKeyboardInit:Void()
			If (touchdirectgamekey = Null) Then
				touchdirectgamekey = New TouchDirectKey(MyAPI.zoomOut(32), MyAPI.zoomOut(128), MyAPI.zoomOut(80), MyAPI.zoomOut(4), 0)
				
				MFDevice.addComponent(touchdirectgamekey)
			EndIf
			
			If (touchkey_a = Null Or touchkey_b = Null) Then
				touchkey_a = New MFTouchKey(MyAPI.zoomOut(SCREEN_WIDTH - 42), MyAPI.zoomOut(103), MyAPI.zoomOut(40), MyAPI.zoomOut(40), B_HIGH_JUMP)
				touchkey_b = New MFTouchKey(MyAPI.zoomOut(SCREEN_WIDTH - 87), MyAPI.zoomOut(118), MyAPI.zoomOut(40), MyAPI.zoomOut(40), B_SEL)
				
				MFDevice.addComponent(touchkey_a)
				MFDevice.addComponent(touchkey_b)
			EndIf
		End
		
		Function touchkeygameboardInit:Void()
			If (touchdirectgamekey = Null) Then
				touchdirectgamekey = New TouchDirectKey(MyAPI.zoomOut(32), MyAPI.zoomOut(128), MyAPI.zoomOut(80), MyAPI.zoomOut(4), B_SEL)
				
				MFDevice.addComponent(touchdirectgamekey)
			EndIf
			
			touchactiongamekeyInit()
		End
		
		Function touchkeygameboardClose:Void()
			If (touchdirectgamekey <> Null) Then
				MFDevice.removeComponent(touchdirectgamekey)
				
				touchdirectgamekey = Null
			EndIf
			
			If (touchdirectgamekey <> Null) Then
				MFDevice.removeComponent(touchdirectgamekey)
				
				touchdirectgamekey = Null
			EndIf
			
			MFDevice.removeComponent(touchkey_a)
			MFDevice.removeComponent(touchGameKeyA)
			MFDevice.removeComponent(touchkey_b)
			
			touchkey_a = Null
			touchGameKeyA = Null
			touchkey_b = Null
		End
		
		Function touchMainMenuInit:Void()
			If (touchMainmenuUp = Null Or touchMainmenuDown = Null Or touchMainmenuSel = Null) Then
				touchMainmenuUp = New TouchKeyRange((SCREEN_WIDTH / 2) - 32, (SCREEN_HEIGHT / 2) - 2, 96, 34) ' Shr 1
				touchMainmenuDown = New TouchKeyRange((SCREEN_WIDTH / 2) - 32, (SCREEN_HEIGHT / 2) + 56, 96, 34) ' Shr 1
				touchMainmenuSel = New TouchKeyRange((SCREEN_WIDTH / 2) - 32, (SCREEN_HEIGHT / 2) + 32, 96, 24) ' Shr 1
				
				MFDevice.addComponent(touchMainmenuUp)
				MFDevice.addComponent(touchMainmenuDown)
				MFDevice.addComponent(touchMainmenuSel)
			EndIf
		End
		
		Function touchMainMenuClose:Void()
			MFDevice.removeComponent(touchMainmenuUp)
			MFDevice.removeComponent(touchMainmenuDown)
			MFDevice.removeComponent(touchMainmenuSel)
			
			touchMainmenuUp = Null
			touchMainmenuDown = Null
			touchMainmenuSel = Null
		End
		
		Function touchConfirmInit:Void()
			If (touchConfirmYes = Null Or touchConfirmNo = Null) Then
				touchConfirmYes = New TouchKeyRange((SCREEN_WIDTH / 2) - 40, (SCREEN_HEIGHT / 2), 40, 28) ' Shr 1
				touchConfirmNo = New TouchKeyRange((SCREEN_WIDTH / 2), (SCREEN_HEIGHT / 2), 40, 28) ' Shr 1
				
				MFDevice.addComponent(touchConfirmYes)
				MFDevice.addComponent(touchConfirmNo)
			EndIf
		End
		
		Function touchConfirmClose:Void()
			MFDevice.removeComponent(touchConfirmYes)
			MFDevice.removeComponent(touchConfirmNo)
			
			touchConfirmYes = Null
			touchConfirmNo = Null
		End
		
		Function touchMenuInit:Void()
			If (touchmenunew = Null Or touchmenucon = Null) Then
				touchmenunew = New TouchKeyRange((SCREEN_WIDTH / 2) - 64, (SCREEN_HEIGHT / 2) - 44, 128, 44) ' Shr 1
				touchmenucon = New TouchKeyRange((SCREEN_WIDTH / 2) - 64, (SCREEN_HEIGHT / 2), 128, 44) ' Shr 1
				
				MFDevice.addComponent(touchmenunew)
				MFDevice.addComponent(touchmenucon)
			EndIf
		End
		
		Function touchMenuClose:Void()
			MFDevice.removeComponent(touchmenunew)
			MFDevice.removeComponent(touchmenucon)
			
			touchmenunew = Null
			touchmenucon = Null
		End
		
		Function System:Void()
			' Empty implementation.
		End
		
		Function touchHelpInit:Void()
			If (touchhelpleft = Null Or touchhelpright = Null Or touchhelpup = Null Or touchhelpdown = Null) Then
				touchhelpleft = New TouchKeyRange((SCREEN_WIDTH / 2) + def.TOUCH_HELP_LEFT_X, (SCREEN_HEIGHT / 2) - 70, 48, 48) ' Shr 1
				touchhelpright = New TouchKeyRange((SCREEN_WIDTH / 2) + 80, (SCREEN_HEIGHT / 2) - 70, 48, 48) ' Shr 1
				touchhelpup = New TouchKeyRange((SCREEN_WIDTH / 2) - 48, (SCREEN_HEIGHT / 2) + 42, 48, 48) ' Shr 1
				touchhelpdown = New TouchKeyRange((SCREEN_WIDTH / 2), (SCREEN_HEIGHT / 2) + 42, 48, 48) ' Shr 1
				
				MFDevice.addComponent(touchhelpleft)
				MFDevice.addComponent(touchhelpright)
				MFDevice.addComponent(touchhelpup)
				MFDevice.addComponent(touchhelpdown)
			EndIf
		End
		
		Function touchHelpClose:Void()
			MFDevice.removeComponent(touchhelpleft)
			MFDevice.removeComponent(touchhelpright)
			MFDevice.removeComponent(touchhelpup)
			MFDevice.removeComponent(touchhelpdown)
			
			touchhelpleft = Null
			touchhelpright = Null
			touchhelpup = Null
			touchhelpdown = Null
		End
		
		Function touchAboutInit:Void()
			If (touchhelpup = Null Or touchhelpdown = Null) Then
				touchhelpup = New TouchKeyRange((SCREEN_WIDTH / 2) - 48, (SCREEN_HEIGHT / 2) + 42, 48, 48) ' Shr 1
				touchhelpdown = New TouchKeyRange((SCREEN_WIDTH / 2), (SCREEN_HEIGHT / 2) + 42, 48, 48) ' Shr 1
				
				MFDevice.addComponent(touchhelpup)
				MFDevice.addComponent(touchhelpdown)
			EndIf
		End
		
		Function touchAboutClose:Void()
			MFDevice.removeComponent(touchhelpup)
			MFDevice.removeComponent(touchhelpdown)
			
			touchhelpup = Null
			touchhelpdown = Null
		End
		
		Function touchPauseInit:Void(IsRaceMode:Bool)
			If (IsRaceMode And (touchpausearrowup = Null Or touchpausearrowdown = Null Or touchpausearrowupsingle = Null Or touchpausearrowdownsingle = Null)) Then
				touchpausearrowup = New TouchKeyRange((SCREEN_WIDTH / 2) - 44, (SCREEN_HEIGHT / 2) + 50, 44, 24) ' Shr 1
				touchpausearrowdown = New TouchKeyRange((SCREEN_WIDTH / 2), (SCREEN_HEIGHT / 2) + 50, 44, 24) ' Shr 1
				touchpausearrowupsingle = New TouchKeyRange((SCREEN_WIDTH / 2) - 44, (SCREEN_HEIGHT / 2) + 50, 88, 24) ' Shr 1
				touchpausearrowdownsingle = New TouchKeyRange((SCREEN_WIDTH / 2) - 44, (SCREEN_HEIGHT / 2) + 50, 88, 24) ' Shr 1
				
				MFDevice.addComponent(touchpausearrowup)
				MFDevice.addComponent(touchpausearrowdown)
				MFDevice.addComponent(touchpausearrowupsingle)
				MFDevice.addComponent(touchpausearrowdownsingle)
			EndIf
			
			If (touchpause1 = Null Or touchpause2 = Null Or touchpause3 = Null Or touchpause4 = Null) Then
				touchpause1 = New TouchKeyRange((SCREEN_WIDTH / 2) - 72, (SCREEN_HEIGHT / 2) - 30, 144, TOUCH_WIDTH) ' Shr 1
				touchpause2 = New TouchKeyRange((SCREEN_WIDTH / 2) - 72, ((SCREEN_HEIGHT / 2) - 30) + TOUCH_WIDTH, 144, TOUCH_WIDTH) ' Shr 1
				touchpause3 = New TouchKeyRange((SCREEN_WIDTH / 2) - 72, ((SCREEN_HEIGHT / 2) - 30) + 40, 144, TOUCH_WIDTH) ' Shr 1
				touchpause4 = New TouchKeyRange((SCREEN_WIDTH / 2) - 72, ((SCREEN_HEIGHT / 2) - 30) + PAUSE_WIDTH, 144, TOUCH_WIDTH) ' Shr 1
				
				MFDevice.addComponent(touchpause1)
				MFDevice.addComponent(touchpause2)
				MFDevice.addComponent(touchpause3)
				MFDevice.addComponent(touchpause4)
			EndIf
		End
		
		Function touchPauseClose:Void(IsRaceMode:Bool)
			If (IsRaceMode) Then
				MFDevice.removeComponent(touchpausearrowup)
				MFDevice.removeComponent(touchpausearrowdown)
				MFDevice.removeComponent(touchpausearrowupsingle)
				MFDevice.removeComponent(touchpausearrowdownsingle)
			EndIf
			
			MFDevice.removeComponent(touchpause1)
			MFDevice.removeComponent(touchpause2)
			MFDevice.removeComponent(touchpause3)
			MFDevice.removeComponent(touchpause4)
			
			If (IsRaceMode) Then
				touchpausearrowup = Null
				touchpausearrowdown = Null
				touchpausearrowupsingle = Null
				touchpausearrowdownsingle = Null
			EndIf
			
			touchpause1 = Null
			touchpause2 = Null
			touchpause3 = Null
			touchpause4 = Null
		End
		
		Function touchSelectStageInit:Void()
			If (touchselarrowup = Null Or touchselarrowdown = Null Or touchsel1 = Null Or touchsel2 = Null Or touchsel3 = Null Or touchsel4 = Null Or touchsel5 = Null Or touchsel6 = Null) Then
				touchselarrowup = New TouchKeyRange((SCREEN_WIDTH / 2) - 72, (SCREEN_HEIGHT / 2) - 64, 24, 32) ' Shr 1
				touchselarrowdown = New TouchKeyRange((SCREEN_WIDTH / 2) - 72, (SCREEN_HEIGHT / 2) + 32, 24, 32) ' Shr 1
				
				touchsel1 = New TouchKeyRange((SCREEN_WIDTH / 2) - 48, (SCREEN_HEIGHT / 2) - 72, def.TOUCH_SEL_1_W, 24) ' Shr 1
				touchsel2 = New TouchKeyRange((SCREEN_WIDTH / 2) - 48, ((SCREEN_HEIGHT / 2) - 72) + 24, def.TOUCH_SEL_1_W, 24) ' Shr 1
				touchsel3 = New TouchKeyRange((SCREEN_WIDTH / 2) - 48, ((SCREEN_HEIGHT / 2) - 72) + 48, def.TOUCH_SEL_1_W, 24) ' Shr 1
				touchsel4 = New TouchKeyRange((SCREEN_WIDTH / 2) - 48, ((SCREEN_HEIGHT / 2) - 72) + 72, def.TOUCH_SEL_1_W, 24) ' Shr 1
				touchsel5 = New TouchKeyRange((SCREEN_WIDTH / 2) - 48, ((SCREEN_HEIGHT / 2) - 72) + 96, def.TOUCH_SEL_1_W, 24) ' Shr 1
				touchsel6 = New TouchKeyRange((SCREEN_WIDTH / 2) - 48, ((SCREEN_HEIGHT / 2) - 72) + 120, def.TOUCH_SEL_1_W, 24) ' Shr 1
				
				MFDevice.addComponent(touchselarrowup)
				MFDevice.addComponent(touchselarrowdown)
				MFDevice.addComponent(touchsel1)
				MFDevice.addComponent(touchsel2)
				MFDevice.addComponent(touchsel3)
				MFDevice.addComponent(touchsel4)
				MFDevice.addComponent(touchsel5)
				MFDevice.addComponent(touchsel6)
			EndIf
		End
		
		Function touchSelectStageClose:Void()
			MFDevice.removeComponent(touchselarrowup)
			MFDevice.removeComponent(touchselarrowdown)
			MFDevice.removeComponent(touchsel1)
			MFDevice.removeComponent(touchsel2)
			MFDevice.removeComponent(touchsel3)
			MFDevice.removeComponent(touchsel4)
			MFDevice.removeComponent(touchsel5)
			MFDevice.removeComponent(touchsel6)
			
			touchselarrowup = Null
			touchselarrowdown = Null
			touchsel1 = Null
			touchsel2 = Null
			touchsel3 = Null
			touchsel4 = Null
			touchsel5 = Null
			touchsel6 = Null
		End
		
		Function touchPauseOptionInit:Void()
			If (touchpauseopsound = Null Or touchpauseopvolplus = Null Or touchpauseopvolcut = Null Or touchpauseopsein = Null Or touchpauseopseout = Null) Then
				touchpauseopsound = New TouchKeyRange((SCREEN_WIDTH / 2) - 64, (SCREEN_HEIGHT / 2) - 20, 128, TOUCH_WIDTH) ' Shr 1
				touchpauseopvolcut = New TouchKeyRange((SCREEN_WIDTH / 2) - 64, ((SCREEN_HEIGHT / 2) - 20) + TOUCH_WIDTH, 48, TOUCH_WIDTH) ' Shr 1
				touchpauseopvolplus = New TouchKeyRange((SCREEN_WIDTH / 2) + 16, ((SCREEN_HEIGHT / 2) - 20) + TOUCH_WIDTH, 48, TOUCH_WIDTH) ' Shr 1
				touchpauseopsein = New TouchKeyRange((SCREEN_WIDTH / 2) - 64, ((SCREEN_HEIGHT / 2) - 20) + TOUCH_WIDTH, 128, TOUCH_WIDTH) ' Shr 1
				touchpauseopseout = New TouchKeyRange((SCREEN_WIDTH / 2) - 64, ((SCREEN_HEIGHT / 2) - 20) + 40, 128, TOUCH_WIDTH) ' Shr 1
				
				MFDevice.addComponent(touchpauseopsound)
				MFDevice.addComponent(touchpauseopvolcut)
				MFDevice.addComponent(touchpauseopvolplus)
				MFDevice.addComponent(touchpauseopsein)
				MFDevice.addComponent(touchpauseopseout)
			EndIf
		End
		
		Function touchPauseOptionClose:Void()
			MFDevice.removeComponent(touchpauseopsound)
			MFDevice.removeComponent(touchpauseopvolcut)
			MFDevice.removeComponent(touchpauseopvolplus)
			MFDevice.removeComponent(touchpauseopsein)
			MFDevice.removeComponent(touchpauseopseout)
			
			touchpauseopsound = Null
			touchpauseopvolcut = Null
			touchpauseopvolplus = Null
			touchpauseopsein = Null
			touchpauseopseout = Null
		End
		
		Function touchOptionInit:Void()
			If (touchoptiondif = Null Or touchoptionso = Null Or touchoptionvolcut = Null Or touchoptionvolplus = Null Or touchoptionsein = Null Or touchoptionseout = Null Or touchoptiontimein = Null Or touchoptiontimeout = Null Or touchoptionrein = Null Or touchoptionreout = Null) Then
				touchoptiondif = New TouchKeyRange((SCREEN_WIDTH / 2) - 64, (SCREEN_HEIGHT / 2) - 50, 128, TOUCH_WIDTH) ' Shr 1
				touchoptionso = New TouchKeyRange((SCREEN_WIDTH / 2) - 64, ((SCREEN_HEIGHT / 2) - 50) + TOUCH_WIDTH, 128, TOUCH_WIDTH) ' Shr 1
				touchoptionvolcut = New TouchKeyRange((SCREEN_WIDTH / 2) - 64, ((SCREEN_HEIGHT / 2) - 50) + 40, 48, TOUCH_WIDTH) ' Shr 1
				touchoptionvolplus = New TouchKeyRange((SCREEN_WIDTH / 2) + 16, ((SCREEN_HEIGHT / 2) - 50) + 40, 48, TOUCH_WIDTH) ' Shr 1
				touchoptionsein = New TouchKeyRange((SCREEN_WIDTH / 2) - 64, ((SCREEN_HEIGHT / 2) - 50) + 40, 128, TOUCH_WIDTH) ' Shr 1
				touchoptionseout = New TouchKeyRange((SCREEN_WIDTH / 2) - 64, ((SCREEN_HEIGHT / 2) - 50) + PAUSE_WIDTH, 128, TOUCH_WIDTH) ' Shr 1
				touchoptiontimein = New TouchKeyRange((SCREEN_WIDTH / 2) - 64, ((SCREEN_HEIGHT / 2) - 50) + PAUSE_WIDTH, 128, TOUCH_WIDTH) ' Shr 1
				touchoptiontimeout = New TouchKeyRange((SCREEN_WIDTH / 2) - 64, ((SCREEN_HEIGHT / 2) - 50) + 80, 128, TOUCH_WIDTH) ' Shr 1
				touchoptionrein = New TouchKeyRange((SCREEN_WIDTH / 2) - 64, ((SCREEN_HEIGHT / 2) - 50) + 80, 128, TOUCH_WIDTH) ' Shr 1
				touchoptionreout = New TouchKeyRange((SCREEN_WIDTH / 2) - 64, ((SCREEN_HEIGHT / 2) - 50) + 100, 128, TOUCH_WIDTH) ' Shr 1
				
				MFDevice.addComponent(touchoptiondif)
				MFDevice.addComponent(touchoptionso)
				MFDevice.addComponent(touchoptionvolcut)
				MFDevice.addComponent(touchoptionvolplus)
				MFDevice.addComponent(touchoptionsein)
				MFDevice.addComponent(touchoptionseout)
				MFDevice.addComponent(touchoptiontimein)
				MFDevice.addComponent(touchoptiontimeout)
				MFDevice.addComponent(touchoptionrein)
				MFDevice.addComponent(touchoptionreout)
			EndIf
		End
		
		Function touchOptionClose:Void()
			MFDevice.removeComponent(touchoptiondif)
			MFDevice.removeComponent(touchoptionso)
			MFDevice.removeComponent(touchoptionvolcut)
			MFDevice.removeComponent(touchoptionvolplus)
			MFDevice.removeComponent(touchoptionsein)
			MFDevice.removeComponent(touchoptionseout)
			MFDevice.removeComponent(touchoptiontimein)
			MFDevice.removeComponent(touchoptiontimeout)
			MFDevice.removeComponent(touchoptionrein)
			MFDevice.removeComponent(touchoptionreout)
			
			touchoptiondif = Null
			touchoptionso = Null
			touchoptionvolcut = Null
			touchoptionvolplus = Null
			touchoptionsein = Null
			touchoptionseout = Null
			touchoptiontimein = Null
			touchoptiontimeout = Null
			touchoptionrein = Null
			touchoptionreout = Null
		End
		
		Function touchMainMenuInit2:Void()
			If (touchmainmenu = Null Or touchmainmenustart = Null Or touchmainmenurace = Null Or touchmainmenuoption = Null Or touchmainmenuend = Null Or touchmainmenureturn = Null Or touchmainmenuup = Null Or touchmainmenudown = Null Or touchmainmenuitem = Null) Then
				touchmainmenu = New TouchKeyRange(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
				touchmainmenustart = New TouchKeyRange((SCREEN_WIDTH / 2) - 64, (SCREEN_HEIGHT / 2) + B_S2, 128, TOUCH_WIDTH) ' Shr 1
				touchmainmenurace = New TouchKeyRange((SCREEN_WIDTH / 2) - 64, ((SCREEN_HEIGHT / 2) + B_S2) + TOUCH_WIDTH, 128, TOUCH_WIDTH) ' Shr 1
				touchmainmenuoption = New TouchKeyRange((SCREEN_WIDTH / 2) - 64, ((SCREEN_HEIGHT / 2) + B_S2) + 40, 128, TOUCH_WIDTH) ' Shr 1
				touchmainmenuend = New TouchKeyRange((SCREEN_WIDTH / 2) - 64, ((SCREEN_HEIGHT / 2) + B_S2) + PAUSE_WIDTH, 128, TOUCH_WIDTH) ' Shr 1
				touchmainmenureturn = New TouchKeyRange(0, SCREEN_HEIGHT - 24, 24, 24)
				touchmainmenuup = New TouchKeyRange((SCREEN_WIDTH / 2) - 52, (SCREEN_HEIGHT / 2), 104, 28) ' Shr 1
				touchmainmenudown = New TouchKeyRange((SCREEN_WIDTH / 2) - 52, (SCREEN_HEIGHT / 2) + 52, 104, 28) ' Shr 1
				touchmainmenuitem = New TouchKeyRange((SCREEN_WIDTH / 2) - 52, (SCREEN_HEIGHT / 2) + 28, 104, 24) ' Shr 1
				
				MFDevice.addComponent(touchmainmenu)
				MFDevice.addComponent(touchmainmenustart)
				MFDevice.addComponent(touchmainmenurace)
				MFDevice.addComponent(touchmainmenuoption)
				MFDevice.addComponent(touchmainmenuend)
				MFDevice.addComponent(touchmainmenureturn)
				MFDevice.addComponent(touchmainmenuup)
				MFDevice.addComponent(touchmainmenudown)
				MFDevice.addComponent(touchmainmenuitem)
			EndIf
			
			touchmainmenu.resetKeyState()
			touchmainmenustart.resetKeyState()
			touchmainmenurace.resetKeyState()
			touchmainmenuoption.resetKeyState()
			touchmainmenuend.resetKeyState()
			touchmainmenureturn.resetKeyState()
			touchmainmenuup.resetKeyState()
			touchmainmenudown.resetKeyState()
			touchmainmenuitem.resetKeyState()
		End
		
		Function touchMainMenuReset2:Void()
			If (touchmainmenu <> Null) Then
				touchmainmenu.resetKeyState()
				touchmainmenustart.resetKeyState()
				touchmainmenurace.resetKeyState()
				touchmainmenuoption.resetKeyState()
				touchmainmenuend.resetKeyState()
				touchmainmenureturn.resetKeyState()
				touchmainmenuup.resetKeyState()
				touchmainmenudown.resetKeyState()
				touchmainmenuitem.resetKeyState()
			EndIf
		End
		
		Function touchMainMenuClose2:Void()
			MFDevice.removeComponent(touchmainmenu)
			MFDevice.removeComponent(touchmainmenustart)
			MFDevice.removeComponent(touchmainmenurace)
			MFDevice.removeComponent(touchmainmenuoption)
			MFDevice.removeComponent(touchmainmenuend)
			MFDevice.removeComponent(touchmainmenureturn)
			MFDevice.removeComponent(touchmainmenuup)
			MFDevice.removeComponent(touchmainmenudown)
			MFDevice.removeComponent(touchmainmenuitem)
			
			touchmainmenu = Null
			touchmainmenustart = Null
			touchmainmenurace = Null
			touchmainmenuoption = Null
			touchmainmenuend = Null
			touchmainmenureturn = Null
			touchmainmenuup = Null
			touchmainmenudown = Null
			touchmainmenuitem = Null
		End
		
		Function touchProRaceModeInit:Void()
			If (touchproracemode = Null Or touchproracemodereturn = Null Or touchproracemodestart = Null Or touchproracemoderecord = Null) Then
				touchproracemode = New TouchKeyRange(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
				touchproracemodestart = New TouchKeyRange(0, (SCREEN_HEIGHT / 2) - 28, SCREEN_WIDTH, 24) ' Shr 1
				touchproracemoderecord = New TouchKeyRange(0, (SCREEN_HEIGHT / 2) - 4, SCREEN_WIDTH, 24) ' Shr 1
				touchproracemodereturn = New TouchKeyRange(0, SCREEN_HEIGHT - 24, 24, 24)
				
				MFDevice.addComponent(touchproracemode)
				MFDevice.addComponent(touchproracemodestart)
				MFDevice.addComponent(touchproracemoderecord)
				MFDevice.addComponent(touchproracemodereturn)
			EndIf
			
			touchproracemode.resetKeyState()
			touchproracemodestart.resetKeyState()
			touchproracemoderecord.resetKeyState()
			touchproracemodereturn.resetKeyState()
		End
		
		Function touchProRaceModeClose:Void()
			MFDevice.removeComponent(touchproracemode)
			MFDevice.removeComponent(touchproracemodestart)
			MFDevice.removeComponent(touchproracemoderecord)
			MFDevice.removeComponent(touchproracemodereturn)
			
			touchproracemodereturn = Null
			touchproracemode = Null
			touchproracemodestart = Null
			touchproracemoderecord = Null
		End
		
		Function touchCharacterSelectModeInit:Void()
			If (touchcharsel = Null Or touchcharselreturn = Null Or touchcharsElselect = Null Or slidesensorcharsel = Null Or touchcharselleftarrow = Null Or touchcharselrightarrow = Null) Then
				touchcharsel = New TouchKeyRange(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
				touchcharsElselect = New TouchKeyRange(80, (SCREEN_HEIGHT / 2) - 56, 80, 96) ' Shr 1
				slidesensorcharsel = New MFSlideSensor(0, (SCREEN_HEIGHT / 2) - 56, SCREEN_WIDTH, 96, 64) ' Shr 1
				touchcharselreturn = New TouchKeyRange(0, SCREEN_HEIGHT - 24, 24, 24)
				touchcharselleftarrow = New TouchKeyRange((SCREEN_WIDTH / 2) + def.TOUCH_CHARACTER_SELECT_LEFT_ARROW_OFFSET_X, (SCREEN_HEIGHT / 2) - 44, 48, 44) ' Shr 1
				touchcharselrightarrow = New TouchKeyRange((SCREEN_WIDTH / 2) + 72, (SCREEN_HEIGHT / 2) - 44, 48, 44) ' Shr 1
				
				MFDevice.addComponent(touchcharsel)
				MFDevice.addComponent(touchcharsElselect)
				MFDevice.addComponent(slidesensorcharsel)
				MFDevice.addComponent(touchcharselreturn)
				MFDevice.addComponent(touchcharselleftarrow)
				MFDevice.addComponent(touchcharselrightarrow)
			EndIf
			
			touchcharsel.resetKeyState()
			touchcharsElselect.resetKeyState()
			touchcharselreturn.resetKeyState()
			touchcharselleftarrow.resetKeyState()
			touchcharselrightarrow.resetKeyState()
		End
		
		Function touchCharacterSelectModeClose:Void()
			MFDevice.removeComponent(touchcharsel)
			MFDevice.removeComponent(touchcharsElselect)
			MFDevice.removeComponent(slidesensorcharsel)
			MFDevice.removeComponent(touchcharselreturn)
			MFDevice.removeComponent(touchcharselleftarrow)
			MFDevice.removeComponent(touchcharselrightarrow)
			
			touchcharsel = Null
			touchcharsElselect = Null
			slidesensorcharsel = Null
			touchcharselreturn = Null
			touchcharselleftarrow = Null
			touchcharselrightarrow = Null
		End
		
		Function touchStageSelectModeInit:Void()
			If (slidesensorstagesel = Null Or touchstageselect = Null Or touchstageselectreturn = Null Or touchstageselectuparrow = Null Or touchstageselectdownarrow = Null) Then
				slidesensorstagesel = New MFSlideSensor(64, 0, (SCREEN_WIDTH - 64) - 52, SCREEN_HEIGHT, 8)
				
				touchstageselect = New TouchKeyRange(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
				
				touchstageselectitem = New TouchKeyRange[14]
				
				For Local i:= 0 Until touchstageselectitem.Length
					touchstageselectitem[i] = New TouchKeyRange(64, ((i + 1) * 24) - 12, (SCREEN_WIDTH - 64) - 52, 24)
				Next
				
				touchstageselectreturn = New TouchKeyRange(0, SCREEN_HEIGHT - 24, 24, 24)
				touchstageselectuparrow = New TouchKeyRange(24, (SCREEN_HEIGHT / 2) - 80, 40, 48) ' Shr 1
				touchstageselectdownarrow = New TouchKeyRange(24, (SCREEN_HEIGHT / 2) + 32, 40, 48) ' Shr 1
				
				MFDevice.addComponent(slidesensorstagesel)
				MFDevice.addComponent(touchstageselect)
				
				For Local i:= 0 Until touchstageselectitem.Length
					MFDevice.addComponent(touchstageselectitem[i])
				Next
				
				MFDevice.addComponent(touchstageselectreturn)
				MFDevice.addComponent(touchstageselectuparrow)
				MFDevice.addComponent(touchstageselectdownarrow)
			EndIf
			
			touchstageselect.resetKeyState()
			
			For Local i:= 0 Until touchstageselectitem.Length
				touchstageselectitem[i].resetKeyState()
			Next
			
			touchstageselectreturn.resetKeyState()
			touchstageselectuparrow.resetKeyState()
			touchstageselectdownarrow.resetKeyState()
		End
		
		Function touchStageSelectModeClose:Void()
			MFDevice.removeComponent(slidesensorstagesel)
			MFDevice.removeComponent(touchstageselect)
			
			For Local i:= 0 Until touchstageselectitem.Length
				MFDevice.removeComponent(touchstageselectitem[i])
			Next
			
			MFDevice.removeComponent(touchstageselectreturn)
			MFDevice.removeComponent(touchstageselectuparrow)
			MFDevice.removeComponent(touchstageselectdownarrow)
			
			slidesensorstagesel = Null
			touchstageselect = Null
			
			For Local i:= 0 Until touchstageselectitem.Length
				touchstageselectitem[i] = Null
			Next
			
			touchstageselectitem = []
			
			touchstageselectreturn = Null
			touchstageselectuparrow = Null
			touchstageselectdownarrow = Null
		End
		
		Function touchCharacterRecordInit:Void()
			If (slidesensorcharacterrecord = Null Or touchintergraderecord = Null Or touchintergraderecordreturn = Null Or touchintergraderecordleftarrow = Null Or touchintergraderecordrightarrow = Null Or touchintergraderecordupdate = Null) Then
				slidesensorcharacterrecord = New MFSlideSensor(0, (SCREEN_HEIGHT / 2) - 48, SCREEN_WIDTH, def.TOUCH_OPTION_ITEMS_TOUCH_WIDTH_1, (SCREEN_WIDTH / 2)) ' Shr 1
				touchintergraderecord = New TouchKeyRange(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
				touchintergraderecordreturn = New TouchKeyRange(0, SCREEN_HEIGHT - 24, 24, 24)
				touchintergraderecordleftarrow = New TouchKeyRange(0, (SCREEN_HEIGHT / 2) - 12, PAUSE_WIDTH, PAUSE_WIDTH) ' Shr 1
				touchintergraderecordrightarrow = New TouchKeyRange(SCREEN_WIDTH - PAUSE_WIDTH, (SCREEN_HEIGHT / 2) - 12, PAUSE_WIDTH, PAUSE_WIDTH) ' Shr 1
				touchintergraderecordupdate = New TouchKeyRange(SCREEN_WIDTH - 50, 0, 50, 32)
				
				MFDevice.addComponent(slidesensorcharacterrecord)
				MFDevice.addComponent(touchintergraderecord)
				MFDevice.addComponent(touchintergraderecordreturn)
				MFDevice.addComponent(touchintergraderecordleftarrow)
				MFDevice.addComponent(touchintergraderecordrightarrow)
				MFDevice.addComponent(touchintergraderecordupdate)
			EndIf
			
			touchintergraderecord.resetKeyState()
			touchintergraderecordreturn.resetKeyState()
			touchintergraderecordleftarrow.resetKeyState()
			touchintergraderecordrightarrow.resetKeyState()
			touchintergraderecordupdate.resetKeyState()
		End
		
		Function touchCharacterRecordClose:Void()
			MFDevice.removeComponent(slidesensorcharacterrecord)
			MFDevice.removeComponent(touchintergraderecord)
			MFDevice.removeComponent(touchintergraderecordreturn)
			MFDevice.removeComponent(touchintergraderecordleftarrow)
			MFDevice.removeComponent(touchintergraderecordrightarrow)
			MFDevice.removeComponent(touchintergraderecordupdate)
			
			slidesensorcharacterrecord = Null
			touchintergraderecord = Null
			touchintergraderecordreturn = Null
			touchintergraderecordleftarrow = Null
			touchintergraderecordrightarrow = Null
			touchintergraderecordupdate = Null
		End
		
		Function touchGamePauseInit:Void(type:Int)
			If (touchgamepause = Null Or (touchgamepauseitem.Length = 0) Or touchgamepausereturn = Null) Then
				touchgamepause = New TouchKeyRange(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
				
				touchgamepauseitem = New TouchKeyRange[6]
				
				Local itemsstarty:= 0
				
				If (type = TYPE_SP_MODE) Then
					itemsstarty = ((SCREEN_HEIGHT / 2) - 36) - 12 ' Shr 1
				ElseIf (type = TYPE_GAME_MODE) Then
					itemsstarty = ((SCREEN_HEIGHT / 2) - PAUSE_WIDTH) - 12 ' Shr 1
				EndIf
				
				MFDevice.addComponent(touchgamepause)
				
				For Local i:= 0 Until touchgamepauseitem.Length
					touchgamepauseitem[i] = New TouchKeyRange((SCREEN_WIDTH / 2) - 44, (i * 24) + itemsstarty, 88, 24) ' Shr 1
					
					MFDevice.addComponent(touchgamepauseitem[i])
				Next
				
				touchgamepausereturn = New TouchKeyRange(0, SCREEN_HEIGHT - 24, 24, 24)
				
				MFDevice.addComponent(touchgamepausereturn)
			EndIf
			
			touchgamepause.resetKeyState()
			touchgamepausereturn.resetKeyState()
			
			For Local i:= 0 Until touchgamepauseitem.Length
				touchgamepauseitem[i].resetKeyState()
			Next
		End
		
		Function touchGamePauseClose:Void()
			If (touchgamepause <> Null) Then
				MFDevice.removeComponent(touchgamepause)
				
				touchgamepause = Null
				
				For Local i:= 0 Until touchgamepauseitem.Length
					MFDevice.removeComponent(touchgamepauseitem[i])
					
					touchgamepauseitem[i] = Null
				Next
				
				touchgamepauseitem = []
				
				MFDevice.removeComponent(touchgamepausereturn)
				
				touchgamepausereturn = Null
			EndIf
		End
		
		Function touchSecondEnsureInit:Void()
			If (touchsecondensure = Null Or touchsecondensureyes = Null Or touchsecondensureno = Null Or touchsecondensurereturn = Null) Then
				touchsecondensure = New TouchKeyRange(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
				touchsecondensureyes = New TouchKeyRange((SCREEN_WIDTH / 2) - 80, (SCREEN_HEIGHT / 2) + 24, 80, 32) ' Shr 1
				touchsecondensureno = New TouchKeyRange((SCREEN_WIDTH / 2), (SCREEN_HEIGHT / 2) + 24, 80, 32) ' Shr 1
				touchsecondensurereturn = New TouchKeyRange(0, SCREEN_HEIGHT - 24, 24, 24)
				
				MFDevice.addComponent(touchsecondensure)
				MFDevice.addComponent(touchsecondensureyes)
				MFDevice.addComponent(touchsecondensureno)
				MFDevice.addComponent(touchsecondensurereturn)
			EndIf
			
			touchsecondensure.resetKeyState()
			touchsecondensureyes.resetKeyState()
			touchsecondensureno.resetKeyState()
			touchsecondensurereturn.resetKeyState()
		End
		
		Function touchSecondEnsureClose:Void()
			MFDevice.removeComponent(touchsecondensure)
			MFDevice.removeComponent(touchsecondensureyes)
			MFDevice.removeComponent(touchsecondensureno)
			MFDevice.removeComponent(touchsecondensurereturn)
			
			touchsecondensure = Null
			touchsecondensureyes = Null
			touchsecondensureno = Null
			touchsecondensurereturn = Null
		End
		
		Function touchStartGameInit:Void()
			If (touchstartgame = Null Or touchstartgamecontinue = Null Or touchstartgamenew = Null Or touchstartgamereturn = Null) Then
				touchstartgame = New TouchKeyRange(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
				touchstartgamecontinue = New TouchKeyRange((SCREEN_WIDTH / 2) - 48, (SCREEN_HEIGHT / 2) - 36, 96, 36) ' Shr 1
				touchstartgamenew = New TouchKeyRange((SCREEN_WIDTH / 2) - 48, (SCREEN_HEIGHT / 2), 96, 36) ' Shr 1
				touchstartgamereturn = New TouchKeyRange(0, SCREEN_HEIGHT - 24, 24, 24)
				
				MFDevice.addComponent(touchstartgame)
				MFDevice.addComponent(touchstartgamecontinue)
				MFDevice.addComponent(touchstartgamenew)
				MFDevice.addComponent(touchstartgamereturn)
			EndIf
			
			touchstartgame.resetKeyState()
			touchstartgamecontinue.resetKeyState()
			touchstartgamenew.resetKeyState()
			touchstartgamereturn.resetKeyState()
		End
		
		Function touchStartGameClose:Void()
			MFDevice.removeComponent(touchstartgame)
			MFDevice.removeComponent(touchstartgamecontinue)
			MFDevice.removeComponent(touchstartgamenew)
			MFDevice.removeComponent(touchstartgamereturn)
			
			touchstartgame = Null
			touchstartgamecontinue = Null
			touchstartgamenew = Null
			touchstartgamereturn = Null
		End
		
		Function touchGamePauseOptionInit:Void()
			If (touchpauseoption = Null Or touchpauseoptionsound = Null Or touchpauseoptionvib = Null Or touchpauseoptionkeyset = Null Or touchpauseoptionspset = Null Or touchpauseoptionhelp = Null Or touchpauseoptionreturn = Null) Then
				touchpauseoption = New TouchKeyRange(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
				touchpauseoptionsound = New TouchKeyRange(((SCREEN_WIDTH / 2) + 56) - 56, 28, def.TOUCH_OPTION_ITEMS_TOUCH_WIDTH_1, 24) ' Shr 1
				touchpauseoptionvib = New TouchKeyRange(((SCREEN_WIDTH / 2) + 56) - 56, 52, def.TOUCH_OPTION_ITEMS_TOUCH_WIDTH_1, 24) ' Shr 1
				touchpauseoptionkeyset = New TouchKeyRange(((SCREEN_WIDTH / 2) - 56) - def.TOUCH_OPTION_ITEMS_TOUCH_WIDTH_1, 76, SpecialMap.MAP_HEIGHT, 24) ' Shr 1 ' 224
				touchpauseoptionspset = New TouchKeyRange(((SCREEN_WIDTH / 2) + 56) - 56, 100, def.TOUCH_OPTION_ITEMS_TOUCH_WIDTH_1, 24) ' Shr 1
				touchpauseoptionhelp = New TouchKeyRange(((SCREEN_WIDTH / 2) - 56) - def.TOUCH_OPTION_ITEMS_TOUCH_WIDTH_1, 124, SpecialMap.MAP_HEIGHT, 24) ' Shr 1 ' 224
				touchpauseoptionreturn = New TouchKeyRange(0, SCREEN_HEIGHT - 24, 24, 24)
				
				MFDevice.addComponent(touchpauseoption)
				MFDevice.addComponent(touchpauseoptionsound)
				MFDevice.addComponent(touchpauseoptionvib)
				MFDevice.addComponent(touchpauseoptionkeyset)
				MFDevice.addComponent(touchpauseoptionspset)
				MFDevice.addComponent(touchpauseoptionhelp)
				MFDevice.addComponent(touchpauseoptionreturn)
			EndIf
			
			touchpauseoption.resetKeyState()
			touchpauseoptionsound.resetKeyState()
			touchpauseoptionvib.resetKeyState()
			touchpauseoptionkeyset.resetKeyState()
			touchpauseoptionspset.resetKeyState()
			touchpauseoptionhelp.resetKeyState()
			touchpauseoptionreturn.resetKeyState()
		End
		
		Function touchGamePauseOptionClose:Void()
			MFDevice.removeComponent(touchpauseoption)
			MFDevice.removeComponent(touchpauseoptionsound)
			MFDevice.removeComponent(touchpauseoptionvib)
			MFDevice.removeComponent(touchpauseoptionkeyset)
			MFDevice.removeComponent(touchpauseoptionspset)
			MFDevice.removeComponent(touchpauseoptionhelp)
			MFDevice.removeComponent(touchpauseoptionreturn)
			
			touchpauseoption = Null
			touchpauseoptionsound = Null
			touchpauseoptionvib = Null
			touchpauseoptionkeyset = Null
			touchpauseoptionspset = Null
			touchpauseoptionhelp = Null
			touchpauseoptionreturn = Null
		End
		
		Function touchMenuOptionInit:Void()
			If (touchmenuoption = Null Or slidesensormenuoption = Null Or (touchmenuoptionitems.Length = 0) Or touchmenuoptionreturn = Null Or touchmenuoptionuparrow = Null Or touchmenuoptiondownarrow = Null) Then
				touchmenuoption = New TouchKeyRange(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
				
				slidesensormenuoption = New MFSlideSensor(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, 4)
				
				touchmenuoptionitems = New TouchKeyRange[22]
				
				For Local i:= 0 Until (touchmenuoptionitems.Length / 2) ' Shr 1
					touchmenuoptionitems[i * 2] = New TouchKeyRange((SCREEN_WIDTH / 2) - 100, (i * 24) + 28, 100, 24) ' Shr 1
					touchmenuoptionitems[(i * 2) + 1] = New TouchKeyRange((SCREEN_WIDTH / 2), (i * 24) + 28, def.TOUCH_OPTION_ITEMS_TOUCH_WIDTH_1, 24) ' Shr 1
				Next
				
				touchmenuoptionreturn = New TouchKeyRange(0, SCREEN_HEIGHT - 24, 24, 24)
				
				MFDevice.addComponent(touchmenuoption)
				MFDevice.addComponent(slidesensormenuoption)
				MFDevice.addComponent(touchmenuoptionreturn)
				
				For Local i:= 0 Until touchmenuoptionitems.Length
					MFDevice.addComponent(touchmenuoptionitems[i])
				Next
				
				touchmenuoptionuparrow = New TouchKeyRange((SCREEN_WIDTH / 2) + def.TOUCH_OPTION_ARROW_RANGE_X, (SCREEN_HEIGHT / 2) - 41, 24, 32) ' Shr 1
				touchmenuoptiondownarrow = New TouchKeyRange((SCREEN_WIDTH / 2) + def.TOUCH_OPTION_ARROW_RANGE_X, (SCREEN_HEIGHT / 2) + 24, 24, 32) ' Shr 1
				
				MFDevice.addComponent(touchmenuoptionuparrow)
				MFDevice.addComponent(touchmenuoptiondownarrow)
			EndIf
			
			touchmenuoption.resetKeyState()
			touchmenuoptionreturn.resetKeyState()
			
			For Local i:= 0 Until touchmenuoptionitems.Length
				touchmenuoptionitems[i].resetKeyState()
			Next
		End
		
		Function touchMenuOptionClose:Void()
			MFDevice.removeComponent(touchmenuoption)
			MFDevice.removeComponent(slidesensormenuoption)
			MFDevice.removeComponent(touchmenuoptionreturn)
			
			For Local i:= 0 Until touchmenuoptionitems.Length
				MFDevice.removeComponent(touchmenuoptionitems[i])
				
				touchmenuoptionitems[i] = Null
			Next
			
			touchmenuoptionitems = []
			
			touchmenuoption = Null
			slidesensormenuoption = Null
			touchmenuoptionreturn = Null
			
			MFDevice.removeComponent(touchmenuoptionuparrow)
			MFDevice.removeComponent(touchmenuoptiondownarrow)
			
			touchmenuoptionuparrow = Null
			touchmenuoptiondownarrow = Null
		End
		
		Function touchItemsSelect2Init:Void()
			If (touchitemsselect2 = Null Or touchitemsselect2_1 = Null Or touchitemsselect2_2 = Null Or touchitemsselect2_return = Null) Then
				touchitemsselect2 = New TouchKeyRange(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
				touchitemsselect2_1 = New TouchKeyRange((SCREEN_WIDTH / 2) - 48, (SCREEN_HEIGHT / 2) - 36, 96, 36) ' Shr 1
				touchitemsselect2_2 = New TouchKeyRange((SCREEN_WIDTH / 2) - 48, (SCREEN_HEIGHT / 2), 96, 36) ' Shr 1
				touchitemsselect2_return = New TouchKeyRange(0, SCREEN_HEIGHT - 24, 24, 24)
				
				MFDevice.addComponent(touchitemsselect2)
				MFDevice.addComponent(touchitemsselect2_1)
				MFDevice.addComponent(touchitemsselect2_2)
				MFDevice.addComponent(touchitemsselect2_return)
			EndIf
			
			touchitemsselect2.resetKeyState()
			touchitemsselect2_1.resetKeyState()
			touchitemsselect2_2.resetKeyState()
			touchitemsselect2_return.resetKeyState()
		End
		
		Function touchItemsSelect2Close:Void()
			MFDevice.removeComponent(touchitemsselect2)
			MFDevice.removeComponent(touchitemsselect2_1)
			MFDevice.removeComponent(touchitemsselect2_2)
			MFDevice.removeComponent(touchitemsselect2_return)
			
			touchitemsselect2 = Null
			touchitemsselect2_1 = Null
			touchitemsselect2_2 = Null
			touchitemsselect2_return = Null
		End
		
		Function touchItemsSelect3Init:Void()
			If (touchitemsselect3 = Null Or touchitemsselect3_1 = Null Or touchitemsselect3_3 = Null Or touchitemsselect3_2 = Null Or touchitemsselect3_return = Null) Then
				touchitemsselect3 = New TouchKeyRange(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
				touchitemsselect3_1 = New TouchKeyRange((SCREEN_WIDTH / 2) - 48, ((SCREEN_HEIGHT / 2) - 36) - 18, 96, 36) ' Shr 1
				touchitemsselect3_2 = New TouchKeyRange((SCREEN_WIDTH / 2) - 48, ((SCREEN_HEIGHT / 2) - 36) + 18, 96, 36) ' Shr 1
				touchitemsselect3_3 = New TouchKeyRange((SCREEN_WIDTH / 2) - 48, ((SCREEN_HEIGHT / 2) - 36) + 54, 96, 36) ' Shr 1
				touchitemsselect3_return = New TouchKeyRange(0, SCREEN_HEIGHT - 24, 24, 24)
				
				MFDevice.addComponent(touchitemsselect3)
				MFDevice.addComponent(touchitemsselect3_1)
				MFDevice.addComponent(touchitemsselect3_2)
				MFDevice.addComponent(touchitemsselect3_3)
				MFDevice.addComponent(touchitemsselect3_return)
			EndIf
			
			touchitemsselect3.resetKeyState()
			touchitemsselect3_1.resetKeyState()
			touchitemsselect3_2.resetKeyState()
			touchitemsselect3_3.resetKeyState()
			touchitemsselect3_return.resetKeyState()
		End
		
		Function touchItemsSelect3Close:Void()
			MFDevice.removeComponent(touchitemsselect3)
			MFDevice.removeComponent(touchitemsselect3_1)
			MFDevice.removeComponent(touchitemsselect3_2)
			MFDevice.removeComponent(touchitemsselect3_3)
			MFDevice.removeComponent(touchitemsselect3_return)
			
			touchitemsselect3 = Null
			touchitemsselect3_1 = Null
			touchitemsselect3_2 = Null
			touchitemsselect3_3 = Null
			touchitemsselect3_return = Null
		End
		
		Function touchInstructionInit:Void()
			If (slidesensorhelp = Null Or touchhelpreturn = Null Or touchhelpuparrow = Null Or touchhelpdownarrow = Null Or touchpage = Null Or touchhelpleftarrow = Null Or touchhelprightarrow = Null) Then
				touchpage = New TouchKeyRange(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
				
				slidesensorhelp = New MFSlideSensor((SCREEN_WIDTH / 2) - 104, 0, def.TOUCH_HELP_WIDTH, SCREEN_HEIGHT, TOUCH_WIDTH) ' Shr 1
				
				touchhelpreturn = New TouchKeyRange(0, SCREEN_HEIGHT - 24, 24, 24)
				touchhelpuparrow = New TouchKeyRange((SCREEN_WIDTH / 2) - 40, SCREEN_HEIGHT - 24, 32, 24) ' Shr 1
				touchhelpdownarrow = New TouchKeyRange((SCREEN_WIDTH / 2) + 8, SCREEN_HEIGHT - 24, 32, 24) ' Shr 1
				touchhelpleftarrow = New TouchKeyRange(0, (SCREEN_HEIGHT / 2) - 24, 40, 40) ' Shr 1
				touchhelprightarrow = New TouchKeyRange(SCREEN_WIDTH - 40, (SCREEN_HEIGHT / 2) - 24, 40, 40) ' Shr 1
				
				MFDevice.addComponent(touchpage)
				MFDevice.addComponent(slidesensorhelp)
				MFDevice.addComponent(touchhelpreturn)
				MFDevice.addComponent(touchhelpuparrow)
				MFDevice.addComponent(touchhelpdownarrow)
				MFDevice.addComponent(touchhelpleftarrow)
				MFDevice.addComponent(touchhelprightarrow)
			EndIf
			
			touchpage.resetKeyState()
			touchhelpreturn.resetKeyState()
			touchhelpuparrow.resetKeyState()
			touchhelpdownarrow.resetKeyState()
			touchhelpleftarrow.resetKeyState()
			touchhelprightarrow.resetKeyState()
		End
		
		Function touchInstructionClose:Void()
			MFDevice.removeComponent(touchpage)
			MFDevice.removeComponent(slidesensorhelp)
			MFDevice.removeComponent(touchhelpreturn)
			MFDevice.removeComponent(touchhelpuparrow)
			MFDevice.removeComponent(touchhelpdownarrow)
			MFDevice.removeComponent(touchhelpleftarrow)
			MFDevice.removeComponent(touchhelprightarrow)
			
			touchpage = Null
			slidesensorhelp = Null
			touchhelpreturn = Null
			touchhelpuparrow = Null
			touchhelpdownarrow = Null
			touchhelpleftarrow = Null
			touchhelprightarrow = Null
		End
		
		Function touchMenuOptionLanguageInit:Void()
			If (touchmenuoptionlanguage = Null Or (touchmenuoptionlanguageitems.Length = 0) Or touchmenuoptionlanguagereturn = Null) Then
				touchmenuoptionlanguage = New TouchKeyRange(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
				
				MFDevice.addComponent(touchmenuoptionlanguage)
				
				touchmenuoptionlanguageitems = New TouchKeyRange[5]
				
				For Local i:= 0 Until touchmenuoptionlanguageitems.Length ' 5
					touchmenuoptionlanguageitems[i] = New TouchKeyRange((SCREEN_WIDTH / 2) - 48, ((SCREEN_HEIGHT / 2) - 60) + (i * 36), 96, 36) ' Shr 1
					
					MFDevice.addComponent(touchmenuoptionlanguageitems[i])
				Next
				
				touchmenuoptionlanguagereturn = New TouchKeyRange(0, SCREEN_HEIGHT - 24, 24, 24)
				
				MFDevice.addComponent(touchmenuoptionlanguagereturn)
			EndIf
			
			touchmenuoptionlanguage.resetKeyState()
			touchmenuoptionlanguagereturn.resetKeyState()
			
			For Local i:= 0 Until touchmenuoptionlanguageitems.Length ' 5
				touchmenuoptionlanguageitems[i].resetKeyState()
			Next
		End
		
		Function touchMenuOptionLanguageClose:Void()
			MFDevice.removeComponent(touchmenuoptionlanguage)
			touchmenuoptionlanguage = Null
			
			For Local i:= 0 Until touchmenuoptionlanguageitems.Length ' 5
				MFDevice.removeComponent(touchmenuoptionlanguageitems[i])
				
				touchmenuoptionlanguageitems[i] = Null
			Next
			
			touchmenuoptionlanguageitems = []
			
			MFDevice.removeComponent(touchmenuoptionlanguagereturn)
			touchmenuoptionlanguagereturn = Null
		End
		
		Function touchOpeningInit:Void()
			If (touchopening = Null Or touchopeningskip = Null) Then
				touchopening = New TouchKeyRange(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
				touchopeningskip = New TouchKeyRange(0, SCREEN_HEIGHT - 24, 24, 24)
				
				MFDevice.addComponent(touchopening)
				MFDevice.addComponent(touchopeningskip)
			EndIf
			
			touchopening.resetKeyState()
			touchopeningskip.resetKeyState()
		End
		
		Function touchOpeningClose:Void()
			MFDevice.removeComponent(touchopening)
			MFDevice.removeComponent(touchopeningskip)
			
			touchopening = Null
			touchopeningskip = Null
		End
		
		Function touchInterruptInit:Void()
			If (touchinterruptreturn = Null) Then
				touchinterruptreturn = New TouchKeyRange((SCREEN_WIDTH / 2) - 48, (SCREEN_HEIGHT / 2) - 12, 96, 24) ' Shr 1
				
				MFDevice.addComponent(touchinterruptreturn)
			EndIf
			
			touchinterruptreturn.resetKeyState()
		End
		
		Function touchInterruptClose:Void()
			MFDevice.removeComponent(touchinterruptreturn)
			
			touchinterruptreturn = Null
		End
		
		Function touchSPstageInit:Void()
			If (touchspstagepause = Null Or touchspstage = Null) Then
				touchspstage = New TouchKeyRange(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
				touchspstagepause = New TouchKeyRange(MyAPI.zoomOut(pause_x), MyAPI.zoomOut(pause_y), MyAPI.zoomOut(PAUSE_WIDTH), MyAPI.zoomOut(PAUSE_HEIGHT))
				
				MFDevice.addComponent(touchspstage)
				MFDevice.addComponent(touchspstagepause)
			EndIf
			
			touchspstage.resetKeyState()
			touchspstagepause.resetKeyState()
			
			touchstarpoundkeyInit()
		End
		
		Function touchSPstageClose:Void()
			MFDevice.removeComponent(touchspstage)
			MFDevice.removeComponent(touchspstagepause)
			
			touchspstage = Null
			touchspstagepause = Null
		End
		
		Function touchgameoverensurekeyInit:Void()
			If (touchgameover = Null Or touchgameoveryres = Null Or touchgameoverno = Null) Then
				touchgameover = New TouchKeyRange(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
				touchgameoveryres = New TouchKeyRange(MyAPI.zoomOut(SCREEN_WIDTH - 42), MyAPI.zoomOut(103), MyAPI.zoomOut(40), MyAPI.zoomOut(40))
				touchgameoverno = New TouchKeyRange(MyAPI.zoomOut(SCREEN_WIDTH - 87), MyAPI.zoomOut(118), MyAPI.zoomOut(40), MyAPI.zoomOut(40))
				
				MFDevice.addComponent(touchgameover)
				MFDevice.addComponent(touchgameoveryres)
				MFDevice.addComponent(touchgameoverno)
			EndIf
			
			touchgameover.resetKeyState()
			touchgameoveryres.resetKeyState()
			touchgameoverno.resetKeyState()
		End
		
		Function touchgameoverensurekeyClose:Void()
			If (touchgameover <> Null) Then
				MFDevice.removeComponent(touchgameover)
				MFDevice.removeComponent(touchgameoveryres)
				MFDevice.removeComponent(touchgameoverno)
				
				touchgameover = Null
				touchgameoveryres = Null
				touchgameoverno = Null
			EndIf
		End
		
		Function touchscoreupdatekeyInit:Void()
			If (touchscoreupdate = Null Or touchscoreupdateyes = Null Or touchscoreupdateno = Null Or touchscoreupdatereturn = Null) Then
				touchscoreupdate = New TouchKeyRange(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
				touchscoreupdateyes = New TouchKeyRange((SCREEN_WIDTH / 2) + def.TOUCH_SCORE_UPDATE_MENU_YES_START_X, (SCREEN_HEIGHT / 2) + 10, 96, 28) ' Shr 1
				touchscoreupdateno = New TouchKeyRange((SCREEN_WIDTH / 2) + 12, (SCREEN_HEIGHT / 2) + 10, 96, 28) ' Shr 1
				touchscoreupdatereturn = New TouchKeyRange(0, SCREEN_HEIGHT - 24, 24, 24)
				
				MFDevice.addComponent(touchscoreupdate)
				MFDevice.addComponent(touchscoreupdateyes)
				MFDevice.addComponent(touchscoreupdateno)
				MFDevice.addComponent(touchscoreupdatereturn)
			EndIf
			
			touchscoreupdate.resetKeyState()
			touchscoreupdateyes.resetKeyState()
			touchscoreupdateno.resetKeyState()
			touchscoreupdatereturn.resetKeyState()
		End
		
		Function touchscoreupdatekeyClose:Void()
			If (touchscoreupdate <> Null) Then
				MFDevice.removeComponent(touchscoreupdate)
				MFDevice.removeComponent(touchscoreupdateyes)
				MFDevice.removeComponent(touchscoreupdateno)
				MFDevice.removeComponent(touchscoreupdatereturn)
				
				touchscoreupdate = Null
				touchscoreupdateyes = Null
				touchscoreupdateno = Null
				touchscoreupdatereturn = Null
			EndIf
		End
		
		Function touchgamekeyInit:Void()
			' Empty implementation.
		End
		
		Function touchgamekeyClose:Void()
			' Empty implementation.
		End
		
		Function touchkeypauseInit:Void()
			If (touchkey_pause = Null Or touchgame = Null) Then
				touchgame = New TouchKeyRange(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
				touchkey_pause = New TouchKeyRange(MyAPI.zoomOut(pause_x), MyAPI.zoomOut(pause_y), MyAPI.zoomOut(PAUSE_WIDTH), MyAPI.zoomOut(PAUSE_HEIGHT))
				
				MFDevice.addComponent(touchgame)
				MFDevice.addComponent(touchkey_pause)
			EndIf
			
			touchgame.resetKeyState()
			touchkey_pause.resetKeyState()
		End
		
		Function touchkeypauseClose:Void()
			MFDevice.removeComponent(touchgame)
			MFDevice.removeComponent(touchkey_pause)
			
			touchgame = Null
			touchkey_pause = Null
		End
		
		Function init:Void()
			gUp = (B_UP | B_2)
			gDown = (B_DOWN | B_8)
			gLeft = (B_LEFT | B_4)
			gRight = (B_RIGHT | B_6)
			gSelect = (B_SEL | B_5)
		End
		
		Function initSonic:Void()
			gUp = (((B_UP | B_2) | B_3) | B_1)
			gDown = (B_DOWN | B_8)
			gLeft = ((B_LEFT | B_4) | B_1)
			gRight = ((B_RIGHT | B_6) | B_3)
			gSelect = (B_SEL | B_5)
		End
		
		Function getKeypadState:Void()
			KEY_before = KEY_get
			KEY_get = KEY
			KEY_press = ((KEY_before ~ -1) & KEY_get)
		End
		
		Function clear:Void()
			MFGamePad.resetKeys()
		End
		
		Function setPress:Void(button:Int)
			KEY |= button
			
			getKeypadState()
		End
		
		Function press:Bool(button:Int)
			If (keyFunction) Then
				Return MFGamePad.isKeyPress(button)
			EndIf
			
			Return False
		End
		
		Function repeated:Bool(button:Int) ' repeat
			If (keyFunction) Then
				Return MFGamePad.isKeyRepeat(button)
			EndIf
			
			Return False
		End
		
		Function release:Bool(button:Int)
			If (keyFunction) Then
				Return MFGamePad.isKeyRelease(button)
			EndIf
			
			Return False
		End
		
		Function setKeyFunction:Void(toggle:Bool)
			keyFunction = toggle
		End
		
		Function pressAnyKey:Bool()
			If (keyFunction) Then
				Return MFGamePad.isKeyPress(-1)
			EndIf
			
			Return False
		End
		
		Function repeatAnyKey:Bool()
			If (keyFunction) Then
				Return MFGamePad.isKeyRepeat(-1)
			EndIf
			
			Return False
		End
		
		Function buttonPress:Bool(button:Int)
			If (press(button)) Then
				If (keyState = 0) Then
					keyState = TYPE_GAME_MODE
				EndIf
				
				Return False
			ElseIf (Not release(button)) Then
				Return False
			EndIf
			
			If (keyState <> TYPE_GAME_MODE) Then
				Return False
			EndIf
			
			keyState = 0
			
			Return True
		End
		
		Function keyPressed:Void(keyCode:Int)
			' Empty implementation.
		End
		
		Function keyReleased:Void(keyCode:Int)
			' Empty implementation.
		End
End