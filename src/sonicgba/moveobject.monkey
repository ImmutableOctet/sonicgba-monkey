Strict

Public

' Imports:
Private
	Import sonicgba.gameobject
Public

' Classes:

' Presumed base class for objects with some form of motion.
' May be for specialized objects hierarchy unknown.
Class MoveObject Extends GameObject Abstract
	Protected
		' Fields:
		Field totalVelocity:Int
	Public
		' Methods:
		
		' Property potential:
		Method getVelX:Int()
			Return Self.velX
		End
		
		Method getVelY:Int()
			Return Self.velY
		End
		
		Method setVelX:Void(value:Int)
			Self.velX = value
			
			Return 
		End
		
		Method setVelY:Void(value:Int)
			Self.velY = value
			
			Return 
		End
		
		' Extensions:
		Method getTotalVelocity:Int()
			Return totalVelocity
		End
		
		Method setTotalVelocity:Void(value:Int)
			Self.totalVelocity = value
		End
End