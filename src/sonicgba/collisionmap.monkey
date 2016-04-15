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
	
	Import regal.typetool
	Import regal.sizeof
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
		
		' Functions:
		
		' Extensions:
		Function AsModelCoord:Int(x:Int, y:Int)
			Return ((y * GRID_NUM_PER_MODEL) + x) ' x Mod GRID_NUM_PER_MODEL
		End
		
		Function GetModelTileAt:Int(data:DataBuffer, x:Int, y:Int)
			Return data.PeekShort(AsModelCoord(x, y))
		End
		
		' Fields:
		Field ds:Stream
		
		Field directionInfo:DataBuffer ' Byte[]
		Field collisionInfo:DataBuffer ' DataBuffer[] ' Byte[][]
		
		Field modelInfo:DataBuffer[] ' Short[][][]
		
		Field degreeGetter:MyDegreeGetter
		
		' Constructor(s):
		Method New()
			' Empty implementation; used for privacy reasons.
		End
		
		' Methods:
		Method getBlockIndexWithBlock:Int(blockX:Int, blockY:Int, currentLayer:Int)
			' Magic number: 1 (Collision layer)
			If (currentLayer = 1) Then
				Return getTileId(MapManager.mapBack, blockX, blockY)
			EndIf
			
			Return getTileId(MapManager.mapFront, blockX, blockY)
		End
		
		Method getTileId:Int(mapArray:DataBuffer, x:Int, y:Int)
			Local chunk:= Self.modelInfo[MapManager.GetModelTileAt(mapArray, (x / GRID_NUM_PER_MODEL), (y / GRID_NUM_PER_MODEL))] ' GetModelTileAt
			
			Return GetModelTileAt(chunk, (x Mod GRID_NUM_PER_MODEL), (y Mod GRID_NUM_PER_MODEL))
		End
	Public
		' Constant variable(s):
		Const COLLISION_FILE_NAME:String = ".co"
		Const MODEL_FILE_NAME:String = ".ci"
		
		Const MODEL_INFO_SIZE:= ((GRID_NUM_PER_MODEL*GRID_NUM_PER_MODEL)*SizeOf_Short)
		Const COLLISION_INFO_STRIDE:= 8
		
		' Functions:
		Function getInstance:CollisionMap()
			If (instance = Null) Then
				instance = New CollisionMap()
			EndIf
			
			Return instance
		End
		
		' Extensions:
		Function ToCollisionInfoPosition:Int(index:Int)
			Return (index * COLLISION_INFO_STRIDE)
		End
		
		' Methods:
		Method loadCollisionInfoStep:Bool(stageName:String)
			Select (loadStep)
				Case LOAD_OPEN_FILE
					Self.ds = MFDevice.getResourceAsStream("/map/" + stageName + MODEL_FILE_NAME)
				Case LOAD_MODEL_INFO
					Self.modelInfo = New DataBuffer[MapManager.mapModel.Length]
					
					For Local i:= 0 Until Self.modelInfo.Length ' MapManager.mapModel.Length
						Self.modelInfo[i] = New DataBuffer(MODEL_INFO_SIZE)
					Next
					
					Try
						For Local i:= 0 Until Self.modelInfo.Length
							ds.ReadAll(Self.modelInfo[i], 0, Self.modelInfo[i].Length) ' & 65535
						Next
					Catch E:StreamError
						' Nothing so far.
					End Try
					
					If (Self.ds <> Null) Then
						Self.ds.Close()
					EndIf
				Case LOAD_COLLISION_INFO
					Self.ds = MFDevice.getResourceAsStream("/map/" + stageName + COLLISION_FILE_NAME)
					
					Try
						Local collisionKindNum = Self.ds.ReadShort()
						
						Self.collisionInfo = New DataBuffer(collisionKindNum * COLLISION_INFO_STRIDE) ' * SizeOf_Byte
						Self.directionInfo = New DataBuffer(collisionKindNum) ' * SizeOf_Byte
						
						For Local i:= 0 Until collisionKindNum ' Self.directionInfo.Length
							Self.ds.ReadAll(Self.collisionInfo, (i * COLLISION_INFO_STRIDE), COLLISION_INFO_STRIDE)
							
							Self.directionInfo.PokeByte(i, Self.ds.ReadByte())
						Next
					Catch E:StreamError
						' Nothing so far.
					End Try
					
					If (Self.ds <> Null) Then
						Self.ds.Close()
					EndIf
				Case LOAD_OVER
					loadStep = 0
					
					Return True
			End Select
			
			loadStep += 1
			
			Return False
		End
		
		Method getCollisionInfoWithBlock:Void(blockX:Int, blockY:Int, currentLayer:Int, block:ACBlock)
			getCollisionBlock(block, (getTileWidth() * blockX), (getTileHeight() * blockY), currentLayer)
		End
		
		Method closeMap:Void()
			Self.collisionInfo = Null
			Self.directionInfo = Null
			
			For Local i:= 0 Until Self.modelInfo.Length
				Self.modelInfo[i].Discard()
				
				Self.modelInfo[i] = Null
			Next
			
			Self.modelInfo = []
		End
		
		Method getCollisionBlock:Void(block:ACBlock, x:Int, y:Int, layer:Int)
			' Pretty terrible, but it works:
			
			' Optimization potential; dynamic cast.
			Local myBlock:= CollisionBlock(block)
			
			If (myBlock <> Null) Then
				Local blockX:= ACUtilities.getQuaParam(x - (MapManager.mapOffsetX Shl 6), getTileWidth()) ' getZoom()
				Local blockY:= ACUtilities.getQuaParam(y, getTileHeight())
				
				myBlock.setPosition((getTileWidth() * blockX) + (MapManager.mapOffsetX Shl 6), getTileHeight() * blockY) ' getZoom()
				
				If (blockX < 0) Then
					myBlock.setProperty(BLANK_BLOCK, False, False, 64, False)
				ElseIf (blockY < 0 Or blockY >= (MapManager.mapHeight * GRID_NUM_PER_MODEL)) Then
					myBlock.setProperty(BLANK_BLOCK, False, False, 0, False)
				Else
					Local tileId:= getBlockIndexWithBlock((MapManager.getConvertX(blockX / GRID_NUM_PER_MODEL) * GRID_NUM_PER_MODEL) + (blockX Mod GRID_NUM_PER_MODEL), blockY, layer)
					
					' Magic numbers: 8191 (Bit mask)
					Local cell_id:= (tileId & 8191)
					
					' Magic numbers: 16384, 32768, 8192 (Flags?)
					myBlock.setProperty(Self.collisionInfo, ToCollisionInfoPosition(cell_id), ((tileId & 16384) <> 0), ((32768 & tileId) <> 0), Self.directionInfo.PeekByte(cell_id), ((tileId & 8192) <> 0))
				EndIf
			EndIf
		End
		
		Method getDegreeGetterForObject:ACDegreeGetter()
			If (Self.degreeGetter = Null) Then
				Self.degreeGetter = New MyDegreeGetter(Self)
			EndIf
			
			Return Self.degreeGetter
		End
		
		Method getNewCollisionBlock:ACBlock()
			Return New CollisionBlock(Self)
		End
		
		Method getTileHeight:Int()
			Return 512
		End
		
		Method getTileWidth:Int()
			Return 512
		End
		
		Method getWorldHeight:Int()
			Return (MapManager.getPixelHeight() Shl 6) ' getZoom()
		End
		
		Method getWorldWidth:Int()
			Return (MapManager.getPixelWidth() Shl 6) ' getZoom()
		End
		
		Method getZoom:Int()
			Return 6
		End
End