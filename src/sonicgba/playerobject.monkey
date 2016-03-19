﻿Strict

Public

' Imports:
Private
	Import common.numberdrawer
	
	Import gameengine.def
	Import gameengine.key
	
	Import lib.animation
	Import lib.animationdrawer
	Import lib.coordinate
	Import lib.direction
	Import lib.line
	Import lib.myapi
	Import lib.myrandom
	Import lib.soundsystem
	Import lib.crlfp32
	
	Import mflib.bpdef
	
	Import special.ssdef
	Import special.specialmap
	
	Import state.gamestate
	Import state.state
	Import state.stringindex
	Import state.titlestate
	
	Import com.sega.engine.action.acblock
	Import com.sega.engine.action.accollision
	Import com.sega.engine.action.acobject
	Import com.sega.engine.action.acutilities
	Import com.sega.engine.action.acworldcaluser
	Import com.sega.engine.action.acworldcollisioncalculator
	Import com.sega.mobile.define.mdphone
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
	
	Import regal.typetool
	
	Import sonicgba.moveobject
	Import sonicgba.focusable
Public

' Functions:
Private
	' Extensions:
	Function __Resolve_NUM_DISTANCE:Int(X:Int, Y:Int, A:Int, B:Int)
		If (X > Y) Then
			Return A
		EndIf
		
		Return B
	End
Public

' Classes:
Class PlayerObject Extends MoveObject Implements Focusable, ACWorldCalUser Abstract
	Private
		' Constant variable(s):
		Const ANIMATION_PATH:String = "/animation"
		Const ANI_BIG_ZERO:Int = 67
		Const ANI_SMALL_ZERO:Int = 27
		Const ANI_SMALL_ZERO_Y:Int = 37
		Const ASPIRATE_INTERVAL:Int = 3
		Const ATTRACT_EFFECT_HEIGHT:Int = 9600
		Const ATTRACT_EFFECT_WIDTH:Int = 9600
		Const BACKGROUND_WIDTH:Int = 80
		Const BAR_COLOR:Int = 2
		Const BG_NUM:Int = (((SCREEN_WIDTH + BACKGROUND_WIDTH) - 1) / BACKGROUND_WIDTH)
		Const BODY_OFFSET:Int = 768
		Const BREATHE_IMAGE_HEIGHT:Int = 16
		Const BREATHE_IMAGE_WIDTH:Int = 16
		Const BREATHE_TIME_COUNT:Int = 21000
		Const BREATHE_TO_DIE_PER_COUNT:Int = 1760
		Const B_1:Int = 5760
		Const B_2:Int = 11264
		Const CAMERA_MAX_DISTANCE:Int = 20
		Const CENTER_X:Int = 660480
		Const CENTER_Y:Int = 63488
		Const COUNT_INDEX:Int = 1
		Const DEBUG_WUDI:Bool = False
		Const DIE_DRIP_STATE_JUMP_V0:Int = -800
		Const DO_POAL_MOTION_SPEED:Int = 600
		Const ENLARGE_NUM:Int = 1920
		Const f23A:Int = 3072
		Const f24C:Int = 3072
		Const FADE_FILL_HEIGHT:Int = 40
		Const FADE_FILL_WIDTH:Int = 40
		Const FOCUS_MAX_OFFSET:Int = (MapManager.CAMERA_HEIGHT / 2) - 16
		Const FOCUS_MOVE_SPEED:Int = 15
		Const FOCUS_MOVING_NONE:Int = 0
		Const FONT_NUM:Int = 7
		Const FOOT_OFFSET:Int = 256
		Const HINER_JUMP_LIMIT:Int = 1024
		Const HINER_JUMP_MAX:Int = 4352
		Const HINER_JUMP_X_ADD:Int = 1024
		Const HINER_JUMP_Y:Int = 2048
		Const ICE_SLIP_FLUSH_OFFSET_Y:Int = 512
		Const INVINCIBLE_COUNT:Int = 320
		Const IN_WATER_WALK_SPEED_SCALE1:Float = 5.0
		Const IN_WATER_WALK_SPEED_SCALE2:Float = 9.0
		Const ITEM_INDEX:Int = 0
		Const JUMP_EFFECT_HEIGHT:Int = 1920
		Const JUMP_EFFECT_OFFSET_Y:Int = 256
		Const JUMP_EFFECT_WIDTH:Int = 1920
		Const LEFT_FOOT_OFFSET_X:Int = -256
		Const LEFT_WALK_COLLISION_CHECK_OFFSET_X:Int = -512
		Const LEFT_WALK_COLLISION_CHECK_OFFSET_Y:Int = -512
		Const LOOK_COUNT:Int = 32
		Const MAX_ITEM:Int = 5
		Const MAX_ITEM_SHOW_NUM:Int = 4
		Const MOON_STAR_FRAMES_1:Int = 207
		Const MOON_STAR_FRAMES_2:Int = 120
		Const MOON_STAR_ORI_X_1:Int = 360
		Const MOON_STAR_ORI_Y_1:Int = 18
		Const MOON_STAR_DES_X_1:Int = (MOON_STAR_ORI_X_1 - 22)
		Const MOON_STAR_DES_Y_1:Int = 26
		Global NUM_DISTANCE:Int = __Resolve_NUM_DISTANCE(NUM_SPACE[0] * 8, 60, NUM_SPACE[0] * 7, 60)
		
		' Sizes of numbers found in "number.png":
		Const NUM_PIC_WIDTH:Int = 7
		Const NUM_PIC_HEIGHT:Int = 13
		Const NUM_PIC_SPACE_WIDTH:= (NUM_PIC_WIDTH+1)
		
		Const PIPE_SET_POWER:Int = 2880
		Const RAIL_FLIPPER_V0:Int = -3380
		Const RAIL_OUT_SPEED_VY0:Int = -1200
		Const RIGHT_FOOT_OFFSET_X:Int = 256
		Const RIGHT_WALK_COLLISION_CHECK_OFFSET_X:Int = 512
		Const RIGHT_WALK_COLLISION_CHECK_OFFSET_Y:Int = -512
		Const SIDE_COLLISION_NUM:Int = -2
		Const SIDE_FOOT_FROM_CENTER:Int = 256
		Const SMALL_JUMP_COUNT:Int = 4
		Const SONIC_DRAW_HEIGHT:Int = 1920
		Const SPIN_KEY_COUNT:Int = 20
		Const SPIN_LV2_COUNT:Int = 12
		Const SPIN_LV2_COUNT_CONF:Int = 36
		Const STAGE_PASS_STR_SPACE:Int = 182
		Const STAGE_PASS_STR_SPACE_FONT:Int = MyAPI.zoomIn(MFGraphics.stringWidth(14, "索尼克完成行行")) + 20
		Const SUPER_SONIC_CHANGING_CENTER_Y:Int = 25280
		Const SUPER_SONIC_STAND_POS_X:Int = 235136
		Const TERMINAL_COUNT:Int = 10
		Const WALK_COLLISION_CHECK_OFFSET_X:Int = 0
		Const WALK_COLLISION_CHECK_OFFSET_Y:Int = 0
		Const WHITE_BACKGROUND_ID:Int = 118
		
		' Immutable Arrays (Constant):
		Global DEGREE_DIVIDE:Int[] = [44, 75, 105, 136, 224, 255, 285, 316, 360]
		Global EFFECT_LOOP:Bool[] = [True, True]
		Global FOOT_OFFSET_X:Int[] = [LEFT_FOOT_OFFSET_X, RIGHT_FOOT_OFFSET_X]
		
		Global NUM_ANI_ID:Int[] = [27, 37, 67, 125, 37]
		Global NUM_SPACE_ANIMATION:Int[] = [8, 8, 16, 8, 8]
		Global NUM_SPACE:Int[] = NUM_SPACE_ANIMATION
		Global NUM_SPACE_FONT:Int[] = [FONT_WIDTH_NUM, FONT_WIDTH_NUM, FONT_WIDTH_NUM, FONT_WIDTH_NUM, FONT_WIDTH_NUM]
		Global NUM_SPACE_IMAGE:Int[] = [NUM_PIC_SPACE_WIDTH, NUM_PIC_SPACE_WIDTH, NUM_PIC_SPACE_WIDTH, NUM_PIC_SPACE_WIDTH, NUM_PIC_SPACE_WIDTH]
		
		Global PAUSE_MENU_NORMAL_NOSHOP:Int[] = [12, 81, 5, 6]
		Global PAUSE_MENU_NORMAL_SHOP:Int[] = [12, 81, 52, 5, 6]
		Global PAUSE_MENU_RACE_ITEM:Int[] = [12, 82, 11, 81, 5, 6]
		Global RANDOM_RING_NUM:Int[] = [1, 5, 5, 5, 5, 10, 20, 30, 40]
		
		' Global variable(s):
		Global bariaDrawer:AnimationDrawer
		Global breatheCountImage:MFImage
		
		Global characterID:Int = CHARACTER_SONIC
		
		Global clipendw:Int
		Global cliph:Int
		Global clipspeed:Int = 5
		Global clipstartw:Int
		Global clipx:Int
		Global clipy:Int
		
		Global collisionBlockGround:ACBlock = CollisionMap.getInstance().getNewCollisionBlock()
		Global collisionBlockGroundTmp:ACBlock = CollisionMap.getInstance().getNewCollisionBlock()
		Global collisionBlockSky:ACBlock = CollisionMap.getInstance().getNewCollisionBlock()
		
		Global currentPauseMenuItem:Int[]
		
		Global fadeAlpha:Int = FADE_FILL_WIDTH ' 40
		Global fadeFromValue:Int
		Global fadeRGB:Int[] = New Int[1600]
		Global fadeToValue:Int
		
		Global fastRunDrawer:AnimationDrawer
		Global gBariaDrawer:AnimationDrawer
		Global getLifeDrawer:AnimationDrawer
		Global headDrawer:AnimationDrawer
		
		Global invincibleAnimation:Animation
		Global invincibleCount:Int
		Global invincibleDrawer:AnimationDrawer
		
		Global isStartStageEndFlag:Bool = False
		
		Global itemOffsetX:Int
		
		' Not sure if this is correct.
		Global itemVec:Int[][] = [[5, 2]]
		
		Global lifeDrawerX:Int = 0
		
		Global moonStarDrawer:AnimationDrawer
		
		Global movespeedx:Int = 96
		Global movespeedy:Int = 28
		
		Global newRecordCount:Int
		
		Global numDrawer:AnimationDrawer
		
		Global offsetx:Int
		Global offsety:Int
		
		' Magic number: Not sure where these IDs are held yet.
		Global passStageActionID:Int = 0
		
		Global PAUSE_MENU_NORMAL_ITEM:Int[]
		
		Global preFadeAlpha:Int
		Global preLifeNum:Int
		Global preScoreNum:Int
		Global preTimeCount:Int = 0
		
		Global ringRandomNum:Int
		
		Global score1:Int = 49700
		Global score2:Int = 12700
		
		Global shieldType:Int
		
		Global stageEndFrameCnt:Int
		Global stagePassResultOutOffsetX:Int
		
		Global totalPlusscore:Int
		
		Global uiDrawer:AnimationDrawer
		Global uiRingImage:MFImage
		Global uiSonicHeadImage:MFImage
		
		Global waterSprayDrawer:AnimationDrawer
	Protected
		' Constant variable(s):
		Const EFFECT_NONE:Int = -1
		Const EFFECT_SAND_1:Int = 0
		Const EFFECT_SAND_2:Int = 1
		
		Const FOCUS_MOVING_DOWN:Int = 2
		Const FOCUS_MOVING_UP:Int = 1
		
		Const PLAYER_ANIMATION_PATH:String = "/animation/player"
		
		Const ROTATE_MODE_NEGATIVE:Int = 2
		Const ROTATE_MODE_NEVER_MIND:Int = 0
		Const ROTATE_MODE_POSITIVE:Int = 1
		
		Const STATE_PIPE_IN:= 0
		Const STATE_PIPE_OVER:= 2
		Const STATE_PIPING:= 1
		
		Const TER_STATE_BRAKE:= 1
		Const TER_STATE_CHANGE_1:= 4
		Const TER_STATE_CHANGE_2:= 5
		Const TER_STATE_GO_AWAY:= 6
		Const TER_STATE_LOOK_MOON:= 2
		Const TER_STATE_LOOK_MOON_WAIT:= 3
		Const TER_STATE_RUN:= 0
		Const TER_STATE_SHINING_2:= 7
		
		' Immutable Arrays (Constant):
		Global TRANS:Int[] = [0, 5, 3, 6]
		
		' Global variable(s):
		Global ringNum:Int
		Global ringTmpNum:Int
		Global speedCount:Int
		Global terminalState:Byte
		Global terminalType:Int
		Global timeStopped:Bool = False
	Public
		' Constant variable(s):
		Const CHARACTER_SONIC:Int = 0
		Const CHARACTER_TAILS:Int = 1
		Const CHARACTER_KNUCKLES:Int = 2
		Const CHARACTER_AMY:Int = 3
		
		Const WIDTH:Int = 1024
		Const HEIGHT:Int = 1536
		
		Const ANI_ATTACK_1:Int = 18
		Const ANI_ATTACK_2:Int = 19
		Const ANI_ATTACK_3:Int = 20
		Const ANI_BANK_1:Int = 32
		Const ANI_BANK_2:Int = 33
		Const ANI_BANK_3:Int = 34
		Const ANI_BAR_ROLL_1:Int = 22
		Const ANI_BAR_ROLL_2:Int = 23
		Const ANI_BRAKE:Int = 17
		Const ANI_BREATHE:Int = 49
		Const ANI_CAUGHT:Int = 52
		Const ANI_CELEBRATE_1:Int = 35
		Const ANI_CELEBRATE_2:Int = 36
		Const ANI_CELEBRATE_3:Int = 37
		Const ANI_CLIFF_1:Int = 47
		Const ANI_CLIFF_2:Int = 48
		Const ANI_DEAD:Int = 41
		Const ANI_DEAD_PRE:Int = 45
		Const ANI_FALLING:Int = 10
		Const ANI_HURT:Int = 12
		Const ANI_HURT_PRE:Int = 44
		Const ANI_JUMP:Int = 4
		Const ANI_JUMP_ROLL:Int = 15
		Const ANI_JUMP_RUSH:Int = 16
		Const ANI_LOOK_UP_1:Int = 38
		Const ANI_LOOK_UP_2:Int = 39
		Const ANI_LOOK_UP_OVER:Int = 40
		Const ANI_NONE:Int = -1
		Const ANI_POAL_PULL:Int = 13
		Const ANI_POAL_PULL_2:Int = 31
		Const ANI_POP_JUMP_DOWN_SLOW:Int = 43
		Const ANI_POP_JUMP_UP:Int = 14
		Const ANI_POP_JUMP_UP_SLOW:Int = 42
		Const ANI_PULL:Int = 24
		Const ANI_PULL_BAR_MOVE:Int = 28
		Const ANI_PULL_BAR_STAY:Int = 27
		Const ANI_PUSH_WALL:Int = 8
		Const ANI_RAIL_ROLL:Int = 21
		Const ANI_ROPE_ROLL_1:Int = 25
		Const ANI_ROPE_ROLL_2:Int = 26
		Const ANI_ROTATE_JUMP:Int = 9
		Const ANI_RUN_1:Int = 1
		Const ANI_RUN_2:Int = 2
		Const ANI_RUN_3:Int = 3
		Const ANI_SLIP:Int = 11
		Const ANI_SPIN_LV1:Int = 6
		Const ANI_SPIN_LV2:Int = 7
		Const ANI_SQUAT:Int = 5
		Const ANI_SQUAT_PROCESS:Int = 46
		Const ANI_STAND:Int = 0
		Const ANI_VS_FAKE_KNUCKLE:Int = 53
		Const ANI_WAITING_1:Int = 50
		Const ANI_WAITING_2:Int = 51
		Const ANI_WIND_JUMP:Int = 29
		Const ANI_YELL:Int = 30
		
		Const ATTACK_POP_POWER:Int = (GRAVITY + 774)
		Const BALL_HEIGHT_OFFSET:Int = 1024
		Const BANKING_MIN_SPEED:Int = 500
		Const BIG_NUM:Int = 2
		Const CAN_BE_SQUEEZE:Bool = True
		Const DETECT_HEIGHT:Int = 2048
		
		Const FALL_IN_SAND_SLIP_LEFT:Int = 2
		Const FALL_IN_SAND_SLIP_NONE:Int = 0
		Const FALL_IN_SAND_SLIP_RIGHT:Int = 1
		
		Const HUGE_POWER_SPEED:Int = 1900
		Const HURT_COUNT:Int = 48
		
		Const IN_BLOCK_CHECK:Bool = False
		
		Const ITEM_INVINCIBLE:Int = 3
		Const ITEM_LIFE:Int = 0
		Const ITEM_RING_10:Int = 7
		Const ITEM_RING_5:Int = 6
		Const ITEM_RING_RANDOM:Int = 5
		Const ITEM_SHIELD:Int = 1
		Const ITEM_SHIELD_2:Int = 2
		Const ITEM_SPEED:Int = 4
		
		Const LIFE_NUM_RESET:Int = 2
		Const MIN_ATTACK_JUMP:Int = -900
		Const NEED_RESET_DEDREE:Bool = False
		
		Const NumberSideX:Int = 81
		
		Const NUM_CENTER:Int = 0
		Const NUM_DISTANCE_BIG:Int = 72
		Const NUM_LEFT:Int = 1
		Const NUM_RIGHT:Int = 2
		
		Const PAUSE_FRAME_HEIGHT:Int =  (MENU_SPACE * 5) + 20
		Const PAUSE_FRAME_OFFSET_X:Int = ((-PAUSE_FRAME_WIDTH) / 2)
		Const PAUSE_FRAME_OFFSET_Y:Int = ((-PAUSE_FRAME_HEIGHT) / 2)
		
		Const RED_NUM:Int = 3
		Const SHOOT_POWER:Int = -1800
		
		Const SMALL_NUM:Int = 0
		Const SMALL_NUM_Y:Int = 1
		
		Const SONIC_ATTACK_LEVEL_1_V0:Int = 488
		Const SONIC_ATTACK_LEVEL_2_V0:Int = 672
		Const SONIC_ATTACK_LEVEL_3_V0:Int = 1200
		
		Const TERMINAL_NO_MOVE:Int = 1
		Const TERMINAL_RUN_TO_RIGHT:Int = 0
		Const TERMINAL_RUN_TO_RIGHT_2:Int = 2
		Const TERMINAL_SUPER_SONIC:Int = 3
		
		Const YELLOW_NUM:Int = 4
		
		Const COLLISION_STATE_IN_SAND:= 3
		Const COLLISION_STATE_JUMP:= 1
		Const COLLISION_STATE_NONE:= 4
		Const COLLISION_STATE_NUM:= 4
		Const COLLISION_STATE_ON_OBJECT:= 2
		Const COLLISION_STATE_WALK:= 0
		
		' Immutable Arrays (Constant):
		Global CHARACTER_LIST:Int[] = [CHARACTER_SONIC, CHARACTER_TAILS, CHARACTER_KNUCKLES, CHARACTER_AMY]
		
		' Global variable(s):
		Global BANK_BRAKE_SPEED_LIMIT:Int = 1100
		
		Global currentMarkId:Int
		Global cursor:Int
		Global cursorIndex:Int
		Global cursorMax:Int = 5
		Global FAKE_GRAVITY_ON_BALL:Int = 224
		Global FAKE_GRAVITY_ON_WALK:Int = NUM_DISTANCE_BIG
		Global HURT_POWER_X:Int = 384
		Global HURT_POWER_Y:Int = -992
		Global isbarOut:Bool = False
		Global isDeadLineEffect:Bool = False
		Global IsDisplayRaceModeNewRecord:Bool = False
		Global isNeedPlayWaterSE:Bool = False
		Global isOnlyBarOut:Bool = False
		Global IsStarttoCnt:Bool = False
		Global isTerminal:Bool = False
		
		Global JUMP_INWATER_START_VELOCITY:Int = (-1304 - GRAVITY)
		Global JUMP_PROTECT:Int = ((-GRAVITY) * 2)
		Global JUMP_REVERSE_POWER:Int = 32
		Global JUMP_RUSH_SPEED_PLUS:Int = 480
		Global JUMP_START_VELOCITY:Int = (-1208 - GRAVITY)
		
		Global lastTimeCount:Int
		Global lifeNum:Int = 2 ' 3 (Zero counts)
		
		Global MAX_VELOCITY:Int = 1280
		
		Global MOVE_POWER:Int = 28
		Global MOVE_POWER_IN_AIR:Int = 92
		Global MOVE_POWER_REVERSE:Int = 336
		Global MOVE_POWER_REVERSE_BALL:Int = 96
		
		Global numImage:MFImage
		Global onlyBarOutCnt:Int = 0
		Global onlyBarOutCntMax:Int = BACKGROUND_WIDTH ' 80
		Global overTime:Int
		Global PAUSE_FRAME_WIDTH:Int = (FONT_WIDTH * 7) + 4
		Global raceScoreNum:Int
		Global RingBonus:Int = 0
		Global RUN_BRAKE_SPEED_LIMIT:Int = 480
		Global scoreNum:Int
		Global slidingFrame:Int
		Global SPEED_FLOAT_DEVICE:Int = 40
		Global SPEED_LIMIT_LEVEL_1:Int = 500
		Global SPEED_LIMIT_LEVEL_2:Int = 1120
		
		Global SPIN_INWATER_START_SPEED_1:Int = 2160
		Global SPIN_INWATER_START_SPEED_2:Int = 3600
		Global SPIN_START_SPEED_1:Int = 1440
		Global SPIN_START_SPEED_2:Int = 2400
		
		Global TimeBonus:Int = 0
		Global timeCount:Int
		Global uiOffsetX:Int = 0
	Private
		' Fields:
		Field footOffsetX:Int
		
		Field effectDrawer:AnimationDrawer
		Field waterFallDrawer:AnimationDrawer
		Field waterFlushDrawer:AnimationDrawer
		
		Field checkedObject:Bool
		Field ducting:Bool
		Field enteringSP:Bool
		Field freeMoveDebug:Bool
		Field isTouchSandSlip:Bool
		Field noKeyFlag:Bool
		Field onGround:Bool
		Field onObjectContinue:Bool
		Field orgGravity:Bool
		Field pushOnce:Bool
		Field railFlipping:Bool
		Field sandStanding:Bool
		Field setNoMoving:Bool
		Field slipFlag:Bool
		Field squeezeFlag:Bool
		Field transing:Bool
		Field visible:Bool
		Field waterFalling:Bool
		Field waterSprayFlag:Bool
		Field xFirst:Bool
		
		Field aaaAttackRect:CollisionRect
		Field jumpAttackRect:CollisionRect
		
		Field attackAnimationID:Int
		Field attackCount:Int
		Field attackLevel:Int
		Field breatheNumCount:Int
		Field breatheNumY:Int
		Field collisionLayer:Int
		Field deadPosX:Int
		Field deadPosY:Int
		Field drownCnt:Int
		Field ductingCount:Int
		Field focusOffsetY:Int
		Field frame:Int
		Field frameCnt:Int
		Field justLeaveCount:Int
		Field justLeaveDegree:Int
		Field lookCount:Int
		Field moonStarFrame1:Int
		Field moonStarFrame2:Int
		Field movePower:Int
		Field movePowerInAir:Int
		Field movePowerReserseBall:Int
		Field movePowerReserseBallInSand:Int
		Field movePowerReverse:Int
		Field movePowerReverseInSand:Int
		Field nextVelX:Int
		Field nextVelY:Int
		Field noMovingPosition:Int
		Field pipeDesX:Int
		Field pipeDesY:Int
		Field preBreatheNumCount:Int
		Field preFocusX:Int
		Field preFocusY:Int
		Field preposY:Int
		Field sandFrame:Int
		Field sBlockX:Int
		Field sBlockY:Int
		Field smallJumpCount:Int
		Field spinCount:Int
		Field spinDownWaitCount:Int
		Field spinKeyCount:Int
		Field sXPosition:Int
		Field sYPosition:Int
		Field waitingCount:Int
		Field waitingLevel:Int
		Field waterSprayX:Int
		Field count:Long
	Protected
		' Fields:
		Field worldCal:ACWorldCollisionCalculator
		Field dustEffectAnimation:Animation
		Field drawer:AnimationDrawer
		Field dashRolling:Bool
		Field doJumpForwardly:Bool
		Field fading:Bool
		Field isInWater:Bool
		Field pipeState:Byte
		Field animationID:Int
		Field breatheCount:Int
		Field breatheFrame:Int
		Field checkPositionX:Int
		Field checkPositionY:Int
		Field degreeForDraw:Int
		Field degreeRotateMode:Int
		Field effectID:Int
		Field faceDegree:Int
		Field focusMovingState:Int
		Field maxVelocity:Int
		Field myAnimationID:Int
		Field railLine:Line
	Public
		' Fields:
		Field bankwalking:Bool
		Field beAttackByHari:Bool
		Field canAttackByHari:Bool
		Field changeRectHeight:Bool
		Field collisionChkBreak:Bool
		Field controlObjectLogic:Bool
		Field extraAttackFlag:Bool
		Field faceDirection:Bool
		Field finishDeadStuff:Bool
		Field footObjectLogic:Bool
		Field hurtNoControl:Bool
		Field ignoreFirstTouch:Bool
		Field isAfterSpinDash:Bool
		Field isAntiGravity:Bool
		Field isAttackBoss4:Bool
		Field isAttacking:Bool
		Field isCelebrate:Bool
		Field isCrashFallingSand:Bool
		Field isCrashPipe:Bool
		Field isDead:Bool
		Field isDirectioninSkyChange:Bool
		Field isInGravityCircle:Bool
		Field isInSnow:Bool
		Field isOnBlock:Bool
		Field isOnlyJump:Bool
		Field isPowerShoot:Bool
		Field isResetWaitAni:Bool
		Field isSharked:Bool
		Field IsStandOnItems:Bool
		Field isStopByObject:Bool
		Field isUpPipeIn:Bool
		Field justLeaveLand:Bool
		Field leavingBar:Bool
		Field leftStopped:Bool
		Field noMoving:Bool
		Field noVelMinus:Bool
		Field onBank:Bool
		Field outOfControl:Bool
		Field piping:Bool
		Field prefaceDirection:Bool
		Field railing:Bool
		Field railOut:Bool
		Field rightStopped:Bool
		Field showWaterFlush:Bool
		Field slideSoundStart:Bool
		Field slipping:Bool
		Field speedLock:Bool
		
		Field collisionState:Byte
		
		Field attractRect:CollisionRect
		Field preCollisionRect:CollisionRect
		
		Field footOnObject:GameObject
		Field outOfControlObject:GameObject
		
		Field bePushedFootX:Int
		Field degreeStable:Int
		Field fallinSandSlipState:Int
		Field fallTime:Int
		Field footPointX:Int
		Field footPointY:Int
		Field hurtCount:Int
		Field isSidePushed:Int
		Field movedSpeedX:Int
		Field movedSpeedY:Int
		Field moveLimit:Int
		Field terminalCount:Int
		Field terminalOffset:Int
		Field attackRectVec:Stack<CollisionRect>
	Public
		' Methods (Abstract):
		Method closeImpl:Void() Abstract
		
		' Functions:
		Function setNewParam:Void(newParam:Int[])
			MOVE_POWER = newParam[0]
			MOVE_POWER_IN_AIR = MOVE_POWER / 2
			MOVE_POWER_REVERSE = newParam[1]
			MAX_VELOCITY = newParam[2]
			MOVE_POWER_REVERSE_BALL = newParam[3]
			SPIN_START_SPEED_1 = newParam[4]
			SPIN_START_SPEED_2 = newParam[5]
			JUMP_START_VELOCITY = newParam[6]
			HURT_POWER_X = newParam[7]
			HURT_POWER_Y = newParam[8]
			JUMP_RUSH_SPEED_PLUS = newParam[9]
			JUMP_REVERSE_POWER = newParam[10]
			FAKE_GRAVITY_ON_WALK = newParam[11]
			FAKE_GRAVITY_ON_BALL = newParam[12]
		End
		
		Function characterSelectLogic:Bool()
			If (Key.press(Key.gSelect)) Then
				Return True
			EndIf
			
			If (Key.press(Key.gLeft)) Then
				characterID -= 1
				characterID Mod= CHARACTER_LIST.length
			ElseIf (Key.press(Key.gRight)) Then
				characterID += 1
				characterID Mod= CHARACTER_LIST.length
			EndIf
			
			Return False
		End
	
		Function setCharacter:Void(ID:Int)
			characterID = ID
		End
	
		Function getCharacterID:Int()
			Return characterID
		End
	
		Function getPlayer:PlayerObject()
			Local re:PlayerObject = Null
			
			Select (characterID)
				Case CHARACTER_SONIC
					' Magic number: 8 (Zone ID)
					' Presumably, this is a check for the Super Sonic fight:
					If (StageManager.getCurrentZoneId() <> 8) Then
						re = New PlayerSonic()
					Else
						re = New PlayerSuperSonic()
					EndIf
				Case CHARACTER_TAILS
					re = New PlayerTails()
				Case CHARACTER_KNUCKLES
					re = New PlayerKnuckles()
				Case CHARACTER_AMY
					re = New PlayerAmy()
				Default
					re = New PlayerSonic()
			End Select
			
			terminalState = TER_STATE_RUN
			terminalType = CHARACTER_SONIC
			
			Return re
		End
		
		' Methods (Implemented):
		Method setMeetingBoss:Void(state:Bool)
			Self.setNoMoving = state
			Self.noMovingPosition = Self.footPointX
			Self.worldCal.stopMoveX()
			Self.collisionChkBreak = True
		End
	
		Method changeRectUpCheck:Bool()
			Local tileHeight:= worldInstance.getTileHeight()
			
			For Local i:= (DETECT_HEIGHT / tileHeight) To 0 Step -1
				If (Self.worldInstance.getWorldY(Self.collisionRect.x0 + RIGHT_WALK_COLLISION_CHECK_OFFSET_X, Self.collisionRect.y0 - (tileHeight * i), Self.currentLayer, 0) <> ACParam.NO_COLLISION) Then
					Return True
				EndIf
			Next
			
			Return False
		End
	
		Method changeRectDownCheck:Bool()
			Local tileHeight:= worldInstance.getTileHeight()
			
			For Local i:= (DETECT_HEIGHT / tileHeight) To 0 Step -1
				If (Self.worldInstance.getWorldY(Self.collisionRect.x0 + RIGHT_WALK_COLLISION_CHECK_OFFSET_X, Self.collisionRect.y0 + (tileHeight * i), Self.currentLayer, 2) <> ACParam.NO_COLLISION) Then
					Return True
				EndIf
			Next
			
			Return False
		End
	
		Method needChangeRect:Bool()
			' Kind of bad that we're checking the animation and collision state, but whatever.
			Return ((Self.animationID = ANI_JUMP) And Self.collisionState = COLLISION_STATE_JUMP And ((Not Self.isAntiGravity And changeRectUpCheck()) Or (Self.isAntiGravity And changeRectDownCheck())))
		End
	
		Method getObjHeight:Int()
			If (needChangeRect()) Then
				Return Self.collisionRect.getHeight()
			EndIf
			
			Return HEIGHT
		End
		
		' Constructor(s):
		Method New()
			Self.degreeStable = 0
			Self.faceDegree = 0
			Self.faceDirection = True
			Self.prefaceDirection = True
			Self.extraAttackFlag = False
			Self.footPointX = 0
			Self.onGround = False
			Self.spinCount = 0
			
			Self.movePower = MOVE_POWER
			Self.movePowerInAir = MOVE_POWER_IN_AIR
			Self.movePowerReverse = MOVE_POWER_REVERSE
			Self.movePowerReserseBall = MOVE_POWER_REVERSE_BALL
			Self.movePowerReverseInSand = (MOVE_POWER_REVERSE / 2)
			Self.movePowerReserseBallInSand = (MOVE_POWER_REVERSE / 2)
			
			Self.maxVelocity = MAX_VELOCITY
			
			Self.effectID = EFFECT_NONE
			Self.collisionLayer = 0
			Self.dashRolling = False
			Self.hurtCount = 0
			Self.hurtNoControl = False
			Self.visible = True
			Self.outOfControl = False
			Self.controlObjectLogic = False
			Self.leavingBar = False
			Self.footObjectLogic = False
			Self.outOfControlObject = Null
			
			Self.attackRectVec = New Stack<CollisionRect>()
			
			Self.jumpAttackRect = New CollisionRect()
			Self.attractRect = New CollisionRect()
			Self.aaaAttackRect = New CollisionRect()
			
			Self.fallinSandSlipState = 0
			Self.isAttacking = False
			Self.canAttackByHari = False
			Self.beAttackByHari = False
			Self.setNoMoving = False
			Self.leftStopped = False
			Self.rightStopped = False
			Self.focusMovingState = 0
			Self.lookCount = LOOK_COUNT
			Self.footOffsetX = 0
			Self.justLeaveLand = False
			Self.justLeaveCount = 2
			Self.IsStandOnItems = False
			Self.degreeRotateMode = 0
			Self.slipping = False
			Self.doJumpForwardly = False
			
			Self.preCollisionRect = New CollisionRect()
			
			Self.ignoreFirstTouch = False
			Self.waterFallDrawer = Null
			Self.waterFlushDrawer = Null
			Self.railFlipping = False
			Self.isPowerShoot = False
			Self.isDead = False
			Self.isSharked = False
			Self.finishDeadStuff = False
			Self.deadPosX = 0
			Self.deadPosY = 0
			Self.noKeyFlag = False
			Self.bankwalking = False
			Self.transing = False
			Self.ducting = False
			Self.ductingCount = 0
			Self.pushOnce = False
			Self.squeezeFlag = True
			Self.orgGravity = False
			Self.footPointX = RIGHT_WALK_COLLISION_CHECK_OFFSET_X
			Self.footPointY = 0
			
			MapManager.setFocusObj(Self)
			MapManager.focusQuickLocation()
			
			Self.dustEffectAnimation = New Animation("/animation/effect_dust")
			Self.effectDrawer = Self.dustEffectAnimation.getDrawer()
			
			Self.animationID = ANI_RUN_1
			Self.collisionState = COLLISION_STATE_JUMP ' COLLISION_STATE_WALK
			Self.currentLayer = 1 ' DRAW_AFTER_SONIC
			
			If (bariaDrawer = Null) Then
				bariaDrawer = New Animation("/animation/baria").getDrawer(0, True, 0)
			EndIf
			
			If (gBariaDrawer = Null) Then
				gBariaDrawer = New Animation("/animation/g_baria").getDrawer(0, True, 0)
			EndIf
			
			If (invincibleAnimation = Null) Then
				invincibleAnimation = New Animation("/animation/muteki")
			EndIf
			
			If (invincibleDrawer = Null) Then
				invincibleDrawer = invincibleAnimation.getDrawer(0, True, 0)
			EndIf
			
			If (breatheCountImage = Null) Then
				breatheCountImage = MFImage.createImage("/animation/player/breathe_count.png")
			EndIf
			
			' Magic number: 4 (Zone ID)
			If (waterSprayDrawer = Null And StageManager.getCurrentZoneId() = 4) Then
				waterSprayDrawer = New Animation("/animation/stage6_water_spray").getDrawer()
			EndIf
			
			If (moonStarDrawer = Null And StageManager.isGoingToExtraStage()) Then
				moonStarDrawer = New Animation("/animation/moon_star").getDrawer()
			EndIf
			
			Self.width = WIDTH
			Self.height = HEIGHT
			
			Self.worldCal = New ACWorldCollisionCalculator(Self, Self)
			
			initUIResource()
		End
	Private
		' Methods:
		Method initUIResource:Void()
			' Empty implementation.
		End
	Public
		' Methods
		Method logic:Void()
			Local i:Int
			
			For Local i2:= 0 Until MAX_ITEM
				If (itemVec[i2][0] >= 0) Then
					If (itemVec[i2][1] > 0) Then
						Local iArr:= itemVec[i2]
						
						iArr[1] = iArr[1] - 1
					EndIf
					
					If (itemVec[i2][1] = 0) Then
						getItem(itemVec[i2][0])
						
						itemVec[i2][0] = -1
					EndIf
				EndIf
			Next
			
			If (Self.isAntiGravity) Then
				i = 180
			Else
				i = 0
			EndIf
			
			Self.degreeStable = i
			Self.leftStopped = False
			Self.rightStopped = False
			
			If (Self.enteringSP) Then
				If ((Self.posY Shr 6) < camera.y) Then
					GameState.enterSpStage(ringNum, currentMarkId, timeCount)
					
					Self.enteringSP = False
				EndIf
			EndIf
			
			If (Self.hurtCount > 0) Then
				Self.hurtCount -= 1
			EndIf
			
			If (invincibleCount > 0) Then
				invincibleCount -= 1
				
				If (invincibleCount = 0) Then
					i = SoundSystem.getInstance().getPlayingBGMIndex()
					SoundSystem.getInstance()
					
					If (i = ANI_HURT_PRE) Then
						SoundSystem.getInstance().stopBgm(False)
						
						If (Not isTerminal) Then
							SoundSystem.getInstance().playBgm(StageManager.getBgmId())
						EndIf
					EndIf
					
					i = SoundSystem.getInstance().getPlayingBGMIndex()
					SoundSystem.getInstance()
					
					If (i = ANI_POP_JUMP_DOWN_SLOW) Then
						SoundSystem.getInstance().playNextBgm(StageManager.getBgmId())
					EndIf
				EndIf
			EndIf
			
			' Magic number: -768
			Self.preFocusX = getNewPointX(Self.footPointX, 0, -768, Self.faceDegree) Shr 6
			Self.preFocusY = getNewPointY(Self.footPointY, 0, -768, Self.faceDegree) Shr 6
			
			If (Self.setNoMoving) Then
				If (Self.collisionState = Null) Then
					Self.footPointX = Self.noMovingPosition
					
					setVelX(0)
					setVelY(0)
					
					Self.animationID = ANI_STAND
					
					Return
				ElseIf (Self.collisionState = COLLISION_STATE_JUMP) Then
					Self.footPointX = Self.noMovingPosition
					Self.velX = 0
					setNoKey()
				EndIf
			EndIf
			
			If (Self.collisionState = Null) Then
				Self.deadPosX = Self.footPointX
				Self.deadPosY = Self.footPointY
			EndIf
			
			If (characterID = CHARACTER_TAILS) Then
				If (Not (Self.myAnimationID = ANI_HURT Or Self.myAnimationID = ANI_CLIFF_2 Or Self.myAnimationID = ANI_BREATHE)) Then
					If (soundInstance.getPlayingLoopSeIndex() = 15) Then
						soundInstance.stopLoopSe()
					EndIf
					
					resetFlyCount()
				EndIf
				
				If (Self.collisionState = Null) Then
					If (soundInstance.getPlayingLoopSeIndex() = 15) Then
						soundInstance.stopLoopSe()
					EndIf
					
					resetFlyCount()
				EndIf
			EndIf
			
			If (Self.isDead) Then
				If (Self.isInWater And Self.breatheNumCount >= 6) Then
					Self.drownCnt += 1
					
					If ((Self.drownCnt Mod 2) = 0) Then
						' Add a bubble effect to represent that the player is drowning.
						GameObject.addGameObject(New DrownBubble(ANI_DEAD, Self.footPointX, Self.footPointY - HEIGHT, 0, 0, 0, 0))
					EndIf
				EndIf
				
				Local deadOver:Bool = False
				
				If (Self.isAntiGravity) Then
					If (Self.footPointY < (MapManager.getCamera().y Shl 6) - f24C) Then
						Self.footPointY = (MapManager.getCamera().y Shl 6) - f24C
						
						deadOver = True
					EndIf
				ElseIf (Self.velY > 0 And Self.footPointY > ((MapManager.getCamera().y + MapManager.CAMERA_HEIGHT) Shl 6) + f24C) Then
					Self.footPointY = ((MapManager.getCamera().y + MapManager.CAMERA_HEIGHT) Shl 6) + f24C
					
					deadOver = True
				EndIf
				
				If (deadOver And Not Self.finishDeadStuff) Then
					If (stageModeState = 1) Then
						StageManager.setStageRestart()
					ElseIf (Not (timeCount = overTime And GlobalResource.timeIsLimit())) Then
						If (lifeNum > 0) Then
							lifeNum -= 1
							StageManager.setStageRestart()
						Else
							StageManager.setStageGameover()
						EndIf
					EndIf
					
					Self.finishDeadStuff = True
					
					Return
				EndIf
				
				Return
			EndIf
			
			Self.focusMovingState = 0
			Self.controlObjectLogic = False
			
			If (Not Self.outOfControl) Then
				Local waterLevel:= StageManager.getWaterLevel()
				
				If (waterLevel > 0) Then
					If (characterID = CHARACTER_KNUCKLES) Then
						PlayerKnuckles(player).setPreWaterFlag(Self.isInWater)
					EndIf
					
					If (Not Self.isInWater) Then
						Self.breatheCount = 0
						Self.breatheNumCount = -1
						Self.preBreatheNumCount = -1
						
						If (getNewPointY(Self.posY, 0, (-Self.collisionRect.getHeight()) / 2, Self.faceDegree) - SIDE_FOOT_FROM_CENTER >= (waterLevel Shl 6)) Then
							Self.isInWater = True
							
							If (isNeedPlayWaterSE) Then
								SoundSystem.getInstance().playSe(58)
							EndIf
							
							Self.waterSprayFlag = True
							Self.waterSprayX = Self.posX
							waterSprayDrawer.restart()
						EndIf
					ElseIf (Not IsGamePause) Then
						Self.breatheCount += 63
						Self.breatheNumCount = -1
						
						If (characterID = CHARACTER_KNUCKLES And Self.collisionState = COLLISION_STATE_NONE) Then
							If (getNewPointY(Self.posY, 0, -Self.collisionRect.getHeight(), Self.faceDegree) + SIDE_FOOT_FROM_CENTER < (waterLevel Shl 6)) Then
								Self.breatheCount = 0
								i = SoundSystem.getInstance().getPlayingBGMIndex()
								SoundSystem.getInstance()
								
								If (i = ANI_RAIL_ROLL) Then
									SoundSystem.getInstance().stopBgm(False)
									
									If (IsInvincibility()) Then
										SoundSystem.getInstance().playBgm(ANI_HURT_PRE)
									ElseIf (Self.isAttackBoss4) Then
										SoundSystem.getInstance().playBgm(ANI_BAR_ROLL_1)
									Else
										SoundSystem.getInstance().playBgm(StageManager.getBgmId())
									EndIf
								EndIf
							EndIf
						EndIf
						
						If (Self.breatheCount > BREATHE_TIME_COUNT) Then
							Self.breatheNumCount = (Self.breatheCount - BREATHE_TIME_COUNT) / BREATHE_TO_DIE_PER_COUNT
							
							If (Self.breatheCount = 0) Then
								i = SoundSystem.getInstance().getPlayingBGMIndex()
								SoundSystem.getInstance()
								
								If (i <> ANI_RAIL_ROLL) Then
									If (Self.isAttackBoss4) Then
										soundInstance.playBgm(ANI_RAIL_ROLL)
									Else
										soundInstance.playBgm(ANI_RAIL_ROLL)
									EndIf
									
									If (Self.breatheNumCount < 6 And canBeHurt()) Then
										setDie(True)
										Return
									ElseIf (Self.breatheNumCount <> Self.preBreatheNumCount) Then
										Self.breatheNumY = ((Self.posY Shr 6) - camera.y) - ANI_YELL
									EndIf
								EndIf
							EndIf
							
							i = SoundSystem.getInstance().getPlayingBGMIndex()
							SoundSystem.getInstance()
							
							If (i <> ANI_RAIL_ROLL) Then
								long startTime = (long) (((Self.breatheCount - BREATHE_TIME_COUNT) * 10000) / 10560)
								
								If (Self.isAttackBoss4) Then
									soundInstance.playBgmFromTime(startTime, ANI_RAIL_ROLL)
								Else
									soundInstance.playBgmFromTime(startTime, ANI_RAIL_ROLL)
								EndIf
							EndIf
							
							If (Self.breatheNumCount < 6) Then
								' Nothing so far.
							EndIf
							
							If (Self.breatheNumCount <> Self.preBreatheNumCount) Then
								Self.breatheNumY = ((Self.posY Shr 6) - camera.y) - ANI_YELL
							EndIf
						EndIf
						
						Self.preBreatheNumCount = Self.breatheNumCount
						Int bodyCenterY = getNewPointY(Self.posY, 0, (-Self.collisionRect.getHeight()) / 2, Self.faceDegree)
						
						If (characterID = CHARACTER_AMY) Then
							bodyCenterY = getNewPointY(Self.posY, 0, (((-Self.collisionRect.getHeight()) * 3) / 4) - TitleState.CHARACTER_RECORD_BG_OFFSET, Self.faceDegree)
						EndIf
						
						If (bodyCenterY + SIDE_FOOT_FROM_CENTER <= (waterLevel Shl 6)) Then
							Self.isInWater = False
							
							If (Self.breatheNumCount >= 0 And SoundSystem.getInstance().getPlayingBGMIndex() = ANI_RAIL_ROLL) Then
								SoundSystem.getInstance().stopBgm(False)
								
								If (IsInvincibility()) Then
									SoundSystem.getInstance().playBgm(ANI_HURT_PRE)
								ElseIf (Self.isAttackBoss4) Then
									SoundSystem.getInstance().playBgm(ANI_BAR_ROLL_1)
								Else
									SoundSystem.getInstance().playBgm(StageManager.getBgmId())
								EndIf
							EndIf
							
							If (isNeedPlayWaterSE) Then
								SoundSystem.getInstance().playSe(58)
							EndIf
							
							Self.waterSprayFlag = True
							Self.waterSprayX = Self.posX
							waterSprayDrawer.restart()
						EndIf
						
						Self.breatheFrame += 1
						Self.breatheFrame Mod= ANI_WAITING_2
						
						If (Self.breatheFrame = MyRandom.nextInt(1, ANI_PUSH_WALL) * 6) Then
							GameObject.addGameObject(New AspirateBubble(FADE_FILL_WIDTH, player.getFootPositionX() + (Self.faceDirection ? PlayerSonic.BACK_JUMP_SPEED_X : -384), player.getFootPositionY() - HEIGHT, 0, 0, 0, 0))
						EndIf
					EndIf
				EndIf
				
				If (speedCount > 0) Then
					speedCount -= 1
					Self.movePower = MOVE_POWER / 2
					Self.movePowerInAir = MOVE_POWER_IN_AIR / 2
					Self.movePowerReverse = MOVE_POWER_REVERSE / 2
					Self.movePowerReserseBall = MOVE_POWER_REVERSE_BALL / 2
					Self.maxVelocity = MAX_VELOCITY / 2
					
					If (Not (speedCount <> 0 Or SoundSystem.getInstance().getPlayingBGMIndex() = ANI_POP_JUMP_UP_SLOW Or SoundSystem.getInstance().getPlayingBGMIndex() = ANI_DEAD Or SoundSystem.getInstance().getPlayingBGMIndex() = MOON_STAR_DES_Y_1)) Then
						SoundSystem.getInstance().setSoundSpeed(1.0)
						
						If (SoundSystem.getInstance().getPlayingBGMIndex() <> ANI_POP_JUMP_DOWN_SLOW) Then
							SoundSystem.getInstance().restartBgm()
						EndIf
					EndIf
					
				Else
					Self.movePower = MOVE_POWER
					Self.movePowerInAir = MOVE_POWER_IN_AIR
					Self.movePowerReverse = MOVE_POWER_REVERSE
					Self.movePowerReserseBall = MOVE_POWER_REVERSE_BALL
					Self.maxVelocity = MAX_VELOCITY
				EndIf
				
				If (Self.isAntiGravity) Then
					If (Not Self.isDead And Self.footPointY > (MapManager.getPixelHeight() Shl 6)) Then
						Self.footPointY = (MapManager.getCamera().y + MapManager.CAMERA_HEIGHT) Shl 6
						
						If (getVelY() < 0) Then
							setVelY(0)
						EndIf
					EndIf
					
				ElseIf (Not Self.isDead And Self.footPointY > (MapManager.getPixelHeight() Shl 6)) Then
					Self.footPointY = ((MapManager.getCamera().y + MapManager.CAMERA_HEIGHT) Shl 6) + f24C
					setDie(False, -1600)
				EndIf
				
				Self.ignoreFirstTouch = False
				
				If (Self.dashRolling) Then
					dashRollingLogic()
					
					If (Self.dashRolling) Then
						collisionChk()
						Return
					EndIf
					
				ElseIf (Self.effectID = 0 Or Self.effectID = 1) Then
					Self.effectID = -1
				EndIf
				
				If (Self.railing) Then
					setNoKey()
					
					If (Self.railLine = Null) Then
						Self.velY += getGravity()
						checkWithObject(Self.footPointX, Self.footPointY, Self.footPointX + Self.velX, Self.footPointY + Self.velY)
					Else
						Int preFootPointX = Self.footPointX
						Int preFootPointY = Self.footPointY
						Int velocityChange = Self.railLine.sin(getGravity())
						
						If (Not Self.railLine.directRatio()) Then
							velocityChange = -velocityChange
						EndIf
						
						If (velocityChange <> 0) Then
							Direction direction = Self.railLine.getOneDirection()
							Self.totalVelocity += velocityChange
							checkWithObject(Self.footPointX, Self.footPointY, Self.footPointX + direction.getValueX(Self.railLine.cos(Self.totalVelocity)), Self.footPointY + direction.getValueY(Self.railLine.sin(Self.totalVelocity)))
						Else
							checkWithObject(Self.footPointX, Self.footPointY, Self.footPointX + ((Self.totalVelocity < 0 ? -1 : 1) * Self.railLine.cos(Self.totalVelocity)), Self.footPointY + ((Self.totalVelocity < 0 ? -1 : 1) * Self.railLine.sin(Self.totalVelocity)))
						EndIf
						
						If (Not (Self.railOut Or Self.railLine = Null)) Then
							Self.velX = Self.footPointX - preFootPointX
							Self.velY = Self.footPointY - preFootPointY
						EndIf
					EndIf
					
					If (Self.railOut And Self.velY = getGravity() + RAIL_OUT_SPEED_VY0) Then
						If (characterID = CHARACTER_AMY) Then
							soundInstance.playSe(ANI_ROPE_ROLL_1)
						Else
							soundInstance.playSe(ANI_SMALL_ZERO_Y)
						EndIf
					EndIf
					
					If (Self.railOut And Self.velY > 0) Then
						Self.railOut = False
						Self.railing = False
						Self.collisionState = COLLISION_STATE_JUMP
					EndIf
					
				ElseIf (Self.piping) Then
					Int preX = Self.footPointX
					Int preY = Self.footPointY
					Select (Self.pipeState)
						Case 0
							
							If (Self.footPointX < Self.pipeDesX) Then
								Self.footPointX += 250
								
								If (Self.footPointX >= Self.pipeDesX) Then
									Self.footPointX = Self.pipeDesX
								EndIf
								
							ElseIf (Self.footPointX > Self.pipeDesX) Then
								Self.footPointX -= 250
								
								If (Self.footPointX <= Self.pipeDesX) Then
									Self.footPointX = Self.pipeDesX
								EndIf
							EndIf
							
							If (Self.footPointY < Self.pipeDesY) Then
								Self.footPointY += 250
								
								If (Self.footPointY >= Self.pipeDesY) Then
									Self.footPointY = Self.pipeDesY
								EndIf
								
							ElseIf (Self.footPointY > Self.pipeDesY) Then
								Self.footPointY -= 250
								
								If (Self.footPointY <= Self.pipeDesY) Then
									Self.footPointY = Self.pipeDesY
								EndIf
							EndIf
							
							If (Self.footPointX = Self.pipeDesX And Self.footPointY = Self.pipeDesY) Then
								Self.pipeState = 1
								Self.velX = Self.nextVelX
								Self.velY = Self.nextVelY
								break
							EndIf
							
						Case 1
							Self.footPointX += Self.velX
							Self.footPointY += Self.velY
							break
						Case 2
							Self.footPointX += Self.velX
							Self.footPointY += Self.velY
							
							If (Self.velX <> 0) Then
								If (Self.velX > 0 And Self.footPointX > Self.pipeDesX) Then
									Self.footPointX = Self.pipeDesX
								ElseIf (Self.velX < 0 And Self.footPointX < Self.pipeDesX) Then
									Self.footPointX = Self.pipeDesX
								EndIf
							EndIf
							
							If (Self.velY <> 0) Then
								If (Self.velY > 0 And Self.footPointY > Self.pipeDesY) Then
									Self.footPointY = Self.pipeDesY
								ElseIf (Self.velY < 0 And Self.footPointY < Self.pipeDesY) Then
									Self.footPointY = Self.pipeDesY
								EndIf
							EndIf
							
							If ((Self.velX = 0 Or Self.footPointX = Self.pipeDesX Or Self.nextVelX <> 0) And (Self.velY = 0 Or Self.footPointY = Self.pipeDesY Or Self.nextVelY <> 0)) Then
								Self.velX = Self.nextVelX
								Self.velY = Self.nextVelY
								Self.pipeState = 1
								break
							EndIf
							
							break
					End Select
					checkWithObject(preX, preY, Self.footPointX, Self.footPointY)
					Self.animationID = 4
				Else
					bankLogic()
					
					If (Not Self.onBank) Then
						If (isTerminal) Then
							If (Self.terminalCount > 0) Then
								Self.terminalCount -= 1
							EndIf
							
							If (Self.animationID = 4) Then
								Self.totalVelocity -= MOVE_POWER_REVERSE_BALL
								
								If (Self.totalVelocity < 0) Then
									Self.totalVelocity = 0
								EndIf
								
							ElseIf (Self.totalVelocity > MAX_VELOCITY) Then
								Self.totalVelocity -= MOVE_POWER_REVERSE_BALL
								
								If (Self.totalVelocity <= MAX_VELOCITY) Then
									Self.totalVelocity = MAX_VELOCITY
								EndIf
							EndIf
							
							Self.noKeyFlag = True
						EndIf
						
						If (Self.isCelebrate) Then
							If (Self.faceDirection) Then
								If (Self.collisionState = Null) Then
									setVelX(0)
								EndIf
								
							ElseIf (Self.collisionState = Null) Then
								setVelX(0)
							EndIf
							
							Self.noKeyFlag = True
						EndIf
						
						If (StageManager.getStageID() <> ANI_SLIP) Then
							If (Not isFirstTouchedWind And Self.animationID = ANI_WIND_JUMP) Then
								soundInstance.playSe(68)
								isFirstTouchedWind = True
								Self.frameCnt = 0
							EndIf
							
							If (isFirstTouchedWind) Then
								If (Self.animationID = ANI_WIND_JUMP) Then
									Self.frameCnt += 1
									
									If (Self.frameCnt > 4 And Not IsGamePause) Then
										soundInstance.playLoopSe(69)
									EndIf
									
								Else
									
									If (soundInstance.getPlayingLoopSeIndex() = 69) Then
										soundInstance.stopLoopSe()
									EndIf
									
									isFirstTouchedWind = False
								EndIf
							EndIf
						EndIf
						
						If (StageManager.getCurrentZoneId() = MAX_ITEM) Then
							If (Not isFirstTouchedSandSlip And Self.animationID = ANI_YELL) Then
								isFirstTouchedSandSlip = True
								Self.frameCnt = 0
							EndIf
							
							If (isFirstTouchedSandSlip) Then
								If (Self.animationID = ANI_YELL And Self.collisionState = Null) Then
									Self.frameCnt += 1
									
									If (Self.frameCnt > 2 And Not IsGamePause) Then
										soundInstance.playLoopSe(71)
									EndIf
									
								Else
									
									If (soundInstance.getPlayingLoopSeIndex() = 71) Then
										soundInstance.stopLoopSe()
									EndIf
									
									isFirstTouchedSandSlip = False
								EndIf
							EndIf
						EndIf
						
						If (Self.ducting) Then
							Self.ductingCount += 1
							Self.noKeyFlag = True
							Self.animationID = 4
							Self.attackAnimationID = Self.animationID
							Self.attackCount = 0
							Self.attackLevel = 0
						EndIf
						
						If (Self.noKeyFlag) Then
							Key.setKeyFunction(False)
						EndIf
						
						If (Not (Not Self.hurtNoControl Or Self.animationID = SPIN_LV2_COUNT Or Self.animationID = ANI_HURT_PRE)) Then
							Self.hurtNoControl = False
						EndIf
						
						Select (Self.collisionState)
							Case 0
								inputLogicWalk()
								break
							Case 1
								inputLogicJump()
								
								If (Self.transing) Then
									Self.velX = 0
									Self.velY = 0
									
									If (MapManager.isCameraStop()) Then
										Self.transing = False
										break
									EndIf
								EndIf
								
								break
							Case 2
								inputLogicOnObject()
								break
							Case 3
								inputLogicSand()
								break
							Default
								extraInputLogic()
								break
						End Select
						
						If (Self.noKeyFlag) Then
							Key.setKeyFunction(True)
							Self.noKeyFlag = False
						EndIf
						
						If (Self.slipFlag) Then
							If (Self.collisionState = Null) Then
								Self.animationID = ANI_YELL
							EndIf
							
							Self.slipFlag = False
						EndIf
						
						calPreCollisionRect()
						collisionChk()
						
						If (Self.animationID = ANI_BRAKE) Then
							Effect.showEffect(Self.dustEffectAnimation, 2, Self.posX Shr 6, Self.posY Shr 6, 0)
						EndIf
						
						Select (Self.collisionState)
							Case 0
								fallChk()
								Self.degreeForDraw = Self.faceDegree
								
								If (noRotateDraw()) Then
									Self.degreeForDraw = Self.degreeStable
								EndIf
								
								If (isTerminal) Then
									MapManager.setCameraDownLimit((Self.posY Shr 6) + ANI_PULL)
								EndIf
								
								If (Not isTerminal Or Self.terminalCount <> 0 Or Self.totalVelocity < MAX_VELOCITY) Then
									Select (terminalType)
										Case 3
											terminalLogic()
											break
										Default
											break
									End Select
								EndIf
								
								Select (terminalType)
									Case 0
										
										If (Self.animationID = ANI_CELEBRATE_1) Then
											If (Self.drawer.checkEnd()) Then
												Self.animationID = SPIN_LV2_COUNT_CONF
											EndIf
										EndIf
										
										If (Not (Self.animationID = 4 Or Self.animationID = ANI_CELEBRATE_1 Or Self.animationID = SPIN_LV2_COUNT_CONF)) Then
											Self.animationID = ANI_CELEBRATE_1
											break
										EndIf
										
									Case 2
										
										If (StageManager.getCurrentZoneId() <> 6) Then
											If (Self.fading) Then
												If (fadeChangeOver()) Then
													StageManager.setStagePass()
													break
												EndIf
											EndIf
											
											setFadeColor(MapManager.END_COLOR)
											fadeInit(0, 255)
											Self.fading = True
											break
										EndIf
										
										StageManager.setStagePass()
										break
										break
									Case 3
										terminalLogic()
										break
								End Select
								
								If (Self.isCelebrate) Then
									Self.animationID = ANI_SMALL_ZERO_Y
									break
								EndIf
								
								break
							Case 1
								
								If (noRotateDraw()) Then
									Self.degreeForDraw = Self.degreeStable
								EndIf
								
								terminalLogic()
								
								If (isTerminal And Self.terminalCount = 0 And terminalType = 1) Then
									StageManager.setStagePass()
									break
								EndIf
								
							Case 2
							Case 3
								Self.degreeForDraw = Self.faceDegree
								break
							Case 4
								terminalLogic()
								break
						End Select
						
						If (Self.footPointX - RIGHT_WALK_COLLISION_CHECK_OFFSET_X < (MapManager.actualLeftCameraLimit Shl 6)) Then
							Self.footPointX = (MapManager.actualLeftCameraLimit Shl 6) + RIGHT_WALK_COLLISION_CHECK_OFFSET_X
							
							If (getVelX() < 0) Then
								setVelX(0)
							EndIf
						EndIf
						
						If (MapManager.actualRightCameraLimit <> MapManager.getPixelWidth()) Then
							If (Self.footPointX + RIGHT_WALK_COLLISION_CHECK_OFFSET_X > (MapManager.actualRightCameraLimit Shl 6)) Then
								Self.footPointX = (MapManager.actualRightCameraLimit Shl 6) - RIGHT_WALK_COLLISION_CHECK_OFFSET_X
								
								If (getVelX() > 0) Then
									setVelX(0)
								EndIf
							EndIf
						EndIf
						
						If (EnemyObject.isBossEnter) Then
							If ((Self.footPointY - HEIGHT) + WIDTH < (MapManager.actualUpCameraLimit Shl 6)) Then
								Self.footPointY = ((MapManager.actualUpCameraLimit Shl 6) + HEIGHT) - WIDTH
								
								If (getVelY() < 0) Then
									setVelY(0)
								EndIf
							EndIf
							
						Else
							
							If (Self.footPointY - HEIGHT < (MapManager.actualUpCameraLimit Shl 6)) Then
								Self.footPointY = (MapManager.actualUpCameraLimit Shl 6) + HEIGHT
								
								If (getVelY() < 0) Then
									setVelY(0)
								EndIf
							EndIf
						EndIf
						
						If (isDeadLineEffect And Not Self.isDead And Self.footPointY > (MapManager.actualDownCameraLimit Shl 6)) Then
							Self.footPointY = ((MapManager.getCamera().y + MapManager.CAMERA_HEIGHT) Shl 6) + f24C
							setDie(False, -1600)
						EndIf
						
						If (Self.leftStopped And Self.rightStopped) Then
							setDie(False)
						EndIf
					EndIf
				EndIf
				
			ElseIf (Self.outOfControlObject <> Null) Then
				Self.outOfControlObject.logic()
				Self.controlObjectLogic = True
			EndIf
		End
	
	Public Method terminalLogic:Void()
		
		If (terminalType = 3) Then
			Select (terminalState)
				Case 0
					
					If (Self.posX > SUPER_SONIC_STAND_POS_X) Then
						terminalState = 1
					EndIf
					
				Case 1
					
					If (Self.totalVelocity = 0 And Self.animationID = ANI_STAND) Then
						terminalState = TER_STATE_LOOK_MOON
						Self.terminalCount = TERMINAL_COUNT
					EndIf
					
				Case 2
					
					If (Self.terminalCount = 0) Then
						StageManager.setOnlyScoreCal()
						StageManager.setStagePass()
						terminalState = TER_STATE_LOOK_MOON_WAIT
					EndIf
					
				Case 3
					
					If (Self.terminalCount = 0 And StageManager.isScoreBarOut()) Then
						terminalState = TER_STATE_CHANGE_1
						Self.collisionState = TER_STATE_CHANGE_1
						Self.velY = Self.isInWater ? JUMP_INWATER_START_VELOCITY : JUMP_START_VELOCITY
						Self.velX = 0
						Self.worldCal.actionState = 1
						MapManager.setCameraUpLimit(MapManager.getCamera().y)
					EndIf
					
				Case 4
					Self.velY += getGravity()
					Self.collisionState = TER_STATE_CHANGE_1
					
					If (Self.posY <= SUPER_SONIC_CHANGING_CENTER_Y) Then
						Self.velY = -100
						terminalState = TER_STATE_CHANGE_2
						Self.terminalCount = 60
					EndIf
					
				Case MAX_ITEM
					Self.collisionState = TER_STATE_CHANGE_1
					
					If (Self.posY <= SUPER_SONIC_CHANGING_CENTER_Y) Then
						Self.velY += ANI_YELL
					Else
						Self.velY -= ANI_YELL
					EndIf
					
					If (Self.terminalCount = 0) Then
						Self.velY = 0
						Self.velX = 0
						MapManager.setCameraRightLimit(MapManager.getPixelWidth())
						MapManager.setFocusObj(Null)
						Self.terminalCount = ANI_YELL
						terminalState = TER_STATE_GO_AWAY
						Self.posY -= Boss4Ice.DRAW_OFFSET_Y
						Self.footPointY = Self.posY
					EndIf
					
				Case 6
					Self.collisionState = TER_STATE_CHANGE_1
					Self.terminalOffset += 1600
					
					If (Self.terminalCount = 0) Then
						Self.terminalCount = 100
						terminalState = TER_STATE_SHINING_2
					EndIf
					
				Case ITEM_RING_10
					
					If (Self.terminalCount = 0) Then
						StageManager.setStraightlyPass()
					EndIf
					
				Default
			End Select
		EndIf
	End
	
	Public Method drawCharacter:Void(g:MFGraphics)
		' Empty implementation.
	End
	
	Public Method draw2:Void(g:MFGraphics)
		Bool z = (drawAtFront() And Self.visible) ? True : False
		draw(g, z)
		drawCollisionRect(g)
		
		If (Self.waterSprayFlag And StageManager.getCurrentZoneId() = 4 And waterSprayDrawer <> Null) Then
			waterSprayDrawer.draw(g, 0, (Self.waterSprayX Shr 6) - camera.x, StageManager.getWaterLevel() - camera.y, False, 0)
			
			If (waterSprayDrawer.checkEnd()) Then
				Self.waterSprayFlag = False
				waterSprayDrawer.restart()
			EndIf
		EndIf
		
		If (Not IsGamePause) Then
			If (Self.isDead) Then
				Self.velY += (Self.isAntiGravity ? -1 : 1) * getGravity()
				Self.footPointX += Self.velX
				Self.footPointY += Self.velY
			EndIf
			
			If (Self.isInWater And Self.breatheNumCount >= 0 And Self.breatheNumCount < 6) Then
				Int i
				MFImage mFImage = breatheCountImage
				Int i2 = Self.breatheNumCount * 16
				Int i3 = (Self.posX Shr 6) - camera.x
				
				If (Self.breatheNumY > 16) Then
					i = Self.breatheNumY
				Else
					i = 16
				EndIf
				
				MyAPI.drawRegion(g, mFImage, i2, 0, 16, 16, 0, i3, i, ANI_BANK_2)
				Self.breatheNumY -= 1
			EndIf
		EndIf
		
		If (Self.fading) Then
			drawFadeBase(g, SPIN_LV2_COUNT)
		EndIf
		
		If (terminalType = 3) Then
			If (terminalState < 2 Or terminalState >= 6) Then
				Self.moonStarFrame1 = 0
			Else
				moonStarDrawer.draw(g, 0, (((MOON_STAR_DES_X_1 - MOON_STAR_ORI_X_1) * Self.moonStarFrame1) / MOON_STAR_FRAMES_1) + MOON_STAR_ORI_X_1, ((Self.moonStarFrame1 * ANI_PUSH_WALL) / MOON_STAR_FRAMES_1) + MOON_STAR_ORI_Y_1, True, 0)
				Self.moonStarFrame1 += 1
			EndIf
			
			If (terminalState = ITEM_RING_10) Then
				moonStarDrawer.draw(g, 1, (((MOON_STAR_DES_X_1 - MOON_STAR_ORI_X_1) * Self.moonStarFrame2) / MOON_STAR_FRAMES_2) + MOON_STAR_ORI_X_1, ((Self.moonStarFrame2 * ANI_PUSH_WALL) / MOON_STAR_FRAMES_2) + MOON_STAR_ORI_Y_1, True, 0)
				Self.moonStarFrame2 += 1
				Return
			EndIf
			
			Self.moonStarFrame2 = 0
		EndIf
		
	End
	
	Public Method drawAtFront:Bool()
		Return (Self.slipping Or Self.isDead) ? True : False
	End
	
	Public Method collisionChk:Void()
		
		If (Not Self.noMoving) Then
			Select (Self.collisionState)
				Case 0
					calDivideVelocity(Self.faceDegree)
					break
			End Select
			Self.posZ = Self.currentLayer
			Self.worldCal.footDegree = Self.faceDegree
			Self.posX = Self.footPointX
			Self.posY = Self.footPointY
			
			If (Self.collisionState = COLLISION_STATE_ON_OBJECT) Then
				collisionLogicOnObject()
			ElseIf (Self.isInWater) Then
				Self.worldCal.actionLogic(Self.velX / 2, Self.velY / 2, (Int) ((((Float) Self.totalVelocity) * IN_WATER_WALK_SPEED_SCALE1) / IN_WATER_WALK_SPEED_SCALE2))
			ElseIf (Self.movedSpeedX <> 0) Then
				Self.worldCal.actionLogic(Self.movedSpeedX, Self.velY)
			Else
				Self.worldCal.actionLogic(Self.velX, Self.velY, Self.totalVelocity)
			EndIf
			
			Self.footPointX = Self.posX
			Self.footPointY = Self.posY
			Self.faceDegree = Self.worldCal.footDegree
		EndIf
		
	End
	
	Public Method setFaceDegree:Void(degree:Int)
		Self.worldCal.footDegree = degree
		Self.faceDegree = degree
	End
	
	Public Method draw:Void(g:MFGraphics)
		Bool z = (drawAtFront() Or Not Self.visible) ? False : True
		draw(g, z)
	End
	
	Public Method draw:Void(g:MFGraphics, visible:Bool)
		
		If (visible) Then
			Select (Self.collisionState)
				Case 0
					
					If (noRotateDraw()) Then
						Self.degreeForDraw = Self.degreeStable
						break
					EndIf
					
					break
			End Select
			
			If (Self.isInWater) Then
				Self.drawer.setSpeed(1, 2)
			Else
				Self.drawer.setSpeed(1, 1)
			EndIf
			
			If (Self.animationID = 1) Then
				If (Self.isInSnow) Then
					Self.drawer.setSpeed(1, 2)
				Else
					Self.drawer.setSpeed(1, 1)
				EndIf
			EndIf
			
			drawCharacter(g)
			
			If (characterID = CHARACTER_AMY) Then
				If (Self.animationID = 4 And Not IsGamePause) Then
					If (Not Self.ducting) Then
						soundInstance.playLoopSe(ANI_ROPE_ROLL_1)
					ElseIf (Self.ductingCount Mod 2 = 0) Then
						soundInstance.stopLoopSe()
						soundInstance.playLoopSe(ANI_ROPE_ROLL_1)
					EndIf
				EndIf
				
				If ((Self.animationID <> 4 Or IsGamePause) And soundInstance.getPlayingLoopSeIndex() = ANI_ROPE_ROLL_1) Then
					soundInstance.stopLoopSe()
				EndIf
			EndIf
			
			If (Self.effectID > -1) Then
				Self.effectDrawer.draw(g, Self.effectID, (Self.footPointX Shr 6) - camera.x, (Self.footPointY Shr 6) - camera.y, EFFECT_LOOP[Self.effectID], getTrans())
				
				If (Self.effectDrawer.checkEnd()) Then
					Self.effectDrawer.restart()
					Self.effectID = -1
				EndIf
			EndIf
			
			waterFallDraw(g, camera)
			waterFlushDraw(g)
			
			If (Self.drawer.checkEnd()) Then
				Select (Self.animationID)
					Case ANI_ROTATE_JUMP
						
						If (Self.isInGravityCircle) Then
							Self.animationID = ANI_ROTATE_JUMP
							Self.drawer.restart()
							Return
						EndIf
						
						Self.animationID = TERMINAL_COUNT
					Case ANI_JUMP_ROLL
						Self.animationID = 16
					Case ANI_BAR_ROLL_1
						Self.animationID = ANI_BAR_ROLL_2
					Case ANI_BAR_ROLL_2
						Self.animationID = ANI_BAR_ROLL_1
					Case ANI_ROPE_ROLL_1
						Self.animationID = MOON_STAR_DES_Y_1
					Case MOON_STAR_DES_Y_1
						Self.animationID = ANI_ROPE_ROLL_1
					Case ANI_POAL_PULL_2
						Self.animationID = 1
					Case ANI_CELEBRATE_1
					Case ANI_SMALL_ZERO_Y
						StageManager.setStagePass()
					Case ANI_POP_JUMP_UP_SLOW
						Self.animationID = ANI_POP_JUMP_DOWN_SLOW
					Case ANI_POP_JUMP_DOWN_SLOW
						Self.animationID = TERMINAL_COUNT
					Case ANI_HURT_PRE
						Self.animationID = SPIN_LV2_COUNT
					Case ANI_DEAD_PRE
						Self.animationID = ANI_DEAD
					Case ANI_SQUAT_PROCESS
						
						If (Key.repeat(Key.gDown)) Then
							Self.animationID = MAX_ITEM
						Else
							Self.animationID = ANI_STAND
						EndIf
						
					Case ANI_BREATHE
						Self.animationID = 1
					Case ANI_VS_FAKE_KNUCKLE
						Self.animationID = ANI_STAND
					Default
				End Select
			EndIf
		EndIf
		
	End
	
	Public Method drawSheild1:Void(g:MFGraphics)
		
		If (Not drawAtFront()) Then
			drawSheildPrivate(g)
		EndIf
		
	End
	
	Public Method drawSheild2:Void(g:MFGraphics)
		
		If (drawAtFront()) Then
			drawSheildPrivate(g)
		EndIf
		
	End
	
	Private Method drawSheildPrivate:Void(g:MFGraphics)
		Int offset_x
		Int offset_y
		Int drawDegree = Self.faceDegree
		Int offset = (-(getCollisionRectHeight() + PlayerSonic.BACK_JUMP_SPEED_X)) / 2
		
		If (characterID = CHARACTER_KNUCKLES And Self.myAnimationID >= ANI_ATTACK_2 And Self.myAnimationID <= ANI_BAR_ROLL_1) Then
			offset = -384
		ElseIf (Self.animationID = ANI_SLIP And getAnimationOffset() = 1) Then
			drawDegree = 0
			offset = -1408
		ElseIf (Self.animationID = 4 Or Self.animationID = MAX_ITEM Or Self.animationID = ANI_SQUAT_PROCESS Or Self.animationID = 6 Or Self.animationID = ITEM_RING_10 Or Self.animationID = MOON_STAR_ORI_Y_1 Or Self.animationID = ANI_ATTACK_2 Or Self.animationID = SPIN_KEY_COUNT) Then
			offset = -640
		ElseIf (Self.animationID = ANI_ROPE_ROLL_1 Or Self.animationID = MOON_STAR_DES_Y_1) Then
			offset = 0
		EndIf
		
		If (characterID = CHARACTER_SONIC And Self.myAnimationID = ANI_ROPE_ROLL_1) Then
			offset_x = Def.TOUCH_HELP_LEFT_X
			offset_y = 0
		ElseIf (characterID = CHARACTER_AMY And Self.myAnimationID = ANI_LOOK_UP_1) Then
			offset_x = Def.TOUCH_HELP_LEFT_X
			offset_y = TitleState.CHARACTER_RECORD_BG_OFFSET
		ElseIf (characterID = CHARACTER_AMY And Self.myAnimationID = ANI_SMALL_ZERO_Y) Then
			offset_x = Def.TOUCH_HELP_LEFT_X
			offset_y = SIDE_FOOT_FROM_CENTER
		ElseIf (characterID <> 2 Or Self.myAnimationID < ANI_WIND_JUMP Or Self.myAnimationID > LOOK_COUNT) Then
			offset_x = 0
			offset_y = 0
		ElseIf (player.isAntiGravity) Then
			If (Self.faceDirection) Then
				offset_x = SIDE_FOOT_FROM_CENTER
				offset_y = LEFT_FOOT_OFFSET_X
			Else
				offset_x = LEFT_FOOT_OFFSET_X
				offset_y = LEFT_FOOT_OFFSET_X
			EndIf
			
		ElseIf (Self.faceDirection) Then
			offset_x = LEFT_FOOT_OFFSET_X
			offset_y = SIDE_FOOT_FROM_CENTER
		Else
			offset_x = SIDE_FOOT_FROM_CENTER
			offset_y = SIDE_FOOT_FROM_CENTER
		EndIf
		
		Int bodyCenterX = getNewPointX(Self.footPointX, 0, offset, drawDegree)
		Int bodyCenterY = getNewPointY(Self.footPointY, 0, offset, drawDegree)
		
		If (invincibleCount > 0) Then
			If (invincibleDrawer <> Null) Then
				drawInMap(g, invincibleDrawer, bodyCenterX + offset_x, bodyCenterY + offset_y)
			EndIf
			
			If (systemClock Mod 2 = 0) Then
				Effect.showEffect(invincibleAnimation, 1, (bodyCenterX Shr 6) + MyRandom.nextInt(-3, 3), (bodyCenterY Shr 6) + MyRandom.nextInt(-3, 3), 0)
			EndIf
			
		ElseIf (shieldType <= 0) Then
		Else
			
			If (shieldType = 1) Then
				drawInMap(g, bariaDrawer, bodyCenterX + offset_x, bodyCenterY + offset_y)
			ElseIf (isAttracting()) Then
				drawInMap(g, gBariaDrawer, bodyCenterX + offset_x, bodyCenterY + offset_y)
			EndIf
		EndIf
		
	End
	
	Protected Method getAnimationOffset:Int()
		Return getAnimationOffset(Self.faceDegree)
	End
	
	Protected Method getAnimationOffset:Int(degree:Int)
		For (Int resault = 0; resault < DEGREE_DIVIDE.length; resault += 1)
			
			If (degree < DEGREE_DIVIDE[resault]) Then
				Return resault Mod 2
			EndIf
			
		Next
		Return 0
	End
	
	Protected Method getTransId:Int(degree:Int)
		Int resault = 0
		While (resault < DEGREE_DIVIDE.length) {
			
			If (degree < DEGREE_DIVIDE[resault]) Then
				resault Mod= ANI_PUSH_WALL
				break
			EndIf
			
			resault += 1
		End
		Return ((resault + 1) / 2) Mod 4
	End
	
	Protected Method getTrans:Int(degree:Int)
		Int re = TRANS[getTransId(degree)]
		Int offset = getAnimationOffset(degree)
		
		If (Self.faceDirection) Then
			Return re
		EndIf
		
		If (offset <> 0) Then
			Select (re)
				Case 0
					re = 4
					break
				Case 3
					re = ITEM_RING_10
					break
				Case MAX_ITEM
					re = 2
					break
				Case 6
					re = 1
					break
				Default
					break
			End Select
		EndIf
		
		Select (re)
			Case 0
			Case 3
			Case MAX_ITEM
			Case 6
				re ^= 2
				break
		End Select
		Return re
	End
	
	Protected Method getTrans:Int()
		Return getTrans(Self.faceDegree)
	End
	
	Public Method getFocusX:Int()
		Return getNewPointX(Self.footPointX, 0, -768, Self.faceDegree) Shr 6
	End
	
	Public Method getFocusY:Int()
		
		If (FOCUS_MAX_OFFSET > TERMINAL_COUNT) Then
			If (Self.focusMovingState = 0) Then
				Self.lookCount = LOOK_COUNT
			EndIf
			
			If (Self.lookCount = 0) Then
				Select (Self.focusMovingState)
					Case 1
						
						If (Self.focusOffsetY < FOCUS_MAX_OFFSET) Then
							Self.focusOffsetY += FOCUS_MOVE_SPEED
							
							If (Self.focusOffsetY > FOCUS_MAX_OFFSET) Then
								Self.focusOffsetY = FOCUS_MAX_OFFSET
								break
							EndIf
						EndIf
						
						break
					Case 2
						
						If (Self.focusOffsetY > (-FOCUS_MAX_OFFSET)) Then
							Self.focusOffsetY -= FOCUS_MOVE_SPEED
							
							If (Self.focusOffsetY < (-FOCUS_MAX_OFFSET)) Then
								Self.focusOffsetY = -FOCUS_MAX_OFFSET
								break
							EndIf
						EndIf
						
						break
				End Select
			EndIf
			
			Self.lookCount -= 1
			
			If (Self.focusOffsetY > 0) Then
				Self.focusOffsetY -= FOCUS_MOVE_SPEED
				
				If (Self.focusOffsetY < 0) Then
					Self.focusOffsetY = 0
				EndIf
			EndIf
			
			If (Self.focusOffsetY < 0) Then
				Self.focusOffsetY += FOCUS_MOVE_SPEED
				
				If (Self.focusOffsetY > 0) Then
					Self.focusOffsetY = 0
				EndIf
			EndIf
		EndIf
		
		Return (getNewPointY(Self.footPointY, 0, -768, Self.faceDegree) Shr 6) + ((Self.isAntiGravity ? 1 : -1) * Self.focusOffsetY)
	End
	
	Public Method collisionLogicOnObject:Void()
		Self.onObjectContinue = False
		Self.checkedObject = False
		Self.footObjectLogic = False
		Self.worldCal.actionState = 1
		
		If (Self.isInWater) Then
			Self.worldCal.actionLogic(Self.velX / 2, Self.velY)
		Else
			Self.worldCal.actionLogic(Self.velX, Self.velY)
		EndIf
		
		If (Self.worldCal.actionState = Null) Then
			Self.onObjectContinue = False
		ElseIf (Not (Self.checkedObject Or Self.footOnObject = Null Or Not Self.footOnObject.onObjectChk(Self))) Then
			Self.footOnObject.doWhileCollisionWrap(Self)
			Self.onObjectContinue = True
		EndIf
		
		If (Not Self.onObjectContinue) Then
			Self.footOnObject = Null
			calTotalVelocity()
			
			If (Self.collisionState = TER_STATE_LOOK_MOON) Then
				Self.collisionState = COLLISION_STATE_JUMP
				Self.worldCal.actionState = 1
			EndIf
			
		ElseIf (Self.collisionState = TER_STATE_LOOK_MOON And Not Self.piping) Then
			Self.velY = 0
		EndIf
		
	End
	
	Public Method calDivideVelocity:Void()
		calDivideVelocity(Self.faceDegree)
	End
	
	Public Method calDivideVelocity:Void(degree:Int)
		Self.velX = (Self.totalVelocity * Cos(degree)) / 100
		Self.velY = (Self.totalVelocity * Sin(degree)) / 100
	End
	
	Public Method calTotalVelocity:Void()
		calTotalVelocity(Self.faceDegree)
	End
	
	Public Method calTotalVelocity:Void(degree:Int)
		Self.totalVelocity = ((Self.velX * Cos(degree)) + (Self.velY * Sin(degree))) / 100
	End
	
	Protected Method getNewPointX:Int(oriX:Int, xOffset:Int, yOffset:Int, degree:Int)
		Return (((Cos(degree) * xOffset) / 100) + oriX) - ((Sin(degree) * yOffset) / 100)
	End
	
	Protected Method getNewPointY:Int(oriY:Int, xOffset:Int, yOffset:Int, degree:Int)
		Return (((Sin(degree) * xOffset) / 100) + oriY) + ((Cos(degree) * yOffset) / 100)
	End
	
	Private Method faceDirectionChk:Bool()
		
		If (Self.totalVelocity > 0) Then
			Return True
		EndIf
		
		If (Self.totalVelocity < 0) Then
			Return False
		EndIf
		
		If (Key.press(Key.gLeft) Or Key.repeat(Key.gLeft)) Then
			Return False
		EndIf
		
		If (Key.press(Key.gRight) Or Key.repeat(Key.gRight)) Then
			Return True
		EndIf
		
		Return True
	End
	
	Private Method faceSlopeChk:Void()
		Int slopeVelocity = (Sin(Self.faceDegree) * (getGravity() * (Self.isAntiGravity ? -1 : 1))) / 100
	End
	
	Private Method decelerate:Void()
		Int preTotalVelocity = Self.totalVelocity
		Int resistance = getRetPower()
		
		If (Self.totalVelocity > 0) Then
			Self.totalVelocity -= resistance
			
			If (Self.totalVelocity < 0) Then
				Self.totalVelocity = 0
			EndIf
			
		ElseIf (Self.totalVelocity < 0) Then
			Self.totalVelocity += resistance
			
			If (Self.totalVelocity > 0) Then
				Self.totalVelocity = 0
			EndIf
		EndIf
		
		If (Self.totalVelocity * preTotalVelocity <= 0 And Self.animationID = 4) Then
			Self.animationID = ANI_STAND
		EndIf
		
	End
	
	Private Method inputLogicWalk:Void()
		Int preTotalVelocity
		Self.leavingBar = False
		Self.doJumpForwardly = False
		Self.degreeRotateMode = 0
		
		If (Self.slipFlag Or Self.totalVelocity <> 0) Then
			Int fakeGravity = getSlopeGravity() * (Self.isAntiGravity ? -1 : 1)
			
			If (Self.slipFlag) Then
				fakeGravity *= 3
			EndIf
			
			Int velChange = (Sin(Self.faceDegree) * fakeGravity) / 100
			preTotalVelocity = Self.totalVelocity
			
			If (Self.slipFlag And Abs(velChange) < 100) Then
				velChange = velChange < 0 ? -100 : 100
			EndIf
			
			If (Self.animationID = 4) Then
				If (Self.totalVelocity >= 0) Then
					If (velChange < 0) Then
						velChange Shr= 2
					EndIf
					
				ElseIf (velChange > 0) Then
					velChange Shr= 2
				EndIf
			EndIf
			
			Self.totalVelocity += velChange
			
			If (Self.totalVelocity * preTotalVelocity <= 0 And Self.animationID = 4) Then
				Self.animationID = ANI_STAND
				Self.faceDirection = preTotalVelocity > 0 ? True : False
			EndIf
		EndIf
		
		If (Not (Self.attackLevel <> 0 Or Key.repeat(Key.gDown) Or Self.animationID = -1 Or Self.animationID = ANI_YELL)) Then
			Int reversePower
			
			If ((Not Self.isAntiGravity And Key.repeat(Key.gLeft)) Or ((Self.isAntiGravity And Key.repeat(Key.gRight)) Or doBrake())) Then
				If (Self.animationID = MAX_ITEM) Then
					Self.animationID = ANI_STAND
				EndIf
				
				If (Not ((Self.animationID = 4 And Self.collisionState = Null) Or doBrake())) Then
					Self.faceDirection = False
				EndIf
				
				If (Self.fallTime = 0) Then
					If (Self.totalVelocity > 0 Or doBrake()) Then
						If (Self.animationID = 4) Then
							reversePower = Self.movePowerReserseBall
						Else
							reversePower = Self.movePowerReverse
						EndIf
						
						Self.totalVelocity -= reversePower
						
						If (Self.totalVelocity < 0) Then
							If (Self.onBank) Then
								Self.totalVelocity = 0
								Self.onBank = False
								Self.bankwalking = False
							Else
								Self.totalVelocity = (0 - reversePower) Shr 2
							EndIf
						EndIf
						
						If (Not (Abs(Self.totalVelocity) <= BANK_BRAKE_SPEED_LIMIT Or Self.animationID = 4 Or Self.animationID = ANI_BRAKE)) Then
							soundInstance.playSe(TERMINAL_COUNT)
							
							If (Self.onBank) Then
								Self.onBank = False
								Self.bankwalking = False
							EndIf
						EndIf
						
					ElseIf (Self.animationID <> 4) Then
						Self.totalVelocity -= Self.movePower
						
						If (Self.totalVelocity < (-Self.maxVelocity)) Then
							Self.totalVelocity += Self.movePower
							
							If (Self.totalVelocity > (-Self.maxVelocity)) Then
								Self.totalVelocity = -Self.maxVelocity
							EndIf
						EndIf
					EndIf
				EndIf
				
			ElseIf ((Not Self.isAntiGravity And Key.repeat(Key.gRight)) Or ((Self.isAntiGravity And Key.repeat(Key.gLeft)) Or isTerminalRunRight())) Then
				If (Self.animationID = MAX_ITEM) Then
					Self.animationID = ANI_STAND
				EndIf
				
				If (Not (Self.animationID = 4 And Self.collisionState = Null)) Then
					Self.faceDirection = True
				EndIf
				
				If (Self.fallTime = 0) Then
					If (Self.totalVelocity < 0 Or doBrake()) Then
						If (Self.animationID = 4) Then
							reversePower = Self.movePowerReserseBall
						Else
							reversePower = Self.movePowerReverse
						EndIf
						
						Self.totalVelocity += reversePower
						
						If (Self.totalVelocity > -1) Then
							If (Self.onBank) Then
								Self.totalVelocity = 0
								Self.onBank = False
								Self.bankwalking = False
							Else
								Self.totalVelocity = reversePower Shr 2
							EndIf
						EndIf
						
						If (Not (Abs(Self.totalVelocity) <= BANK_BRAKE_SPEED_LIMIT Or Self.animationID = 4 Or Self.animationID = ANI_BRAKE)) Then
							soundInstance.playSe(TERMINAL_COUNT)
							
							If (Self.onBank) Then
								Self.onBank = False
								Self.bankwalking = False
							EndIf
						EndIf
						
					ElseIf (Self.animationID <> 4) Then
						Self.totalVelocity += Self.movePower
						
						If (Self.totalVelocity > Self.maxVelocity) Then
							Self.totalVelocity -= Self.movePower
							
							If (Self.totalVelocity < Self.maxVelocity) Then
								Self.totalVelocity = Self.maxVelocity
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
		
		If (Self.animationID <> -1) Then
			If (Abs(Self.totalVelocity) <= 0) Then
				If (Not (Self.animationID = ANI_LOOK_UP_1 Or Self.animationID = ANI_LOOK_UP_2 Or Self.animationID = FADE_FILL_WIDTH Or Self.animationID = MAX_ITEM Or Self.collisionState = COLLISION_STATE_JUMP)) Then
					Self.animationID = ANI_STAND
					Self.bankwalking = False
					checkCliffAnimation()
				EndIf
				
			ElseIf (Not (Self.animationID = 4 Or Self.animationID = ANI_CELEBRATE_1 Or Self.animationID = SPIN_LV2_COUNT_CONF Or Self.animationID = MAX_ITEM Or Self.animationID = ANI_POAL_PULL_2)) Then
				If (Abs(Self.totalVelocity) < SPEED_LIMIT_LEVEL_1) Then
					Self.animationID = 1
				ElseIf (Abs(Self.totalVelocity) < SPEED_LIMIT_LEVEL_2) Then
					Self.animationID = 2
				ElseIf (Not Self.slipping) Then
					Self.animationID = 3
				EndIf
			EndIf
		EndIf
		
		waitingChk()
		Int slopeVelocity = (Sin(Self.faceDegree) * (getGravity() * (Self.isAntiGravity ? -1 : 1))) / 100
		faceSlopeChk()
		
		If (Self.animationID <> -1 And Self.attackLevel = 0 And Self.animationID <> 4 And Abs(Self.totalVelocity) > Abs(slopeVelocity) And Self.fallTime = 0) Then
			If (Not (Key.repeat(Key.gLeft) And Key.repeat(Key.gRight)) And ((((Not Self.isAntiGravity And Key.repeat(Key.gLeft)) Or (Self.isAntiGravity And Key.repeat(Key.gRight))) And Self.totalVelocity > RUN_BRAKE_SPEED_LIMIT) Or (((Not Self.isAntiGravity And Key.repeat(Key.gRight)) Or (Self.isAntiGravity And Key.repeat(Key.gLeft))) And Self.totalVelocity < (-RUN_BRAKE_SPEED_LIMIT)))) Then
				Bool z
				Self.animationID = ANI_BRAKE
				soundInstance.playSe(TERMINAL_COUNT)
				
				If (Self.totalVelocity > 0) Then
					z = True
				Else
					z = False
				EndIf
				
				Self.faceDirection = z
			ElseIf (Self.totalVelocity <> 0 And doBrake()) Then
				Self.animationID = ANI_BRAKE
				soundInstance.playSe(TERMINAL_COUNT)
				Self.faceDirection = Self.totalVelocity > 0 ? True : False
			EndIf
		EndIf
		
		If (Self.ducting And Abs(Self.totalVelocity) < MDPhone.SCREEN_HEIGHT) Then
			If (Self.totalVelocity > 0 And Self.pushOnce) Then
				Self.totalVelocity += MDPhone.SCREEN_HEIGHT
				Self.pushOnce = False
			EndIf
			
			If (Self.totalVelocity < 0 And Self.pushOnce) Then
				Self.totalVelocity -= 640
				Self.pushOnce = False
			EndIf
		EndIf
		
		If (Not spinLogic()) Then
			If (canDoJump() And Key.press(Key.gUp | Key.B_HIGH_JUMP)) Then
				If ((characterID <> 3 Or PlayerAmy.isCanJump) And Not (characterID = CHARACTER_AMY And (getCharacterAnimationID() = MOON_STAR_ORI_Y_1 Or getCharacterAnimationID() = ANI_ATTACK_2))) Then
					doJump()
				EndIf
				
			ElseIf (Key.repeat(Key.gUp | Key.B_LOOK)) Then
				If (Self.animationID = ANI_LOOK_UP_1 And Self.drawer.checkEnd()) Then
					Self.animationID = ANI_LOOK_UP_2
				EndIf
				
				If (Not (Self.animationID = ANI_LOOK_UP_1 Or Self.animationID = ANI_LOOK_UP_2 Or (Self.animationID <> 0 And Self.animationID <> ANI_WAITING_1 And Self.animationID <> ANI_WAITING_2))) Then
					Self.animationID = ANI_LOOK_UP_1
				EndIf
				
				If (Self.animationID = ANI_LOOK_UP_2) Then
					Self.focusMovingState = 1
				EndIf
				
			Else
				
				If (Self.animationID = FADE_FILL_WIDTH And Self.drawer.checkEnd()) Then
					Self.animationID = ANI_STAND
				EndIf
				
				If (Self.animationID = ANI_LOOK_UP_1 Or Self.animationID = ANI_LOOK_UP_2) Then
					Self.animationID = FADE_FILL_WIDTH
				EndIf
			EndIf
		EndIf
		
		extraLogicWalk()
		Int newPointX
		
		If (((Not Self.isAntiGravity And Self.faceDegree >= 90 And Self.faceDegree <= 270) Or (Self.isAntiGravity And (Self.faceDegree <= 90 Or Self.faceDegree >= 270))) And ((Abs((FAKE_GRAVITY_ON_WALK * Cos(Self.faceDegree)) / 100) >= (Self.totalVelocity * Self.totalVelocity) / 4864 And Not Self.ducting) Or Self.animationID = ANI_BRAKE)) Then
			calDivideVelocity()
			Int bodyCenterX = getNewPointX(Self.posX, 0, (-Self.collisionRect.getHeight()) / 2, Self.faceDegree)
			Int bodyCenterY = getNewPointY(Self.posY, 0, (-Self.collisionRect.getHeight()) / 2, Self.faceDegree)
			newPointX = getNewPointX(bodyCenterX, 0, Self.collisionRect.getHeight() / 2, Self.faceDegree)
			Self.footPointX = newPointX
			Self.posX = newPointX
			newPointX = getNewPointY(bodyCenterY, 0, Self.collisionRect.getHeight() / 2, Self.faceDegree)
			Self.footPointY = newPointX
			Self.posY = newPointX
			Self.collisionState = COLLISION_STATE_JUMP
			Self.worldCal.actionState = 1
		ElseIf (Not Self.ducting) Then
			If (needRetPower() And Self.collisionState = Null) Then
				preTotalVelocity = Self.totalVelocity
				Int resistance = getRetPower()
				
				If (Self.totalVelocity > 0) Then
					Self.totalVelocity -= resistance
					
					If (Self.totalVelocity < 0) Then
						Self.totalVelocity = 0
					EndIf
					
				ElseIf (Self.totalVelocity < 0) Then
					Self.totalVelocity += resistance
					
					If (Self.totalVelocity > 0) Then
						Self.totalVelocity = 0
					EndIf
				EndIf
				
				If (Self.totalVelocity * preTotalVelocity <= 0 And Self.animationID = 4) Then
					Self.animationID = ANI_STAND
					Self.faceDirection = preTotalVelocity > 0 ? True : False
				EndIf
			EndIf
			
			Print(BPDef.gameID)
			
			If (Self.collisionState = COLLISION_STATE_JUMP) Then
				Int i
				newPointX = Self.velY
				
				If (Self.isAntiGravity) Then
					i = -1
				Else
					i = 1
				EndIf
				
				Self.velY = newPointX + (i * getGravity())
			EndIf
		EndIf
		
	End
	
	Private Method inputLogicOnObject:Void()
		Int i
		Self.leavingBar = False
		Self.doJumpForwardly = False
		Self.degreeRotateMode = 0
		Int tmpPower = Self.movePower
		Int tmpMaxVel = Self.maxVelocity
		
		If (Self.animationID <> MAX_ITEM) Then
			Int reversePower
			
			If (((Key.repeat(Key.gLeft) And (Self.animationID = ANI_STAND Or Self.animationID = ANI_CLIFF_1 Or Self.animationID = HURT_COUNT Or Self.animationID = 1 Or Self.animationID = 2 Or Self.animationID = 3)) Or (Self.isCelebrate And Not Self.faceDirection)) And Not isOnSlip0()) Then
				If (Self.animationID = MAX_ITEM) Then
					Self.animationID = ANI_STAND
				EndIf
				
				Self.faceDirection = Self.isAntiGravity ? True : False
				
				If (Self.velX > 0) Then
					If (Self.animationID = 4) Then
						reversePower = Self.movePowerReserseBall
					Else
						reversePower = Self.movePowerReverse
					EndIf
					
					Self.velX -= reversePower
					
					If (Self.velX < 0) Then
						Self.velX = (0 - reversePower) Shr 2
					Else
						Self.faceDirection = True
					EndIf
					
				ElseIf (Self.animationID <> 4) Then
					Self.velX -= tmpPower
					
					If (Self.velX < (-tmpMaxVel)) Then
						Self.velX += tmpPower
						
						If (Self.velX > (-tmpMaxVel)) Then
							Self.velX = -tmpMaxVel
						EndIf
					EndIf
				EndIf
				
			ElseIf ((Key.repeat(Key.gRight) And (Self.animationID = ANI_STAND Or Self.animationID = ANI_CLIFF_1 Or Self.animationID = HURT_COUNT Or Self.animationID = 1 Or Self.animationID = 2 Or Self.animationID = 3)) Or (Self.isCelebrate And Self.faceDirection)) Then
				If (Self.animationID = MAX_ITEM) Then
					Self.animationID = ANI_STAND
				EndIf
				
				Self.faceDirection = Self.isAntiGravity ? False : True
				
				If (Self.velX < 0) Then
					If (Self.animationID = 4) Then
						reversePower = Self.movePowerReserseBall
					Else
						reversePower = Self.movePowerReverse
					EndIf
					
					Self.velX += reversePower
					
					If (Self.velX > -1) Then
						Self.velX = reversePower Shr 2
					Else
						Self.faceDirection = False
					EndIf
					
				ElseIf (Self.animationID <> 4) Then
					Self.velX += tmpPower
					
					If (Self.velX > tmpMaxVel) Then
						Self.velX -= tmpPower
						
						If (Self.velX < tmpMaxVel) Then
							Self.velX = tmpMaxVel
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
		
		If (Self.animationID <> -1) Then
			If (Abs(Self.velX) <= 0) Then
				If (Not (Self.animationID = ANI_LOOK_UP_1 Or Self.animationID = ANI_LOOK_UP_2 Or Self.animationID = FADE_FILL_WIDTH Or Self.animationID = MAX_ITEM)) Then
					Self.animationID = ANI_STAND
					checkCliffAnimation()
				EndIf
				
			ElseIf (Self.animationID <> 4) Then
				If (Abs(Self.velX) < SPEED_LIMIT_LEVEL_1) Then
					Self.animationID = 1
				ElseIf (Abs(Self.velX) < SPEED_LIMIT_LEVEL_2) Then
					Self.animationID = 2
				Else
					Self.animationID = 3
				EndIf
			EndIf
		EndIf
		
		extraLogicOnObject()
		Self.attackAnimationID = Self.animationID
		
		If (Not spinLogic()) Then
			If (canDoJump() And Not Self.dashRolling And Key.press(Key.gUp | Key.B_HIGH_JUMP)) Then
				If (characterID <> 3 Or PlayerAmy.isCanJump) Then
					doJump()
				EndIf
				
			ElseIf (Key.repeat(Key.gUp | Key.B_LOOK)) Then
				If (Self.animationID = ANI_LOOK_UP_1 And Self.drawer.checkEnd()) Then
					Self.animationID = ANI_LOOK_UP_2
				EndIf
				
				If (Not (Self.animationID = ANI_LOOK_UP_1 Or Self.animationID = ANI_LOOK_UP_2 Or Self.animationID <> 0)) Then
					Self.animationID = ANI_LOOK_UP_1
				EndIf
				
				If (Self.animationID = ANI_LOOK_UP_2) Then
					Self.focusMovingState = 1
				EndIf
				
			Else
				
				If (Self.animationID = FADE_FILL_WIDTH And Self.drawer.checkEnd()) Then
					Self.animationID = ANI_STAND
				EndIf
				
				If (Self.animationID = ANI_LOOK_UP_1 Or Self.animationID = ANI_LOOK_UP_2) Then
					Self.animationID = FADE_FILL_WIDTH
				EndIf
			EndIf
		EndIf
		
		If (needRetPower() And Self.collisionState = COLLISION_STATE_ON_OBJECT) Then
			Int resistance = getRetPower()
			
			If (Self.velX > 0) Then
				Self.velX -= resistance
				
				If (Self.velX < 0) Then
					Self.velX = 0
				EndIf
				
			ElseIf (Self.velX < 0) Then
				Self.velX += resistance
				
				If (Self.velX > 0) Then
					Self.velX = 0
				EndIf
			EndIf
		EndIf
		
		Int i2 = Self.velY
		
		If (Self.isAntiGravity) Then
			i = -1
		Else
			i = 1
		EndIf
		
		Self.velY = i2 + (i * getGravity())
		waitingChk()
	End
	
	Private Method inputLogicJump:Void()
		Int newPointX
		Int i
		
		If (Self.faceDegree <> Self.degreeStable) Then
			Int bodyCenterX = getNewPointX(Self.posX, 0, (-Self.collisionRect.getHeight()) / 2, Self.faceDegree)
			Int bodyCenterY = getNewPointY(Self.posY, 0, (-Self.collisionRect.getHeight()) / 2, Self.faceDegree)
			Self.faceDegree = Self.degreeStable
			newPointX = getNewPointX(bodyCenterX, 0, Self.collisionRect.getHeight() / 2, Self.faceDegree)
			Self.footPointX = newPointX
			Self.posX = newPointX
			newPointX = getNewPointY(bodyCenterY, 0, Self.collisionRect.getHeight() / 2, Self.faceDegree)
			Self.footPointY = newPointX
			Self.posY = newPointX
		EndIf
		
		If (Self.degreeForDraw <> Self.faceDegree) Then
			Int degreeDiff = Self.faceDegree - Self.degreeForDraw
			Int degreeDes = Self.faceDegree
			Select (Self.degreeRotateMode)
				Case 0
					
					If (Abs(degreeDiff) > 180) Then
						If (degreeDes > Self.degreeForDraw) Then
							degreeDes -= 360
						Else
							degreeDes += MDPhone.SCREEN_WIDTH
						EndIf
					EndIf
					
					Self.degreeForDraw = MyAPI.calNextPosition((double) Self.degreeForDraw, (double) degreeDes, 1, 3)
					break
				Case 1
					Self.degreeForDraw += ANI_PULL
					break
				Case 2
					Self.degreeForDraw -= ANI_PULL
					break
			End Select
			While (Self.degreeForDraw < 0)
				Self.degreeForDraw += MDPhone.SCREEN_WIDTH
			End
			Self.degreeForDraw Mod= MDPhone.SCREEN_WIDTH
		EndIf
		
		If (Self.animationID = ANI_PUSH_WALL) Then
			doWalkPoseInAir()
		EndIf
		
		If (Not (Self.hurtNoControl Or Self.animationID = ANI_YELL Or (characterID = CHARACTER_AMY And Self.myAnimationID >= MAX_ITEM And Self.myAnimationID <= ITEM_RING_10))) Then
			If ((Key.repeat(Key.gLeft) Or (Self.isCelebrate And Not Self.faceDirection)) And Not Self.ducting) Then
				If (Self.velX > (-Self.maxVelocity)) Then
					Self.velX -= Self.movePowerInAir
					
					If (Self.velX < (-Self.maxVelocity)) Then
						Self.velX = -Self.maxVelocity
					EndIf
				EndIf
				
				If (Self.degreeRotateMode = 0) Then
					Bool z
					
					If (Self.isAntiGravity) Then
						z = True
					Else
						z = False
					EndIf
					
					Self.faceDirection = z
				EndIf
				
			ElseIf ((Key.repeat(Key.gRight) Or isTerminal Or (Self.isCelebrate And Self.faceDirection)) And Not Self.ducting) Then
				If (Self.velX < Self.maxVelocity) Then
					Self.velX += Self.movePowerInAir
					
					If (Self.velX > Self.maxVelocity) Then
						Self.velX = Self.maxVelocity
					EndIf
				EndIf
				
				If (Self.degreeRotateMode = 0) Then
					Self.faceDirection = Self.isAntiGravity ? False : True
				EndIf
			EndIf
		EndIf
		
		If (Not Self.isOnlyJump) Then
			extraLogicJump()
		EndIf
		
		If (Self.velY >= -768 - getGravity()) Then
			Int velX2 = Self.velX Shl MAX_ITEM
			Int resistance = (velX2 * 3) / JUMP_REVERSE_POWER
			
			If (velX2 > 0) Then
				velX2 -= resistance
				
				If (velX2 < 0) Then
					velX2 = 0
				EndIf
				
			ElseIf (velX2 < 0) Then
				velX2 -= resistance
				
				If (velX2 > 0) Then
					velX2 = 0
				EndIf
			EndIf
			
			Self.velX = velX2 Shr MAX_ITEM
		EndIf
		
		If (Self.smallJumpCount > 0) Then
			Self.smallJumpCount -= 1
			
			If (Not (Self.noVelMinus Or Key.repeat(Key.gUp | Key.B_HIGH_JUMP))) Then
				newPointX = Self.velY
				
				If (Self.isAntiGravity) Then
					i = -1
				Else
					i = 1
				EndIf
				
				Self.velY = newPointX + (i * (getGravity() / 2))
				newPointX = Self.velY
				
				If (Self.isAntiGravity) Then
					i = -1
				Else
					i = 1
				EndIf
				
				Self.velY = newPointX + (i * (getGravity() Shr 2))
			EndIf
		EndIf
		
		newPointX = Self.velY
		
		If (Self.isAntiGravity) Then
			i = -1
		Else
			i = 1
		EndIf
		
		Self.velY = newPointX + (i * getGravity())
		
		If (Self.animationID <> ANI_POP_JUMP_UP) Then
			Return
		EndIf
		
		If ((Self.velY > -200 And Not Self.isAntiGravity) Or (Self.velY < BPDef.PRICE_REVIVE And Self.isAntiGravity)) Then
			Self.animationID = ANI_POP_JUMP_UP_SLOW
		EndIf
		
	End
	
	Private Method inputLogicSand:Void()
		Self.leavingBar = False
		Self.doJumpForwardly = False
		Self.degreeRotateMode = 0
		
		If (Self.velY > 0 And Not Self.sandStanding) Then
			Self.sandStanding = True
		EndIf
		
		Self.sandFrame += 1
		
		If (Self.velX = 0) Then
			Self.sandFrame = 0
		ElseIf (Self.sandFrame = 1) Then
			soundInstance.playSe(70)
		ElseIf (Self.sandFrame > 2) Then
			soundInstance.playSequenceSe(71)
		EndIf
		
		If (Self.sandStanding) Then
			Int reversePower
			Int tmpPower = Self.movePower / 2
			Int tmpMaxVel = Self.maxVelocity / 2
			
			If (Key.repeat(Key.gLeft)) Then
				Self.faceDirection = False
				
				If (Self.velX > 0) Then
					If (Self.animationID = 4) Then
						reversePower = Self.movePowerReserseBallInSand
					Else
						reversePower = Self.movePowerReverseInSand
					EndIf
					
					Self.velX -= reversePower
					
					If (Self.velX < 0) Then
						Self.velX = (0 - reversePower) Shr 2
					Else
						Self.faceDirection = True
					EndIf
					
				ElseIf (Self.animationID <> 4) Then
					Self.velX -= tmpPower
					
					If (Self.velX < (-tmpMaxVel)) Then
						Self.velX += tmpPower
						
						If (Self.velX > (-tmpMaxVel)) Then
							Self.velX = -tmpMaxVel
						EndIf
					EndIf
				EndIf
				
			ElseIf (Key.repeat(Key.gRight)) Then
				Self.faceDirection = True
				
				If (Self.velX < 0) Then
					If (Self.animationID = 4) Then
						reversePower = Self.movePowerReserseBallInSand
					Else
						reversePower = Self.movePowerReverseInSand
					EndIf
					
					Self.velX += reversePower
					
					If (Self.velX > -1) Then
						Self.velX = reversePower Shr 2
					Else
						Self.faceDirection = False
					EndIf
					
				ElseIf (Self.animationID <> 4) Then
					Self.velX += tmpPower
					
					If (Self.velX > tmpMaxVel) Then
						Self.velX -= tmpPower
						
						If (Self.velX < tmpMaxVel) Then
							Self.velX = tmpMaxVel
						EndIf
					EndIf
				EndIf
				
			Else
				Self.velX = 0
			EndIf
			
			If (Abs(Self.velX) <= 64) Then
				If (Not (((Self instanceof PlayerAmy) And getCharacterAnimationID() = ANI_POAL_PULL And getVelY() < 0) Or Self.animationID = ANI_LOOK_UP_1 Or Self.animationID = ANI_LOOK_UP_2 Or Self.animationID = FADE_FILL_WIDTH)) Then
					Self.animationID = ANI_STAND
				EndIf
				
			ElseIf (characterID <> 1 Or ((PlayerTails) player).flyCount <= 0) Then
				If ((Not (Self instanceof PlayerAmy) Or (getCharacterAnimationID() <> 4 And (getCharacterAnimationID() <> MAX_ITEM Or Self.drawer.getCurrentFrame() >= 2))) And Not ((Self instanceof PlayerAmy) And getCharacterAnimationID() = ANI_POAL_PULL And getVelY() < 0)) Then
					If (Abs(Self.velX) < SPEED_LIMIT_LEVEL_1) Then
						Self.animationID = 1
					ElseIf (Abs(Self.velX) < SPEED_LIMIT_LEVEL_2) Then
						Self.animationID = 2
					Else
						Self.animationID = 3
					EndIf
				EndIf
				
			ElseIf (Not (Self.myAnimationID = SPIN_LV2_COUNT Or Self.myAnimationID = HURT_COUNT Or Self.myAnimationID = ANI_BREATHE)) Then
				((PlayerTails) player).flyCount = 0
			EndIf
			
			If (Not ((Self instanceof PlayerAmy) And getCharacterAnimationID() = ANI_POAL_PULL And getVelY() < 0)) Then
				Self.velY = 100
			EndIf
			
			If (characterID = CHARACTER_SONIC) Then
				Int sandDash = SPEED_LIMIT_LEVEL_1 Shr 2
				
				If (Key.press(Key.gSelect)) Then
					soundInstance.playSe(4)
					
					If (Self.faceDirection) Then
						If (Self.velX < 0) Then
							If (Self.animationID = 4) Then
								reversePower = Self.movePowerReserseBallInSand
							Else
								reversePower = Self.movePowerReverseInSand
							EndIf
							
							Self.velX += reversePower
							
							If (Self.velX > -1) Then
								Self.velX = reversePower Shr 2
							Else
								Self.faceDirection = False
							EndIf
							
						ElseIf (Self.animationID <> 4) Then
							Self.velX += sandDash
							
							If (Self.velX > tmpMaxVel) Then
								Self.velX -= sandDash
								
								If (Self.velX < tmpMaxVel) Then
									Self.velX = tmpMaxVel
								EndIf
							EndIf
						EndIf
						
					ElseIf (Self.velX > 0) Then
						If (Self.animationID = 4) Then
							reversePower = Self.movePowerReserseBallInSand
						Else
							reversePower = Self.movePowerReverseInSand
						EndIf
						
						Self.velX -= reversePower
						
						If (Self.velX < 0) Then
							Self.velX = (0 - reversePower) Shr 2
						Else
							Self.faceDirection = True
						EndIf
						
					ElseIf (Self.animationID <> 4) Then
						Self.velX -= sandDash
						
						If (Self.velX < (-tmpMaxVel)) Then
							Self.velX += sandDash
							
							If (Self.velX > (-tmpMaxVel)) Then
								Self.velX = -tmpMaxVel
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
			
			If (Not spinLogic()) Then
				If (Not (Key.repeat(Key.gLeft) Or Key.repeat(Key.gRight) Or isTerminalRunRight() Or Self.animationID = -1)) Then
					If (Key.repeat(Key.gDown)) Then
						If (Abs(Self.velX) > 64) Then
							Self.velX = 0
						ElseIf (Self.animationID <> MAX_ITEM) Then
							Self.animationID = ANI_SQUAT_PROCESS
						EndIf
						
					ElseIf (Self.animationID = MAX_ITEM) Then
						Self.animationID = ANI_SQUAT_PROCESS
					EndIf
				EndIf
				
				If (Self.animationID <> MAX_ITEM And Key.press(Key.gUp | Key.B_HIGH_JUMP)) Then
					If ((Self instanceof PlayerTails) And ((PlayerTails) player).flyCount > 0) Then
						((PlayerTails) player).flyCount = 0
					EndIf
					
					doJump()
					Self.velY -= getGravity()
					Self.sandStanding = False
				EndIf
			EndIf
			
			If (Not Key.repeat(Key.gLeft | Key.gRight) And Self.sandStanding) Then
				Int resistance
				
				If (Self.animationID <> 4) Then
					resistance = tmpPower
				Else
					resistance = tmpPower / 2
				EndIf
				
				If (Self.velX > 0) Then
					Self.velX -= resistance
					
					If (Self.velX < 0) Then
						Self.velX = 0
					EndIf
					
				ElseIf (Self.velX < 0) Then
					Self.velX += resistance
					
					If (Self.velX > 0) Then
						Self.velX = 0
					EndIf
				EndIf
			EndIf
			
		Else
			inputLogicJump()
		EndIf
		
		Self.collisionState = COLLISION_STATE_JUMP
	End
	
	Private Method faceDegreeChk:Int()
		Return Self.faceDegree
	End
	
	Private Method jumpDirectionX:Int()
		Return (Self.faceDegree <= 90 Or Self.faceDegree >= 270) ? -1 : 1
	End
	
	Public Method slipJumpOut:Void()
		' Empty implementation.
	End
	
	Public Method resetFlyCount:Void()
		' Empty implementation.
	End
	
	Public Method doJump:Void()
		
		If (Self.collisionState = Null) Then
			calDivideVelocity()
		EndIf
		
		Self.collisionState = COLLISION_STATE_JUMP
		Self.worldCal.actionState = 1
		Self.velY += ((Self.isInWater ? JUMP_INWATER_START_VELOCITY : JUMP_START_VELOCITY) * Cos(faceDegreeChk())) / 100
		Self.velX += ((Self.isInWater ? JUMP_INWATER_START_VELOCITY : JUMP_START_VELOCITY) * (-Sin(faceDegreeChk()))) / 100
		
		If (Self.faceDegree >= 0 And Self.faceDegree <= 90) Then
			If (Self.isAntiGravity) Then
				Self.velY = Math.max(Self.velY, -JUMP_PROTECT)
			Else
				Self.velY = Math.min(Self.velY, JUMP_PROTECT)
			EndIf
		EndIf
		
		Self.animationID = 4
		soundInstance.playSe(ANI_SLIP)
		Self.smallJumpCount = 4
		Self.onBank = False
		Self.attackAnimationID = 0
		Self.attackCount = 0
		Self.attackLevel = 0
		Self.noVelMinus = False
		Self.doJumpForwardly = True
		slipJumpOut()
		
		If (StageManager.getWaterLevel() > 0 And characterID = CHARACTER_KNUCKLES) Then
			((PlayerKnuckles) player).Floatchk()
		EndIf
		
	End
	
	Public Method doJump:Void(v0:Int)
		
		If (Self.collisionState = Null) Then
			calDivideVelocity()
		EndIf
		
		Self.collisionState = COLLISION_STATE_JUMP
		Self.worldCal.actionState = 1
		Self.velY += (Cos(faceDegreeChk()) * v0) / 100
		Self.velX += ((-Sin(faceDegreeChk())) * v0) / 100
		
		If (Self.isAntiGravity) Then
			Self.velY = Math.max(Self.velY, -JUMP_PROTECT)
		Else
			Self.velY = Math.min(Self.velY, JUMP_PROTECT)
		EndIf
		
		Self.animationID = 4
		soundInstance.playSe(ANI_SLIP)
		Self.smallJumpCount = 4
		Self.onBank = False
		Self.attackAnimationID = 0
		Self.attackCount = 0
		Self.attackLevel = 0
		Self.noVelMinus = False
		Self.doJumpForwardly = True
	End
	
	Public Method doJumpV:Void()
		
		If (Self.collisionState = Null) Then
			calDivideVelocity()
		EndIf
		
		Self.collisionState = COLLISION_STATE_JUMP
		Self.worldCal.actionState = 1
		setVelX(0)
		setVelY(Self.isInWater ? JUMP_INWATER_START_VELOCITY : JUMP_START_VELOCITY)
		Self.animationID = 4
		soundInstance.playSe(ANI_SLIP)
		Self.smallJumpCount = 4
		Self.onBank = False
		Self.attackAnimationID = 0
		Self.attackCount = 0
		Self.attackLevel = 0
		Self.noVelMinus = False
		Self.doJumpForwardly = True
		slipJumpOut()
	End
	
	Public Method doJumpV:Void(v0:Int)
		Self.collisionState = COLLISION_STATE_JUMP
		Self.worldCal.actionState = 1
		setVelY(v0)
		Self.animationID = 4
		soundInstance.playSe(ANI_SLIP)
		Self.smallJumpCount = 4
		Self.onBank = False
		Self.attackAnimationID = 0
		Self.attackCount = 0
		Self.attackLevel = 0
		Self.noVelMinus = False
		Self.doJumpForwardly = True
	End
	
	Public Method setFurikoOutVelX:Void(degree:Int)
		Self.velX = ((-JUMP_PROTECT) * Cos(degree)) / 100
	End
	
	Public Method getCheckPositionX:Int()
		Return (Self.collisionRect.x0 + Self.collisionRect.x1) / 2
	End
	
	Public Method getCheckPositionY:Int()
		Return (Self.collisionRect.y0 + Self.collisionRect.y1) / 2
	End
	
	Public Method getFootPositionX:Int()
		Return Self.footPointX
	End
	
	Public Method getFootPositionY:Int()
		Return Self.footPointY
	End
	
	Public Method getHeadPositionY:Int()
		Return getNewPointY(Self.footPointY, 0, -1536, Self.faceDegree)
	End
	
	Public Method setHeadPositionY:Void(y:Int)
		Self.footPointY = getNewPointY(y, 0, HEIGHT, Self.faceDegree)
	End
	
	Public Method doWhileCollision:Void(player:PlayerObject, direction:Int)
		' Empty implementation.
	End
	
	Public Method setCollisionLayer:Void(layer:Int)
		
		If (layer >= 0 And layer <= 1) Then
			Self.currentLayer = layer
		EndIf
		
	End
	
	Private Method land:Void()
		calTotalVelocity()
		Int playingLoopSeIndex = soundInstance.getPlayingLoopSeIndex()
		SoundSystem soundSystem = soundInstance
		
		If (playingLoopSeIndex = MOON_STAR_ORI_Y_1) Then
			soundInstance.stopLoopSe()
		EndIf
		
		If (Self.animationID <> ANI_DEAD_PRE) Then
			If (Abs(Self.totalVelocity) = 0) Then
				Self.animationID = ANI_STAND
			ElseIf (Abs(Self.totalVelocity) < SPEED_LIMIT_LEVEL_1) Then
				Self.animationID = 1
			ElseIf (Abs(Self.totalVelocity) < SPEED_LIMIT_LEVEL_2) Then
				Self.animationID = 2
			ElseIf (Not Self.slipping) Then
				Self.animationID = 3
			EndIf
		EndIf
		
		If (Self.ducting) Then
			If (Self.totalVelocity > 0 And Self.totalVelocity < MDPhone.SCREEN_HEIGHT And Self.pushOnce) Then
				Self.totalVelocity += MDPhone.SCREEN_HEIGHT
				Self.pushOnce = False
			EndIf
			
			If (Self.totalVelocity < 0 And Self.totalVelocity > -640 And Self.pushOnce) Then
				Self.totalVelocity -= MDPhone.SCREEN_HEIGHT
				Self.pushOnce = False
			EndIf
		EndIf
		
	End
	
	Public Method collisionCheckWithGameObject:Void(footX:Int, footY:Int)
		Self.collisionChkBreak = False
		refreshCollisionRectWrap()
		
		If (isAttracting()) Then
			Self.attractRect.setRect(footX - 4800, (footY - 4800) - BODY_OFFSET, ATTRACT_EFFECT_WIDTH, ATTRACT_EFFECT_WIDTH)
		EndIf
		
		GameObject.collisionChkWithAllGameObject(Self)
		calPreCollisionRect()
	End
	
	Public Method getCurrentHeight:Int()
		Return getCollisionRectHeight()
	End
	
	Public Method calPreCollisionRect:Void()
		Int RECT_HEIGHT = getCollisionRectHeight()
		Self.checkPositionX = getNewPointX(Self.footPointX, 0, (-RECT_HEIGHT) / 2, Self.faceDegree)
		Self.checkPositionY = getNewPointY(Self.footPointY, 0, (-RECT_HEIGHT) / 2, Self.faceDegree)
		Self.preCollisionRect.setTwoPosition(Self.checkPositionX - RIGHT_WALK_COLLISION_CHECK_OFFSET_X, Self.checkPositionY - (RECT_HEIGHT / 2), Self.checkPositionX + RIGHT_WALK_COLLISION_CHECK_OFFSET_X, Self.checkPositionY + (RECT_HEIGHT / 2))
	End
	
	Public Method collisionCheckWithGameObject:Void()
		collisionCheckWithGameObject(Self.footPointX, Self.footPointY)
	End
	
	Public Method moveOnObject:Void(newX:Int, newY:Int)
		moveOnObject(newX, newY, False)
	End
	
	Public Method moveOnObject:Void(newX:Int, newY:Int, fountain:Bool)
		Int moveDistanceX = newX - Self.footPointX
		Int moveDistanceY = newY - Self.footPointY
		Self.posZ = Self.currentLayer
		Self.worldCal.footDegree = Self.faceDegree
		Self.posX = Self.footPointX
		Self.posY = Self.footPointY
		Int preVelX = Self.velX
		Int preVelY = Self.velY
		Self.worldCal.actionLogic(moveDistanceX, moveDistanceY)
		
		If (getAnimationId() <> SPIN_LV2_COUNT And getAnimationId() <> ANI_HURT_PRE) Then
			Self.footPointX = Self.posX
			Self.footPointY = Self.posY
			Self.velX = preVelX
			Self.velY = preVelY
			Self.faceDegree = Self.worldCal.footDegree
		EndIf
		
	End
	
	Public Method prepareForCollision:Void()
		refreshCollisionRectWrap()
	End
	
	Public Method setSlideAni:Void()
		' Empty implementation.
	End
	
	Public Method beSlide0:Void(object:GameObject)
		
		If (Self.collisionState = Null) Then
			calDivideVelocity()
		EndIf
		
		Self.degreeRotateMode = 0
		
		If (Not Self.hurtNoControl Or Self.collisionState <> 1 Or ((Self.velY >= 0 Or Self.isAntiGravity) And (Self.velY <= 0 Or Not Self.isAntiGravity))) Then
			If (Self.collisionState <> TER_STATE_LOOK_MOON) Then
				calTotalVelocity()
			EndIf
			
			setSlideAni()
			
			If (Self.isAntiGravity) Then
				Self.footPointY = object.getCollisionRect().y1
			Else
				Self.footPointY = object.getCollisionRect().y0
			EndIf
			
			If (isFootOnObject(object)) Then
				Self.checkedObject = True
			EndIf
			
			setVelY(0)
			Self.worldCal.stopMoveY()
			
			If (Not (Self.collisionState = TER_STATE_LOOK_MOON And isFootOnObject(object))) Then
				Self.footOnObject = object
				Self.collisionState = TER_STATE_LOOK_MOON
				Self.collisionChkBreak = True
			EndIf
			
		ElseIf (Self.isAntiGravity) Then
			Self.footPointY = object.getCollisionRect().y1
		Else
			Self.footPointY = object.getCollisionRect().y0
		EndIf
		
		Self.onObjectContinue = True
		Self.posX = Self.footPointX
		Self.posY = Self.footPointY
		setPosition(Self.posX, Self.posY)
	End
	
	Public Method beStop:Void(newPosition:Int, direction:Int, object:GameObject, isDirectionDown:Bool)
		
		If (Self.isAntiGravity) Then
			If (direction = 1) Then
				direction = 0
			ElseIf (direction = 0) Then
				direction = 1
			EndIf
		EndIf
		
		Select (direction)
			Case 0
				
				If (Not Self.isAntiGravity And Self.velY < 0) Then
					setVelY(0)
					Self.worldCal.stopMoveY()
				EndIf
				
				If (Self.isAntiGravity And Self.velY > 0) Then
					setVelY(0)
					Self.worldCal.stopMoveY()
				EndIf
				
				If (Self.isAntiGravity) Then
					Self.footPointY = object.getCollisionRect().y0 - Self.collisionRect.getHeight()
				Else
					Self.footPointY = object.getCollisionRect().y1 + Self.collisionRect.getHeight()
				EndIf
				
				If ((Self.collisionState = Null Or Self.collisionState = COLLISION_STATE_ON_OBJECT) And Self.faceDegree = 0 And Not (object instanceof ItemObject)) Then
					setDie(False)
					break
				EndIf
				
			Case 1
				
				If (Self.collisionState = Null) Then
					calDivideVelocity()
				EndIf
				
				Self.degreeRotateMode = 0
				Int prey = Self.footPointY
				
				If (Not Self.hurtNoControl Or Self.collisionState <> 1 Or ((Self.velY >= 0 Or Self.isAntiGravity) And (Self.velY <= 0 Or Not Self.isAntiGravity))) Then
					If (Not (Self.collisionState = COLLISION_STATE_ON_OBJECT Or (object instanceof Spring))) Then
						land()
					EndIf
					
					If (Self.isAntiGravity) Then
						Self.footPointY = object.getCollisionRect().y1
					Else
						Self.footPointY = object.getCollisionRect().y0
					EndIf
					
					If (isFootOnObject(object)) Then
						Self.checkedObject = True
					EndIf
					
					setVelY(0)
					Self.worldCal.stopMoveY()
					
					If (Not (Self.collisionState = COLLISION_STATE_ON_OBJECT And isFootOnObject(object))) Then
						Self.footOnObject = object
						Self.collisionState = TER_STATE_LOOK_MOON
						Self.collisionChkBreak = True
					EndIf
					
					If (Not (Self.isSidePushed = 4 And isDirectionDown)) Then
						If (Self.isSidePushed = 3) Then
							Self.footPointX = Self.bePushedFootX
							Print("~~RIGHT footPointX:" + Self.footPointX)
							
							If (getVelX() > 0) Then
								setVelX(0)
								Self.worldCal.stopMoveX()
							EndIf
							
						ElseIf (Self.isSidePushed = 2) Then
							Self.footPointX = Self.bePushedFootX
							Print("~~LEFT footPointX:" + Self.footPointX)
							
							If (getVelX() < 0) Then
								setVelX(0)
								Self.worldCal.stopMoveX()
							EndIf
						EndIf
					EndIf
					
				ElseIf (Self.isAntiGravity) Then
					Self.footPointY = object.getCollisionRect().y1
				Else
					Self.footPointY = object.getCollisionRect().y0
				EndIf
				
				Self.movedSpeedY = Self.footPointY - prey
				Self.onObjectContinue = True
				break
			Case 2
			Case 3
				Int prex
				Int curx
				
				If (direction = 3) Then
					prex = Self.footPointX
					Self.footPointX = (object.getCollisionRect().x0 - (Self.collisionRect.getWidth() / 2)) + 1
					Self.footPointX = getNewPointX(Self.footPointX, 0, getCurrentHeight() / 2, Self.faceDegree)
					curx = Self.footPointX
					Self.bePushedFootX = Self.footPointX - RIGHT_WALK_COLLISION_CHECK_OFFSET_X
					Self.movedSpeedX = curx - prex
					
					If (Not (object instanceof DekaPlatform)) Then
						Self.movedSpeedX = 0
					EndIf
					
					If (Key.repeat(Key.gRight) And ((Self.collisionState = Null Or Self.collisionState = COLLISION_STATE_ON_OBJECT Or Self.collisionState = COLLISION_STATE_IN_SAND) And Not Self.isAttacking)) Then
						Self.animationID = ANI_PUSH_WALL
					EndIf
					
					If (getVelX() > 0) Then
						setVelX(0)
						Self.worldCal.stopMoveX()
					EndIf
					
					Self.rightStopped = True
				Else
					prex = Self.footPointX
					Self.footPointX = (object.getCollisionRect().x1 + (Self.collisionRect.getWidth() / 2)) - 1
					Self.footPointX = getNewPointX(Self.footPointX, 0, getCurrentHeight() / 2, Self.faceDegree)
					curx = Self.footPointX
					Self.bePushedFootX = Self.footPointX
					Self.movedSpeedX = curx - prex
					
					If (Not (object instanceof DekaPlatform)) Then
						Self.movedSpeedX = 0
					EndIf
					
					If (Key.repeat(Key.gLeft) And ((Self.collisionState = Null Or Self.collisionState = COLLISION_STATE_ON_OBJECT Or Self.collisionState = COLLISION_STATE_IN_SAND) And Not Self.isAttacking)) Then
						Self.animationID = ANI_PUSH_WALL
					EndIf
					
					If (getVelX() < 0) Then
						setVelX(0)
						Self.worldCal.stopMoveX()
					EndIf
					
					Self.leftStopped = True
				EndIf
				
				If (Self.collisionState = Null And Self.animationID = 4 And (object instanceof Hari)) Then
					Self.animationID = ANI_STAND
				EndIf
				
				Select (Self.collisionState)
					Case 1
						Self.xFirst = False
						break
				End Select
				
				If (Not (object instanceof GimmickObject)) Then
					Self.isStopByObject = False
					break
				Else
					Self.isStopByObject = True
					break
				EndIf
				
		End Select
		Self.posX = Self.footPointX
		Self.posY = Self.footPointY
	End
	
	Public Method beStopbyDoor:Void(newPosition:Int, direction:Int, object:GameObject)
		
		If (Self.isAntiGravity) Then
			If (direction = 1) Then
				direction = 0
			ElseIf (direction = 0) Then
				direction = 1
			EndIf
		EndIf
		
		Select (direction)
			Case 0
				
				If (Not Self.isAntiGravity And Self.velY < 0) Then
					setVelY(0)
					Self.worldCal.stopMoveY()
				EndIf
				
				If (Self.isAntiGravity And Self.velY > 0) Then
					setVelY(0)
					Self.worldCal.stopMoveY()
				EndIf
				
				If (Self.isAntiGravity) Then
					Self.footPointY = object.getCollisionRect().y0 - Self.collisionRect.getHeight()
				Else
					Self.footPointY = object.getCollisionRect().y1 + Self.collisionRect.getHeight()
				EndIf
				
				If ((Self.collisionState = Null Or Self.collisionState = TER_STATE_LOOK_MOON) And Self.faceDegree = 0) Then
					setDie(False)
					break
				EndIf
				
			Case 1
				
				If (Self.collisionState = Null) Then
					calDivideVelocity()
				EndIf
				
				Self.degreeRotateMode = 0
				
				If (Not Self.hurtNoControl Or Self.collisionState <> 1 Or ((Self.velY >= 0 Or Self.isAntiGravity) And (Self.velY <= 0 Or Not Self.isAntiGravity))) Then
					If (Not (Self.collisionState = TER_STATE_LOOK_MOON Or (object instanceof Spring))) Then
						land()
					EndIf
					
					If (Self.isAntiGravity) Then
						Self.footPointY = object.getCollisionRect().y1
					Else
						Self.footPointY = object.getCollisionRect().y0
					EndIf
					
					If (isFootOnObject(object)) Then
						Self.checkedObject = True
					EndIf
					
					If (Not (Self.collisionState = TER_STATE_LOOK_MOON And isFootOnObject(object))) Then
						Self.footOnObject = object
						Self.collisionState = TER_STATE_LOOK_MOON
						Self.collisionChkBreak = True
					EndIf
					
				ElseIf (Self.isAntiGravity) Then
					Self.footPointY = object.getCollisionRect().y1
				Else
					Self.footPointY = object.getCollisionRect().y0
				EndIf
				
				Self.onObjectContinue = True
				break
			Case 2
			Case 3
				Int prex
				
				If (direction = 3) Then
					Bool z
					prex = Self.footPointX
					Self.footPointX = (object.getCollisionRect().x0 - (Self.collisionRect.getWidth() / 2)) + 1
					Self.footPointX = getNewPointX(Self.footPointX, 0, getCurrentHeight() / 2, Self.faceDegree)
					Self.movedSpeedX = Self.footPointX - prex
					
					If (Not (object instanceof DekaPlatform)) Then
						Self.movedSpeedX = 0
					EndIf
					
					If (Key.repeat(Key.gRight) And ((Self.collisionState = Null Or Self.collisionState = TER_STATE_LOOK_MOON Or Self.collisionState = TER_STATE_LOOK_MOON_WAIT) And Not Self.isAttacking)) Then
						Self.animationID = ANI_PUSH_WALL
					EndIf
					
					If (getVelX() > 0) Then
						setVelX(0)
						Self.worldCal.stopMoveX()
					EndIf
					
					Self.rightStopped = True
					
					If (Self.isAntiGravity) Then
						z = False
					Else
						z = True
					EndIf
					
					Self.faceDirection = z
				Else
					prex = Self.footPointX
					Self.footPointX = (object.getCollisionRect().x1 + (Self.collisionRect.getWidth() / 2)) - 1
					Self.footPointX = getNewPointX(Self.footPointX, 0, getCurrentHeight() / 2, Self.faceDegree)
					Self.movedSpeedX = Self.footPointX - prex
					
					If (Not (object instanceof DekaPlatform)) Then
						Self.movedSpeedX = 0
					EndIf
					
					If (Key.repeat(Key.gLeft) And ((Self.collisionState = Null Or Self.collisionState = TER_STATE_LOOK_MOON Or Self.collisionState = TER_STATE_LOOK_MOON_WAIT) And Not Self.isAttacking)) Then
						Self.animationID = ANI_PUSH_WALL
					EndIf
					
					If (getVelX() < 0) Then
						setVelX(0)
						Self.worldCal.stopMoveX()
					EndIf
					
					Self.leftStopped = True
					Self.faceDirection = Self.isAntiGravity ? True : False
				EndIf
				
				If (Self.collisionState = Null And Self.animationID = 4 And (object instanceof Hari)) Then
					Self.animationID = ANI_STAND
				EndIf
				
				Select (Self.collisionState)
					Case 1
						Self.xFirst = False
						break
				End Select
				
				If (Not (object instanceof GimmickObject)) Then
					Self.isStopByObject = False
					break
				Else
					Self.isStopByObject = True
					break
				EndIf
				
		End Select
		Self.posX = Self.footPointX
		Self.posY = Self.footPointY
	End
	
	Public Method beStop:Void(newPosition:Int, direction:Int, object:GameObject)
		
		If (Self.isAntiGravity) Then
			If (direction = 1) Then
				direction = 0
			ElseIf (direction = 0) Then
				direction = 1
			EndIf
		EndIf
		
		Select (direction)
			Case 0
				
				If (Not Self.isAntiGravity And Self.velY < 0) Then
					setVelY(0)
					Self.worldCal.stopMoveY()
				EndIf
				
				If (Self.isAntiGravity And Self.velY > 0) Then
					setVelY(0)
					Self.worldCal.stopMoveY()
				EndIf
				
				If (Self.isAntiGravity) Then
					Self.footPointY = object.getCollisionRect().y0 - Self.collisionRect.getHeight()
				Else
					Self.footPointY = object.getCollisionRect().y1 + Self.collisionRect.getHeight()
				EndIf
				
				If ((Self.collisionState = Null Or Self.collisionState = TER_STATE_LOOK_MOON) And Self.faceDegree = 0 And Not (object instanceof Spring) And Not (object instanceof ItemObject)) Then
					setDie(False)
					break
				EndIf
				
			Case 1
				
				If (Self.collisionState = Null) Then
					calDivideVelocity()
				EndIf
				
				Self.degreeRotateMode = 0
				
				If (Not Self.hurtNoControl Or Self.collisionState <> 1 Or ((Self.velY >= 0 Or Self.isAntiGravity) And (Self.velY <= 0 Or Not Self.isAntiGravity))) Then
					If (Not (Self.collisionState = TER_STATE_LOOK_MOON Or (object instanceof Spring))) Then
						land()
					EndIf
					
					If (Self.isAntiGravity) Then
						Self.footPointY = object.getCollisionRect().y1
					Else
						Self.footPointY = object.getCollisionRect().y0
					EndIf
					
					If (isFootOnObject(object)) Then
						Self.checkedObject = True
					EndIf
					
					setVelY(0)
					Self.worldCal.stopMoveY()
					
					If (Not (Self.collisionState = TER_STATE_LOOK_MOON And isFootOnObject(object))) Then
						Self.footOnObject = object
						Self.collisionState = TER_STATE_LOOK_MOON
						Self.collisionChkBreak = True
					EndIf
					
				ElseIf (Self.isAntiGravity) Then
					Self.footPointY = object.getCollisionRect().y1
				Else
					Self.footPointY = object.getCollisionRect().y0
				EndIf
				
				Self.onObjectContinue = True
				break
			Case 2
			Case 3
				Int prex
				
				If (direction = 3) Then
					prex = Self.footPointX
					Self.footPointX = (object.getCollisionRect().x0 - (Self.collisionRect.getWidth() / 2)) + 1
					Self.footPointX = getNewPointX(Self.footPointX, 0, getCurrentHeight() / 2, Self.faceDegree)
					Self.movedSpeedX = Self.footPointX - prex
					
					If (Not (object instanceof DekaPlatform)) Then
						Self.movedSpeedX = 0
					EndIf
					
					If (Key.repeat(Key.gRight) And ((Self.animationID = ANI_STAND Or Self.animationID = ANI_CLIFF_1 Or Self.animationID = HURT_COUNT Or Self.animationID = 1 Or Self.animationID = 2 Or Self.animationID = 3) And Not ((object instanceof Hari) And object.objId = 3 And canBeHurt()))) Then
						Self.animationID = ANI_PUSH_WALL
					EndIf
					
					If (Not ((object instanceof Hari) And object.objId = 3 And canBeHurt()) And getVelX() > 0) Then
						setVelX(0)
						Self.worldCal.stopMoveX()
					EndIf
					
					Self.rightStopped = True
				Else
					prex = Self.footPointX
					Self.footPointX = (object.getCollisionRect().x1 + (Self.collisionRect.getWidth() / 2)) - 1
					Self.footPointX = getNewPointX(Self.footPointX, 0, getCurrentHeight() / 2, Self.faceDegree)
					Self.movedSpeedX = Self.footPointX - prex
					
					If (Not (object instanceof DekaPlatform)) Then
						Self.movedSpeedX = 0
					EndIf
					
					If (Key.repeat(Key.gLeft) And ((Self.animationID = ANI_STAND Or Self.animationID = ANI_CLIFF_1 Or Self.animationID = HURT_COUNT Or Self.animationID = 1 Or Self.animationID = 2 Or Self.animationID = 3) And Not ((object instanceof Hari) And object.objId = 4 And canBeHurt()))) Then
						Self.animationID = ANI_PUSH_WALL
					EndIf
					
					If (Not ((object instanceof Hari) And object.objId = 4 And canBeHurt()) And getVelX() < 0) Then
						setVelX(0)
						Self.worldCal.stopMoveX()
					EndIf
					
					Self.leftStopped = True
				EndIf
				
				If (Self.collisionState = Null And Self.animationID = 4 And (object instanceof Hari)) Then
					Self.animationID = ANI_STAND
				EndIf
				
				Select (Self.collisionState)
					Case 1
						Self.xFirst = False
						break
				End Select
				
				If (Not (object instanceof GimmickObject)) Then
					Self.isStopByObject = False
					break
				Else
					Self.isStopByObject = True
					break
				EndIf
				
		End Select
		Self.posX = Self.footPointX
		Self.posY = Self.footPointY
	End
	
	Public Method isAttackingEnemy:Bool()
		
		If ((Self instanceof PlayerAmy) And getCharacterAnimationID() = ANI_LOOK_UP_2) Then
			Return False
		EndIf
		
		If ((Self instanceof PlayerAmy) And (getCharacterAnimationID() = MOON_STAR_ORI_Y_1 Or getCharacterAnimationID() = ANI_ATTACK_2 Or getCharacterAnimationID() = SPIN_KEY_COUNT Or getCharacterAnimationID() = ANI_RAIL_ROLL Or getCharacterAnimationID() = ANI_BAR_ROLL_1 Or getCharacterAnimationID() = ITEM_RING_10)) Then
			Return True
		EndIf
		
		If ((Self instanceof PlayerSonic) And (getCharacterAnimationID() = ANI_POAL_PULL Or getCharacterAnimationID() = ANI_POP_JUMP_UP Or getCharacterAnimationID() = ANI_JUMP_ROLL Or getCharacterAnimationID() = 4)) Then
			Return True
		EndIf
		
		If ((Self instanceof PlayerTails) And getCharacterAnimationID() = ANI_SLIP) Then
			Return True
		EndIf
		
		If ((Self instanceof PlayerKnuckles) And (getCharacterAnimationID() = ANI_SLIP Or getCharacterAnimationID() = SPIN_LV2_COUNT Or getCharacterAnimationID() = ANI_POAL_PULL Or getCharacterAnimationID() = ANI_ATTACK_2 Or getCharacterAnimationID() = SPIN_KEY_COUNT Or getCharacterAnimationID() = ANI_RAIL_ROLL Or getCharacterAnimationID() = ANI_BAR_ROLL_1)) Then
			Return True
		EndIf
		
		Return (Self.animationID = MOON_STAR_ORI_Y_1 Or Self.animationID = ANI_ATTACK_2 Or Self.animationID = SPIN_KEY_COUNT Or Self.animationID = 4 Or Self.animationID = 6 Or Self.animationID = ITEM_RING_10 Or invincibleCount > 0) ? True : False
	End
	
	Public Method isAttackingItem:Bool(pFirstTouch:Bool)
		
		If (Self.ignoreFirstTouch Or pFirstTouch) Then
			Return isAttackingItem()
		EndIf
		
		Return False
	End
	
	Public Method isAttackingItem:Bool()
		
		If ((Self instanceof PlayerAmy) And (getCharacterAnimationID() = ANI_RAIL_ROLL Or getCharacterAnimationID() = ANI_BAR_ROLL_1)) Then
			player.setVelY(player.getVelY() - 325)
			Return True
		ElseIf ((Self instanceof PlayerAmy) And getCharacterAnimationID() = ANI_LOOK_UP_2) Then
			Return False
		Else
			
			If ((Self instanceof PlayerAmy) And getCharacterAnimationID() = ANI_BRAKE) Then
				Return False
			EndIf
			
			Return (Self.animationID = MOON_STAR_ORI_Y_1 Or Self.animationID = ANI_ATTACK_2 Or Self.animationID = SPIN_KEY_COUNT Or Self.animationID = 4) ? True : False
		EndIf
		
	End
	
	Public Method getVelX:Int()
		
		If (Self.collisionState = Null) Then
			Return (Self.totalVelocity * Cos(Self.faceDegree)) / 100
		EndIf
		
		Return Self.velX
	End
	
	Public Method getVelY:Int()
		
		If (Self.collisionState = Null) Then
			Return (Self.totalVelocity * Sin(Self.faceDegree)) / 100
		EndIf
		
		Return Self.velY
	End
	
	Public Method setVelX:Void(mVelX:Int)
		
		If (Self.collisionState = Null) Then
			Int tmpVelX = (Self.totalVelocity * Cos(Self.faceDegree)) / 100
			tmpVelX = mVelX
			Self.totalVelocity = ((Cos(Self.faceDegree) * tmpVelX) + (Sin(Self.faceDegree) * ((Self.totalVelocity * Sin(Self.faceDegree)) / 100))) / 100
			Return
		EndIf
		
		Super.setVelX(mVelX)
	End
	
	Public Method setVelY:Void(mVelY:Int)
		
		If (Self.collisionState = Null) Then
			Int dSin = (Self.totalVelocity * Sin(Self.faceDegree)) / 100
			Self.totalVelocity = ((Cos(Self.faceDegree) * ((Self.totalVelocity * Cos(Self.faceDegree)) / 100)) + (Sin(Self.faceDegree) * mVelY)) / 100
			Return
		EndIf
		
		Super.setVelY(mVelY)
	End
	
	Public Method setVelXPercent:Void(percentage:Int)
		
		If (Self.collisionState = Null) Then
			Int tmpVelX = (Self.totalVelocity * Cos(Self.faceDegree)) / 100
			tmpVelX = (Self.totalVelocity * percentage) / 100
			Self.totalVelocity = ((Cos(Self.faceDegree) * tmpVelX) + (Sin(Self.faceDegree) * ((Self.totalVelocity * Sin(Self.faceDegree)) / 100))) / 100
			Return
		EndIf
		
		Super.setVelX((Self.totalVelocity * percentage) / 100)
	End
	
	Public Method setVelYPercent:Void(percentage:Int)
		
		If (Self.collisionState = Null) Then
			Int tmpVelY = (Self.totalVelocity * Sin(Self.faceDegree)) / 100
			Self.totalVelocity = ((Cos(Self.faceDegree) * ((Self.totalVelocity * Cos(Self.faceDegree)) / 100)) + (Sin(Self.faceDegree) * ((Self.totalVelocity * percentage) / 100))) / 100
			Return
		EndIf
		
		Super.setVelY((Self.totalVelocity * percentage) / 100)
	End
	
	Public Method beSpring:Void(springPower:Int, direction:Int)
		
		If (Self.collisionState = Null) Then
			calDivideVelocity()
		EndIf
		
		If (Self.isInWater) Then
			springPower = (springPower * 185) / 100
		EndIf
		
		Select (direction)
			Case 0
				Self.velY = springPower
				Self.worldCal.stopMoveY()
				break
			Case 1
				Self.velY = -springPower
				Self.worldCal.stopMoveY()
				break
			Case 2
				Self.velX = springPower
				Self.worldCal.stopMoveX()
				break
			Case 3
				Self.velX = -springPower
				Self.worldCal.stopMoveX()
				break
		End Select
		
		If (Self.collisionState = Null) Then
			calTotalVelocity()
		EndIf
		
		If ((Not Self.isAntiGravity And direction = 1) Or (Self.isAntiGravity And direction = 0)) Then
			Int i = Self.degreeStable
			Self.faceDegree = i
			Self.degreeForDraw = i
			Self.animationID = ANI_ROTATE_JUMP
			Self.collisionState = COLLISION_STATE_JUMP
			Self.worldCal.actionState = 1
			Self.collisionChkBreak = True
			Self.drawer.restart()
		EndIf
		
		If (player instanceof PlayerTails) Then
			((PlayerTails) player).resetFlyCount()
		EndIf
		
	End
	
	Public Method bePop:Void(springPower:Int, direction:Int)
		beSpring(springPower, direction)
		
		If ((Not Self.isAntiGravity And direction = 1) Or (Self.isAntiGravity And direction = 0)) Then
			Self.animationID = ANI_POP_JUMP_UP
			Self.collisionState = COLLISION_STATE_JUMP
			Self.worldCal.actionState = 1
		EndIf
		
	End
	
	Public Method beHurt:Void()
		
		If (player.canBeHurt()) Then
			doHurt()
			Int bodyCenterX = getNewPointX(Self.footPointX, 0, -768, Self.faceDegree)
			Int bodyCenterY = getNewPointY(Self.footPointY, 0, -768, Self.faceDegree)
			Self.faceDegree = Self.degreeStable
			Self.footPointX = getNewPointX(bodyCenterX, 0, BODY_OFFSET, Self.faceDegree)
			Self.footPointY = getNewPointY(bodyCenterY, 0, BODY_OFFSET, Self.faceDegree)
			
			If (shieldType <> 0) Then
				shieldType = 0
				
				If (Not Self.beAttackByHari) Then
					soundInstance.playSe(ANI_POP_JUMP_UP)
				EndIf
				
				If (Self.beAttackByHari) Then
					Self.beAttackByHari = False
				EndIf
				
			ElseIf (ringNum + ringTmpNum > 0) Then
				RingObject.hurtRingExplosion(ringNum + ringTmpNum, getBodyPositionX(), getBodyPositionY(), Self.currentLayer, Self.isAntiGravity)
				ringNum = 0
				ringTmpNum = 0
			ElseIf (ringNum = 0 And ringTmpNum = 0) Then
				setDie(False)
			EndIf
		EndIf
		
	End
	
	Public Method beHurtNoRingLose:Void()
		
		If (player.canBeHurt()) Then
			doHurt()
			Int bodyCenterX = getNewPointX(Self.footPointX, 0, -768, Self.faceDegree)
			Int bodyCenterY = getNewPointY(Self.footPointY, 0, -768, Self.faceDegree)
			Self.faceDegree = Self.degreeStable
			Self.footPointX = getNewPointX(bodyCenterX, 0, BODY_OFFSET, Self.faceDegree)
			Self.footPointY = getNewPointY(bodyCenterY, 0, BODY_OFFSET, Self.faceDegree)
			
			If (shieldType <> 0) Then
				shieldType = 0
			EndIf
		EndIf
		
	End
	
	Public Method beHurtByCage:Void()
		
		If (Self.hurtCount = 0) Then
			doHurt()
			Self.velX = (Self.velX * 3) / 2
			Self.velY = (Self.velY * 3) / 2
		EndIf
		
	End
	
	Public Method doHurt:Void()
		Int i
		Self.animationID = ANI_HURT_PRE
		
		If (Self.collisionState = COLLISION_STATE_ON_OBJECT) Then
			Self.footPointY -= TitleState.CHARACTER_RECORD_BG_OFFSET
			prepareForCollision()
		EndIf
		
		If (Self.outOfControl And Self.outOfControlObject <> Null And Self.outOfControlObject.releaseWhileBeHurt()) Then
			Self.outOfControl = False
			Self.outOfControlObject = Null
		EndIf
		
		Self.hurtCount = HURT_COUNT
		
		If (Self.velX = 0) Then
			Self.velX = (Self.faceDirection ? -1 : 1) * HURT_POWER_X
		ElseIf (Self.velX > 0) Then
			Self.velX = -HURT_POWER_X
		Else
			Self.velX = HURT_POWER_X
		EndIf
		
		If (Self.isAntiGravity) Then
			Self.velX = -Self.velX
		EndIf
		
		If (Self.isAntiGravity) Then
			i = -1
		Else
			i = 1
		EndIf
		
		Self.velY = i * HURT_POWER_Y
		Self.collisionState = COLLISION_STATE_JUMP
		Self.worldCal.actionState = 1
		Self.collisionChkBreak = True
		Self.worldCal.stopMove()
		Self.onObjectContinue = False
		Self.footOnObject = Null
		Self.hurtNoControl = True
		Self.attackAnimationID = 0
		Self.attackCount = 0
		Self.attackLevel = 0
		Self.dashRolling = False
		MyAPI.vibrate()
		Self.degreeRotateMode = 0
	End
	
	Public Method canBeHurt:Bool()
		
		If (Self.hurtCount > 0 Or invincibleCount > 0 Or Self.isDead) Then
			Return False
		EndIf
		
		Return True
	End
	
	Public Method isFootOnObject:Bool(object:GameObject)
		
		If (Self.outOfControl) Then
			Return False
		EndIf
		
		If (Self.collisionState <> 2) Then
			Return False
		EndIf
		
		Return Self.footOnObject = object ? True : False
	End
	
	Public Method isFootObjectAndLogic:Bool(object:GameObject)
		Return (Self.footObjectLogic And Self.footOnObject = object And Self.collisionState = COLLISION_STATE_ON_OBJECT) ? True : False
	End
	
	Public Method setFootPositionX:Void(x:Int)
		Self.footPointX = x
		Self.posX = x
	End
	
	Public Method setFootPositionY:Void(y:Int)
		Self.footPointY = y
		Self.posY = y
	End
	
	Public Method setBodyPositionX:Void(x:Int)
		setFootPositionX(x)
	End
	
	Public Method setBodyPositionY:Void(y:Int)
		setFootPositionY(y + BODY_OFFSET)
	End
	
	Public Method getBodyPositionX:Int()
		Return getFootPositionX()
	End
	
	Public Method getBodyPositionY:Int()
		Return getFootPositionY() + (Self.isAntiGravity ? BODY_OFFSET : -768)
	End
	
	Private Method spinLv2Calc:Int()
		Return (((Self.isInWater ? SPIN_INWATER_START_SPEED_2 : SPIN_START_SPEED_2) * (SONIC_ATTACK_LEVEL_3_V0 - (Self.spinDownWaitCount * SPIN_LV2_COUNT_CONF))) / SPIN_LV2_COUNT) / 100
	End
	
	Public Method dashRollingLogic:Void()
		Int i
		Self.animationID = 6
		
		If (Self.spinCount > ANI_ROTATE_JUMP) Then
			Self.animationID = ITEM_RING_10
		Else
			
			If (Key.press(Key.B_HIGH_JUMP | Key.gUp)) Then
				Self.spinDownWaitCount = 0
				Self.spinCount = SPIN_LV2_COUNT
				Self.animationID = ITEM_RING_10
				Self.spinKeyCount = SPIN_KEY_COUNT
				Self.drawer.restart()
				
				If (characterID <> 3) Then
					soundInstance.playSe(4)
				EndIf
				
			ElseIf (Key.repeat((Key.B_SPIN2 | Key.B_7) | Key.B_9) And Self.spinKeyCount = 0) Then
				Self.spinCount = SPIN_LV2_COUNT
				Self.animationID = ITEM_RING_10
				Self.spinKeyCount = SPIN_KEY_COUNT
				Self.drawer.restart()
				
				If (characterID <> 3) Then
					soundInstance.playSe(4)
				EndIf
			EndIf
			
			If (Self.spinCount = 0 And Self.spinKeyCount > 0) Then
				Self.spinKeyCount -= 1
			EndIf
		EndIf
		
		If (Self.spinCount > 0) Then
			If (Self.spinDownWaitCount < SPIN_LV2_COUNT) Then
				Self.spinDownWaitCount += 1
			Else
				Self.spinDownWaitCount = SPIN_LV2_COUNT
			EndIf
		EndIf
		
		If (Self.spinCount > 0) Then
			Self.spinCount -= 1
			Self.effectID = 1
		Else
			Self.effectID = 0
		EndIf
		
		Select (Self.collisionState)
			Case 0
				Self.totalVelocity = 0
				break
			Default
				Self.velX = 0
				break
		End Select
		
		If (Not Key.repeat(((Key.gDown | Key.B_7) | Key.B_9) | Key.B_SPIN2)) Then
			Self.effectID = -1
			Select (Self.collisionState)
				Case 0
					Self.totalVelocity = SPIN_START_SPEED_1
					
					If (Self.isInWater) Then
						Self.totalVelocity = SPIN_INWATER_START_SPEED_1
					EndIf
					
					If (Self.spinCount > 0) Then
						Self.totalVelocity = spinLv2Calc()
						SoundSystem.getInstance().playSe(MAX_ITEM)
					Else
						SoundSystem.getInstance().playSe(MAX_ITEM)
					EndIf
					
					If (Not Self.faceDirection) Then
						Self.totalVelocity = -Self.totalVelocity
						break
					EndIf
					
					break
				Default
					Self.velX = SPIN_START_SPEED_1
					
					If (Self.isInWater) Then
						Self.totalVelocity = SPIN_INWATER_START_SPEED_1
					EndIf
					
					If (Self.spinCount > 0) Then
						Self.velX = spinLv2Calc()
						SoundSystem.getInstance().playSe(MAX_ITEM)
					Else
						SoundSystem.getInstance().playSe(MAX_ITEM)
					EndIf
					
					If (Not Self.faceDirection) Then
						If (Self.isAntiGravity) Then
							i = 1
						Else
							i = -1
						EndIf
						
						Self.velX = i * Self.velX
						break
					EndIf
					
					Self.velX = (Self.isAntiGravity ? -1 : 1) * Self.velX
					break
			End Select
			Self.spinCount = 0
			Self.animationID = 4
			Self.dashRolling = False
			Self.ignoreFirstTouch = True
			Self.isAfterSpinDash = True
		EndIf
		
		Select (Self.collisionState)
			Case 0
			Case 3
				Self.velY = 100
			Default
				Int i2
				i = Self.velY
				
				If (Self.isAntiGravity) Then
					i2 = -1
				Else
					i2 = 1
				EndIf
				
				Self.velY = i + (i2 * getGravity())
		End Select
	End
	
	Public Method beWaterFall:Void()
		Self.waterFalling = True
		Self.velY += GRAVITY / TERMINAL_COUNT
	End
	
	Public Method getWaterFallState:Bool()
		Return Self.waterFalling
	End
	
	Public Method initWaterFall:Void()
		
		If (Self.waterFallDrawer = Null) Then
			MFImage image = Null
			
			If (StageManager.getCurrentZoneId() = MAX_ITEM) Then
				image = MFImage.createImage("/animation/water_fall_5.png")
			EndIf
			
			If (image = Null) Then
				Self.waterFallDrawer = New Animation("/animation/water_fall").getDrawer(0, True, 0)
			Else
				Self.waterFallDrawer = New Animation(image, "/animation/water_fall").getDrawer(0, True, 0)
			EndIf
		EndIf
		
	End
	
	Private Method waterFallDraw:Void(g:MFGraphics, camera:Coordinate)
		
		If (Self.waterFalling) Then
			Int offset_y = (characterID = CHARACTER_KNUCKLES And Self.myAnimationID = ANI_BAR_ROLL_1) ? INVINCIBLE_COUNT : -320
			drawInMap(g, Self.waterFallDrawer, (Self.collisionRect.x0 + Self.collisionRect.x1) / 2, Self.collisionRect.y0 + offset_y)
			Self.waterFalling = False
		EndIf
		
	End
	
	Public Method initWaterFlush:Void()
		
		If (Self.waterFlushDrawer = Null) Then
			MFImage image = Null
			
			If (StageManager.getCurrentZoneId() = MAX_ITEM) Then
				image = MFImage.createImage("/animation/water_flush_5.png")
			EndIf
			
			If (image = Null) Then
				Self.waterFlushDrawer = New Animation("/animation/water_flush").getDrawer(0, True, 0)
			Else
				Self.waterFlushDrawer = New Animation(image, "/animation/water_flush").getDrawer(0, True, 0)
			EndIf
		EndIf
		
	End
	
	Private Method waterFlushDraw:Void(g:MFGraphics)
		
		If (Self.showWaterFlush) Then
			Int i
			initWaterFlush()
			AnimationDrawer animationDrawer = Self.waterFlushDrawer
			Int i2 = Self.footPointX
			
			If (StageManager.getCurrentZoneId() = 4 Or StageManager.getCurrentZoneId() = MAX_ITEM) Then
				i = Self.collisionRect.y1 - RIGHT_WALK_COLLISION_CHECK_OFFSET_X
			Else
				i = Self.collisionRect.y1
			EndIf
			
			drawInMap(g, animationDrawer, i2, i)
			Self.showWaterFlush = False
		EndIf
		
	End
	
	Public Method beAccelerate:Bool(power:Int, IsX:Bool, sender:GameObject)
		
		If (Self.collisionState = Null) Then
			Self.totalVelocity = power
			Self.faceDirection = Self.totalVelocity > 0 ? True : False
			Return True
		ElseIf (Self.collisionState <> 2 Or (sender instanceof Accelerate)) Then
			Return False
		Else
			
			If (IsX) Then
				Self.velX = power
			Else
				Self.velY = power
			EndIf
			
			Return True
		EndIf
		
	End
	
	Public Method isOnGound:Bool()
		Return Self.collisionState = Null ? True : False
	End
	
	Public Method doPoalMotion:Bool(x:Int, y:Int, isLeft:Bool)
		
		If (Self.collisionState = Null) Then
			Self.collisionState = COLLISION_STATE_JUMP
		EndIf
		
		If (Self.collisionState <> 1) Then
			Return False
		EndIf
		
		Self.animationID = ANI_POAL_PULL
		Self.faceDirection = isLeft ? False : True
		Self.footPointX = x
		Self.footPointY = y + DETECT_HEIGHT
		Self.velX = 0
		Self.velY = 0
		Return True
	End
	
	Public Method doPoalMotion2:Bool(x:Int, y:Int, direction:Bool)
		
		If (Self.collisionState <> Null Or ((Not Self.faceDirection Or Not direction Or Self.totalVelocity < DO_POAL_MOTION_SPEED) And (Self.faceDirection Or direction Or Self.totalVelocity > -600))) Then
			Return False
		EndIf
		
		Int i
		Self.animationID = ANI_POAL_PULL_2
		Self.faceDirection = direction
		Self.footPointX = ((Self.faceDirection ? -1 : 1) * WIDTH) + x
		setNoKey()
		
		If (Self.faceDirection) Then
			i = -1
		Else
			i = 1
		EndIf
		
		Self.totalVelocity = i * SSDef.PLAYER_MOVE_WIDTH
		Self.worldCal.stopMoveX()
		Return True
	End
	
	Public Method doPullMotion:Void(x:Int, y:Int)
		Self.animationID = ANI_PULL
		Self.footPointX = x
		Self.footPointY = y + DETECT_HEIGHT
		Self.velX = 0
		Self.velY = 0
		
		If (Self.faceDirection) Then
			Self.footPointX -= SIDE_FOOT_FROM_CENTER
		Else
			Self.footPointX += SIDE_FOOT_FROM_CENTER
		EndIf
		
	End
	
	Public Method doPullBarMotion:Void(y:Int)
		Self.animationID = ANI_SMALL_ZERO
		Self.footPointY = y + 1792
		Self.velX = 0
		Self.velY = 0
	End
	
	Public Method doWalkPoseInAir:Void()
		
		If (Self.collisionState <> 1) Then
			Return
		EndIf
		
		If (Abs(Self.velX) < SPEED_LIMIT_LEVEL_1) Then
			Self.animationID = 1
		ElseIf (Abs(Self.velX) < SPEED_LIMIT_LEVEL_2) Then
			Self.animationID = 2
		Else
			Self.animationID = 3
		EndIf
		
	End
	
	Public Method doDripInAir:Void()
		
		If (Self.collisionState = COLLISION_STATE_JUMP) Then
			If (Self.animationID = 4) Then
				Self.animationID = 4
			ElseIf (Abs(Self.velX) < SPEED_LIMIT_LEVEL_1) Then
				Self.animationID = 1
			ElseIf (Abs(Self.velX) < SPEED_LIMIT_LEVEL_2) Then
				Self.animationID = 2
			Else
				Self.animationID = 3
			EndIf
		EndIf
		
		Self.bankwalking = False
	End
	
	Public Method setAnimationId:Void(id:Int)
		Self.animationID = id
	End
	
	Public Method restartAniDrawer:Void()
		Self.drawer.restart()
	End
	
	Public Method getAnimationId:Int()
		Return Self.animationID
	End
	
	Public Method refreshCollisionRectWrap:Void()
		Int RECT_HEIGHT = getCollisionRectHeight()
		Int RECT_WIDTH = getCollisionRectWidth()
		Int switchDegree = Self.faceDegree
		Int yOffset = 0
		
		If (Self.animationID = ANI_SLIP) Then
			If (getAnimationOffset() = 1) Then
				yOffset = -960
			Else
				yOffset = -320
			EndIf
			
			switchDegree = 0
		EndIf
		
		Self.checkPositionX = getNewPointX(Self.footPointX, 0, (-RECT_HEIGHT) / 2, switchDegree) + 0
		Self.checkPositionY = getNewPointY(Self.footPointY, 0, (-RECT_HEIGHT) / 2, switchDegree) + yOffset
		Self.collisionRect.setTwoPosition(Self.checkPositionX - (RECT_WIDTH / 2), Self.checkPositionY - (RECT_HEIGHT / 2), Self.checkPositionX + (RECT_WIDTH / 2), Self.checkPositionY + (RECT_HEIGHT / 2))
	End
	
	Public Method getCollisionRectWidth:Int()
		
		If (Self.animationID = ANI_RAIL_ROLL) Then
			Return HEIGHT
		EndIf
		
		Return WIDTH
	End
	
	Public Method getCollisionRectHeight:Int()
		
		If (Self.animationID = 4 Or Self.animationID = MAX_ITEM Or Self.animationID = ANI_SQUAT_PROCESS Or Self.animationID = 6 Or Self.animationID = ITEM_RING_10 Or Self.animationID = MOON_STAR_ORI_Y_1 Or Self.animationID = ANI_ATTACK_2 Or Self.animationID = SPIN_KEY_COUNT) Then
			Return BarHorbinV.HOBIN_POWER
		EndIf
		
		Return HEIGHT
	End
	
	Public Method refreshCollisionRect:Void(x:Int, y:Int)
		' Empty implementation.
	End
	
	Public Method fallChk:Void()
		
		If (Self.fallTime > 0) Then
			Self.fallTime -= 1
			
			If (Self.animationID = ANI_STAND) Then
				Self.animationID = 1
				Return
			EndIf
			
			Return
		EndIf
		
		If (Self.isAntiGravity Or Self.faceDegree < ANI_DEAD_PRE Or Self.faceDegree > 315) Then
			If (Not Self.isAntiGravity) Then
				Return
			EndIf
			
			If (Self.faceDegree > StringIndex.FONT_COLON_RED And Self.faceDegree < 225) Then
				Return
			EndIf
		EndIf
		
		If (Abs(Self.totalVelocity) < 474) Then
			If (Self.totalVelocity = 0) Then
				calDivideVelocity()
				Self.velY += getGravity()
				calTotalVelocity()
			EndIf
			
			Self.fallTime = ITEM_RING_10
		EndIf
		
	End
	
	Public Method railIn:Void(x:Int, y:Int)
		Self.railLine = Null
		Self.velY = 0
		Self.velX = 0
		Self.worldCal.stopMoveX()
		setFootPositionX(x)
		Self.collisionChkBreak = True
		Self.railing = True
		Self.railOut = False
		Self.animationID = ANI_RAIL_ROLL
		setNoKey()
		
		If (characterID = CHARACTER_AMY) Then
			soundInstance.playSe(ANI_ROPE_ROLL_1)
		Else
			soundInstance.playSe(ANI_SMALL_ZERO_Y)
		EndIf
		
	End
	
	Public Method railOut:Void(x:Int, y:Int)
		
		If (Self.railing) Then
			Self.railOut = True
			Self.railLine = Null
			Self.velY = RAIL_OUT_SPEED_VY0
			Self.velX = 0
			setVelX(0)
			setFootPositionX(x)
			setFootPositionY(y)
			Self.collisionChkBreak = True
			Self.animationID = 4
		EndIf
		
	End
	
	Public Method pipeIn:Void(x:Int, y:Int, vx:Int, vy:Int)
		Self.piping = True
		Self.pipeState = TER_STATE_RUN
		Self.pipeDesX = x
		Self.pipeDesY = y + BODY_OFFSET
		Self.velX = 250
		Self.velY = 250
		Self.nextVelX = (vx Shl 6) / 1
		Self.nextVelY = (vy Shl 6) / 1
		Self.collisionChkBreak = True
	End
	
	Public Method pipeSet:Void(x:Int, y:Int, vx:Int, vy:Int)
		
		If (Self.piping) Then
			Self.pipeDesX = x
			Self.pipeDesY = y + BODY_OFFSET
			Int degree = crlFP32.actTanDegree(vy, vx)
			Int sourceSpeed = crlFP32.sqrt((vy * vy) + (vx * vx)) Shr 6
			Self.nextVelX = vx
			Self.nextVelY = vy
			Self.pipeState = TER_STATE_LOOK_MOON
			
			If (Self.velX > 0 And Self.footPointX > Self.pipeDesX) Then
				Self.footPointX = Self.pipeDesX
			EndIf
			
			If (Self.velX < 0 And Self.footPointX < Self.pipeDesX) Then
				Self.footPointX = Self.pipeDesX
			EndIf
			
			If (Self.velY > 0 And Self.footPointY > Self.pipeDesY) Then
				Self.footPointY = Self.pipeDesY
			EndIf
			
			If (Self.velY < 0 And Self.footPointY < Self.pipeDesY) Then
				Self.footPointY = Self.pipeDesY
			EndIf
			
			Self.collisionChkBreak = True
			Return
		EndIf
		
		Self.footPointX = x
		Self.footPointY = y
		degree = crlFP32.actTanDegree(vy, vx)
		sourceSpeed = crlFP32.sqrt((vy * vy) + (vx * vx)) Shr 6
		Self.nextVelX = vx
		Self.nextVelY = vy
		Self.velX = vx
		Self.velY = vy
		Self.pipeState = 1
		Self.piping = True
		Self.collisionChkBreak = True
		Self.worldCal.stopMove()
	End
	
	Public Method pipeOut:Void()
		
		If (Self.piping) Then
			Self.piping = False
			Self.collisionState = COLLISION_STATE_JUMP
			Self.worldCal.actionState = 1
		EndIf
		
	End
	
	Public Method setFall:Void(x:Int, y:Int, left:Int, top:Int)
		
		If (Self instanceof PlayerTails) Then
			((PlayerTails) Self).stopFly()
		EndIf
		
		Self.railing = True
		setFootPositionX(x)
		Self.velX = 0
		Self.velY = 0
		Self.railLine = Null
		Self.collisionChkBreak = True
	End
	
	Public Method setFallOver:Void()
		Self.railing = False
	End
	
	Public Method setRailFlip:Void()
		Self.velX = 0
		Self.velY = RAIL_FLIPPER_V0
		Self.railLine = Null
		Self.collisionChkBreak = True
		Self.railFlipping = True
		SoundSystem.getInstance().playSe(54)
	End
	
	Public Method setRailLine:Bool(line:Line, startX:Int, startY:Int, railDivX:Int, railDivY:Int, railDevX:Int, railDevY:Int, obj:GameObject)
		
		If (Not obj.getCollisionRect().collisionChk(Self.footPointX, Self.footPointY)) Then
			Return False
		EndIf
		
		If (Not Self.railing Or Self.velY < 0) Then
			Return False
		EndIf
		
		If (Self.railLine = Null) Then
			Self.totalVelocity = 0
		EndIf
		
		Self.railLine = line
		calDivideVelocity()
		Self.posX = startX
		Self.posY = startY
		
		If (Abs(railDivY) <= 1) Then
			Self.velX = (railDivX * SONIC_DRAW_HEIGHT) / railDevX
			Self.velY = 0
			
			If (Self.railFlipping) Then
				Self.railFlipping = False
				setFootPositionY(Self.railLine.getY(Self.footPointX) + BODY_OFFSET)
			Else
				setFootPositionY((Self.railLine.getY(Self.footPointX) - RIGHT_WALK_COLLISION_CHECK_OFFSET_X) + BODY_OFFSET)
			EndIf
			
		Else
			Self.velX = (railDivX * SONIC_DRAW_HEIGHT) / railDevX
			Self.velY = (railDivY * SONIC_DRAW_HEIGHT) / railDevY
			setFootPositionY(Self.railLine.getY(Self.footPointX) + BODY_OFFSET)
		EndIf
		
		calTotalVelocity()
		Print("~~1velX:" + Self.velX + "|velY:" + Self.velY)
		Self.collisionChkBreak = True
		Return True
	End
	
	Public Method checkWithObject:Void(preX:Int, preY:Int, currentX:Int, currentY:Int)
		Int moveDistanceX = currentX - preX
		Int moveDistanceY = currentY - preY
		
		If (moveDistanceX = 0 And moveDistanceY = 0) Then
			Self.footPointX = currentX
			Self.footPointY = currentY
			Return
		EndIf
		
		Int moveDistance
		
		If (Abs(moveDistanceX) >= Abs(moveDistanceY) ? True : False) Then
			moveDistance = Abs(moveDistanceX)
		Else
			moveDistance = Abs(moveDistanceY)
		EndIf
		
		Int preCheckX = preX
		Int preCheckY = preY
		Int i = 0
		While (i <= moveDistance And i < moveDistance) {
			i += RIGHT_WALK_COLLISION_CHECK_OFFSET_X
			
			If (i >= moveDistance) Then
				i = moveDistance
			EndIf
			
			Int tmpCurrentX = preX + ((moveDistanceX * i) / moveDistance)
			Int tmpCurrentY = preY + ((moveDistanceY * i) / moveDistance)
			player.moveDistance.x = (tmpCurrentX Shr 6) - (preCheckX Shr 6)
			player.moveDistance.y = (tmpCurrentY Shr 6) - (preCheckY Shr 6)
			Self.footPointX = tmpCurrentX
			Self.footPointY = tmpCurrentY
			collisionCheckWithGameObject(tmpCurrentX, tmpCurrentY)
			
			If (Not Self.collisionChkBreak) Then
				preCheckX = tmpCurrentX
				preCheckY = tmpCurrentY
			Else
				Return
			EndIf
			
		End
	End
	
	Public Method cancelFootObject:Void(object:GameObject)
		
		If (Self.collisionState = COLLISION_STATE_ON_OBJECT And isFootOnObject(object)) Then
			player.collisionState = COLLISION_STATE_JUMP
			player.footOnObject = Null
			Self.onObjectContinue = False
		EndIf
		
	End
	
	Public Method cancelFootObject:Void()
		
		If (Self.collisionState = COLLISION_STATE_ON_OBJECT) Then
			player.footOnObject = Null
			Self.onObjectContinue = False
		EndIf
		
	End
	
	Public Method doItemAttackPose:Void(object:GameObject, direction:Int)
		
		If (Not Self.extraAttackFlag) Then
			Int i
			Int maxPower = Self.isPowerShoot ? SHOOT_POWER : MIN_ATTACK_JUMP
			
			If (Self.isAntiGravity) Then
				i = 1
			Else
				i = -1
			EndIf
			
			Int newVelY = i * getVelY()
			
			If (newVelY > 0) Then
				newVelY = -newVelY
			ElseIf (newVelY > maxPower) Then
				newVelY = maxPower
			EndIf
			
			If (Self.doJumpForwardly) Then
				newVelY = maxPower
			EndIf
			
			If (characterID <> 2 Or Self.myAnimationID < ANI_ATTACK_2 Or Self.myAnimationID > ANI_BAR_ROLL_1) Then
				setVelY((Self.isAntiGravity ? -1 : 1) * newVelY)
			EndIf
			
			If (characterID <> 3) Then
				Select (direction)
					Case 1
						cancelFootObject(Self)
						Self.collisionState = COLLISION_STATE_JUMP
						Self.animationID = 4
						break
				End Select
			EndIf
			
			If (Self.isPowerShoot) Then
				Self.isPowerShoot = False
			EndIf
		EndIf
		
	End
	
	Public Method doAttackPose:Void(object:GameObject, direction:Int)
		
		If (Not Self.extraAttackFlag) Then
			Int newVelY = (Self.isAntiGravity ? 1 : -1) * getVelY()
			
			If (newVelY > 0) Then
				newVelY = -newVelY
			ElseIf (newVelY > MIN_ATTACK_JUMP) Then
				newVelY = MIN_ATTACK_JUMP
			EndIf
			
			If (Self.doJumpForwardly) Then
				newVelY = MIN_ATTACK_JUMP
			EndIf
			
			If (characterID <> 3) Then
				setVelY((Self.isAntiGravity ? -1 : 1) * newVelY)
			ElseIf (Not IsInvincibility() Or Self.myAnimationID < ANI_POP_JUMP_UP Or Self.myAnimationID > ANI_BRAKE) Then
				Int i
				
				If (Self.isAntiGravity) Then
					i = -1
				Else
					i = 1
				EndIf
				
				setVelY(i * newVelY)
			EndIf
			
			If (characterID <> 3) Then
				Select (direction)
					Case 1
						cancelFootObject(Self)
						Self.collisionState = COLLISION_STATE_JUMP
					Default
				End Select
			EndIf
		EndIf
		
	End
	
	Public Method doBossAttackPose:Void(object:GameObject, direction:Int)
		
		If (Self.collisionState = COLLISION_STATE_JUMP) Then
			If (characterID <> 3) Then
				setVelX(-Self.velX)
			EndIf
			
			If ((-Self.velY) < (-ATTACK_POP_POWER)) Then
				setVelY(-ATTACK_POP_POWER)
			ElseIf (characterID <> 2) Then
				setVelY(-Self.velY)
			ElseIf (getCharacterAnimationID() = ANI_ATTACK_2 Or getCharacterAnimationID() = SPIN_KEY_COUNT Or getCharacterAnimationID() = ANI_RAIL_ROLL Or getCharacterAnimationID() = ANI_BAR_ROLL_1) Then
				setVelY((-Self.velY) - 325)
			Else
				setVelY(-Self.velY)
			EndIf
		EndIf
		
	End
	
	Public Method inRailState:Bool()
		Return (Self.railing Or Self.railOut) ? True : False
	End
	
	Public Method changeVisible:Void(mVisible:Bool)
		Self.visible = mVisible
	End
	
	Public Method setOutOfControl:Void(object:GameObject)
		Self.outOfControl = True
		Self.outOfControlObject = object
		Self.piping = False
	End
	
	Public Method setOutOfControlInPipe:Void(object:GameObject)
		Self.outOfControl = True
		Self.outOfControlObject = object
	End
	
	Public Method releaseOutOfControl:Void()
		Self.outOfControl = False
		Self.outOfControlObject = Null
	End
	
	Public Method isControlObject:Bool(object:GameObject)
		Return (Self.controlObjectLogic And object = Self.outOfControlObject) ? True : False
	End
	
	Public Method setDieInit:Void(isDrowning:Bool, v0:Int)
		Self.velX = 0
		
		If (Not isDrowning Or Self.breatheNumCount < 6) Then
			Self.velY = v0
		Else
			Self.velY = 0
		EndIf
		
		If (Self.isAntiGravity) Then
			Self.velY = -Self.velY
		EndIf
		
		Int i = Self.degreeStable
		Self.faceDegree = i
		Self.degreeForDraw = i
		Self.collisionState = COLLISION_STATE_JUMP
		MapManager.setFocusObj(Null)
		Self.isDead = True
		Self.finishDeadStuff = False
		Self.animationID = ANI_DEAD_PRE
		Self.drawer.restart()
		timeStopped = True
		Self.worldCal.stopMove()
		Self.collisionChkBreak = True
		Self.hurtCount = 0
		Self.dashRolling = False
		
		If (Self.effectID = 0 Or Self.effectID = 1) Then
			Self.effectID = -1
		EndIf
		
		Self.drownCnt = 0
		
		If (stageModeState = 1 And StageManager.getStageID() = TERMINAL_COUNT) Then
			RocketSeparateEffect.clearInstance()
		EndIf
		
		GameState.isThroughGame = True
		shieldType = 0
		invincibleCount = 0
		speedCount = 0
		
		If (Self.currentLayer = 0) Then
			Self.currentLayer = 1
		ElseIf (Self.currentLayer = 1) Then
			Self.currentLayer = 0
		EndIf
		
		resetFlyCount()
	End
	
	/* JADX WARNING: inconsistent code. */
	/* Code decompiled incorrectly, please refer to instructions dump. */
	Public Method setDie:Void(r3:Bool, r4:Int)
		/*
		r2 = Self
		r2.setDieInit(r3, r4)
		r0 = lib.soundsystem.getInstance()
		r0 = r0.getPlayingBGMIndex()
		lib.soundsystem.getInstance()
		r1 = 21
		
		If (r0 = r1) goto L_0x0021
	L_0x0012:
		r0 = lib.soundsystem.getInstance()
		r0 = r0.getPlayingBGMIndex()
		lib.soundsystem.getInstance()
		r1 = 44
		
		If (r0 <> r1) goto L_0x0029
	L_0x0021:
		r0 = lib.soundsystem.getInstance()
		r1 = 0
		r0.stopBgm(r1)
	L_0x0029:
		
		If (r3 <> 0) goto L_0x0033
	L_0x002b:
		r0 = soundInstance
		r1 = 14
		r0.playSe(r1)
	L_0x0032:
		Return
	L_0x0033:
		r0 = soundInstance
		r1 = 60
		r0.playSe(r1)
		goto L_0x0032
		*/
		throw New UnsupportedOperationException("Method not decompiled: SonicGBA.PlayerObject.setDie(Bool, Int):Void")
		' Empty implementation.
	End
	
	Public Method setDieWithoutSE:Void()
		setDieInit(False, DIE_DRIP_STATE_JUMP_V0)
	End
	
	Public Method setDie:Void(isDrowning:Bool)
		setDie(isDrowning, DIE_DRIP_STATE_JUMP_V0)
	End
	
	Public Method setNoKey:Void()
		Self.noKeyFlag = True
	End
	
	Public Method setCollisionState:Void(state:Byte)
		
		If (Self.collisionState = Null) Then
			calDivideVelocity()
		EndIf
		
		Select (state)
			Case 1
				Self.faceDegree = Self.degreeStable
				Self.worldCal.actionState = 1
				break
		EndIf
		Self.collisionState = state
	End
	
	Public Method setSlip:Void()
		
		If (Self.collisionState = Null) Then
			Self.slipFlag = True
			Self.showWaterFlush = True
			Self.animationID = ANI_YELL
			setNoKey()
		EndIf
		
	End
	
	Public Method beUnseenPop:Bool()
		
		If (Self.collisionState <> Null Or Abs(getVelX()) <= WIDTH) Then
			Return False
		EndIf
		
		beSpring(getGravity() + DETECT_HEIGHT, 1)
		Int nextVelX = DETECT_HEIGHT
		
		If (DETECT_HEIGHT > HINER_JUMP_MAX) Then
			nextVelX = HINER_JUMP_MAX
		EndIf
		
		If (getVelX() > 0) Then
			beSpring(nextVelX, 2)
		Else
			beSpring(nextVelX, 3)
		EndIf
		
		SoundSystem.getInstance().playSequenceSe(ANI_SMALL_ZERO_Y)
		Return True
	End
	
	Public Method setBank:Void()
		Self.onBank = Self.onBank ? False : True
		
		If (Self.onBank And Self.collisionState = Null) Then
			calDivideVelocity()
		EndIf
		
	End
	
	Public Method bankLogic:Void()
		
		If (Self.onBank) Then
			Self.faceDegree = 0
			inputLogicWalk()
			
			If (Self.onBank) Then
				calDivideVelocity()
				Self.velY = 0
				Int preX = player.getFootPositionX()
				Int preY = player.getFootPositionY()
				Self.footPointX += Self.velX
				Int yLimit = CENTER_Y - (((Cos((((Self.footPointX - CENTER_X) * B_1) / B_2) Shr 6) * f24C) / 100) + f24C)
				decelerate()
				Int velX = player.getVelX()
				
				If (Abs(velX) > BANKING_MIN_SPEED) Then
					player.setFootPositionY(Math.max(yLimit, player.getFootPositionY() - ((Abs(velX) * TitleState.RETURN_PRESSED) / BANKING_MIN_SPEED)))
				Else
					player.setFootPositionY(Math.min(CENTER_Y, player.getFootPositionY() + BPDef.PRICE_REVIVE))
					
					If (Self.footPointY >= CENTER_Y) Then
						Self.onBank = False
						Self.collisionState = COLLISION_STATE_JUMP
						Self.worldCal.actionState = 1
						Self.bankwalking = False
					EndIf
				EndIf
				
				If (Self.animationID <> 4) Then
					If (Abs(velX) <= BANKING_MIN_SPEED) Then
						Self.onBank = False
						Self.collisionState = COLLISION_STATE_JUMP
						Self.worldCal.actionState = 1
						doDripInAir()
					ElseIf (Self.footPointY < 61184) Then
						Self.animationID = ANI_BANK_3
					ElseIf (Self.footPointY < 61952) Then
						Self.animationID = ANI_BANK_2
					ElseIf (Self.footPointY < 62720) Then
						Self.animationID = LOOK_COUNT
					EndIf
				EndIf
				
				checkWithObject(preX, preY, Self.footPointX, Self.footPointY)
			EndIf
		EndIf
		
	End
	
	Public Method setTerminal:Void(type:Int)
		Self.terminalOffset = 0
		terminalType = type
		Self.terminalCount = TERMINAL_COUNT
		isTerminal = True
		timeStopped = True
		Select (terminalType)
			Case 0
			Case 2
				
				If (Self.collisionState = Null) Then
					If (Self.animationID = 4) Then
						land()
					EndIf
					
					If (Self.totalVelocity > MAX_VELOCITY) Then
						Self.totalVelocity = MAX_VELOCITY
					EndIf
				EndIf
				
			Case 1
				changeVisible(False)
				Self.noMoving = True
			Case 3
				terminalState = TER_STATE_RUN
			Default
		EndIf
	End
	
	Public Method setTerminalSingle:Void(type:Int)
		terminalType = type
		Self.terminalCount = TERMINAL_COUNT
		isTerminal = True
		timeStopped = True
	End
	
	Public Method isTerminalRunRight:Bool()
		Return (isTerminal And (terminalType = 0 Or terminalType = 2 Or (terminalType = 3 And terminalState = Null And Self.posX < SUPER_SONIC_STAND_POS_X))) ? True : False
	End
	
	Public Method doBrake:Bool()
		Return (isTerminal And terminalType = 3 And terminalState = 1 And Self.posX > SUPER_SONIC_STAND_POS_X And Self.totalVelocity > 0) ? True : False
	End
	
	Public Method beTrans:Void(desX:Int, desY:Int)
		Self.animationID = 4
		Self.collisionState = COLLISION_STATE_JUMP
		Self.transing = True
		setBodyPositionX(desX)
		setBodyPositionY(desY)
		MapManager.setCameraMoving()
		calPreCollisionRect()
	End
	
	Public Method setCelebrate:Void()
		timeStopped = True
		Self.isCelebrate = True
		MapManager.setCameraLeftLimit(MapManager.getCamera().x)
		MapManager.setCameraRightLimit(MapManager.getCamera().x + MapManager.CAMERA_WIDTH)
		
		If (Self.faceDirection) Then
			Self.moveLimit = Self.posX + 3840
		Else
			Self.moveLimit = Self.posX - 3840
		EndIf
		
	End
	
	Public Method getPreItem:Void(itemId:Int)
		For (Int i = 0; i < MAX_ITEM; i += 1)
			If (itemVec[i][0] = -1) Then
				itemVec[i][0] = itemId
				itemVec[i][1] = SPIN_KEY_COUNT
				Return
			EndIf
		Next
	End
	
	Public Method getItem:Void(itemId:Int)
		Select (itemId)
			Case 0
				addLife()
				playerLifeUpBGM()
			Case 1
				shieldType = 1
				soundInstance.playSe(ANI_DEAD)
			Case 2
				shieldType = 2
				soundInstance.playSe(ANI_DEAD)
			Case 3
				invincibleCount = INVINCIBLE_COUNT
				SoundSystem.getInstance().stopBgm(False)
				SoundSystem.getInstance().playBgm(ANI_HURT_PRE)
			Case 4
				speedCount = INVINCIBLE_COUNT
				SoundSystem.getInstance().setSoundSpeed(2.0)
				
				If (SoundSystem.getInstance().getPlayingBGMIndex() <> ANI_POP_JUMP_DOWN_SLOW) Then
					SoundSystem.getInstance().restartBgm()
				EndIf
				
			Case MAX_ITEM
				
				If (Self.hurtCount = 0) Then
					getRing(ringRandomNum)
				EndIf
				
			Case 6
				
				If (Self.hurtCount = 0) Then
					getRing(MAX_ITEM)
				EndIf
				
			Case ITEM_RING_10
				
				If (Self.hurtCount = 0) Then
					getRing(TERMINAL_COUNT)
				EndIf
				
			Default
		End Select
	End
	
	Public Function getTmpRing:Void(itemId:Int)
		Select (itemId)
			Case MAX_ITEM
				ringTmpNum = RANDOM_RING_NUM[MyRandom.nextInt(RANDOM_RING_NUM.length)]
				ringRandomNum = ringTmpNum
			Case 6
				ringTmpNum = MAX_ITEM
			Case ITEM_RING_10
				ringTmpNum = TERMINAL_COUNT
			Default
		End Select
	End
	
	Public Function getRing:Void(num:Int)
		Int preRingNum = ringNum
		ringNum += num
		
		If (stageModeState <> 1 And StageManager.getCurrentZoneId() <> ANI_PUSH_WALL) Then
			If (preRingNum / 100 <> ringNum / 100) Then
				addLife()
				playerLifeUpBGM()
			EndIf
			
			If (ringTmpNum <> 0) Then
				ringTmpNum = 0
			EndIf
		EndIf
		
	End
	
	Public Method isAttracting:Bool()
		Return shieldType = 2 ? True : False
	End
	
	Public Method getEnemyScore:Void()
		scoreNum += 100
		raceScoreNum += 100
	End
	
	Public Method getBossScore:Void()
		scoreNum += 1000
		raceScoreNum += 1000
	End
	
	Public Method getBallHobinScore:Void()
		scoreNum += TERMINAL_COUNT
		raceScoreNum += TERMINAL_COUNT
	End
	
	Public Method ductIn:Void()
		Self.ducting = True
		Self.pushOnce = True
		Self.ductingCount = 0
	End
	
	Public Method ductOut:Void()
		Self.ducting = False
		Self.pushOnce = False
		Self.ductingCount = 0
	End
	
	Public Method setSqueezeEnable:Void(enable:Bool)
		Self.squeezeFlag = enable
	End
	
	Protected Method isHeadCollision:Bool()
		Bool collision = False
		Int headBlockY = Self.worldInstance.getWorldY(Self.footPointX, Self.footPointY - HEIGHT, 1, 2)
		Int headBlockY2 = Self.worldInstance.getWorldY(Self.footPointX + WIDTH, Self.footPointY - HEIGHT, 1, 2)
		
		If (headBlockY >= 0) Then
			collision = True
		EndIf
		
		If (headBlockY2 >= 0) Then
			Return True
		EndIf
		
		Return collision
	End
	
	Public Function addLife:Void()
		lifeNum += 1
	End
	
	Public Function minusLife:Void()
		lifeNum -= 1
	End
	
	Public Function getLife:Int()
		Return lifeNum
	End
	
	Public Function setLife:Void(num:Int)
		lifeNum = num
	End
	
	Public Function setScore:Void(num:Int)
		scoreNum = num
	End
	
	Public Function getScore:Int()
		Return scoreNum
	End
	
	Public Function resetGameParam:Void()
		scoreNum = 0
		lifeNum = 2
	End
	
	Public Method resetPlayer:Void()
		Self.footPointX = Self.deadPosX
		Self.footPointY = Self.deadPosY
		Self.worldCal.stopMove()
		StageManager.resetStageGameover()
		Self.velX = 0
		Self.velY = 0
		setVelX(Self.velX)
		setVelY(Self.velY)
		Self.totalVelocity = 0
		Self.collisionState = TER_STATE_RUN
		MapManager.setFocusObj(Self)
		MapManager.focusQuickLocation()
		Self.isDead = False
		Self.animationID = ANI_STAND
		timeStopped = False
		invincibleCount = SSDef.PLAYER_MOVE_HEIGHT
		preScoreNum = scoreNum
		preLifeNum = lifeNum
		timeCount = 0
		lastTimeCount = timeCount
	End
	
	Public Function doInitInNewStage:Void()
		currentMarkId = 0
	End
	
	Public Function initStageParam:Void()
		ringNum = 0
		invincibleCount = 0
		speedCount = 0
		SoundSystem.getInstance().setSoundSpeed(1.0)
		shieldType = 0
		timeCount = 0
		lastTimeCount = timeCount
		timeStopped = False
		raceScoreNum = 0
		preScoreNum = scoreNum
		preLifeNum = lifeNum
		For (Int i = 0; i < MAX_ITEM; i += 1)
			itemVec[i][0] = -1
		End Select
		setOverCount(SonicDef.OVER_TIME)
	End
	
	Public Function initSpParam:Void(param_ringNum:Int, checkPointID:Int, param_timeCount:Int)
		
		If (player <> Null) Then
			currentMarkId = checkPointID
		EndIf
		
		ringNum = param_ringNum
		timeCount = param_timeCount
		lastTimeCount = timeCount
	End
	
	Public Function doPauseLeaveGame:Void()
		scoreNum = preScoreNum
		lifeNum = preLifeNum
	End
	
	Public Method headInit:Void()
		
		If (GameState.guiAnimation = Null) Then
			GameState.guiAnimation = New Animation("/animation/gui")
		EndIf
		
		headDrawer = GameState.guiAnimation.getDrawer(characterID, False, 0)
		Self.isAttackBoss4 = False
	End
	
	Public Function drawGameUI:Void(g:MFGraphics)
		
		If (Not isTerminal Or terminalType <> 3 Or terminalState <= TER_STATE_LOOK_MOON_WAIT) Then
			GameState.guiAniDrawer.draw(g, MAX_ITEM, uiOffsetX + 0, 0, False, 0)
			Int i = ringNum
			Int i2 = uiOffsetX + SPIN_LV2_COUNT
			Int i3 = (ringNum = 0 And (timeCount / SSDef.PLAYER_MOVE_HEIGHT) Mod 2 = 0) ? 3 : 0
			drawNum(g, i, i2, 15, 0, i3)
			drawNum(g, stageModeState = 1 ? raceScoreNum : scoreNum, NumberSideX + uiOffsetX, ANI_PUSH_WALL, 2, 0)
			timeDraw(g, NumberSideX + uiOffsetX, ANI_BAR_ROLL_1)
			
			If (stageModeState <> 1) Then
				If (StageManager.getCurrentZoneId() = ANI_PUSH_WALL) Then
					If (player.isDead) Then
						headDrawer.setActionId(0)
					Else
						headDrawer.setActionId(4)
					EndIf
				EndIf
				
				headDrawer.draw(g, SCREEN_WIDTH, 0)
				drawNum(g, lifeNum >= ANI_ROTATE_JUMP ? ANI_ROTATE_JUMP : lifeNum, SCREEN_WIDTH - ANI_ROTATE_JUMP, 4, SPIN_LV2_COUNT, 0)
			EndIf
		EndIf
		
	End
	
	Public Function drawNum:Void(g:MFGraphics, num:Int, x:Int, y:Int, anchor:Int, type:Int)
		Int divideNum = TERMINAL_COUNT
		Int blockNum = 1
		Int i = 0
		While (num / divideNum <> 0) {
			blockNum += 1
			divideNum *= TERMINAL_COUNT
			i += 1
		End Select
		divideNum /= TERMINAL_COUNT
		Int localanchor = 0
		Select (anchor)
			Case 0
				localanchor = ANI_BANK_3
				break
			Case 1
				localanchor = ANI_BANK_2
				break
			Case 2
				localanchor = SPIN_LV2_COUNT_CONF
				break
		End Select
		Int localtype = 0
		Select (type)
			Case 0
				localtype = 0
				break
			Case 1
				localtype = 1
				break
			Case 2
				localtype = 3
				break
			Case 3
				localtype = 2
				break
			Case 4
				localtype = 1
				break
		End Select
		NumberDrawer.drawNum(g, localtype, num, x, y, localanchor)
	End
	
	Public Function drawNum:Void(g:MFGraphics, num:Int, x:Int, y:Int, anchor:Int, type:Int, blockNum:Int)
		Int i
		
		If (numDrawer = Null) Then
			numDrawer = GlobalResource.statusAnimation.getDrawer(0, False, 0)
		EndIf
		
		Int divideNum = 1
		For (i = 1; i < blockNum; i += 1)
			divideNum *= TERMINAL_COUNT
		Next
		Int leftPosition = 0
		Select (anchor)
			Case 0
				leftPosition = x - ((NUM_SPACE[type] * (blockNum - 1)) / 2)
				break
			Case 1
				leftPosition = x
				break
			Case 2
				leftPosition = x - (NUM_SPACE[type] * (blockNum - 1))
				break
		End Select
		For (i = 0; i < blockNum; i += 1)
			Int tmpNum = Abs(num / divideNum) Mod TERMINAL_COUNT
			divideNum /= TERMINAL_COUNT
			
			If (type = 3 And tmpNum = 0) Then
				numDrawer.setActionId(MOON_STAR_DES_Y_1)
			Else
				numDrawer.setActionId(NUM_ANI_ID[type] + tmpNum)
			EndIf
			
			numDrawer.draw(g, (NUM_SPACE[type] * i) + leftPosition, y)
		Next
	End
	
	Public Function timeLogic:Void()
		
		If (Not timeStopped) Then
			If (overTime > timeCount) Then
				timeCount += 60
				
				If (timeCount > overTime) Then
					timeCount = overTime
				EndIf
				
				If (GlobalResource.timeIsLimit()) Then
					If (overTime - timeCount <= BREATHE_TIME_COUNT) Then
						If (timeCount / 1000 <> preTimeCount) Then
							SoundSystem.getInstance().playSe(ANI_YELL)
						EndIf
						
						preTimeCount = timeCount / 1000
					EndIf
					
					If (timeCount = overTime And player <> Null) Then
						If (stageModeState = 1) Then
							player.setDie(False)
							StageManager.setStageTimeover()
							StageManager.checkPointTime = 0
						ElseIf (lifeNum > 0) Then
							player.setDie(False)
							StageManager.setStageTimeover()
							StageManager.checkPointTime = 0
							minusLife()
						Else
							player.setDie(False)
							StageManager.setStageGameover()
						EndIf
					EndIf
					
				ElseIf (stageModeState = 1) Then
					If (overTime - timeCount <= BREATHE_TIME_COUNT) Then
						If (timeCount / 1000 <> preTimeCount) Then
							SoundSystem.getInstance().playSe(ANI_YELL)
						EndIf
						
						preTimeCount = timeCount / 1000
					EndIf
					
					If (timeCount = overTime And player <> Null) Then
						If (stageModeState = 1) Then
							player.setDie(False)
							StageManager.setStageTimeover()
							StageManager.checkPointTime = 0
						ElseIf (lifeNum > 0) Then
							player.setDie(False)
							StageManager.setStageTimeover()
							StageManager.checkPointTime = 0
							minusLife()
						Else
							player.setDie(False)
							StageManager.setStageGameover()
						EndIf
					EndIf
				EndIf
				
			ElseIf (overTime < timeCount) Then
				timeCount -= 60
				
				If (timeCount < overTime) Then
					timeCount = overTime
				EndIf
				
				If (GlobalResource.timeIsLimit()) Then
					If (timeCount <= BREATHE_TIME_COUNT) Then
						If (timeCount / 1000 <> preTimeCount) Then
							SoundSystem.getInstance().playSe(ANI_YELL)
						EndIf
						
						preTimeCount = timeCount / 1000
					EndIf
					
					If (timeCount = overTime And player <> Null) Then
						If (stageModeState = 1) Then
							player.setDie(False)
							StageManager.setStageTimeover()
							StageManager.checkPointTime = 0
						ElseIf (lifeNum > 0) Then
							player.setDie(False)
							StageManager.setStageTimeover()
							StageManager.checkPointTime = 0
							minusLife()
						Else
							player.setDie(False)
							StageManager.setStageGameover()
						EndIf
					EndIf
					
				ElseIf (stageModeState = 1) Then
					If (timeCount <= BREATHE_TIME_COUNT) Then
						If (timeCount / 1000 <> preTimeCount) Then
							SoundSystem.getInstance().playSe(ANI_YELL)
						EndIf
						
						preTimeCount = timeCount / 1000
					EndIf
					
					If (timeCount = overTime And player <> Null) Then
						If (stageModeState = 1) Then
							player.setDie(False)
							StageManager.setStageTimeover()
							StageManager.checkPointTime = 0
						ElseIf (lifeNum > 0) Then
							player.setDie(False)
							StageManager.setStageTimeover()
							StageManager.checkPointTime = 0
							minusLife()
						Else
							player.setDie(False)
							StageManager.setStageGameover()
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
		
	End
	
	Public Function setTimeCount:Void(min:Int, sec:Int, msec:Int)
		timeCount = (((min * 60) * 1000) + (sec * 1000)) + msec
		lastTimeCount = timeCount
	End
	
	Public Function setTimeCount:Void(count:Int)
		timeCount = count
		lastTimeCount = timeCount
	End
	
	Public Function setOverCount:Void(min:Int, sec:Int, msec:Int)
		overTime = (((min * 60) * 1000) + (sec * 1000)) + msec
	End
	
	Public Function setOverCount:Void(count:Int)
		overTime = count
	End
	
	Public Function getTimeCount:Int()
		Return timeCount
	End
	
	Public Function timeDraw:Void(g:MFGraphics, x:Int, y:Int)
		Int min = timeCount / 60000
		Int sec = (timeCount Mod 60000) / 1000
		Int msec = ((timeCount Mod 60000) Mod 1000) / TERMINAL_COUNT
		Int numType = 0
		
		If ((GlobalResource.timeIsLimit() Or stageModeState = 1) And (((overTime > timeCount And timeCount > 540000) Or (overTime < timeCount And timeCount < 60000)) And (timeCount / SSDef.PLAYER_MOVE_HEIGHT) Mod 2 = 0)) Then
			numType = 3
		EndIf
		
		If (msec < TERMINAL_COUNT) Then
			drawNum(g, 0, x - NUM_SPACE[numType], y, 2, numType)
		EndIf
		
		drawNum(g, msec, x, y, 2, numType)
		NumberDrawer.drawColon(g, numType = 3 ? 2 : 0, (x - (NUM_SPACE[numType] * 2)) - (NUM_SPACE[numType] / 2), y, ANI_BANK_3)
		
		If (sec < TERMINAL_COUNT) Then
			drawNum(g, 0, x - (NUM_SPACE[numType] * 4), y, 2, numType)
		EndIf
		
		drawNum(g, sec, x - (NUM_SPACE[numType] * 3), y, 2, numType)
		NumberDrawer.drawColon(g, numType = 3 ? 2 : 0, (x - (NUM_SPACE[numType] * MAX_ITEM)) - (NUM_SPACE[numType] / 2), y, ANI_BANK_3)
		drawNum(g, min, x - (NUM_SPACE[numType] * 6), y, 2, numType)
	End
	
	Public Function drawRecordTime:Void(g:MFGraphics, timeCount:Int, x:Int, y:Int, numType:Int, anchor:Int)
		Int min = timeCount / 60000
		Int sec = (timeCount Mod 60000) / 1000
		timeCount = ((timeCount Mod 60000) Mod 1000) / TERMINAL_COUNT
		Select (anchor)
			Case 0
				x += (NUM_SPACE[numType] * ITEM_RING_10) / 2
				break
			Case 1
				x += NUM_SPACE[numType] * ITEM_RING_10
				break
		End Select
		
		If (timeCount < TERMINAL_COUNT) Then
			drawNum(g, 0, x - NUM_SPACE[numType], y, 2, numType)
		EndIf
		
		drawNum(g, timeCount, x, y, 2, numType)
		NumberDrawer.drawColon(g, 3, (x - (NUM_SPACE[numType] * 2)) - (NUM_SPACE[numType] / 2), y, ANI_BANK_3)
		
		If (sec < TERMINAL_COUNT) Then
			drawNum(g, 0, x - (NUM_SPACE[numType] * 4), y, 2, numType)
		EndIf
		
		drawNum(g, sec, x - (NUM_SPACE[numType] * 3), y, 2, numType)
		NumberDrawer.drawColon(g, 3, (x - (NUM_SPACE[numType] * MAX_ITEM)) - (NUM_SPACE[numType] / 2), y, ANI_BANK_3)
		drawNum(g, min, x - (NUM_SPACE[numType] * 6), y, 2, numType)
	End
	
	Public Function drawRecordTimeTotalYellow:Void(g:MFGraphics, timeCount:Int, x:Int, y:Int, numType:Int, anchor:Int)
		Int min = timeCount / 60000
		Int sec = (timeCount Mod 60000) / 1000
		timeCount = ((timeCount Mod 60000) Mod 1000) / TERMINAL_COUNT
		Select (anchor)
			Case 0
				x += (NUM_SPACE[numType] * ITEM_RING_10) / 2
				break
			Case 1
				x += NUM_SPACE[numType] * ITEM_RING_10
				break
		End Select
		
		If (timeCount < TERMINAL_COUNT) Then
			drawNum(g, 0, x - NUM_SPACE[numType], y, 2, numType)
		EndIf
		
		drawNum(g, timeCount, x, y, 2, numType)
		NumberDrawer.drawColon(g, 0, (x - (NUM_SPACE[numType] * 2)) - (NUM_SPACE[numType] / 2), y, ANI_BANK_3)
		
		If (sec < TERMINAL_COUNT) Then
			drawNum(g, 0, x - (NUM_SPACE[numType] * 4), y, 2, numType)
		EndIf
		
		drawNum(g, sec, x - (NUM_SPACE[numType] * 3), y, 2, numType)
		NumberDrawer.drawColon(g, 0, (x - (NUM_SPACE[numType] * MAX_ITEM)) - (NUM_SPACE[numType] / 2), y, ANI_BANK_3)
		drawNum(g, min, x - (NUM_SPACE[numType] * 6), y, 2, numType)
	End
	
	Public Function drawRecordTimeLeft:Void(g:MFGraphics, timeCount:Int, x:Int, y:Int)
		drawRecordTimeTotalYellow(g, timeCount, x, y, 0, 1)
		MyAPI.setBmfColor(0)
	End
	
	Private Function drawStaticAni:Void(g:MFGraphics, aniId:Int, x:Int, y:Int)
		numDrawer.setActionId(aniId)
		numDrawer.draw(g, x, y)
	End
	
	Private Function drawStagePassInfoScroll:Void(g:MFGraphics, y:Int, speed:Int, space:Int)
		State.drawBar(g, 2, y)
		itemOffsetX -= speed
		itemOffsetX Mod= space
		Int x1 = itemOffsetX - 294
		While (x1 < SCREEN_WIDTH * 2) {
			GameState.stageInfoAniDrawer.draw(g, getCharacterID() + ANI_WIND_JUMP, x1, (y - TERMINAL_COUNT) + 2, False, 0)
			GameState.stageInfoAniDrawer.draw(g, ANI_BANK_2, x1, (y - TERMINAL_COUNT) + 2, False, 0)
			MFGraphics mFGraphics = g
			GameState.stageInfoAniDrawer.draw(mFGraphics, passStageActionID, x1, (y - TERMINAL_COUNT) + 2, False, 0)
			x1 += space
		Next
	End
	
	Private Function drawStagePassInfoScroll:Void(g:MFGraphics, offset_x:Int, y:Int, speed:Int, space:Int)
		
		If (isbarOut) Then
			State.drawBar(g, 2, offset_x, y)
			State.drawBar(g, 2, SCREEN_WIDTH + offset_x, y)
			State.drawBar(g, 2, (SCREEN_WIDTH * 2) + offset_x, y)
		Else
			State.drawBar(g, 2, y)
		EndIf
		
		If (offset_x = 0) Then
			itemOffsetX -= speed
			itemOffsetX Mod= space
		EndIf
		
		Int x1 = itemOffsetX - 294
		While (x1 < SCREEN_WIDTH * 2) {
			MFGraphics mFGraphics = g
			GameState.stageInfoAniDrawer.draw(mFGraphics, getCharacterID() + ANI_WIND_JUMP, x1 + offset_x, (y - TERMINAL_COUNT) + 2, False, 0)
			mFGraphics = g
			GameState.stageInfoAniDrawer.draw(mFGraphics, ANI_BANK_2, x1 + offset_x, (y - TERMINAL_COUNT) + 2, False, 0)
			mFGraphics = g
			GameState.stageInfoAniDrawer.draw(mFGraphics, passStageActionID, x1 + offset_x, (y - TERMINAL_COUNT) + 2, False, 0)
			x1 += space
		Next
	End
	
	Public Function initMovingBar:Void()
		offsetx = SCREEN_WIDTH
		offsety = (SCREEN_HEIGHT / 2) + HURT_COUNT
		
		If (StageManager.getStageID() >= SPIN_LV2_COUNT) Then
			passStageActionID = (StageManager.getStageID() - SPIN_LV2_COUNT) + SPIN_LV2_COUNT_CONF
		ElseIf (StageManager.getStageID() Mod 2 = 0) Then
			passStageActionID = ANI_BANK_3
		ElseIf (StageManager.getStageID() Mod 2 = 1) Then
			passStageActionID = ANI_CELEBRATE_1
		EndIf
		
	End
	
	Private Function drawMovingbar:Void(g:MFGraphics, space:Int)
		State.drawBar(g, 2, offsetx - BACKGROUND_WIDTH, offsety)
		State.drawBar(g, 2, (offsetx - BACKGROUND_WIDTH) + SCREEN_WIDTH, offsety)
		Int drawNum = (((SCREEN_WIDTH + space) - 1) / space) + 2
		For (Int i = 0; i < drawNum; i += 1)
			Int x2 = offsetx + (i * space)
			GameState.stageInfoAniDrawer.draw(g, getCharacterID() + ANI_WIND_JUMP, x2, (offsety - TERMINAL_COUNT) + 2, False, 0)
			GameState.stageInfoAniDrawer.draw(g, ANI_BANK_2, x2, (offsety - TERMINAL_COUNT) + 2, False, 0)
			GameState.stageInfoAniDrawer.draw(g, passStageActionID, x2, (offsety - TERMINAL_COUNT) + 2, False, 0)
		Next
	End
	
	Public Function stagePassLogic:Void()
		Select (stageModeState)
		End Select
	End
	
	Private Function isRaceModeNewRecord:Bool()
		Return timeCount < StageManager.getTimeModeScore(characterID) ? True : False
	End
	
	Public Function isHadRaceRecord:Bool()
		Return StageManager.getTimeModeScore(characterID) < SonicDef.OVER_TIME ? True : False
	End
	
	Public Function movingBar:Bool()
		
		If (offsetx <= 0) Then
			offsetx = 0
		Else
			offsetx -= movespeedx
			
			If (offsetx = SCREEN_WIDTH - movespeedx) Then
				If (stageModeState = 1) Then
					If (isRaceModeNewRecord()) Then
						SoundSystem.getInstance().playBgm(ANI_DEAD, False)
					Else
						SoundSystem.getInstance().playBgm(ANI_POP_JUMP_UP_SLOW, False)
					EndIf
					
				ElseIf (StageManager.getStageID() = SPIN_LV2_COUNT) Then
					SoundSystem.getInstance().playBgm(28, False)
				ElseIf (StageManager.getStageID() = ANI_POAL_PULL) Then
					SoundSystem.getInstance().playBgm(ANI_WIND_JUMP, False)
				Else
					
					If (StageManager.getStageID() Mod 2 = 0) Then
						SoundSystem.getInstance().playBgm(MOON_STAR_DES_Y_1, False)
					EndIf
					
					If (StageManager.getStageID() Mod 2 = 1) Then
						SoundSystem.getInstance().playBgm(ANI_SMALL_ZERO, False)
					EndIf
				EndIf
			EndIf
		EndIf
		
		If (offsetx <> 0) Then
			Return False
		EndIf
		
		If (offsety <= (SCREEN_HEIGHT / 2) - SPIN_LV2_COUNT_CONF) Then
			offsety = (SCREEN_HEIGHT / 2) - SPIN_LV2_COUNT_CONF
			Return True
		EndIf
		
		offsety -= movespeedy
		Return False
	End
	
	Public Function clipMoveInit:Void(startx:Int, starty:Int, startw:Int, endw:Int, height:Int)
		clipx = startx
		clipy = starty
		clipstartw = startw
		clipendw = endw
		cliph = height
	End
	
	Public Function clipMoveLogic:Bool()
		
		If (clipstartw < clipendw) Then
			clipstartw += clipspeed
			Return False
		EndIf
		
		clipstartw = clipendw
		Return True
	End
	
	Public Function clipMoveShadow:Void(g:MFGraphics)
		MyAPI.setClip(g, clipx, 0, clipstartw, SCREEN_HEIGHT)
	End
	
	Public Function calculateScore:Void()
		
		If (StageManager.getStageID() = TERMINAL_COUNT) Then
			Print("timeCount=" + timeCount)
			
			If (timeCount > 192000) Then
				score1 = 1000
			ElseIf (timeCount > 192000 Or timeCount <= 132000) Then
				score1 = 0
			Else
				score1 = BANKING_MIN_SPEED
			EndIf
			
			score2 = ringNum * 100
			Return
		EndIf
		
		If (timeCount < 50000) Then
			score1 = 50000
		ElseIf (timeCount >= 50000 And timeCount < 60000) Then
			score1 = 10000
		ElseIf (timeCount >= 60000 And timeCount < 90000) Then
			score1 = 5000
		ElseIf (timeCount >= 90000 And timeCount < 120000) Then
			score1 = 4000
		ElseIf (timeCount >= 120000 And timeCount < 180000) Then
			score1 = 3000
		ElseIf (timeCount >= 180000 And timeCount < 240000) Then
			score1 = 2000
		ElseIf (timeCount >= 240000 And timeCount < 300000) Then
			score1 = 1000
		ElseIf (timeCount < 300000 Or timeCount >= 360000) Then
			score1 = 0
		Else
			score1 = BANKING_MIN_SPEED
		EndIf
		
		score2 = ringNum * 100
	End
	
	Public Function stagePassDraw:Void(g:MFGraphics)
		
		If (Not StageManager.isOnlyStagePass) Then
			Select (stageModeState)
				Case 0
					
					If (movingBar()) Then
						drawStagePassInfoScroll(g, stagePassResultOutOffsetX, (SCREEN_HEIGHT / 2) - SPIN_LV2_COUNT_CONF, ANI_PUSH_WALL, SIDE_FOOT_FROM_CENTER)
						
						If (Not clipMoveLogic()) Then
							clipMoveShadow(g)
							GameState.guiAniDrawer.draw(g, 6, (SCREEN_WIDTH / 2) - 70, (SCREEN_HEIGHT / 2) - 6, False, 0)
							GameState.guiAniDrawer.draw(g, ITEM_RING_10, (SCREEN_WIDTH / 2) - 70, ((SCREEN_HEIGHT / 2) + MENU_SPACE) - 6, False, 0)
							drawNum(g, score1, (SCREEN_WIDTH / 2) + NUM_DISTANCE, SCREEN_HEIGHT / 2, 2, 0)
							drawNum(g, score2, (SCREEN_WIDTH / 2) + NUM_DISTANCE, (SCREEN_HEIGHT / 2) + MENU_SPACE, 2, 0)
							MyAPI.setClip(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
							totalPlusscore = (score1 + score2) + scoreNum
						EndIf
						
					Else
						drawMovingbar(g, STAGE_PASS_STR_SPACE)
						stagePassResultOutOffsetX = 0
						isStartStageEndFlag = False
						stageEndFrameCnt = 0
						isOnlyBarOut = False
					EndIf
					
					If (clipMoveLogic()) Then
						GameState.guiAniDrawer.draw(g, 6, stagePassResultOutOffsetX + ((SCREEN_WIDTH / 2) - 70), (SCREEN_HEIGHT / 2) - 6, False, 0)
						GameState.guiAniDrawer.draw(g, ITEM_RING_10, stagePassResultOutOffsetX + ((SCREEN_WIDTH / 2) - 70), ((SCREEN_HEIGHT / 2) + MENU_SPACE) - 6, False, 0)
						
						If (stageModeState = 1) Then
							raceScoreNum = MyAPI.calNextPosition((double) raceScoreNum, (double) totalPlusscore, 1, MAX_ITEM)
						Else
							scoreNum = MyAPI.calNextPosition((double) scoreNum, (double) totalPlusscore, 1, MAX_ITEM)
						EndIf
						
						score1 = MyAPI.calNextPosition((double) score1, 0.0d, 1, MAX_ITEM)
						score2 = MyAPI.calNextPosition((double) score2, 0.0d, 1, MAX_ITEM)
						drawNum(g, score1, ((SCREEN_WIDTH / 2) + NUM_DISTANCE) + stagePassResultOutOffsetX, SCREEN_HEIGHT / 2, 2, 0)
						drawNum(g, score2, ((SCREEN_WIDTH / 2) + NUM_DISTANCE) + stagePassResultOutOffsetX, (SCREEN_HEIGHT / 2) + MENU_SPACE, 2, 0)
						
						If (scoreNum = totalPlusscore) Then
							IsStarttoCnt = True
							
							If (StageManager.isOnlyScoreCal) Then
								isOnlyBarOut = True
							Else
								isStartStageEndFlag = True
							EndIf
							
						Else
							SoundSystem.getInstance().playSe(ANI_POAL_PULL_2)
						EndIf
					EndIf
					
					If (isStartStageEndFlag) Then
						stageEndFrameCnt += 1
						
						If (stageEndFrameCnt = 2) Then
							SoundSystem.getInstance().playSe(LOOK_COUNT)
						EndIf
					EndIf
					
					If (isOnlyBarOut) Then
						onlyBarOutCnt += 1
						
						If (onlyBarOutCnt = 2) Then
							SoundSystem.getInstance().playSe(LOOK_COUNT)
						EndIf
						
						If (onlyBarOutCnt > onlyBarOutCntMax) Then
							stagePassResultOutOffsetX -= 96
						EndIf
						
						If (stagePassResultOutOffsetX < ACParam.NO_COLLISION) Then
							StageManager.isScoreBarOutOfScreen = True
						EndIf
					EndIf
					
				Case 1
					
					If (movingBar()) Then
						drawStagePassInfoScroll(g, (SCREEN_HEIGHT / 2) - SPIN_LV2_COUNT_CONF, ANI_PUSH_WALL, SIDE_FOOT_FROM_CENTER)
						
						If (clipMoveLogic()) Then
							IsStarttoCnt = True
						EndIf
						
						clipMoveShadow(g)
						GameState.guiAniDrawer.draw(g, ANI_PUSH_WALL, (SCREEN_WIDTH / 2) - BACKGROUND_WIDTH, SCREEN_HEIGHT / 2, False, 0)
						drawRecordTime(g, timeCount, (SCREEN_WIDTH / 2) + NUM_DISTANCE_BIG, (SCREEN_HEIGHT / 2) + ITEM_RING_10, 2, 2)
						MyAPI.setClip(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
						
						If (isRaceModeNewRecord() And IsStarttoCnt And Not StageManager.isSaveTimeModeScore) Then
							IsDisplayRaceModeNewRecord = True
						EndIf
						
						If (IsDisplayRaceModeNewRecord) Then
							GameState.guiAniDrawer.draw(g, ANI_ROTATE_JUMP, SCREEN_WIDTH / 2, (SCREEN_HEIGHT / 2) + ANI_BANK_2, False, 0)
						EndIf
						
						If (StageManager.isSaveTimeModeScore = Null And IsStarttoCnt) Then
							StageManager.setTimeModeScore(characterID, timeCount)
							StageManager.isSaveTimeModeScore = True
							Return
						EndIf
						
						Return
					EndIf
					
					drawMovingbar(g, STAGE_PASS_STR_SPACE)
				Default
			End Select
		EndIf
		
	End
	
	Public Function gamepauseInit:Void()
		cursor = 0
		cursorIndex = 0
		Key.touchkeygameboardClose()
	End
	
	Public Function gamepauseDraw:Void(g:MFGraphics)
		PAUSE_MENU_NORMAL_ITEM = PAUSE_MENU_NORMAL_NOSHOP
		State.fillMenuRect(g, (SCREEN_WIDTH / 2) + PAUSE_FRAME_OFFSET_X, (SCREEN_HEIGHT / 2) + PAUSE_FRAME_OFFSET_Y, PAUSE_FRAME_WIDTH, PAUSE_FRAME_HEIGHT)
		State.drawMenuFontById(g, BACKGROUND_WIDTH, SCREEN_WIDTH / 2, (((SCREEN_HEIGHT / 2) + PAUSE_FRAME_OFFSET_Y) + (MENU_SPACE / 2)) + TERMINAL_COUNT)
		
		If (stageModeState = 0) Then
			currentPauseMenuItem = PAUSE_MENU_NORMAL_ITEM
		Else
			currentPauseMenuItem = PAUSE_MENU_RACE_ITEM
		EndIf
		
		If (currentPauseMenuItem.length <= 4) Then
			cursorIndex = 0
		ElseIf (cursorIndex > cursor) Then
			cursorIndex = cursor
		ElseIf ((cursorIndex + 4) - 1 < cursor) Then
			cursorIndex = (cursor - 4) + 1
		EndIf
		
		State.drawMenuFontById(g, 119, SCREEN_WIDTH / 2, (((((SCREEN_HEIGHT / 2) + PAUSE_FRAME_OFFSET_Y) + TERMINAL_COUNT) + (MENU_SPACE / 2)) + MENU_SPACE) + (MENU_SPACE * (cursor - cursorIndex)))
		State.drawMenuFontById(g, StringIndex.STR_RIGHT_ARROW, ((SCREEN_WIDTH / 2) - 56) - 0, (((((SCREEN_HEIGHT / 2) + PAUSE_FRAME_OFFSET_Y) + TERMINAL_COUNT) + (MENU_SPACE / 2)) + MENU_SPACE) + (MENU_SPACE * (cursor - cursorIndex)))
		For (Int i = cursorIndex; i < cursorIndex + 4; i += 1)
			State.drawMenuFontById(g, currentPauseMenuItem[i], SCREEN_WIDTH / 2, (((((SCREEN_HEIGHT / 2) + PAUSE_FRAME_OFFSET_Y) + TERMINAL_COUNT) + (MENU_SPACE / 2)) + MENU_SPACE) + (MENU_SPACE * (i - cursorIndex)))
		Next
		
		If (currentPauseMenuItem.length > 4) Then
			If (cursorIndex = 0) Then
				State.drawMenuFontById(g, 96, SCREEN_WIDTH / 2, ((SCREEN_HEIGHT / 2) - PAUSE_FRAME_OFFSET_Y) + (MENU_SPACE / 2))
				GameState.IsSingleUp = False
				GameState.IsSingleDown = True
			ElseIf (cursorIndex = currentPauseMenuItem.length - 4) Then
				State.drawMenuFontById(g, 95, SCREEN_WIDTH / 2, ((SCREEN_HEIGHT / 2) - PAUSE_FRAME_OFFSET_Y) + (MENU_SPACE / 2))
				GameState.IsSingleUp = True
				GameState.IsSingleDown = False
			Else
				State.drawMenuFontById(g, 95, (SCREEN_WIDTH / 2) - ANI_BAR_ROLL_2, ((SCREEN_HEIGHT / 2) - PAUSE_FRAME_OFFSET_Y) + (MENU_SPACE / 2))
				State.drawMenuFontById(g, 96, (SCREEN_WIDTH / 2) + ANI_BAR_ROLL_1, ((SCREEN_HEIGHT / 2) - PAUSE_FRAME_OFFSET_Y) + (MENU_SPACE / 2))
				GameState.IsSingleUp = False
				GameState.IsSingleDown = False
			EndIf
		EndIf
		
		State.drawSoftKey(g, True, True)
	End
	
	Public Method close:Void()
		Animation.closeAnimationDrawer(Self.waterFallDrawer)
		Self.waterFallDrawer = Null
		Animation.closeAnimationDrawer(Self.waterFlushDrawer)
		Self.waterFlushDrawer = Null
		Animation.closeAnimationDrawer(Self.drawer)
		Self.drawer = Null
		Animation.closeAnimationDrawer(Self.effectDrawer)
		Self.effectDrawer = Null
		Animation.closeAnimation(Self.dustEffectAnimation)
		Self.dustEffectAnimation = Null
		closeImpl()
	End
	
	Public Function doWhileQuitGame:Void()
		bariaDrawer = Null
		gBariaDrawer = Null
		invincibleAnimation = Null
		invincibleDrawer = Null
	End
	
	Public Function IsInvincibility:Bool()
		
		If (invincibleCount > 0) Then
			Return True
		EndIf
		
		Return False
	End
	
	Public Function IsUnderSheild:Bool()
		
		If (shieldType = 2) Then
			Return True
		EndIf
		
		Return False
	End
	
	Public Function IsSpeedUp:Bool()
		
		If (speedCount > 0) Then
			Return True
		EndIf
		
		Return False
	End
	
	Public Method setAntiGravity:Void()
		Bool z
		Int i
		
		If (Self.isAntiGravity) Then
			z = False
		Else
			z = True
		EndIf
		
		Self.isAntiGravity = z
		Self.worldCal.actionState = 1
		Self.collisionState = COLLISION_STATE_JUMP
		
		If (Self.faceDirection) Then
			z = False
		Else
			z = True
		EndIf
		
		Self.faceDirection = z
		Int bodyCenterX = getNewPointX(Self.posX, 0, (-Self.collisionRect.getHeight()) / 2, Self.faceDegree)
		Int bodyCenterY = getNewPointY(Self.posY, 0, (-Self.collisionRect.getHeight()) / 2, Self.faceDegree)
		
		If (Self.isAntiGravity) Then
			i = 180
		Else
			i = 0
		EndIf
		
		Self.faceDegree = i
		i = getNewPointX(bodyCenterX, 0, Self.collisionRect.getHeight() / 2, Self.faceDegree)
		Self.footPointX = i
		Self.posX = i
		i = getNewPointY(bodyCenterY, 0, Self.collisionRect.getHeight() / 2, Self.faceDegree)
		Self.footPointY = i
		Self.posY = i
	End
	
	Public Method setAntiGravity:Void(GraFlag:Bool)
		Self.orgGravity = Self.isAntiGravity
		Self.isAntiGravity = GraFlag
		
		If (Self.orgGravity <> Self.isAntiGravity) Then
			Int i
			Self.worldCal.actionState = 1
			Self.collisionState = COLLISION_STATE_JUMP
			Self.faceDirection = Self.faceDirection ? False : True
			
			If (Self.isAntiGravity) Then
				i = 180
			Else
				i = 0
			EndIf
			
			Self.faceDegree = i
		EndIf
		
	End
	
	Public Method doWhileTouchWorld:Void(direction:Int, degree:Int)
		
		If (Self.worldCal.getActionState() = 1) Then
			Select (direction)
				Case 0
					
					If (Self.collisionState = TER_STATE_LOOK_MOON And Self.movedSpeedY < 0) Then
						setDie(False)
						break
					EndIf
					
				Case 1
					
					If (Self.isAntiGravity) Then
						Self.leftStopped = True
					Else
						Self.rightStopped = True
					EndIf
					
					If (Self.leftStopped And Self.rightStopped) Then
						setDie(False)
						Return
					EndIf
					
				Case 3
					
					If (Self.isAntiGravity) Then
						Self.rightStopped = True
					Else
						Self.leftStopped = True
					EndIf
					
					If (Self.leftStopped And Self.rightStopped) Then
						setDie(False)
						Return
					EndIf
					
			End Select
		EndIf
		
		If (Self.worldCal.getActionState() = Null Or Self.collisionState = TER_STATE_LOOK_MOON) Then
			Select (direction)
				Case 0
					
					If (Self.collisionState = TER_STATE_LOOK_MOON And Self.movedSpeedY < 0) Then
						setDie(False)
					EndIf
					
				Case 1
					
					If (Not Self.speedLock) Then
						Self.totalVelocity = 0
					EndIf
					
					If (Self.isAntiGravity) Then
						Self.leftStopped = True
					Else
						Self.rightStopped = True
					EndIf
					
					If (Self.leftStopped And Self.rightStopped) Then
						setDie(False)
					ElseIf ((Key.repeat(Key.gRight) And Not Self.isAntiGravity) Or (Key.repeat(Key.gLeft) And Self.isAntiGravity)) Then
						If (Self.animationID = ANI_STAND Or Self.animationID = ANI_CLIFF_1 Or Self.animationID = HURT_COUNT Or Self.animationID = 1 Or Self.animationID = 2 Or Self.animationID = 3) Then
							Self.animationID = ANI_PUSH_WALL
						EndIf
					EndIf
					
				Case 3
					
					If (Not Self.speedLock) Then
						Self.totalVelocity = 0
					EndIf
					
					If (Self.isAntiGravity) Then
						Self.rightStopped = True
					Else
						Self.leftStopped = True
					EndIf
					
					If (Self.leftStopped And Self.rightStopped) Then
						setDie(False)
					ElseIf ((Key.repeat(Key.gLeft) And Not Self.isAntiGravity) Or (Key.repeat(Key.gRight) And Self.isAntiGravity)) Then
						If (Self.animationID = ANI_STAND Or Self.animationID = ANI_CLIFF_1 Or Self.animationID = HURT_COUNT Or Self.animationID = 1 Or Self.animationID = 2 Or Self.animationID = 3) Then
							Self.animationID = ANI_PUSH_WALL
						EndIf
					EndIf
					
				Default
			End Select
		EndIf
		
	End
	
	Public Method getBodyDegree:Int()
		Return Self.worldCal.footDegree
	End
	
	Public Method getBodyOffset:Int()
		Return BODY_OFFSET
	End
	
	Public Method getFootOffset:Int()
		Return SIDE_FOOT_FROM_CENTER
	End
	
	Public Method getFootX:Int()
		Return Self.posX
	End
	
	Public Method getFootY:Int()
		Return Self.posY
	End
	
	Public Method getPressToGround:Int()
		Return GRAVITY / 2
	End
	
	Public Method didAfterEveryMove:Void(arg0:Int, arg1:Int)
		player.moveDistance.x = arg0
		player.moveDistance.y = arg1
		Self.footPointX = Self.posX
		Self.footPointY = Self.posY
		collisionCheckWithGameObject()
		Self.posZ = Self.currentLayer
	End
	
	Public Method doBeforeCollisionCheck:Void()
		' Empty implementation.
	End
	
	Public Method doWhileCollision:Void(arg0:ACObject, arg1:ACCollision, arg2:Int, arg3:Int, arg4:Int, arg5:Int, arg6:Int)
		' Empty implementation.
	End
	
	Public Method doWhileLeaveGround:Void()
		calDivideVelocity()
		Self.collisionState = COLLISION_STATE_JUMP
		
		If (isTerminal And terminalState >= TER_STATE_CHANGE_1) Then
			Self.collisionState = TER_STATE_CHANGE_1
		EndIf
		
	End
	
	Public Method doWhileLand:Void(degree:Int)
		Self.faceDegree = degree
		land()
		
		If (Self.footOnObject <> Null) Then
			Self.worldCal.stopMove()
			Self.footOnObject = Null
		EndIf
		
		Self.collisionState = TER_STATE_RUN
		Self.isSidePushed = 4
		Print("~~velx:" + (Self.velX Shr 6))
	End
	
	Public Method getMinDegreeToLeaveGround:Int()
		Return ANI_DEAD_PRE
	End
	
	Public Method stopMove:Void()
		Self.worldCal.stopMove()
	End
	
	Public Method getCal:ACWorldCollisionCalculator()
		Return Self.worldCal
	End
	
	Public Method getDegreeDiff:Int(degree1:Int, degree2:Int)
		Int re = Abs(degree1 - degree2)
		
		If (re > 180) Then
			re = MDPhone.SCREEN_WIDTH - re
		EndIf
		
		If (re > 90) Then
			Return 180 - re
		EndIf
		
		Return re
	End
	
	Protected Method extraLogicJump:Void()
		' Empty implementation.
	End
	
	Protected Method extraLogicWalk:Void()
		' Empty implementation.
	End
	
	Protected Method extraLogicOnObject:Void()
		' Empty implementation.
	End
	
	Protected Method extraInputLogic:Void()
		' Empty implementation.
	End
	
	Private Method checkCliffAnimation:Void()
		Int footLeftX = ACUtilities.getRelativePointX(Self.posX, LEFT_FOOT_OFFSET_X, 0, Self.faceDegree)
		Int footLeftY = ACUtilities.getRelativePointY(Self.posY, LEFT_FOOT_OFFSET_X, Self.worldInstance.getTileHeight(), Self.faceDegree)
		Int footCenterX = ACUtilities.getRelativePointX(Self.posX, 0, 0, Self.faceDegree)
		Int footCenterY = ACUtilities.getRelativePointY(Self.posY, 0, Self.worldInstance.getTileHeight(), Self.faceDegree)
		Int footRightX = ACUtilities.getRelativePointX(Self.posX, SIDE_FOOT_FROM_CENTER, 0, Self.faceDegree)
		Int footRightY = ACUtilities.getRelativePointY(Self.posY, SIDE_FOOT_FROM_CENTER, Self.worldInstance.getTileHeight(), Self.faceDegree)
		Select (Self.collisionState)
			Case 0
				
				If (Self.worldInstance.getWorldY(footCenterX, footCenterY, Self.currentLayer, Self.worldCal.getDirectionByDegree(Self.faceDegree)) <> ACParam.NO_COLLISION) Then
					Return
				EndIf
				
				If (Self.worldInstance.getWorldY(footLeftX, footLeftY, Self.currentLayer, Self.worldCal.getDirectionByDegree(Self.faceDegree)) <> ACParam.NO_COLLISION) Then
					If (Self.faceDirection) Then
						Self.animationID = ANI_CLIFF_1
					Else
						Self.animationID = HURT_COUNT
					EndIf
					
				ElseIf (Self.worldInstance.getWorldY(footRightX, footRightY, Self.currentLayer, Self.worldCal.getDirectionByDegree(Self.faceDegree)) = ACParam.NO_COLLISION) Then
				Else
					
					If (Self.faceDirection) Then
						Self.animationID = HURT_COUNT
					Else
						Self.animationID = ANI_CLIFF_1
					EndIf
				EndIf
				
			Case 2
				
				If (Self.footOnObject = Null) Then
					Return
				EndIf
				
				If (footCenterX < Self.footOnObject.collisionRect.x0) Then
					If (Self.faceDirection) Then
						Self.animationID = HURT_COUNT
					Else
						Self.animationID = ANI_CLIFF_1
					EndIf
					
				ElseIf (footCenterX <= Self.footOnObject.collisionRect.x1) Then
				Else
					
					If (Self.faceDirection) Then
						Self.animationID = ANI_CLIFF_1
					Else
						Self.animationID = HURT_COUNT
					EndIf
				EndIf
				
			Default
		End Select
	End
	
	Public Method setCliffAnimation:Void()
		
		If (Self.faceDirection) Then
			Self.animationID = HURT_COUNT
		Else
			Self.animationID = ANI_CLIFF_1
		EndIf
		
		Self.drawer.restart()
	End
	
	Protected Method spinLogic:Bool()
		
		If (Not (Key.repeat(Key.gLeft) Or Key.repeat(Key.gRight) Or isTerminal Or Self.animationID = -1 Or Self.animationID = ANI_CLIFF_1 Or Self.animationID = HURT_COUNT)) Then
			If (Key.repeat(Key.gDown)) Then
				If (Abs(getVelX()) > 64 Or getDegreeDiff(Self.faceDegree, Self.degreeStable) > ANI_DEAD_PRE) Then
					If (Not (Self.animationID = 4 Or characterID = CHARACTER_AMY Or Self.isCrashFallingSand)) Then
						soundInstance.playSe(4)
					EndIf
					
					Self.animationID = 4
				Else
					
					If (Self.animationID <> MAX_ITEM) Then
						Self.animationID = ANI_SQUAT_PROCESS
					EndIf
					
					If (Self.collisionState = TER_STATE_LOOK_MOON_WAIT) Then
						If (Self instanceof PlayerAmy) Then
							Self.dashRolling = True
							Self.spinDownWaitCount = 0
							
							If (characterID <> 3) Then
								soundInstance.playSe(4)
							EndIf
						EndIf
						
					ElseIf (Key.press(Key.B_HIGH_JUMP | Key.gUp)) Then
						Self.dashRolling = True
						Self.spinDownWaitCount = 0
						
						If (characterID <> 3) Then
							soundInstance.playSe(4)
						EndIf
					EndIf
					
					If (Not Self.dashRolling) Then
						Self.focusMovingState = 2
					EndIf
				EndIf
				
			ElseIf (Self.animationID = MAX_ITEM) Then
				Self.animationID = ANI_SQUAT_PROCESS
			EndIf
		EndIf
		
		If (Self.animationID = ANI_STAND And getDegreeDiff(Self.faceDegree, Self.degreeStable) <= ANI_DEAD_PRE) Then
			If (Key.press(Key.B_SPIN2)) Then
				Self.dashRolling = True
				
				If (characterID <> 3) Then
					soundInstance.playSe(4)
				EndIf
				
				Self.spinCount = SPIN_LV2_COUNT
				Self.spinKeyCount = SPIN_KEY_COUNT
			ElseIf (Key.press(Key.B_7)) Then
				Self.faceDirection = False
				Self.dashRolling = True
				Self.spinKeyCount = SPIN_KEY_COUNT
				
				If (characterID <> 3) Then
					soundInstance.playSe(4)
				EndIf
				
				Self.spinCount = SPIN_LV2_COUNT
			ElseIf (Key.press(Key.B_9)) Then
				Self.faceDirection = True
				Self.dashRolling = True
				Self.spinKeyCount = SPIN_KEY_COUNT
				
				If (characterID <> 3) Then
					soundInstance.playSe(4)
				EndIf
				
				Self.spinCount = SPIN_LV2_COUNT
			EndIf
		EndIf
		
		Return Self.dashRolling
	End
	
	Protected Method spinLogic2:Bool()
		
		If (Not (Key.repeat(Key.gLeft) Or Key.repeat(Key.gRight) Or isTerminal Or Self.animationID = -1 Or Self.animationID = ANI_CLIFF_1 Or Self.animationID = HURT_COUNT)) Then
			If (Key.repeat(Key.gDown)) Then
				If (getDegreeDiff(Self.faceDegree, Self.degreeStable) <= ANI_DEAD_PRE And Self.animationID <> MAX_ITEM) Then
					Self.animationID = ANI_SQUAT_PROCESS
				EndIf
				
			ElseIf (Self.animationID = MAX_ITEM) Then
				Self.animationID = ANI_SQUAT_PROCESS
			EndIf
		EndIf
		
		Return Self.dashRolling
	End
	
	Public Method dashRollingLogicCheck:Void()
		
		If (Self.dashRolling) Then
			dashRollingLogic()
		ElseIf (Self.effectID = 0 Or Self.effectID = 1) Then
			Self.effectID = -1
		EndIf
		
	End
	
	Public Method getCharacterAnimationID:Int()
		Return Self.myAnimationID
	End
	
	Public Method setCharacterAnimationID:Void(aniID:Int)
		Self.myAnimationID = aniID
	End
	
	Public Method getGravity:Int()
		
		If (Self.isInWater) Then
			Return (GRAVITY * 3) / MAX_ITEM
		EndIf
		
		Return GRAVITY
	End
	
	Public Method doBreatheBubble:Bool()
		
		If (Self.collisionState <> 1) Then
			Return False
		EndIf
		
		resetBreatheCount()
		Self.animationID = ANI_BREATHE
		
		If (characterID = CHARACTER_TAILS) Then
			((PlayerTails) player).flyCount = 0
		EndIf
		
		Self.velX = 0
		Self.velY = 0
		Return True
	End
	
	Public Method resetBreatheCount:Void()
		Self.breatheCount = 0
		Self.breatheNumCount = -1
		Self.preBreatheNumCount = -1
	End
	
	Public Method checkBreatheReset:Void()
		
		If (getNewPointY(Self.posY, 0, -Self.collisionRect.getHeight(), Self.faceDegree) + SIDE_FOOT_FROM_CENTER < (StageManager.getWaterLevel() Shl 6)) Then
			resetBreatheCount()
		EndIf
		
	End
	
	Public Method waitingChk:Void()
		
		If (Key.repeat(((((Key.gSelect | Key.gLeft) | Key.gRight) | Key.gDown) | Key.gUp) | Key.B_HIGH_JUMP) Or Not (Self.animationID = ANI_STAND Or Self.animationID = ANI_WAITING_1 Or Self.animationID = ANI_WAITING_2)) Then
			Self.waitingCount = 0
			Self.waitingLevel = 0
			Self.isResetWaitAni = True
			Return
		EndIf
		
		Self.waitingCount += 1
		
		If (Self.waitingCount > 96) Then
			If (Self.waitingLevel = 0) Then
				Self.animationID = ANI_WAITING_1
			EndIf
			
			If ((Self.drawer.checkEnd() And Self.waitingLevel = 0) Or Self.waitingLevel = 1) Then
				Self.waitingLevel = 1
				Self.animationID = ANI_WAITING_2
			EndIf
		EndIf
		
	End
	
	Public Method drawDrawerByDegree:Void(g:MFGraphics, drawer:AnimationDrawer, aniID:Int, x:Int, y:Int, loop:Bool, degree:Int, mirror:Bool)
		g.saveCanvas()
		g.translateCanvas(x, y)
		g.rotateCanvas((Float) degree)
		drawer.draw(g, aniID, 0, 0, loop, Not mirror ? 0 : 2)
		g.restoreCanvas()
	End
	
	Public Method loseRing:Void(rNum:Int)
		RingObject.hurtRingExplosion(rNum, getBodyPositionX(), getBodyPositionY(), Self.currentLayer, Self.isAntiGravity)
	End
	
	Public Function getRingNum:Int()
		Return ringNum
	End
	
	Public Function setRingNum:Void(rNum:Int)
		ringNum = rNum
	End
	
	Public Method beSpSpring:Void(springPower:Int, direction:Int)
		
		If (Self.collisionState = Null) Then
			calDivideVelocity()
		EndIf
		
		Self.velY = -springPower
		Self.worldCal.stopMoveY()
		
		If (Self.collisionState = Null) Then
			calTotalVelocity()
		EndIf
		
		Int i = Self.degreeStable
		Self.faceDegree = i
		Self.degreeForDraw = i
		Self.animationID = ANI_ROTATE_JUMP
		Self.collisionState = COLLISION_STATE_JUMP
		Self.worldCal.actionState = 1
		Self.collisionChkBreak = True
		Self.drawer.restart()
		MapManager.setFocusObj(Null)
		setMeetingBoss(False)
		Self.animationID = ANI_POP_JUMP_UP
		Self.enteringSP = True
		soundInstance.playSe(ANI_SMALL_ZERO_Y)
	End
	
	Public Method setStagePassRunOutofScreen:Void()
		MapManager.setFocusObj(Null)
		Self.animationID = 3
	End
	
	Public Method stagePassRunOutofScreenLogic:Bool()
		
		If ((StageManager.isOnlyScoreCal Or Self.footPointX + RIGHT_WALK_COLLISION_CHECK_OFFSET_X <= (((camera.x + SCREEN_WIDTH) + 800) Shl 6)) And (Not isStartStageEndFlag Or stageEndFrameCnt <= BACKGROUND_WIDTH)) Then
			Return False
		EndIf
		
		stagePassResultOutOffsetX -= 96
		
		If (stagePassResultOutOffsetX < ACParam.NO_COLLISION) Then
			Return True
		EndIf
		
		Return False
	End
	
	Public Method needRetPower:Bool()
		Return ((Not Key.repeat(Key.gLeft | Key.gRight) And Not isTerminalRunRight() And Not Self.isCelebrate) Or Self.animationID = 4 Or Self.slipFlag) ? True : False
	End
	
	Public Method getRetPower:Int()
		
		If (Self.animationID <> 4) Then
			Return Self.movePower
		EndIf
		
		Return Self.movePower / 2
	End
	
	Public Method getSlopeGravity:Int()
		
		If (Self.animationID <> 4) Then
			Return FAKE_GRAVITY_ON_WALK
		EndIf
		
		Return FAKE_GRAVITY_ON_BALL
	End
	
	Public Method noRotateDraw:Bool()
		Return (Self.animationID = ANI_STAND Or Self.animationID = MAX_ITEM Or Self.animationID = ANI_SQUAT_PROCESS Or Self.animationID = ANI_WAITING_1 Or Self.animationID = ANI_WAITING_2 Or Self.animationID = 6 Or Self.animationID = ITEM_RING_10 Or Self.animationID = ANI_YELL Or Self.animationID = ANI_PUSH_WALL) ? True : False
	End
	
	Public Method canDoJump:Bool()
		Return Self.animationID <> MAX_ITEM ? True : False
	End
	
	Private Method aspirating:Void()
		Int i = Self.breatheCount Mod 3
	End
	
	Public Function setFadeColor:Void(color:Int)
		For (Int i = 0; i < fadeRGB.length; i += 1)
			fadeRGB[i] = color
		Next
	End
	
	Public Function fadeInit:Void(from:Int, to:Int)
		fadeFromValue = from
		fadeToValue = to
		fadeAlpha = fadeFromValue
		preFadeAlpha = -1
	End
	
	Public Function drawFadeBase:Void(g:MFGraphics, vel2:Int)
		fadeAlpha = MyAPI.calNextPosition((double) fadeAlpha, (double) fadeToValue, 1, vel2, 3.0d)
		
		If (fadeAlpha <> 0) Then
			Int w
			Int h
			
			If (preFadeAlpha <> fadeAlpha) Then
				For (w = 0; w < FADE_FILL_WIDTH; w += 1)
					For (h = 0; h < FADE_FILL_WIDTH; h += 1)
						fadeRGB[(h * FADE_FILL_WIDTH) + w] = ((fadeAlpha Shl ANI_PULL) & -16777216) | (fadeRGB[(h * FADE_FILL_WIDTH) + w] & MapManager.END_COLOR)
					Next
				Next
				preFadeAlpha = fadeAlpha
			EndIf
			
			For (w = 0; w < MyAPI.zoomOut(SCREEN_WIDTH); w += FADE_FILL_WIDTH)
				For (h = 0; h < MyAPI.zoomOut(SCREEN_HEIGHT); h += FADE_FILL_WIDTH)
					g.drawRGB(fadeRGB, 0, FADE_FILL_WIDTH, w, h, FADE_FILL_WIDTH, FADE_FILL_WIDTH, True)
				Next
			Next
		EndIf
		
	End
	
	Public Function fadeChangeOver:Bool()
		Return fadeAlpha = fadeToValue ? True : False
	End
	
	Private Function playerLifeUpBGM:Void()
		SoundSystem.getInstance().stopBgm(False)
		
		If (invincibleCount > 0) Then
			SoundSystem.getInstance().playBgmSequence(ANI_POP_JUMP_DOWN_SLOW, ANI_HURT_PRE)
		Else
			SoundSystem.getInstance().playBgmSequence(ANI_POP_JUMP_DOWN_SLOW, StageManager.getBgmId())
		EndIf
	End
	
	Public Method isBodyCenterOutOfWater:Bool()
		Return getNewPointY(Self.posY, 0, -Self.collisionRect.getHeight(), Self.faceDegree) < (StageManager.getWaterLevel() Shl 6) ? True : False
	End
	
	Public Method dripDownUnderWater:Void()
		' Empty implementation.
	End
	
	Public Method resetPlayerDegree:Void()
		Int i = Self.degreeStable
		Self.faceDegree = i
		Self.degreeForDraw = i
	End
	
	Public Method isOnSlip0:Bool()
		Return False
	End
	
	Public Method setSlip0:Void()
		' Empty implementation.
	End
	
	Public Method lookUpCheck:Void()
		If (Key.repeat(Key.gUp | Key.B_LOOK)) Then
			If (Self.animationID = ANI_LOOK_UP_1 And Self.drawer.checkEnd()) Then
				Self.animationID = ANI_LOOK_UP_2
			EndIf
			
			If (Not (Self.animationID = ANI_LOOK_UP_1 Or Self.animationID = ANI_LOOK_UP_2 Or Self.animationID <> 0)) Then
				Self.animationID = ANI_LOOK_UP_1
			EndIf
			
			If (Self.animationID = ANI_LOOK_UP_2) Then
				Self.focusMovingState = 1
				Return
			EndIf
			
			Return
		EndIf
		
		If (Self.animationID = FADE_FILL_WIDTH And Self.drawer.checkEnd()) Then
			Self.animationID = ANI_STAND
		EndIf
		
		If (Self.animationID = ANI_LOOK_UP_1 Or Self.animationID = ANI_LOOK_UP_2) Then
			Self.animationID = FADE_FILL_WIDTH
		EndIf
	End
End