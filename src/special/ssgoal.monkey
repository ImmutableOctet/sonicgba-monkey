Strict

Public

' Imports:
Private
	Import special.usableobject
Public

' Classes:
Class SSGoal Extends UsableObject
	Public
		' Constructor(s):
		Method New(x:Int, y:Int, z:Int)
			Super.New(SSOBJ_GOAL, x, y, z)
		End
		
		' Methods:
		Method onUse:Void(collisionObj:SpecialObject)
			player.setGoal()
		End
End