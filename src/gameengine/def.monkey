Strict

Public

' Imports:
Private
	Import lib.myapi
	'Import lib.constutil
	
	Import com.sega.mobile.define.mdphone
	
	Import com.sega.mobile.framework.device.mfdevice
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Constant variable(s):
Global SCREEN_WIDTH:Int = MDPhone.SCREEN_WIDTH ' 284 ' MyAPI.zoomIn(MFDevice.getScreenWidth(), True) ' Const
Global SCREEN_HEIGHT:Int = MDPhone.SCREEN_HEIGHT ' 160 ' MyAPI.zoomIn(MFDevice.getScreenHeight(), True) ' Const

Const GBA_WIDTH:= 240
Const GBA_HEIGHT:= 160

' This is the 16:9 equivalent of 'GBA_WIDTH'.
Const GBA_EXT_WIDTH:= 284

Global FONT_H:= MyAPI.zoomIn(MFGraphics.charHeight(FONT)) ' Const

Global MOVING_TITLE_TOP:Bool = (SCREEN_WIDTH < SCREEN_HEIGHT) ' Const

Global LINE_SPACE:= (FONT_H + 2) ' Const
Global FONT_H_HALF:= (FONT_H / 2) ' Const
Global FONT_WIDTH:= 20
Global FONT_WIDTH_ALPHABET:= MFGraphics.stringWidth(TOUCH_ACTIVE_PAUSE, "w") ' Const
Global FONT_WIDTH_NUM:= MFGraphics.stringWidth(TOUCH_ACTIVE_PAUSE, "0") ' Const
Global MENU_RECT_WIDTH:= Min(SCREEN_WIDTH - TOUCH_ROTATE_MAIN_MENU_START_ITEM_Y, 220) ' Const
Global TOUCH_STAR_X:= ((-SCREEN_WIDTH) / 2) ' Const
Global TOUCH_POUND_X:= ((-SCREEN_WIDTH) / 2) ' Const

Const ALL_TOUCH_PAD:Bool = True
Const ALL_TOUCH_PAD_TYPE_2:Bool = False
Const CACHE_PAINT:Bool = True
Const CELL_HEIGHT:Int = 16
Const CELL_HEIGHT_HALF:Int = 8
Const CELL_WIDTH:Int = 16
Const CELL_WIDTH_HALF:Int = 8
Const CLOSE_BGM:Bool = False
Const CUTTING_DISPLAY_HEIGHT:Int = 0
Const DEBUG_FLAG:Bool = False
Const DEBUG_MODE:Bool = False
Const DEBUG_STAGE:Bool = False
Const DISPLAY_TOUCH_RANGE:Bool = False
Const E258_BIG_FONT:Bool = False
Const EN_N7610_DEBUG:Bool = False
Const EN_TIPS_NO_SONIC:Bool = False
Const EN_VERSION:Bool = False
Const FONT:Int = 14
Const FOUR_STAGE:Bool = False
Const HAS_OPENING:Bool = True
Const HAS_VOLUME_CONTROL:Bool = True
Const LOW_QUALIFY:Bool = False
Const MORE_GAME_ENABLE:Bool = True
Const MULTI_MAIN_MENU_FLAG:Bool = False
Const N5500_DEBUG:Bool = False
Const NEED_INTERVAL_ABOVE_RECORD_BAR:Bool = True
Const NEED_INTERVAL_FOR_RECORD_BAR:Bool = True
Const NEED_USEFUL_STAR_POUND:Bool = True
Const NEED_WIDE_SCREEN_BG:Bool = False
Const NOKIA_S60V5_SCREEN:Bool = False
Const NO_BACK_GROUND:Bool = False
Const NO_LIFE_ADD_SOUND:Bool = False
Const NO_SE:Bool = False
Const ONLY_USE_SINGLE_MAP_IMAGE:Bool = False
Const OPTION_TYPE_HAVE_SOUND_CONTROL:Bool = False
Const PAGE_FONT:Int = 11
Const PRE_BP:Bool = False
Const PRE_BP_ONLY_TB:Bool = False
Const PRE_E680:Bool = False
Const PRE_LOAD_SE:Bool = True
Const PRE_MX6:Bool = False
Const PRE_SLOW_FRAME:Bool = False
Const ROTATE_MAIN_MENU:Bool = True
Const SINGLE_IMAGE_TITLE:Bool = False
Const TASTY_FLAG:Bool = False
Const TOUCH_ACTIVE_A:Int = 10
Const TOUCH_ACTIVE_B:Int = 12
Const TOUCH_ACTIVE_PAUSE:Int = 14
Const TOUCH_A_R:Int = 40
Const TOUCH_A_RANGE_X:Int = -42
Const TOUCH_A_RANGE_Y:Int = 103
Const TOUCH_A_X:Int = -22
Const TOUCH_A_Y:Int = 123
Const TOUCH_B_R:Int = 40
Const TOUCH_B_RANGE_X:Int = -87
Const TOUCH_B_RANGE_Y:Int = 118
Const TOUCH_B_X:Int = -67
Const TOUCH_B_Y:Int = 138
Const TOUCH_CHARACTER_RECORD_ARROW_RANGE:Int = 60
Const TOUCH_CHARACTER_RECORD_ARROW_Y:Int = -12
Const TOUCH_CHARACTER_RECORD_HEIGHT:Int = 112
Const TOUCH_CHARACTER_RECORD_SCORE_UPDATE_HEIGHT:Int = 32
Const TOUCH_CHARACTER_RECORD_SCORE_UPDATE_WIDTH:Int = 50
Const TOUCH_CHARACTER_RECORD_Y:Int = -48
Const TOUCH_CHARACTER_SELECT_ARROW_HEIGHT:Int = 44
Const TOUCH_CHARACTER_SELECT_ARROW_OFFSET_Y:Int = -44
Const TOUCH_CHARACTER_SELECT_ARROW_WIDTH:Int = 48
Const TOUCH_CHARACTER_SELECT_DIRECT_WIDTH:Int = 80
Const TOUCH_CHARACTER_SELECT_HEIGHT:Int = 96
Const TOUCH_CHARACTER_SELECT_LEFT_ARROW_OFFSET_X:Int = -120
Const TOUCH_CHARACTER_SELECT_MOVEMENT:Int = 8
Const TOUCH_CHARACTER_SELECT_OFFSET_Y:Int = -56
Const TOUCH_CHARACTER_SELECT_RIGHT_ARROW_OFFSET_X:Int = 72
Const TOUCH_CHARACTER_SELECT_SEL_WIDTH:Int = 96
Const TOUCH_CONFIRM_NO_H:Int = 28
Const TOUCH_CONFIRM_NO_W:Int = 40
Const TOUCH_CONFIRM_NO_X:Int = 0
Const TOUCH_CONFIRM_NO_Y:Int = 0
Const TOUCH_CONFIRM_YES_H:Int = 28
Const TOUCH_CONFIRM_YES_W:Int = 40
Const TOUCH_CONFIRM_YES_X:Int = -40
Const TOUCH_CONFIRM_YES_Y:Int = 0
Const TOUCH_DIRECT_CENTER_X:Int = 32
Const TOUCH_DIRECT_CENTER_Y:Int = 128
Const TOUCH_DIRECT_RADIUS_GAME_OUT:Int = 80
Const TOUCH_DIRECT_RADIUS_IN:Int = 16
Const TOUCH_DIRECT_RADIUS_NONE:Int = 4
Const TOUCH_DIRECT_RADIUS_OUT:Int = 80
Const TOUCH_DOWN:Int = 5
Const TOUCH_GAME_5_HEIGHT:Int = 26
Const TOUCH_GAME_5_WIDTH:Int = 48
Const TOUCH_GAME_DIRECT_R:Int = 36
Const TOUCH_GAME_PAUSE_ITEM_HEIGHT:Int = 24
Const TOUCH_GAME_PAUSE_ITEM_LEFT_X:Int = 44
Const TOUCH_GAME_PAUSE_ITEM_NORMAL_Y:Int = 36
Const TOUCH_GAME_PAUSE_ITEM_RACE_Y:Int = 60
Const TOUCH_GAME_PAUSE_ITEM_RIGHT_X:Int = 52
Const TOUCH_GAME_PAUSE_ITEM_WIDTH:Int = 88
Const TOUCH_HELP_ARROW_HEIGHT:Int = 24
Const TOUCH_HELP_ARROW_OFFSET_Y:Int = 24
Const TOUCH_HELP_ARROW_RANGE:Int = 40
Const TOUCH_HELP_ARROW_WIDTH:Int = 32
Const TOUCH_HELP_DOWN_ARROW_X:Int = 8
Const TOUCH_HELP_DOWN_X:Int = 0
Const TOUCH_HELP_HEIGHT:Int = 136
Const TOUCH_HELP_LEFT_H:Int = 48
Const TOUCH_HELP_LEFT_W:Int = 48
Const TOUCH_HELP_LEFT_X:Int = -128
Const TOUCH_HELP_LEFT_Y:Int = -70
Const TOUCH_HELP_OFFSET_X:Int = 104
Const TOUCH_HELP_OFFSET_Y:Int = 72
Const TOUCH_HELP_RIGHT_ARROW_X:Int = -40
Const TOUCH_HELP_RIGHT_X:Int = 80
Const TOUCH_HELP_UP_ARROW_X:Int = -40
Const TOUCH_HELP_UP_H:Int = 48
Const TOUCH_HELP_UP_W:Int = 48
Const TOUCH_HELP_UP_X:Int = -48
Const TOUCH_HELP_UP_Y:Int = 42
Const TOUCH_HELP_WIDTH:Int = 208
Const TOUCH_INTERRUPT_HEIGHT:Int = 24
Const TOUCH_INTERRUPT_WIDTH:Int = 96
Const TOUCH_INTERRUPT_X:Int = -48
Const TOUCH_INTERRUPT_Y:Int = -12
Const TOUCH_LEFT:Int = 7
Const TOUCH_LEFT_DOWN:Int = 6
Const TOUCH_LEFT_UP:Int = 8
Const TOUCH_MAINMENU_DOWN_Y:Int = 56
Const TOUCH_MAINMENU_SEL_H:Int = 24
Const TOUCH_MAINMENU_SEL_W:Int = 96
Const TOUCH_MAINMENU_SEL_X:Int = -32
Const TOUCH_MAINMENU_SEL_Y:Int = 32
Const TOUCH_MAINMENU_UP_H:Int = 34
Const TOUCH_MAINMENU_UP_W:Int = 96
Const TOUCH_MAINMENU_UP_X:Int = -32
Const TOUCH_MAINMENU_UP_Y:Int = -2
Const TOUCH_MAIN_MENU_END_Y:Int = 72
Const TOUCH_MAIN_MENU_FIRST_Y:Int = 2
Const TOUCH_MAIN_MENU_HEIGHT:Int = 20
Const TOUCH_MAIN_MENU_OFFSET_X:Int = -64
Const TOUCH_MAIN_MENU_OFFSET_Y:Int = 20
Const TOUCH_MAIN_MENU_OPTION_Y:Int = 52
Const TOUCH_MAIN_MENU_RACE_Y:Int = 32
Const TOUCH_MAIN_MENU_START_Y:Int = 12
Const TOUCH_MAIN_MENU_WIDTH:Int = 128
Const TOUCH_MENU_CON_H:Int = 44
Const TOUCH_MENU_CON_W:Int = 128
Const TOUCH_MENU_CON_X:Int = -64
Const TOUCH_MENU_CON_Y:Int = 0
Const TOUCH_MENU_NEW_H:Int = 44
Const TOUCH_MENU_NEW_W:Int = 128
Const TOUCH_MENU_NEW_X:Int = -64
Const TOUCH_MENU_NEW_Y:Int = -44
Const TOUCH_OPTION_ARROW_HEIGHT:Int = 32
Const TOUCH_OPTION_ARROW_OFFSET_X:Int = -115
Const TOUCH_OPTION_ARROW_RANGE_X:Int = -124
Const TOUCH_OPTION_ARROW_WIDTH:Int = 24
Const TOUCH_OPTION_DIF_X:Int = -64
Const TOUCH_OPTION_DIF_Y:Int = -50
Const TOUCH_OPTION_DOWN_ARROW_OFFSET_Y:Int = 25
Const TOUCH_OPTION_DOWN_ARROW_RANGE_Y:Int = 24
Const TOUCH_OPTION_ITEMS_HEIGHT:Int = 24
Const TOUCH_OPTION_ITEMS_LEFT2_X:Int = -16
Const TOUCH_OPTION_ITEMS_LEFT_X:Int = -96
Const TOUCH_OPTION_ITEMS_MOVEMENT:Int = 4
Const TOUCH_OPTION_ITEMS_RIGHT_X:Int = 56
Const TOUCH_OPTION_ITEMS_START_Y:Int = 40
Const TOUCH_OPTION_ITEMS_TOUCH_WIDTH_1:Int = 112
Const TOUCH_OPTION_ITEMS_TOUCH_WIDTH_2:Int = 100
Const TOUCH_OPTION_ITEM_H:Int = 20
Const TOUCH_OPTION_ITEM_W:Int = 128
Const TOUCH_OPTION_LANGUAGE_START_Y:Int = -60
Const TOUCH_OPTION_UP_ARROW_OFFSET_Y:Int = -19
Const TOUCH_OPTION_UP_ARROW_RANGE_Y:Int = -41
Const TOUCH_OPTION_VOL_PLUS_X:Int = 16
Const TOUCH_OPTION_VOL_W:Int = 48
Const TOUCH_PAUSE_1_H:Int = 20
Const TOUCH_PAUSE_1_W:Int = 144
Const TOUCH_PAUSE_1_X:Int = -72
Const TOUCH_PAUSE_1_Y:Int = -30
Const TOUCH_PAUSE_DOWN_X:Int = 0
Const TOUCH_PAUSE_OFFSET_Y:Int = 20
Const TOUCH_PAUSE_OPTION_SOUND_H:Int = 20
Const TOUCH_PAUSE_OPTION_SOUND_W:Int = 128
Const TOUCH_PAUSE_OPTION_SOUND_X:Int = -64
Const TOUCH_PAUSE_OPTION_SOUND_Y:Int = -20
Const TOUCH_PAUSE_OPTION_VOL_PLUS_W:Int = 48
Const TOUCH_PAUSE_OPTION_VOL_PLUS_X:Int = 16
Const TOUCH_PAUSE_UP_H:Int = 24
Const TOUCH_PAUSE_UP_W:Int = 44
Const TOUCH_PAUSE_UP_X:Int = -44
Const TOUCH_PAUSE_UP_Y:Int = 50
Const TOUCH_POUND_R:Int = 32
Const TOUCH_POUND_Y:Int = 32
Const TOUCH_PRESS_START_X:Int = 33
Const TOUCH_PRO_RACE_MODE_HEIGHT:Int = 24
Const TOUCH_PRO_RACE_MODE_RECODE_Y:Int = -4
Const TOUCH_PRO_RACE_MODE_START_Y:Int = -28
Const TOUCH_RETURN_RANGE:Int = 24
Const TOUCH_RIGHT:Int = 3
Const TOUCH_RIGHT_DOWN:Int = 4
Const TOUCH_RIGHT_UP:Int = 2
Const TOUCH_ROTATE_MAIN_MENU_ARROW_DOWN_Y:Int = 52
Const TOUCH_ROTATE_MAIN_MENU_ARROW_HEIGHT:Int = 28
Const TOUCH_ROTATE_MAIN_MENU_ARROW_UP_Y:Int = 0
Const TOUCH_ROTATE_MAIN_MENU_ITEM_HEIGHT:Int = 24
Const TOUCH_ROTATE_MAIN_MENU_ITEM_WIDTH:Int = 104
Const TOUCH_ROTATE_MAIN_MENU_ITEM_X:Int = -52
Const TOUCH_ROTATE_MAIN_MENU_ITEM_Y:Int = 28
Const TOUCH_ROTATE_MAIN_MENU_START_ITEM_INTERVAL:Int = 20
Const TOUCH_ROTATE_MAIN_MENU_START_ITEM_Y:Int = 20
Const TOUCH_SCORE_UPDATE_MENU_BUTTON_HEIGHT:Int = 28
Const TOUCH_SCORE_UPDATE_MENU_BUTTON_START_Y:Int = 10
Const TOUCH_SCORE_UPDATE_MENU_BUTTON_WIDTH:Int = 96
Const TOUCH_SCORE_UPDATE_MENU_BUTTON_Y:Int = 28
Const TOUCH_SCORE_UPDATE_MENU_NO_START_X:Int = 12
Const TOUCH_SCORE_UPDATE_MENU_NO_X:Int = 60
Const TOUCH_SCORE_UPDATE_MENU_TIME_X:Int = 54
Const TOUCH_SCORE_UPDATE_MENU_TIME_Y:Int = -10
Const TOUCH_SCORE_UPDATE_MENU_WORD_Y:Int = -37
Const TOUCH_SCORE_UPDATE_MENU_YES_START_X:Int = -108
Const TOUCH_SCORE_UPDATE_MENU_YES_X:Int = -60
Const TOUCH_SECOND_ENSURE_HEIGHT:Int = 32
Const TOUCH_SECOND_ENSURE_OFFSET_Y:Int = 24
Const TOUCH_SECOND_ENSURE_WIDTH:Int = 80
Const TOUCH_SEL_1_H:Int = 24
Const TOUCH_SEL_1_W:Int = 108
Const TOUCH_SEL_1_X:Int = -48
Const TOUCH_SEL_1_Y:Int = -72
Const TOUCH_SEL_DOWN_H:Int = 32
Const TOUCH_SEL_DOWN_W:Int = 24
Const TOUCH_SEL_DOWN_X:Int = -72
Const TOUCH_SEL_DOWN_Y:Int = 32
Const TOUCH_SEL_OFFSET_Y:Int = 24
Const TOUCH_SEL_UP_H:Int = 32
Const TOUCH_SEL_UP_W:Int = 24
Const TOUCH_SEL_UP_X:Int = -72
Const TOUCH_SEL_UP_Y:Int = -64
Const TOUCH_SOFTKEY:Bool = False
Const TOUCH_SP_SENSOR_OFFSET_Y:Int = -36
Const TOUCH_STAGE_SELECT_ITEM_HEIGHT:Int = 24
Const TOUCH_STAGE_SELECT_ITEM_TOP_OFFSET:Int = 12
Const TOUCH_STAGE_SELECT_LEFT_X:Int = 64
Const TOUCH_STAGE_SELECT_MOVEMENT:Int = 8
Const TOUCH_STAGE_SELECT_RIGHT_X:Int = 52
Const TOUCH_STAGE_SEL_ARROW_HEIGHT:Int = 48
Const TOUCH_STAGE_SEL_ARROW_WIDTH:Int = 40
Const TOUCH_STAGE_SEL_ARROW_X:Int = 24
Const TOUCH_STAGE_SEL_DOWN_ARROW_Y:Int = 32
Const TOUCH_STAGE_SEL_UP_ARROW_Y:Int = -80
Const TOUCH_START_GAME_HEIGHT:Int = 36
Const TOUCH_START_GAME_OFFSET_X:Int = -48
Const TOUCH_START_GAME_WIDTH:Int = 96
Const TOUCH_STAR_R:Int = 32
Const TOUCH_STAR_Y:Int = 0
Const TOUCH_STAY_A:Int = 9
Const TOUCH_STAY_B:Int = 11
Const TOUCH_STAY_BACK:Int = 0
Const TOUCH_STAY_PAUSE:Int = 13
Const TOUCH_UP:Int = 1
Const USE_ART_WORD:Bool = True
Const USE_BMF:Bool = False
Const USE_NUM_PIC:Bool = False
Const USE_TIME:Bool = False
Const VERSION_STR:String = "111115_Month" ' November 15th, 2011?
Const Null_PS:Bool = True