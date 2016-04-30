Strict

Public

' Imports:
Private
	Import com.sega.engine.action.acblock
	Import com.sega.engine.action.accollisiondata
	Import com.sega.engine.action.acdegreegetter
	Import com.sega.engine.action.acmovecalculator
	Import com.sega.engine.action.acobject
	Import com.sega.engine.action.acparam
	Import com.sega.engine.action.acutilities
	Import com.sega.engine.action.acworld
	Import com.sega.engine.action.acworldcaluser
	Import com.sega.engine.action.acworldcollisionlimit
	
	Import com.sega.engine.lib.crlfp32
	Import com.sega.engine.lib.myapi
	
	Import lib.constutil
	
	Import regal.typetool
Public

' Classes:
Class ACWorldCollisionCalculator Extends ACMoveCalculator Implements ACParam
	Private
		' Constant variable(s):
		Const BLOCK_CHECK_RANGE:Int = 1
		
		Const DIRECTION_OFFSET_DOWN:Int= 0
		Const DIRECTION_OFFSET_LEFT:Int = 1
		Const DIRECTION_OFFSET_UP:Int = 2
		Const DIRECTION_OFFSET_RIGHT:Int = 3
		
		Const DOWN_SEARCH_BLOCK:Int = 8
		
		Const UNDEFINED_DISTANCE:= -9999
		
		' Fields:
		Field degreeRe:DegreeReturner
		
		Field footCollisionPointOffsetX:Int[]
		Field footCollisionPointOffsetY:Int
		
		Field footCollisionPointResaultX:Int[]
		Field footCollisionPointResaultY:Int[]
		
		Field footOffsetX:Int
		Field footOffsetY:Int
		
		Field footX:Int
		Field footY:Int
		
		Field headCollisionPointOffsetX:Int[]
		Field headCollisionPointOffsetY:Int
		
		Field isMoved:Bool
		
		Field lastMoveDistanceX:Int
		Field lastMoveDistanceY:Int
		
		Field limit:ACWorldCollisionLimit
		
		Field movePassiveX:Int
		Field movePassiveY:Int
		
		Field preBodyOffset:Int
		Field preFootOffset:Int
		Field preHeight:Int
		Field preWidth:Int
		
		Field priorityChkId:Int
		Field totalDistance:Int
		
		Field user:ACWorldCalUser
	Public
		' Constant variable(s):
		Const JUMP_ACTION_STATE:Byte = 1
		Const WALK_ACTION_STATE:Byte = 0
		
		' Fields:
		Field actionState:Byte
		Field footDegree:Int
	Private
		' Fields:
		Field bodyCollisionPointOffsetX:Int
		Field bodyCollisionPointOffsetY:Int[]
		
		Field checkArrayForShowX:Int[]
		Field checkArrayForShowY:Int[]
		
		Field chkOffsetX:Int
		Field chkOffsetY:Int
		
		Field chkPointDegree:Int
		Field chkPointId:Int
		
		Field chkPointX:Int
		Field chkPointY:Int
		
		Field collisionData:ACCollisionData
	Protected
		' Fields:
		Field degreeGetter:ACDegreeGetter
		Field getBlock:ACBlock
	Public
		' Constructor(s):
		Method New(acObj:ACObject, user:ACWorldCalUser)
			Super.New(acObj, user)
			
			Self.lastMoveDistanceX = UNDEFINED_DISTANCE
			Self.lastMoveDistanceY = UNDEFINED_DISTANCE
			
			Self.preWidth = -1
			Self.preHeight = -1
			
			Self.preFootOffset = -1
			Self.preBodyOffset = -1
			
			Self.degreeRe = New DegreeReturner()
			
			Self.user = user
			Self.degreeGetter = Self.worldInstance.getDegreeGetterForObject()
			Self.actionState = JUMP_ACTION_STATE
			
			calPosition(acObj.getObjWidth(), acObj.getObjHeight(), user.getFootOffset(), user.getBodyOffset())
			
			If (Self.getBlock = Null) Then
				Self.getBlock = Self.worldInstance.getNewCollisionBlock()
			EndIf
			
			Self.collisionData = New ACCollisionData()
		End
	Private
		' Methods:
		Method calPosition:Void(collisionWidth:Int, collisionHeight:Int, footOffset:Int, bodyOffset:Int)
			Self.footCollisionPointOffsetX = New Int[DIRECTION_OFFSET_RIGHT] ' 3
			Self.footCollisionPointResaultX = New Int[DIRECTION_OFFSET_RIGHT] ' 3
			Self.footCollisionPointResaultY = New Int[DIRECTION_OFFSET_RIGHT] ' 3
			
			Self.footCollisionPointOffsetX[DIRECTION_OFFSET_DOWN] = -((collisionWidth - (footOffset * 2)) Shr 1)
			Self.footCollisionPointOffsetX[DIRECTION_OFFSET_RIGHT - DIRECTION_OFFSET_LEFT] = (collisionWidth - (footOffset * 2)) Shr 1
			Self.priorityChkId = DIRECTION_OFFSET_LEFT ' 1
			
			If (DIRECTION_OFFSET_RIGHT > DIRECTION_OFFSET_UP) Then
				Local x:= ((collisionWidth - footOffset * 2) / (DIRECTION_OFFSET_RIGHT - DIRECTION_OFFSET_LEFT))
				
				For Local i:= DIRECTION_OFFSET_LEFT Until (DIRECTION_OFFSET_RIGHT - DIRECTION_OFFSET_LEFT)
					Self.footCollisionPointOffsetX[i] = (x + Self.footCollisionPointOffsetX[i - DIRECTION_OFFSET_LEFT])
				Next
			EndIf
			
			Self.footCollisionPointOffsetY = 0
			
			Self.headCollisionPointOffsetX = Self.footCollisionPointOffsetX
			Self.headCollisionPointOffsetY = -collisionHeight
			
			Self.bodyCollisionPointOffsetX = (collisionWidth Shr 1)
			
			Local len:= (DIRECTION_OFFSET_UP + (collisionHeight - bodyOffset * DIRECTION_OFFSET_UP - DIRECTION_OFFSET_LEFT) / Self.worldInstance.getTileHeight())
			
			Self.bodyCollisionPointOffsetY = new Int[len]
			Self.bodyCollisionPointOffsetY[DIRECTION_OFFSET_DOWN] = -bodyOffset
			Self.bodyCollisionPointOffsetY[len - 1] = bodyOffset + -collisionHeight
			
			If (len > DIRECTION_OFFSET_UP) Then
				Local y:= (collisionHeight - bodyOffset * 2) / (len - DIRECTION_OFFSET_LEFT)
				
				For Local i:= DIRECTION_OFFSET_LEFT Until (len - DIRECTION_OFFSET_LEFT)
					Self.bodyCollisionPointOffsetY[i] = (Self.bodyCollisionPointOffsetY[i - DIRECTION_OFFSET_LEFT] - y)
				Next
			EndIf
		End
	Public
		' Methods:
		Method setLimit:Void(limit:ACWorldCollisionLimit)
			Self.limit = limit
		End
		
		Method changeSize:Void(collisionWidth:Int, collisionHeight:Int, footOffset:Int, bodyOffset:Int)
			If (bodyOffset < Self.worldInstance.getTileHeight()) Then
				bodyOffset = Self.worldInstance.getTileHeight()
			EndIf
			
			If (collisionWidth <> Self.preWidth Or collisionHeight <> Self.preHeight Or footOffset <> Self.preFootOffset Or bodyOffset <> Self.preBodyOffset) Then
				calPosition(collisionWidth, collisionHeight, footOffset, bodyOffset)
				
				Self.preWidth = collisionWidth
				Self.preHeight = collisionHeight
				
				Self.preFootOffset = footOffset
				Self.preBodyOffset = bodyOffset
			EndIf
		End
		
		Method actionLogic:Void(moveDistanceX:Int, moveDistanceY:Int)
			actionLogic(moveDistanceX, moveDistanceY, ((MyAPI.dCos(Self.footDegree) * moveDistanceX) + (MyAPI.dSin(Self.footDegree) * moveDistanceY)) / 100)
		End

		Method actionLogic:Void(moveDistanceX:Int, moveDistanceY:Int, totalVelocity:Int)
			changeSize(Self.acObj.getObjWidth(), Self.acObj.getObjHeight(), Self.user.getFootOffset(), Self.user.getBodyOffset())
			
			Self.footX = Self.user.getFootX()
			Self.footY = Self.user.getFootY()
			
			Self.moveDistanceX = moveDistanceX
			Self.moveDistanceY = moveDistanceY
			
			Select (Self.actionState)
				Case DIRECTION_OFFSET_DOWN
					Self.totalDistance = totalVelocity
			End Select
			
			checkInMap()
		End
		
		Method setMovedState:Void(state:Bool)
			Self.isMoved = state
		End
		
		Method getMovedState:Bool()
			Return Self.isMoved
		End
		
		Method stopMoveX:Void()
			Super.stopMoveX()
			
			If (Self.actionState = 0) Then
				Local tmpMoveDistanceX:= ((Self.totalDistance * MyAPI.dCos(Self.user.getBodyDegree())) / 100)
				
				Self.totalDistance = ACUtilities.getTotalFromDegree(0, (Self.totalDistance * MyAPI.dSin(Self.user.getBodyDegree())) / 100, Self.user.getBodyDegree())
			EndIf
		End
		
		Method stopMoveY:Void()
			Super.stopMoveY()
			
			If (Self.actionState = 0) Then
				Local dSin:= ((Self.totalDistance * MyAPI.dSin(Self.user.getBodyDegree())) / 100)
				
				Self.totalDistance = ACUtilities.getTotalFromDegree(((Self.totalDistance * MyAPI.dCos(Self.user.getBodyDegree())) / 100), 0, Self.user.getBodyDegree())
			EndIf
		End
		
		Method getActionState:Byte()
			Return Self.actionState
		End
		
		Method getDirectionByDegree:Int(degree:Int)
			While (degree < 0)
				degree += 360
			Wend
			
			degree Mod= 360
			
			If (degree > 315 Or degree < 45) Then
				Return DIRECTION_UP
			EndIf
			
			If (degree >= 225 And degree <= 315) Then
				Return DIRECTION_LEFT
			EndIf
			
			If (degree <= StringIndex.FONT_COLON_RED Or degree >= 225) Then
				Return DIRECTION_RIGHT
			EndIf
			
			Return DIRECTION_DOWN
		End
		
		Method getDegreeDiff:Int(degree1:Int, degree2:Int)
			Local re:= Abs(degree1 - degree2)
			
			If (re > 180) Then
				re = (360 - re)
			EndIf
			
			If (re > 90) Then
				Return (180 - re)
			EndIf
			
			Return re
		End
	Private
		Method checkInMap:Void()
			If (Self.moveDistanceX = 0 And Self.moveDistanceY = 0 And Not Self.isMoved) Then
				findTheFootPoint()
				
				Self.user.didAfterEveryMove(DIRECTION_OFFSET_DOWN, DIRECTION_OFFSET_DOWN)
			EndIf
			
			Repeat
				If (Self.moveDistanceX <> 0 Or Self.moveDistanceY <> 0 Or Self.isMoved) Then
					Self.footX = Self.user.getFootX()
					Self.footY = Self.user.getFootY()
					
					Self.footOffsetX = Self.footX - Self.acObj.posX
					Self.footOffsetY = Self.footY - Self.acObj.posY
					
					findTheFootPoint()
					
					Local preFootX:= Self.footX
					Local preFootY:= Self.footY
					
					Select (Self.actionState)
						Case WALK_ACTION_STATE
							checkInGround()
						Case JUMP_ACTION_STATE
							checkInSky()
					End Select
					
					Self.acObj.posX = Self.footX - Self.footOffsetX
					Self.acObj.posY = Self.footY - Self.footOffsetY
					
					Self.user.didAfterEveryMove(Self.footX - preFootX, Self.footY - preFootY)
				Else
					Return
				EndIf
			Until (Not Self.isMoved)
		End
		
		Method checkInGround:Void()
			moveToNextPosition()
		End
		
		Method checkInSky:Void()
			Local newX:Int
			Local degree:Int
			Local plumbDegree:Int
			
			Local landDegree:= 0
			
			Local xFirst:Bool = (Abs(Self.moveDistanceX) > Abs(Self.moveDistanceY))
			
			Local startPointX:= Self.chkPointX
			Local startPointY:= Self.chkPointY
			
			If (xFirst) Then
				If (Abs(Self.moveDistanceX) > Self.worldInstance.getTileWidth() - (1 Shl Self.worldInstance.getZoom())) Then
					Self.chkPointX += DSgn((Self.moveDistanceX > 0)) * (Self.worldInstance.getTileWidth() - (1 Shl Self.worldInstance.getZoom()))
					Self.chkPointY += (Self.moveDistanceY * (Self.worldInstance.getTileWidth() - (1 Shl Self.worldInstance.getZoom()))) / Abs(Self.moveDistanceX)
				Else
					Self.chkPointX += Self.moveDistanceX
					Self.chkPointY += Self.moveDistanceY
				EndIf
			Else
				If (Abs(Self.moveDistanceY) > Self.worldInstance.getTileHeight() - (1 Shl Self.worldInstance.getZoom())) Then
					Self.chkPointY += DSgn((Self.moveDistanceY > 0)) * (Self.worldInstance.getTileHeight() - (1 Shl Self.worldInstance.getZoom()))
					Self.chkPointX += (Self.moveDistanceX * (Self.worldInstance.getTileHeight() - (1 Shl Self.worldInstance.getZoom()))) / Abs(Self.moveDistanceY)
				Else
					Self.chkPointX += Self.moveDistanceX
					Self.chkPointY += Self.moveDistanceY
				EndIf
			EndIf
			
			calObjPositionFromFoot()
			
			Local sideCollision:Bool = False
			
			Local sideOffset:= 0
			Local sideCollisionDirection:= DIRECTION_RIGHT ' DIRECTION_RIGHT
			Local sideCollisionDegree:= 0
			Local sideNewX:= 0
			
			Local headCollision:Bool = False
			
			Local bodyOffset:= 0 ' DIRECTION_UP
			Local bodyNewY:= 0
			
			Local collisionDegree:= 0
			
			Local footChkPointID:= 0 ' DIRECTION_UP
			Local footChkDegree:= 0
			
			Local footCollision:Bool = False
			Local skyDirection:= getDirectionByDegree(Self.footDegree)
			
			' This behavior may change in the future.
			Local isVertical:Bool = (skyDirection = DIRECTION_RIGHT Or skyDirection = DIRECTION_LEFT)
			
			rightSideCollisionChk(Self.footX, Self.footY, skyDirection, Self.collisionData)
			
			If (isVertical) Then
				newX = Self.collisionData.newPosY
			Else
				newX = Self.collisionData.newPosX
			EndIf
			
			If (newX <> NO_COLLISION) Then
				If (isVertical) Then
					sideOffset = Abs(newX - Self.footY)
				Else
					sideOffset = Abs(newX - Self.footX)
				EndIf
				
				sideCollision = True
				sideCollisionDirection = DIRECTION_RIGHT ' DIRECTION_RIGHT
				sideCollisionDegree = getDegreeFromWorld((Self.footDegree + 270) Mod 360, Self.collisionData.collisionX, Self.collisionData.collisionY, Self.acObj.posZ)
				
				sideNewX = newX
			EndIf
			
			leftSideCollisionChk(Self.footX, Self.footY, skyDirection, Self.collisionData)
			
			If (isVertical) Then
				newX = Self.collisionData.newPosY
			Else
				newX = Self.collisionData.newPosX
			EndIf
			
			If (newX <> NO_COLLISION) Then
				If (sideCollision) Then
					Local sideOffset2:Int
					
					If (isVertical) Then
						sideOffset2 = Abs(newX - Self.footY)
					Else
						sideOffset2 = Abs(newX - Self.footX)
					EndIf
					
					Local totalVelocity:= ACUtilities.getTotalFromDegree(Self.acObj.velX, Self.acObj.velY, Self.footDegree + 180)
					
					If (totalVelocity > 0 Or (totalVelocity = 0 And sideOffset2 < sideOffset)) Then
						sideOffset = sideOffset2
						sideCollisionDirection = DIRECTION_LEFT
						sideCollisionDegree = getDegreeFromWorld((Self.footDegree + 90) Mod 360, Self.collisionData.collisionX, Self.collisionData.collisionY, Self.acObj.posZ)
						
						sideNewX = newX
					EndIf
				Else
					If (isVertical) Then
						sideOffset = Abs(newX - Self.footY)
					Else
						sideOffset = Abs(newX - Self.footX)
					EndIf
					
					sideCollision = True
					sideCollisionDirection = DIRECTION_LEFT
					sideCollisionDegree = getDegreeFromWorld((Self.footDegree + 90) Mod 360, Self.collisionData.collisionX, Self.collisionData.collisionY, Self.acObj.posZ)
					
					sideNewX = newX
				EndIf
			EndIf
			
			upSideCollisionChk(Self.footX, Self.footY, skyDirection, Self.collisionData)
			
			If (Not Self.collisionData.isNoCollision()) Then
				degree = getDegreeFromWorld((Self.footDegree + 180) Mod 360, Self.collisionData.collisionX, Self.collisionData.collisionY, Self.acObj.posZ)
				plumbDegree = ((degree + 90) Mod 360)
				
				If ((((Self.moveDistanceX * MyAPI.dCos(plumbDegree)) + (Self.moveDistanceY * MyAPI.dSin(plumbDegree))) / 100) > 0) Then
					If (sideCollision) Then
						If (isVertical) Then
							bodyOffset = Abs(Self.collisionData.newPosX - Self.footX)
							bodyNewY = Self.collisionData.newPosX
						Else
							bodyOffset = Abs(Self.collisionData.newPosY - Self.footY)
							bodyNewY = Self.collisionData.newPosY
						EndIf
						
						collisionDegree = degree
						headCollision = True
					Else
						If (isVertical) Then
							Self.footX = Self.collisionData.newPosX
						Else
							Self.footY = Self.collisionData.newPosY
						EndIf
						
						calChkPointFromPos()
						
						Self.user.doWhileTouchWorld(DIRECTION_UP, degree)
						
						Local tangentDistance:= (((Self.moveDistanceX * MyAPI.dCos(degree)) + (Self.moveDistanceY * MyAPI.dSin(degree))) / 100)
						
						Self.moveDistanceX = ((MyAPI.dCos(degree) * tangentDistance) / 100)
						Self.moveDistanceY = ((MyAPI.dSin(degree) * tangentDistance) / 100)
						
						Local tangentVel:= (((Self.acObj.velX * MyAPI.dCos(degree)) + (Self.acObj.velY * MyAPI.dSin(degree))) / 100)
						
						Self.acObj.velX = ((MyAPI.dCos(degree) * tangentVel) / 100)
						Self.acObj.velY = ((MyAPI.dSin(degree) * tangentVel) / 100)
					EndIf
				EndIf
			EndIf
			
			downSideCollisionChk(Self.footX, Self.footY, skyDirection, Self.collisionData)
			
			If (Not Self.collisionData.isNoCollision()) Then
				degree = getDegreeFromWorld(Self.footDegree, Self.collisionData.collisionX, Self.collisionData.collisionY, Self.acObj.posZ)
				plumbDegree = ((degree + 90) Mod 360)
				
				If ((((Self.moveDistanceX * MyAPI.dCos(plumbDegree)) + (Self.moveDistanceY * MyAPI.dSin(plumbDegree))) / 100) > 0) Then
					If (sideCollision) Then
						If (isVertical) Then
							bodyOffset = Abs(Self.collisionData.newPosX - Self.footX)
							bodyNewY = Self.collisionData.newPosX
						Else
							bodyOffset = Abs(Self.collisionData.newPosY - Self.footY)
							bodyNewY = Self.collisionData.newPosY
						EndIf
						
						collisionDegree = degree
						
						footCollision = True
						footChkPointID = Self.collisionData.chkPointID
						footChkDegree = degree
					Else
						Self.actionState = WALK_ACTION_STATE
						
						Self.footX = ACUtilities.getRelativePointX(Self.collisionData.collisionX, -Self.footCollisionPointOffsetX[Self.collisionData.chkPointID], -Self.footCollisionPointOffsetY, degree)
						Self.footY = ACUtilities.getRelativePointY(Self.collisionData.collisionY, -Self.footCollisionPointOffsetX[Self.collisionData.chkPointID], -Self.footCollisionPointOffsetY, degree)
						
						calChkPointFromPos()
						
						Self.user.doWhileTouchWorld(DIRECTION_DOWN, degree)
						
						landDegree = degree
					EndIf
				EndIf
			EndIf
			
			If ((footCollision Or headCollision) And sideCollision) Then
				If (sideOffset < bodyOffset) Then
					Self.user.doWhileTouchWorld(sideCollisionDirection, sideCollisionDegree)
					
					If (isVertical) Then
						Self.footY = sideNewX
						
						calChkPointFromPos()
						
						Self.moveDistanceY = DIRECTION_UP
						Self.acObj.velY = DIRECTION_UP
					ElseIf (canBeSideStop(sideCollisionDirection)) Then
						Self.footX = sideNewX
						
						calChkPointFromPos()
						
						Self.moveDistanceX = DIRECTION_UP
						Self.acObj.velX = DIRECTION_UP
					EndIf
					
					upSideCollisionChk(Self.footX, Self.footY, skyDirection, Self.collisionData)
					
					If (Not Self.collisionData.isNoCollision()) Then
						degree = getDegreeFromWorld(Self.footDegree + 180, Self.collisionData.collisionX, Self.collisionData.collisionY, Self.acObj.posZ)
						
						plumbDegree = ((degree + 90) Mod 360)
						
						If ((((Self.moveDistanceX * MyAPI.dCos(plumbDegree)) + (Self.moveDistanceY * MyAPI.dSin(plumbDegree))) / 100) > 0) Then
							If (isVertical) Then
								Self.footX = Self.collisionData.newPosX
							Else
								Self.footY = Self.collisionData.newPosY
							EndIf
							
							calChkPointFromPos()
							
							Self.user.doWhileTouchWorld(DIRECTION_UP, degree)
							
							tangentDistance = (((Self.moveDistanceX * MyAPI.dCos(degree)) + (Self.moveDistanceY * MyAPI.dSin(degree))) / 100)
							
							Self.moveDistanceX = ((MyAPI.dCos(degree) * tangentDistance) / 100)
							Self.moveDistanceY = ((MyAPI.dSin(degree) * tangentDistance) / 100)
							
							tangentVel = (((Self.acObj.velX * MyAPI.dCos(degree)) + (Self.acObj.velY * MyAPI.dSin(degree))) / 100)
							
							Self.acObj.velX = ((MyAPI.dCos(degree) * tangentVel) / 100)
							Self.acObj.velY = ((MyAPI.dSin(degree) * tangentVel) / 100)
						EndIf
					EndIf
					
					downSideCollisionChk(Self.footX, Self.footY, skyDirection, Self.collisionData)
					
					If (Not Self.collisionData.isNoCollision()) Then
						degree = getDegreeFromWorld(Self.footDegree, Self.collisionData.collisionX, Self.collisionData.collisionY, Self.acObj.posZ)
						plumbDegree = ((degree + 90) Mod 360)
						
						If ((((Self.moveDistanceX * MyAPI.dCos(plumbDegree)) + (Self.moveDistanceY * MyAPI.dSin(plumbDegree))) / 100) > 0) Then
							Self.actionState = WALK_ACTION_STATE
							
							Self.footX = ACUtilities.getRelativePointX(Self.collisionData.collisionX, -Self.footCollisionPointOffsetX[Self.collisionData.chkPointID], -Self.footCollisionPointOffsetY, degree)
							Self.footY = ACUtilities.getRelativePointY(Self.collisionData.collisionY, -Self.footCollisionPointOffsetX[Self.collisionData.chkPointID], -Self.footCollisionPointOffsetY, degree)
							
							calChkPointFromPos()
							
							Self.user.doWhileTouchWorld(DIRECTION_DOWN, degree)
							
							landDegree = degree
						EndIf
					EndIf
				Else
					If (footCollision) Then
						Self.actionState = WALK_ACTION_STATE
						
						Self.footX = ACUtilities.getRelativePointX(Self.collisionData.collisionX, -Self.footCollisionPointOffsetX[footChkPointID], -Self.footCollisionPointOffsetY, footChkDegree)
						Self.footY = ACUtilities.getRelativePointY(Self.collisionData.collisionY, -Self.footCollisionPointOffsetX[footChkPointID], -Self.footCollisionPointOffsetY, footChkDegree)
						
						calChkPointFromPos()
						
						Self.user.doWhileTouchWorld(DIRECTION_DOWN, footChkDegree)
						
						landDegree = footChkDegree
					Else
						If (isVertical) Then
							Self.footX = bodyNewY
						Else
							Self.footY = bodyNewY
						EndIf
						
						calChkPointFromPos()
						
						Self.user.doWhileTouchWorld(DIRECTION_UP, collisionDegree)
						
						tangentDistance = (((Self.moveDistanceX * MyAPI.dCos(collisionDegree)) + (Self.moveDistanceY * MyAPI.dSin(collisionDegree))) / 100)
						
						Self.moveDistanceX = (MyAPI.dCos(collisionDegree) * tangentDistance) / 100
						Self.moveDistanceY = (MyAPI.dSin(collisionDegree) * tangentDistance) / 100
						
						tangentVel = (((Self.acObj.velX * MyAPI.dCos(collisionDegree)) + (Self.acObj.velY * MyAPI.dSin(collisionDegree))) / 100)
						
						Self.acObj.velX = (MyAPI.dCos(collisionDegree) * tangentVel) / 100
						Self.acObj.velY = (MyAPI.dSin(collisionDegree) * tangentVel) / 100
					EndIf
					
					rightSideCollisionChk(Self.footX, Self.footY, skyDirection, Self.collisionData)
					
					If (isVertical) Then
						newX = Self.collisionData.newPosY
					Else
						newX = Self.collisionData.newPosX
					EndIf
					
					If (newX <> NO_COLLISION) Then
						Self.user.doWhileTouchWorld(DIRECTION_RIGHT, getDegreeFromWorld((Self.footDegree + 270) Mod 360, Self.collisionData.collisionX, Self.collisionData.collisionY, Self.acObj.posZ))
						
						If (isVertical) Then
							Self.footY = newX
							
							Self.moveDistanceY = DIRECTION_UP
							Self.acObj.velY = DIRECTION_UP
						ElseIf (canBeSideStop(sideCollisionDirection)) Then
							Self.footX = newX
							
							Self.moveDistanceX = DIRECTION_UP
							Self.acObj.velX = DIRECTION_UP
						EndIf
						
						calChkPointFromPos()
					EndIf
					
					leftSideCollisionChk(Self.footX, Self.footY, skyDirection, Self.collisionData)
					
					If (isVertical) Then
						newX = Self.collisionData.newPosY
					Else
						newX = Self.collisionData.newPosX
					EndIf
					
					If (newX <> NO_COLLISION) Then
						Self.user.doWhileTouchWorld(DIRECTION_LEFT, getDegreeFromWorld((Self.footDegree + 90) Mod 360, Self.collisionData.collisionX, Self.collisionData.collisionY, Self.acObj.posZ))
						
						If (isVertical) Then
							Self.footY = newX
							
							Self.moveDistanceY = DIRECTION_UP
							Self.acObj.velY = DIRECTION_UP
						ElseIf (canBeSideStop(sideCollisionDirection)) Then
							Self.footX = newX
							
							Self.moveDistanceX = DIRECTION_UP
							Self.acObj.velX = DIRECTION_UP
						EndIf
						
						calChkPointFromPos()
					EndIf
				EndIf
			ElseIf (sideCollision) Then
				Self.user.doWhileTouchWorld(sideCollisionDirection, sideCollisionDegree)
				
				If (isVertical) Then
					Self.footY = sideNewX
					
					Self.moveDistanceY = DIRECTION_UP
					Self.acObj.velY = DIRECTION_UP
				ElseIf (canBeSideStop(sideCollisionDirection)) Then
					Self.footX = sideNewX
					
					Self.moveDistanceX = DIRECTION_UP
					Self.acObj.velX = DIRECTION_UP
				EndIf
				
				calChkPointFromPos()
				upSideCollisionChk(Self.footX, Self.footY, skyDirection, Self.collisionData)
				
				If (Not Self.collisionData.isNoCollision()) Then
					degree = getDegreeFromWorld(Self.footDegree + 180, Self.collisionData.collisionX, Self.collisionData.collisionY, Self.acObj.posZ)
					plumbDegree = ((degree + 90) Mod 360)
					
					If (((Self.moveDistanceX * MyAPI.dCos(plumbDegree)) + (Self.moveDistanceY * MyAPI.dSin(plumbDegree))) / 100 > 0) Then
						If (isVertical) Then
							Self.footX = Self.collisionData.newPosX
						Else
							Self.footY = Self.collisionData.newPosY
						EndIf
						
						calChkPointFromPos()
						
						Self.user.doWhileTouchWorld(DIRECTION_UP, degree)
						
						tangentDistance = (((Self.moveDistanceX * MyAPI.dCos(degree)) + (Self.moveDistanceY * MyAPI.dSin(degree))) / 100)
						
						Self.moveDistanceX = ((MyAPI.dCos(degree) * tangentDistance) / 100)
						Self.moveDistanceY = ((MyAPI.dSin(degree) * tangentDistance) / 100)
						
						tangentVel = (((Self.acObj.velX * MyAPI.dCos(degree)) + (Self.acObj.velY * MyAPI.dSin(degree))) / 100)
						
						Self.acObj.velX = ((MyAPI.dCos(degree) * tangentVel) / 100)
						Self.acObj.velY = ((MyAPI.dSin(degree) * tangentVel) / 100)
					EndIf
				EndIf
				
				downSideCollisionChk(Self.footX, Self.footY, skyDirection, Self.collisionData)
				
				If (Not Self.collisionData.isNoCollision()) Then
					degree = getDegreeFromWorld(Self.footDegree, Self.collisionData.collisionX, Self.collisionData.collisionY, Self.acObj.posZ)
					
					plumbDegree = ((degree + 90) Mod 360)
					
					If ((((Self.moveDistanceX * MyAPI.dCos(plumbDegree)) + (Self.moveDistanceY * MyAPI.dSin(plumbDegree))) / 100) > 0) Then
						Self.actionState = WALK_ACTION_STATE
						
						Self.footX = ACUtilities.getRelativePointX(Self.collisionData.collisionX, -Self.footCollisionPointOffsetX[Self.collisionData.chkPointID], -Self.footCollisionPointOffsetY, degree)
						Self.footY = ACUtilities.getRelativePointY(Self.collisionData.collisionY, -Self.footCollisionPointOffsetX[Self.collisionData.chkPointID], -Self.footCollisionPointOffsetY, degree)
						
						calChkPointFromPos()
						
						Self.user.doWhileTouchWorld(DIRECTION_DOWN, degree)
						
						landDegree = degree
					EndIf
				EndIf
			EndIf
			
			Local preMoveDistanceX:= Self.moveDistanceX
			Local preMoveDistanceY:= Self.moveDistanceY
			
			If (Self.lastMoveDistanceX = 0) Then
				If (Self.chkPointX - startPointX = 0 And Self.lastMoveDistanceY = 0) Then
					If (Self.chkPointY - startPointY = 0) Then
						Self.lastMoveDistanceX = UNDEFINED_DISTANCE
						Self.lastMoveDistanceY = UNDEFINED_DISTANCE
						
						Self.moveDistanceX = 0
						Self.moveDistanceY = 0
						
						If (Self.moveDistanceX * preMoveDistanceX <= 0) Then
							Self.moveDistanceX = 0
						EndIf
						
						If (Self.moveDistanceY * preMoveDistanceY <= 0) Then
							Self.moveDistanceY = 0
						EndIf
						
						If (Self.actionState = 0) Then
							Self.totalDistance = ACUtilities.getTotalFromDegree(Self.moveDistanceX, Self.moveDistanceY, landDegree)
							
							Self.footDegree = landDegree
							
							Self.user.doWhileLand(Self.footDegree)
						EndIf
						
						calObjPositionFromFoot()
					EndIf
				EndIf
			EndIf
			
			Self.lastMoveDistanceX = (Self.chkPointX - startPointX)
			Self.lastMoveDistanceY = (Self.chkPointY - startPointY)
			
			Self.moveDistanceX -= (Self.chkPointX - startPointX)
			Self.moveDistanceY -= (Self.chkPointY - startPointY)
			
			If (Self.moveDistanceX * preMoveDistanceX <= 0) Then
				Self.moveDistanceX = 0
			EndIf
			
			If (Self.moveDistanceY * preMoveDistanceY <= 0) Then
				Self.moveDistanceY = 0
			EndIf
			
			If (Self.actionState = 0) Then
				Self.totalDistance = ACUtilities.getTotalFromDegree(Self.moveDistanceX, Self.moveDistanceY, landDegree)
				
				Self.footDegree = landDegree
				
				Self.user.doWhileLand(Self.footDegree)
			EndIf
			
			calObjPositionFromFoot()
		End

		Method findTheFootPoint:Void()
			If (Self.actionState = JUMP_ACTION_STATE) Then
				Self.chkPointX = ACUtilities.getRelativePointX(Self.footX, Self.footCollisionPointOffsetX[Self.priorityChkId], Self.footCollisionPointOffsetY, Self.footDegree)
				Self.chkPointY = ACUtilities.getRelativePointY(Self.footY, Self.footCollisionPointOffsetX[Self.priorityChkId], Self.footCollisionPointOffsetY, Self.footDegree)
				
				Self.chkPointId = Self.priorityChkId
				Self.chkPointDegree = Self.footDegree
				
				Self.calChkOffset(Self.chkPointX, Self.chkPointY, Self.chkPointId, Self.chkPointDegree)
			Else
				Local var1:= Self.getDirectionByDegree(Self.footDegree)
				
				Select (var1)
					Case DIRECTION_UP, DIRECTION_DOWN
						Local var10:= Self.footDegree
						Local var11:= NO_COLLISION
						Local var12:= -1
						
						For Local var13:= 0 Until Self.footCollisionPointOffsetX.Length
							Self.footCollisionPointResaultX[var13] = ACUtilities.getRelativePointX(Self.footX, Self.footCollisionPointOffsetX[var13], Self.footCollisionPointOffsetY, var10)
							Self.footCollisionPointResaultY[var13] = Self.getWorldY(Self.footCollisionPointResaultX[var13], ACUtilities.getRelativePointY(Self.footY, Self.footCollisionPointOffsetX[var13], Self.footCollisionPointOffsetY + Self.user.getPressToGround(), var10), var1)
							
							If (Self.footCollisionPointResaultY[var13] <> NO_COLLISION And (var11 = NO_COLLISION Or var1 = DIRECTION_UP And Self.footCollisionPointResaultY[var13] < var11 Or var1 = DIRECTION_DOWN And Self.footCollisionPointResaultY[var13] > var11 Or var13 = Self.priorityChkId)) Then
								var12 = var13
								var11 = Self.footCollisionPointResaultY[var13]
								
								If (var13 = Self.priorityChkId) Then
									Exit
								EndIf
							EndIf
						Next
						
						' Check if this variable was set:
						If (var12 = -1) Then
							Self.user.doWhileLeaveGround()
							
							Self.chkPointX = ACUtilities.getRelativePointX(Self.footX, Self.footCollisionPointOffsetX[Self.priorityChkId], Self.footCollisionPointOffsetY, var10)
							Self.chkPointY = ACUtilities.getRelativePointY(Self.footY, Self.footCollisionPointOffsetX[Self.priorityChkId], Self.footCollisionPointOffsetY, var10)
							
							Self.chkPointId = Self.priorityChkId
							Self.chkPointDegree = Self.footDegree
							
							Self.calChkOffset(Self.chkPointX, Self.chkPointY, Self.chkPointId, Self.chkPointDegree)
							
							Self.actionState = JUMP_ACTION_STATE
							
							Return
						EndIf
		
						Self.chkPointX = Self.footCollisionPointResaultX[var12]
						Self.chkPointY = var11
						Self.chkPointId = var12
						Self.chkPointDegree = Self.footDegree
						
						Self.calChkOffset(Self.chkPointX, Self.chkPointY, Self.chkPointId, Self.chkPointDegree)
						Self.footDegree = Self.getDegreeFromWorld(Self.footDegree, Self.chkPointX, Self.chkPointY, Self.acObj.posZ)
						
						Self.actionState = WALK_ACTION_STATE
						
						Local var14:= ((90 + Self.footDegree) Mod 360)
						Local var15:= (Self.moveDistanceX * MyAPI.dCos(var14) + Self.moveDistanceY * MyAPI.dSin(var14)) / 100 + Self.user.getPressToGround()
						Local var16:= CrlFP32.actTanDegree(Self.acObj.velY, Self.acObj.velX)
						Local var17:= Self.getDegreeDiff(Self.footDegree, var16)
						
						If (var15 < 0 And var17 > Self.user.getMinDegreeToLeaveGround()) Then
							Self.user.doWhileLeaveGround()
							
							Self.chkPointX = ACUtilities.getRelativePointX(Self.footX, Self.footCollisionPointOffsetX[Self.priorityChkId], Self.footCollisionPointOffsetY, var10)
							Self.chkPointY = ACUtilities.getRelativePointY(Self.footY, Self.footCollisionPointOffsetX[Self.priorityChkId], Self.footCollisionPointOffsetY, var10)
							
							Self.chkPointId = Self.priorityChkId
							Self.chkPointDegree = Self.footDegree
							
							Self.calChkOffset(Self.chkPointX, Self.chkPointY, Self.chkPointId, Self.chkPointDegree)
							
							Self.actionState = JUMP_ACTION_STATE
							
							Return
						EndIf
					Case DIRECTION_RIGHT, DIRECTION_LEFT
						Local var2:= NO_COLLISION
						Local var3:= Self.footDegree
						Local var4:= -1
						
						If (Self.checkArrayForShowX = Null) Then
							Self.checkArrayForShowX = new Int[Self.footCollisionPointOffsetX.Length]
							Self.checkArrayForShowY = new Int[Self.footCollisionPointOffsetX.Length]
						EndIf
						
						For Local var5:= 0 Until Self.footCollisionPointOffsetX.Length
							Self.footCollisionPointResaultY[var5] = ACUtilities.getRelativePointY(Self.footY, Self.footCollisionPointOffsetX[var5], Self.footCollisionPointOffsetY, var3)
							
							Self.checkArrayForShowX[var5] = ACUtilities.getRelativePointX(Self.footX, Self.footCollisionPointOffsetX[var5], Self.footCollisionPointOffsetY + Self.user.getPressToGround(), var3)
							Self.checkArrayForShowY[var5] = Self.footCollisionPointResaultY[var5]
							
							Self.footCollisionPointResaultX[var5] = Self.getWorldX(ACUtilities.getRelativePointX(Self.footX, Self.footCollisionPointOffsetX[var5], Self.footCollisionPointOffsetY + Self.user.getPressToGround(), var3), Self.footCollisionPointResaultY[var5], var1)
							
							If (Self.footCollisionPointResaultX[var5] <> NO_COLLISION And (var2 = NO_COLLISION Or var1 = DIRECTION_RIGHT And Self.footCollisionPointResaultX[var5] > var2 Or var1 = DIRECTION_LEFT And Self.footCollisionPointResaultX[var5] < var2 Or var5 = Self.priorityChkId)) Then
								var4 = var5
								var2 = Self.footCollisionPointResaultX[var5]
								
								If (var5 = Self.priorityChkId) Then
									Exit
								EndIf
							EndIf
						Next
		
						If (var4 = -1) Then
							Self.user.doWhileLeaveGround()
							
							Self.chkPointX = ACUtilities.getRelativePointX(Self.footX, Self.footCollisionPointOffsetX[Self.priorityChkId], Self.footCollisionPointOffsetY, var3)
							Self.chkPointY = ACUtilities.getRelativePointY(Self.footY, Self.footCollisionPointOffsetX[Self.priorityChkId], Self.footCollisionPointOffsetY, var3)
							
							Self.chkPointId = Self.priorityChkId
							Self.chkPointDegree = Self.footDegree
							
							Self.calChkOffset(Self.chkPointX, Self.chkPointY, Self.chkPointId, Self.chkPointDegree)
							
							Self.actionState = JUMP_ACTION_STATE
							
							Return
						EndIf
		
						Self.chkPointX = var2
						Self.chkPointY = Self.footCollisionPointResaultY[var4]
						Self.chkPointId = var4
						Self.chkPointDegree = Self.footDegree
						
						Self.footDegree = Self.getDegreeFromWorld(Self.footDegree, Self.chkPointX, Self.chkPointY, Self.acObj.posZ)
						Self.calChkOffset(Self.chkPointX, Self.chkPointY, Self.chkPointId, Self.chkPointDegree)
						
						Self.actionState = WALK_ACTION_STATE
						
						Local var6:= ((90 + Self.footDegree) Mod 360)
						Local var7:= (Self.moveDistanceX * MyAPI.dCos(var6) + Self.moveDistanceY * MyAPI.dSin(var6)) / 100 + Self.user.getPressToGround()
						Local var8:= CrlFP32.actTanDegree(Self.moveDistanceY, Self.moveDistanceX)
						Local var9:= Self.getDegreeDiff(Self.footDegree, var8)
						
						If (var7 < 0 And var9 > Self.user.getMinDegreeToLeaveGround()) Then
							Self.user.doWhileLeaveGround()
							
							Self.chkPointX = ACUtilities.getRelativePointX(Self.footX, Self.footCollisionPointOffsetX[Self.priorityChkId], Self.footCollisionPointOffsetY, var3)
							Self.chkPointY = ACUtilities.getRelativePointY(Self.footY, Self.footCollisionPointOffsetX[Self.priorityChkId], Self.footCollisionPointOffsetY, var3)
							
							Self.chkPointId = Self.priorityChkId
							Self.chkPointDegree = Self.footDegree
							
							Self.calChkOffset(Self.chkPointX, Self.chkPointY, Self.chkPointId, Self.chkPointDegree)
							
							Self.actionState = JUMP_ACTION_STATE
							
							Return
						EndIf
					Default
						Return
				End Select
			EndIf
		End
		
		Method moveToNextPosition:Void()
			Local newY:Int
			Local newX:Int
			
			Local currentBlockX:= ACUtilities.getQuaParam(Self.chkPointX, Self.worldInstance.getTileWidth())
			Local currentBlockY:= ACUtilities.getQuaParam(Self.chkPointY, Self.worldInstance.getTileHeight())
			
			Self.worldInstance.getCollisionBlock(Self.getBlock, Self.chkPointX, Self.chkPointY, Self.acObj.posZ)
			
			Local preDegree:= Self.user.getBodyDegree()
			
			Local startPointX:= Self.chkPointX
			Local startPointY:= Self.chkPointY
			
			Self.moveDistanceX = ((Self.totalDistance * MyAPI.dCos(Self.user.getBodyDegree())) / 100)
			Self.moveDistanceY = ((Self.totalDistance * MyAPI.dSin(Self.user.getBodyDegree())) / 100)
			
			Local direction:= getDirectionByDegree(Self.user.getBodyDegree())
			
			Local preFootDegree:Int
			
			If (direction = DIRECTION_UP Or direction = DIRECTION_DOWN) Then
				Local preCheckX:= Self.chkPointX
				
				If (Self.moveDistanceX = 0) Then
					Self.moveDistanceY = 0
				ElseIf (Self.moveDistanceX > 0) Then
					If (Self.chkPointX + Self.moveDistanceX >= getBlockLeftSide(currentBlockX + 1, currentBlockY)) Then
						Self.chkPointX = getBlockLeftSide(currentBlockX + 1, currentBlockY)
					Else
						Self.chkPointX += Self.moveDistanceX
					EndIf
				Else
					If (Self.chkPointX + Self.moveDistanceX <= getBlockRightSide(currentBlockX - 1, currentBlockY)) Then
						Self.chkPointX = getBlockRightSide(currentBlockX - 1, currentBlockY)
					Else
						Self.chkPointX += Self.moveDistanceX
					EndIf
				EndIf
				
				calObjPositionFromFoot()
				doSideCheckInGround(direction)
				calChkPointFromPos()
				
				preFootDegree = Self.footDegree
				
				newY = getWorldY(Self.chkPointX, Self.chkPointY + (DSgn((direction = DIRECTION_UP)) * (Abs(Self.chkPointX - startPointX) + Self.user.getPressToGround())), direction)
				
				If (newY <> NO_COLLISION) Then
					Self.chkPointY = newY
					
					Self.footDegree = getDegreeFromWorld(Self.footDegree, Self.chkPointX, Self.chkPointY, Self.acObj.posZ)
				EndIf
				
				calObjPositionFromFoot()
				
				If (direction = getDirectionByDegree(Self.footDegree)) Then
					doSideCheckInGround(direction)
					calChkPointFromPos()
				EndIf
				
				Self.footDegree = preFootDegree
				
				newY = getWorldY(Self.chkPointX, Self.chkPointY + (DSgn((direction = DIRECTION_UP)) * (Abs(Self.chkPointX - startPointX) + Self.user.getPressToGround())), direction)
				
				If (newY <> NO_COLLISION) Then
					Self.chkPointY = newY
				EndIf
			Else
				If (Self.moveDistanceY = 0) Then
					Self.moveDistanceX = 0
				ElseIf (Self.moveDistanceY > 0) Then
					If (Self.chkPointY + Self.moveDistanceY >= getBlockUpSide(currentBlockX, currentBlockY + 1)) Then
						Self.chkPointY = getBlockUpSide(currentBlockX, currentBlockY + 1)
					Else
						Self.chkPointY += Self.moveDistanceY
					EndIf
				Else
					If (Self.chkPointY + Self.moveDistanceY <= getBlockDownSide(currentBlockX, currentBlockY - 1)) Then
						Self.chkPointY = getBlockDownSide(currentBlockX, currentBlockY - 1)
					Else
						Self.chkPointY += Self.moveDistanceY
					EndIf
				EndIf
				
				preFootDegree = Self.footDegree
				
				newX = getWorldX(Self.chkPointX + (DSgn((direction = DIRECTION_LEFT)) * (Abs(Self.chkPointY - startPointY) + Self.user.getPressToGround())), Self.chkPointY, direction)
				
				If (newX <> NO_COLLISION) Then
					Self.chkPointX = newX
					Self.footDegree = getDegreeFromWorld(Self.footDegree, Self.chkPointX, Self.chkPointY, Self.acObj.posZ)
				EndIf
				
				calObjPositionFromFoot()
				
				If (direction = getDirectionByDegree(Self.footDegree)) Then
					If (Self.moveDistanceY > 0) Then
						If (direction = DIRECTION_OFFSET_LEFT) Then
							rightSideCollisionChk(Self.footX, Self.footY, direction, Self.collisionData)
							
							newY = Self.collisionData.newPosY
						Else
							leftSideCollisionChk(Self.footX, Self.footY, direction, Self.collisionData)
							
							newY = Self.collisionData.newPosY
						EndIf
						
						If (newY <> NO_COLLISION) Then
							Self.footY = newY
							
							calChkPointFromPos()
							
							Self.user.doWhileTouchWorld(PickValue((direction = DIRECTION_RIGHT), DIRECTION_RIGHT, DIRECTION_LEFT), getDegreeFromWorld((Self.footDegree + PickValue(direction = DIRECTION_RIGHT, 270, 90)) Mod 360, Self.collisionData.collisionX, Self.collisionData.collisionY, Self.acObj.posZ))
							
							Self.moveDistanceY = 0
							Self.acObj.velY = 0
						EndIf
					ElseIf (Self.moveDistanceY < 0) Then
						If (direction = DIRECTION_RIGHT) Then
							leftSideCollisionChk(Self.footX, Self.footY, direction, Self.collisionData)
							
							newY = Self.collisionData.newPosY
						Else
							rightSideCollisionChk(Self.footX, Self.footY, direction, Self.collisionData)
							
							newY = Self.collisionData.newPosY
						EndIf
						
						If (newY <> NO_COLLISION) Then
							Self.footY = newY
							
							calChkPointFromPos()
							
							Self.user.doWhileTouchWorld(PickValue((direction = DIRECTION_RIGHT), DIRECTION_LEFT, DIRECTION_RIGHT), getDegreeFromWorld((Self.footDegree + PickValue((direction = DIRECTION_RIGHT), 90, 270)) Mod 360, Self.collisionData.collisionX, Self.collisionData.collisionY, Self.acObj.posZ))
							
							Self.moveDistanceY = 0
							Self.acObj.velY = 0
						EndIf
					EndIf
				EndIf
				
				Self.footDegree = preFootDegree
				
				newX = getWorldX(Self.chkPointX + (DSgn((direction = DIRECTION_LEFT)) * (Abs(Self.chkPointY - startPointY) + Self.user.getPressToGround())), Self.chkPointY, direction)
				
				If (newX <> NO_COLLISION) Then
					Self.chkPointX = newX
				EndIf
			EndIf
			
			calObjPositionFromFoot()
			
			Select (getDirectionByDegree(Self.footDegree))
				Case DIRECTION_UP
					newY = getWorldY(Self.footX, Self.footY + Self.worldInstance.getTileHeight(), DIRECTION_UP)
					
					If (newY <> NO_COLLISION) Then
						Self.footY = newY
					EndIf
				Case DIRECTION_RIGHT
					newX = getWorldX(Self.footX - Self.worldInstance.getTileHeight(), Self.footY, DIRECTION_RIGHT)
					
					If (newX <> NO_COLLISION) Then
						Self.footX = newX
					EndIf
				Case DIRECTION_DOWN
					newY = getWorldY(Self.footX, Self.footY - Self.worldInstance.getTileHeight(), DIRECTION_DOWN)
					
					If (newY <> NO_COLLISION) Then
						Self.footY = newY
					EndIf
				Case DIRECTION_LEFT
					newX = getWorldX(Self.footX + Self.worldInstance.getTileHeight(), Self.footY, DIRECTION_LEFT)
					
					If (newX <> NO_COLLISION) Then
						Self.footX = newX
					EndIf
			End Select
			
			Local preMoveDistanceX:= Self.moveDistanceX
			Local preMoveDistanceY:= Self.moveDistanceY
			
			Self.moveDistanceX -= Self.chkPointX - startPointX
			Self.moveDistanceY -= Self.chkPointY - startPointY
			
			If (Self.totalDistance * (((Self.moveDistanceX * MyAPI.dCos(Self.user.getBodyDegree())) + (Self.moveDistanceY * MyAPI.dSin(Self.user.getBodyDegree()))) / 100) <= 0) Then
				Self.moveDistanceX = 0
				Self.moveDistanceY = 0
			EndIf
			
			Self.totalDistance = (((Self.moveDistanceX * MyAPI.dCos(Self.user.getBodyDegree())) + (Self.moveDistanceY * MyAPI.dSin(Self.user.getBodyDegree()))) / 100)
		End
		
		Method getWorldY:Int(x:Int, y:Int, direction:Int)
			Return Self.worldInstance.getWorldY(x, y, Self.acObj.posZ, direction)
		End
	
		Method getWorldX:Int(x:Int, y:Int, direction:Int)
			Return Self.worldInstance.getWorldX(x, y, Self.acObj.posZ, direction)
		End
		
		Method rightSideCollisionChk:Void(x:Int, y:Int, direction:Int, collisionData:ACCollisionData)
			Local collisionPointId:Int
			Local maxDiff:Int
			Local i:Int
			Local objX:Int
			Local objY:Int
			Local diff:Int
			
			collisionData.reset()
			
			If (Self.limit <> Null) Then
				If (Self.limit.noSideCollision()) Then
					Return
				EndIf
			EndIf
			
			Select (direction)
				Case DIRECTION_UP, DIRECTION_DOWN
					Local maxBlockPixX:= ACParam.NO_COLLISION
					
					collisionPointId = -1
					maxDiff = -1
					
					i = 0
					
					While (True)
						If (i >= Self.bodyCollisionPointOffsetY.Length) Then
							If (maxBlockPixX <> ACParam.NO_COLLISION) Then
								collisionData.newPosX = ACUtilities.getRelativePointX(maxBlockPixX, -Self.bodyCollisionPointOffsetX, -Self.bodyCollisionPointOffsetY[collisionPointId], Self.user.getBodyDegree())
								
								Self.worldInstance.getCollisionBlock(Self.getBlock, collisionData.collisionX, collisionData.collisionY, Self.acObj.posZ)
								
								collisionData.reBlock = Self.getBlock
								
								Exit
							EndIf
						EndIf
						
						objX = ACUtilities.getRelativePointX(x, Self.bodyCollisionPointOffsetX, Self.bodyCollisionPointOffsetY[i], Self.user.getBodyDegree())
						objY = ACUtilities.getRelativePointY(y, Self.bodyCollisionPointOffsetX, Self.bodyCollisionPointOffsetY[i], Self.user.getBodyDegree())
						
						Local blockPixX:= getWorldX(objX, objY, (direction + DIRECTION_OFFSET_RIGHT) Mod DIRECTION_NUM)
						
						If (blockPixX <> ACParam.NO_COLLISION) Then
							diff = Abs(blockPixX - objX)
							
							If (maxBlockPixX = ACParam.NO_COLLISION Or diff > maxDiff) Then
								maxBlockPixX = blockPixX
								
								collisionPointId = i
								maxDiff = diff
								
								collisionData.collisionX = maxBlockPixX
								collisionData.collisionY = objY
								collisionData.newPosY = y
							EndIf
						EndIf
						
						i += 1
					Wend
			End Select
			
			Local maxBlockPixY:= ACParam.NO_COLLISION
			
			collisionPointId = -1
			maxDiff = -1
			
			i = 0
			
			While (True)
				If (i < Self.bodyCollisionPointOffsetY.Length) Then
					objX = ACUtilities.getRelativePointX(x, Self.bodyCollisionPointOffsetX, Self.bodyCollisionPointOffsetY[i], Self.user.getBodyDegree())
					objY = ACUtilities.getRelativePointY(y, Self.bodyCollisionPointOffsetX, Self.bodyCollisionPointOffsetY[i], Self.user.getBodyDegree())
					
					Local blockPixY:= getWorldY(objX, objY, (direction + DIRECTION_OFFSET_RIGHT) Mod DIRECTION_NUM)
					
					If (blockPixY <> ACParam.NO_COLLISION) Then
						diff = Abs(blockPixY - objY)
						
						If (maxBlockPixY = ACParam.NO_COLLISION Or diff > maxDiff) Then
							maxBlockPixY = blockPixY
							
							collisionPointId = i
							maxDiff = diff
							
							collisionData.collisionX = maxBlockPixY
							collisionData.collisionY = objX
							collisionData.newPosX = x
						EndIf
					EndIf
					
					i += 1
				ElseIf (maxBlockPixY <> ACParam.NO_COLLISION) Then
					collisionData.newPosY = ACUtilities.getRelativePointY(maxBlockPixY, -Self.bodyCollisionPointOffsetX, -Self.bodyCollisionPointOffsetY[collisionPointId], Self.user.getBodyDegree())
					
					Self.worldInstance.getCollisionBlock(Self.getBlock, collisionData.collisionX, collisionData.collisionY, Self.acObj.posZ)
					
					collisionData.reBlock = Self.getBlock
					
					Exit
				Else
					Exit
				EndIf
			Wend
		End
		
		Method leftSideCollisionChk:Void(x:Int, y:Int, direction:Int, collisionData:ACCollisionData)
			Local collisionPointId:Int
			Local maxDiff:Int
			Local i:Int
			Local objX:Int
			Local objY:Int
			Local diff:Int
			
			collisionData.reset()
			
			If (Self.limit <> Null) Then
				If (Self.limit.noSideCollision()) Then
					Return
				EndIf
			EndIf
			
			Select (direction)
				Case DIRECTION_UP, DIRECTION_DOWN
					Local maxBlockPixX:= ACParam.NO_COLLISION
					
					collisionPointId = -1
					maxDiff = -1
					
					i = 0
					
					While (True)
						If (i >= Self.bodyCollisionPointOffsetY.Length) Then
							If (maxBlockPixX <> ACParam.NO_COLLISION) Then
								collisionData.newPosX = ACUtilities.getRelativePointX(maxBlockPixX, Self.bodyCollisionPointOffsetX, -Self.bodyCollisionPointOffsetY[collisionPointId], Self.user.getBodyDegree())
								
								Self.worldInstance.getCollisionBlock(Self.getBlock, collisionData.collisionX, collisionData.collisionY, Self.acObj.posZ)
								
								collisionData.reBlock = Self.getBlock
								
								Exit
							EndIf
						EndIf
						
						objX = ACUtilities.getRelativePointX(x, -Self.bodyCollisionPointOffsetX, Self.bodyCollisionPointOffsetY[i], Self.user.getBodyDegree())
						objY = ACUtilities.getRelativePointY(y, -Self.bodyCollisionPointOffsetX, Self.bodyCollisionPointOffsetY[i], Self.user.getBodyDegree())
						
						Local blockPixX:= getWorldX(objX, objY, (direction + DIRECTION_OFFSET_LEFT) Mod DIRECTION_NUM)
						
						If (blockPixX <> ACParam.NO_COLLISION) Then
							diff = Abs(blockPixX - objX)
							
							If (maxBlockPixX = ACParam.NO_COLLISION Or diff > maxDiff) Then
								maxBlockPixX = blockPixX
								
								collisionPointId = i
								maxDiff = diff
								
								collisionData.collisionX = maxBlockPixX
								collisionData.collisionY = objY
								collisionData.newPosY = y
							EndIf
						EndIf
						
						i += 1
					Wend
			End Select
			
			Local maxBlockPixY:= ACParam.NO_COLLISION
			
			collisionPointId = -1
			maxDiff = -1
			
			i = 0
			
			While (True)
				If (i < Self.bodyCollisionPointOffsetY.Length) Then
					objX = ACUtilities.getRelativePointX(x, -Self.bodyCollisionPointOffsetX, Self.bodyCollisionPointOffsetY[i], Self.user.getBodyDegree())
					objY = ACUtilities.getRelativePointY(y, -Self.bodyCollisionPointOffsetX, Self.bodyCollisionPointOffsetY[i], Self.user.getBodyDegree())
					
					Local blockPixY:= getWorldY(objX, objY, (direction + DIRECTION_OFFSET_LEFT) Mod DIRECTION_NUM)
					
					If (blockPixY <> ACParam.NO_COLLISION) Then
						diff = Abs(blockPixY - objY)
						
						If (maxBlockPixY = ACParam.NO_COLLISION Or diff > maxDiff) Then
							maxBlockPixY = blockPixY
							
							collisionPointId = i
							maxDiff -= diff
							
							collisionData.collisionX = objX
							collisionData.collisionY = maxBlockPixY
							collisionData.newPosX = x
						EndIf
					EndIf
					
					i += 1
				ElseIf (maxBlockPixY <> ACParam.NO_COLLISION) Then
					collisionData.newPosX = ACUtilities.getRelativePointY(maxBlockPixY, Self.bodyCollisionPointOffsetX, -Self.bodyCollisionPointOffsetY[collisionPointId], Self.user.getBodyDegree())
					
					Self.worldInstance.getCollisionBlock(Self.getBlock, collisionData.collisionX, collisionData.collisionY, Self.acObj.posZ)
					
					collisionData.reBlock = Self.getBlock
					
					Exit
				Else
					Exit
				EndIf
			Wend
		End
		
		Method upSideCollisionChk:Void(x:Int, y:Int, direction:Int, collisionData:ACCollisionData)
			collisionData.reset()
			
			If (Self.limit <> Null) Then
				If (Self.limit.noTopCollision()) Then
					Return
				EndIf
			EndIf
			
			Local maxDiff:Int
			Local collisionPointId:Int
			Local i:Int
			Local objX:Int
			Local objY:Int
			Local diff:Int
			
			Select (direction)
				Case DIRECTION_UP, DIRECTION_DOWN
					Local maxBlockPixY:= ACParam.NO_COLLISION
					
					maxDiff = -1
					collisionPointId = -1
					
					i = 0
					
					While (True)
						If (i < Self.headCollisionPointOffsetX.Length) Then
							objX = ACUtilities.getRelativePointX(x, Self.headCollisionPointOffsetX[i], Self.headCollisionPointOffsetY, Self.footDegree)
							objY = ACUtilities.getRelativePointY(y, Self.headCollisionPointOffsetX[i], Self.headCollisionPointOffsetY, Self.footDegree)
							
							Local blockPixY:= getWorldY(objX, objY, (direction + DIRECTION_OFFSET_UP) Mod DIRECTION_NUM)
							
							If (blockPixY <> ACParam.NO_COLLISION) Then
								diff = Abs(objY - blockPixY)
								
								If (maxBlockPixY = ACParam.NO_COLLISION Or diff > maxDiff) Then
									maxBlockPixY = blockPixY
									
									collisionPointId = i
									maxDiff = diff
								EndIf
							EndIf
							
							i += 1
						ElseIf (maxBlockPixY <> ACParam.NO_COLLISION) Then
							objX = ACUtilities.getRelativePointX(x, Self.headCollisionPointOffsetX[collisionPointId], Self.headCollisionPointOffsetY, Self.footDegree)
							objY = ACUtilities.getRelativePointY(y, Self.headCollisionPointOffsetX[collisionPointId], Self.headCollisionPointOffsetY, Self.footDegree)
							
							Self.worldInstance.getCollisionBlock(Self.getBlock, objX, maxBlockPixY, Self.acObj.posZ)
							
							collisionData.collisionX = objX
							collisionData.collisionY = maxBlockPixY
							
							collisionData.newPosX = x
							collisionData.newPosY = ACUtilities.getRelativePointY(maxBlockPixY, -Self.headCollisionPointOffsetX[collisionPointId], -Self.headCollisionPointOffsetY, Self.footDegree)
							
							collisionData.reBlock = Self.getBlock
							
							Exit
						Else
							Exit
						EndIf
					Wend
				Default
					Local maxBlockPixX:= ACParam.NO_COLLISION
					
					maxDiff = -1
					collisionPointId = -1
					
					i = 0
					
					While (True)
						If (i < Self.headCollisionPointOffsetX.Length) Then
							objX = ACUtilities.getRelativePointX(x, Self.headCollisionPointOffsetX[i], Self.headCollisionPointOffsetY, Self.footDegree)
							Local blockPixX:= getWorldX(objX, ACUtilities.getRelativePointY(y, Self.headCollisionPointOffsetX[i], Self.headCollisionPointOffsetY, Self.footDegree), (direction + DIRECTION_OFFSET_UP) Mod DIRECTION_NUM)
							
							If (blockPixX <> ACParam.NO_COLLISION) Then
								diff = Abs(objX - blockPixX)
								
								If (maxBlockPixX = ACParam.NO_COLLISION Or diff > maxDiff) Then
									maxBlockPixX = blockPixX
									
									collisionPointId = i
									maxDiff = diff
								EndIf
							EndIf
							
							i += 1
						ElseIf (maxBlockPixX <> ACParam.NO_COLLISION) Then
							objX = ACUtilities.getRelativePointX(x, Self.headCollisionPointOffsetX[collisionPointId], Self.headCollisionPointOffsetY, Self.footDegree)
							objY = ACUtilities.getRelativePointY(y, Self.headCollisionPointOffsetX[collisionPointId], Self.headCollisionPointOffsetY, Self.footDegree)
							
							Self.worldInstance.getCollisionBlock(Self.getBlock, maxBlockPixX, objY, Self.acObj.posZ)
							
							collisionData.collisionX = maxBlockPixX
							collisionData.collisionY = objY
							
							collisionData.newPosY = y
							collisionData.newPosX = ACUtilities.getRelativePointX(maxBlockPixX, -Self.headCollisionPointOffsetX[collisionPointId], -Self.headCollisionPointOffsetY, Self.footDegree)
							
							collisionData.reBlock = Self.getBlock
							
							Exit
						Else
							Exit
						EndIf
					Wend
			End Select
		End
		
		Method downSideCollisionChk:Void(x:Int, y:Int, direction:Int, collisionData:ACCollisionData)
			collisionData.reset()
			
			If (Self.limit <> Null) Then
				If (Self.limit.noDownCollision()) Then
					Return
				EndIf
			EndIf
			
			Local collisionPointId:= -1
			Local maxDiff:= -1
			
			Local i:Int
			
			Local objX:Int
			Local objY:Int
			Local diff:Int
			
			Select (direction)
				Case DIRECTION_UP, DIRECTION_DOWN
					Local maxBlockPixY:= ACParam.NO_COLLISION
					
					i = 0
					
					While (True)
						If (i < Self.footCollisionPointOffsetX.Length) Then
							objX = ACUtilities.getRelativePointX(x, Self.footCollisionPointOffsetX[i], Self.footCollisionPointOffsetY, Self.footDegree)
							objY = ACUtilities.getRelativePointY(y, Self.footCollisionPointOffsetX[i], Self.footCollisionPointOffsetY, Self.footDegree)
							
							Local blockPixY:= getWorldY(objX, objY, (direction + DIRECTION_OFFSET_DOWN) Mod DIRECTION_NUM)
							
							If (blockPixY <> ACParam.NO_COLLISION) Then
								diff = Abs(objY - blockPixY)
								
								If (maxBlockPixY = ACParam.NO_COLLISION Or diff > maxDiff Or i = Self.priorityChkId) Then
									maxBlockPixY = blockPixY
									
									collisionPointId = i
									maxDiff = diff
									
									If (i <> Self.priorityChkId) Then
										' Nothing so far.
									EndIf
								EndIf
							EndIf
							
							i += 1
						EndIf
						
						If (maxBlockPixY <> ACParam.NO_COLLISION) Then
							objX = ACUtilities.getRelativePointX(x, Self.footCollisionPointOffsetX[collisionPointId], Self.footCollisionPointOffsetY, Self.footDegree)
							objY = ACUtilities.getRelativePointY(y, Self.footCollisionPointOffsetX[collisionPointId], Self.footCollisionPointOffsetY, Self.footDegree)
							
							Self.worldInstance.getCollisionBlock(Self.getBlock, objX, maxBlockPixY, Self.acObj.posZ)
							
							collisionData.collisionX = objX
							collisionData.collisionY = maxBlockPixY
							collisionData.newPosX = x
							collisionData.newPosY = ACUtilities.getRelativePointY(maxBlockPixY, -Self.footCollisionPointOffsetX[collisionPointId], -Self.footCollisionPointOffsetY, Self.footDegree)
							collisionData.reBlock = Self.getBlock
							collisionData.chkPointID = collisionPointId
							
							Exit
						EndIf
						
						' This may change in the future.
						Exit
					Wend
				Default
					Local maxBlockPixX:= ACParam.NO_COLLISION
					
					i = 0
					
					While (True)
						If (i < Self.footCollisionPointOffsetX.Length) Then
							objX = ACUtilities.getRelativePointX(x, Self.footCollisionPointOffsetX[i], Self.footCollisionPointOffsetY, Self.footDegree)
							
							Local blockPixX:= getWorldX(objX, ACUtilities.getRelativePointY(y, Self.footCollisionPointOffsetX[i], Self.footCollisionPointOffsetY, Self.footDegree), (direction + DIRECTION_OFFSET_DOWN) Mod DIRECTION_NUM)
							
							If (blockPixX <> ACParam.NO_COLLISION) Then
								diff = Abs(objX - blockPixX)
								
								If (maxBlockPixX = ACParam.NO_COLLISION Or diff > maxDiff Or i = Self.priorityChkId) Then
									maxBlockPixX = blockPixX
									collisionPointId = i
									maxDiff = diff
									
									If (i <> Self.priorityChkId) Then
										' Nothing so far.
									EndIf
								EndIf
							EndIf
							
							i += 1
						EndIf
						
						If (maxBlockPixX <> ACParam.NO_COLLISION) Then
							objX = ACUtilities.getRelativePointX(x, Self.footCollisionPointOffsetX[collisionPointId], Self.footCollisionPointOffsetY, Self.footDegree)
							objY = ACUtilities.getRelativePointY(y, Self.footCollisionPointOffsetX[collisionPointId], Self.footCollisionPointOffsetY, Self.footDegree)
							
							Self.worldInstance.getCollisionBlock(Self.getBlock, maxBlockPixX, objY, Self.acObj.posZ)
							
							collisionData.collisionX = maxBlockPixX
							collisionData.collisionY = objY
							collisionData.newPosY = y
							collisionData.newPosX = ACUtilities.getRelativePointX(maxBlockPixX, -Self.footCollisionPointOffsetX[collisionPointId], -Self.footCollisionPointOffsetY, Self.footDegree)
							collisionData.reBlock = Self.getBlock
							collisionData.chkPointID = collisionPointId
							
							Exit
						EndIf
						
						' This behavior may change in the future.
						Exit
					Wend
			End Select
		End

		Method getBlockLeftSide:Int(blockX:Int, blockY:Int)
			' Not sure why we're doing this, but whatever.
			Return (blockX + 0) * Self.worldInstance.getTileWidth()
		End
	
		Method getBlockRightSide:Int(blockX:Int, blockY:Int)
			Return (((blockX + 1) * Self.worldInstance.getTileWidth()) - 1)
		End
	
		Method getBlockUpSide:Int(blockX:Int, blockY:Int)
			' Again, not sure why we're doing this, but whatever.
			Return ((blockY + 0) * Self.worldInstance.getTileHeight())
		End
	
		Method getBlockDownSide:Int(blockX:Int, blockY:Int)
			Return (((blockY + 1) * Self.worldInstance.getTileHeight()) - 1)
		End
	
		Method calObjPositionFromFoot:Void()
			Self.footX = (Self.chkPointX - Self.chkOffsetX)
			Self.footY = (Self.chkPointY - Self.chkOffsetY)
		End
	
		Method calChkPointFromPos:Void()
			Self.chkPointX = (Self.footX + Self.chkOffsetX)
			Self.chkPointY = (Self.footY + Self.chkOffsetY)
		End
	
		Method calChkOffset:Void(chkPointX:Int, chkPointY:Int, chkPointId:Int, degree:Int)
			Local footX:= ACUtilities.getRelativePointX(chkPointX, -Self.footCollisionPointOffsetX[chkPointId], -Self.footCollisionPointOffsetY, degree)
			Local footY:= ACUtilities.getRelativePointY(chkPointY, -Self.footCollisionPointOffsetX[chkPointId], -Self.footCollisionPointOffsetY, degree)
			
			Self.chkOffsetX = (chkPointX - footX)
			Self.chkOffsetY = (chkPointY - footY)
		End
		
		Method getDegreeFromWorld:Int(currentDegree:Int, x:Int, y:Int, z:Int)
			While (currentDegree < 0)
				currentDegree += 360
			Wend
			
			currentDegree Mod= 360
			
			If (Self.degreeGetter = Null) Then
				Return currentDegree
			EndIf
			
			Self.degreeGetter.getDegreeFromWorldByPosition(Self.degreeRe, currentDegree, x, y, z)
			
			Return Self.degreeRe.degree
		End
		
		Method doSideCheckInGround:Void(direction:Int)
			Local newX:Int
			Local i:Int
			Local degree:Int
			
			Local aCWorldCalUser:ACWorldCalUser
			
			If (Self.moveDistanceX > 0) Then
				If (direction = DIRECTION_UP) Then
					rightSideCollisionChk(Self.footX, Self.footY, direction, Self.collisionData)
					
					newX = Self.collisionData.newPosX
				Else
					leftSideCollisionChk(Self.footX, Self.footY, direction, Self.collisionData)
					
					newX = Self.collisionData.newPosX
				EndIf
				
				If (newX <> ACParam.NO_COLLISION) Then
					Self.footX = newX
					
					calChkPointFromPos()
					
					Local i2:= Self.footDegree
					
					If (direction = DIRECTION_UP) Then
						i = 270
					Else
						i = 90
					EndIf
					
					degree = getDegreeFromWorld((i2 + i) Mod 360, Self.collisionData.collisionX, Self.collisionData.collisionY, Self.acObj.posZ)
					
					aCWorldCalUser = Self.user
					
					If (direction = DIRECTION_UP) Then
						i = DIRECTION_RIGHT
					Else
						i = DIRECTION_LEFT
					EndIf
					
					aCWorldCalUser.doWhileTouchWorld(i, degree)
					
					Self.moveDistanceX = 0
					Self.acObj.velX = 0
				EndIf
			ElseIf (Self.moveDistanceX < 0) Then
				If (direction = DIRECTION_UP) Then
					leftSideCollisionChk(Self.footX, Self.footY, direction, Self.collisionData)
					
					newX = Self.collisionData.newPosX
				Else
					rightSideCollisionChk(Self.footX, Self.footY, direction, Self.collisionData)
					
					newX = Self.collisionData.newPosX
				EndIf
				
				If (newX <> ACParam.NO_COLLISION) Then
					Self.footX = newX
					
					calChkPointFromPos()
					
					degree = getDegreeFromWorld((Self.footDegree + PickValue((direction = DIRECTION_UP), 90, 270)) Mod 360, Self.collisionData.collisionX, Self.collisionData.collisionY, Self.acObj.posZ)
					
					aCWorldCalUser = Self.user
					
					If (direction = DIRECTIONUP) Then
						i = DIRECTION_LEFT
					Else
						i = DIRECTION_RIGHT
					EndIf
					
					aCWorldCalUser.doWhileTouchWorld(i, degree)
					
					Self.moveDistanceX = 0
					Self.acObj.velX = 0
				EndIf
			EndIf
		End
		
		Method canBeSideStop:Bool(direction:Int)
			Local re:Bool = False
			
			If (direction = DIRECTION_LEFT And ((getDirectionByDegree(Self.footDegree) = 0 And (Self.moveDistanceX <= 0 Or Self.acObj.velX <= 0)) Or (getDirectionByDegree(Self.footDegree) = DIRECTION_DOWN And (Self.moveDistanceX >= 0 Or Self.acObj.velX >= 0)))) Then
				re = True
			EndIf
			
			If (direction <> DIRECTION_RIGHT) Then
				Return re
			EndIf
			
			If (getDirectionByDegree(Self.footDegree) <> 0 Or (Self.moveDistanceX < 0 And Self.acObj.velX < 0)) Then
				If (getDirectionByDegree(Self.footDegree) <> DIRECTION_DOWN) Then
					Return re
				EndIf
				
				If (Self.moveDistanceX > 0 And Self.acObj.velX > 0) Then
					Return re
				EndIf
			EndIf
			
			Return True
		End
End