Strict

' Imports:
Private
	Import sonicgba.collisionblock
	Import sonicgba.mapmanager
	Import sonicgba.mydegreegetter
	Import sonicgba.sonicdef
	
	Import com.sega.engine.action.acblock
	Import com.sega.engine.action.acdegreegetter
	Import com.sega.engine.action.acutilities
	Import com.sega.engine.action.acworld
	
	'Import com.sega.mobile.framework.device.mfdevice
	'Import com.sega.mobile.framework.device.mfgamepad
	
	Import brl.databuffer
	Import brl.stream
Public

' Classes:
Class CollisionMap Extends ACWorld ' Implements SonicDef
	Private
		' Constant variable(s):
		Global BLANK_BLOCK:Byte[] = New Int[8] ' Const
		Global FULL_BLOCK:Byte[] = [-120, -120, -120, -120, -120, -120, -120, -120] ' Const
		
		Const GRID_NUM_PER_MODEL:Int = 12
		
		Const LOAD_OPEN_FILE:Int = 0
		Const LOAD_MODEL_INFO:Int = 1
		Const LOAD_COLLISION_INFO:Int = 2
		Const LOAD_OVER:Int = 3
		
		' Global variable(s):
		Global instance:CollisionMap
		
		Global loadStep:Int = LOAD_OPEN_FILE
		
		' Fields:
		Field ds:Stream
		
		Field directionInfo:Byte[]
		Field collisionInfo:Byte[][]
		
		Field modelInfo:DataBuffer[] ' Short[][][]
		
		Field degreeGetter:MyDegreeGetter
	Public
		' Constant variable(s):
		Const COLLISION_FILE_NAME:String = ".co"
		Const MODEL_FILE_NAME:String = ".ci"
		
		' Functions:
		Function getInstance:CollisionMap()
			If (instance = Null) Then
				instance = New CollisionMap()
			EndIf
			
			Return instance
		End
		
		' Methods:
		Public Method loadCollisionInfoStep:Bool(stageName:String)
			Int i
			Select (loadStep)
				Case LOAD_OPEN_FILE
					Self.ds = New DataInputStream(MFDevice.getResourceAsStream("/map/" + stageName + MODEL_FILE_NAME))
					break
				Case LOAD_MODEL_INFO
					Self.modelInfo = (Short[][][]) Array.newInstance(Short.TYPE, New Int[]{MapManager.mapModel.Length, GRID_NUM_PER_MODEL, GRID_NUM_PER_MODEL})
					i = 0
					While (i < Self.modelInfo.Length) {
						try {
							For (Int y = 0; y < GRID_NUM_PER_MODEL; y += 1)
								For (Int x = 0; x < GRID_NUM_PER_MODEL; x += 1)
									Self.modelInfo[i][x][y] = (Short) (Self.ds.readShort() & 65535)
								Next
							Next
							i += 1
						} catch (Exception e) {
							
							If (Self.ds <> Null) Then
								try {
									Self.ds.close()
									break
								} catch (IOException e2) {
									e2.printStackTrace()
									break
								}
							EndIf
							
						} catch (Throwable th) {
							
							If (Self.ds <> Null) Then
								try {
									Self.ds.close()
								} catch (IOException e3) {
									e3.printStackTrace()
								}
							EndIf
							
						}
					}
					
					If (Self.ds <> Null) Then
						try {
							Self.ds.close()
							break
						} catch (IOException e22) {
							e22.printStackTrace()
							break
						}
					EndIf
					
					break
				Case LOAD_COLLISION_INFO
					Self.ds = New DataInputStream(MFDevice.getResourceAsStream("/map/" + stageName + COLLISION_FILE_NAME))
					try {
						Int collisionKindNum = Self.ds.readShort()
						Self.collisionInfo = (Byte[][]) Array.newInstance(Byte.TYPE, New Int[]{collisionKindNum, 8})
						Self.directionInfo = New Byte[collisionKindNum]
						For (i = 0; i < collisionKindNum; i += 1)
							For (Int n = 0; n < 8; n += 1)
								Self.collisionInfo[i][n] = Self.ds.readByte()
							EndIf
							Self.directionInfo[i] = Self.ds.readByte()
						Next
						
						If (Self.ds <> Null) Then
							try {
								Self.ds.close()
								break
							} catch (IOException e222) {
								e222.printStackTrace()
								break
							EndIf
						EndIf
						
					} catch (Exception e4) {
						
						If (Self.ds <> Null) Then
							try {
								Self.ds.close()
								break
							} catch (IOException e2222) {
								e2222.printStackTrace()
								break
							Next
						EndIf
						
					} catch (Throwable th2) {
						
						If (Self.ds <> Null) Then
							try {
								Self.ds.close()
							} catch (IOException e32) {
								e32.printStackTrace()
							}
						EndIf
					EndIf
					break
				Case LOAD_OVER
					loadStep = 0
					Return True
			End Select
			
			If (True) Then
				loadStep += 1
			EndIf
			
			Return False
		End
		
		Public Method getCollisionInfoWithBlock:Void(blockX:Int, blockY:Int, currentLayer:Int, block:ACBlock)
			getCollisionBlock(block, getTileWidth() * blockX, getTileHeight() * blockY, currentLayer)
		End
		
		Private Method getBlockIndexWithBlock:Int(blockX:Int, blockY:Int, currentLayer:Int)
			
			If (currentLayer = LOAD_MODEL_INFO) Then
				Return getTileId(MapManager.mapBack, blockX, blockY)
			EndIf
			
			Return getTileId(MapManager.mapFront, blockX, blockY)
		End
		
		Private Method getTileId:Int(mapArray:Short[][], x:Int, y:Int)
			Return Self.modelInfo[mapArray[x / GRID_NUM_PER_MODEL][y / GRID_NUM_PER_MODEL]][x Mod GRID_NUM_PER_MODEL][y Mod GRID_NUM_PER_MODEL]
		End
		
		Public Method closeMap:Void()
			Self.collisionInfo = Null
			Self.directionInfo = Null
			Self.modelInfo = Null
		End
		
		Private Method CollisionMap:private()
		End
		
		Public Method getCollisionBlock:Void(block:ACBlock, x:Int, y:Int, layer:Int)
			
			If (block instanceof CollisionBlock) Then
				Int blockX = ACUtilities.getQuaParam(x - (MapManager.mapOffsetX Shl 6), getTileWidth())
				Int blockY = ACUtilities.getQuaParam(y, getTileHeight())
				CollisionBlock myBlock = (CollisionBlock) block
				myBlock.setPosition((getTileWidth() * blockX) + (MapManager.mapOffsetX Shl 6), getTileHeight() * blockY)
				
				If (blockX < 0) Then
					myBlock.setProperty(BLANK_BLOCK, False, False, 64, False)
				ElseIf (blockY < 0 Or blockY >= MapManager.mapHeight * GRID_NUM_PER_MODEL) Then
					myBlock.setProperty(BLANK_BLOCK, False, False, LOAD_OPEN_FILE, False)
				Else
					Int tileId = getBlockIndexWithBlock((MapManager.getConvertX(blockX / GRID_NUM_PER_MODEL) * GRID_NUM_PER_MODEL) + (blockX Mod GRID_NUM_PER_MODEL), blockY, layer)
					Int cell_id = tileId & 8191
					myBlock.setProperty(Self.collisionInfo[cell_id], (tileId & MFGamePad.KEY_NUM_8) <> 0..(MFGamePad.KEY_NUM_9 & tileId) <> 0, Self.directionInfo[cell_id], (tileId & MFGamePad.KEY_NUM_7) <> 0)
				EndIf
			EndIf
			
		End
		
		Public Method getDegreeGetterForObject:ACDegreeGetter()
			
			If (Self.degreeGetter = Null) Then
				Self.degreeGetter = New MyDegreeGetter(Self)
			EndIf
			
			Return Self.degreeGetter
		End
		
		Public Method getNewCollisionBlock:ACBlock()
			Return New CollisionBlock(Self)
		End
		
		Public Method getTileHeight:Int()
			Return 512
		End
		
		Public Method getTileWidth:Int()
			Return 512
		End
		
		Public Method getWorldHeight:Int()
			Return MapManager.getPixelHeight() Shl 6
		End
		
		Public Method getWorldWidth:Int()
			Return MapManager.getPixelWidth() Shl 6
		End
		
		Public Method getZoom:Int()
			Return 6
		End
End