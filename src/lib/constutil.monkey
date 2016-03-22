Strict

Public

' Imports:
Private
	'Import com.sega.mobile.framework.device.mfgamepad
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
Public

' Functions:

' Extensions:
Function DSgn:Int(value:Int)
	If (value > 0) Then
		Return 1
	EndIf
	
	Return -1
End

Function DSgn:Int(value:Bool)
	If (Not value) Then
		Return -1
	EndIf
	
	Return 1
End

' Extensions:
Function PickValue:Int(Toggle:Bool, A:Int, B:Int)
	If (Toggle) Then
		Return A
	EndIf
	
	Return B
End

' Classes:
Class ConstUtil
	Public
		' Constant variable(s):
		Const FLIP_X:Short = 8192
		Const FLIP_Y:Short = 16384
		Const ROTATE_180:Short = 24576
		Const ROTATE_270:Short = 4096
		
		' The math used to make up this array may change in the future.
		Global TRANS:Short[] = [FLIP_Y, FLIP_X, ROTATE_180, (ROTATE_180 - ROTATE_270), (ROTATE_180 | ROTATE_270), ROTATE_270, (FLIP_Y - ROTATE_270)]
		
		' Functions:
		Function DrawImage:Void(g:MFGraphics, img:MFImage, dx:Int, dy:Int, anchor:Int, tmp_attr:Int)
			Local cx:= img.getWidth()
			Local cy:= img.getHeight()
			
			Local attr:= 0
			
			If ((tmp_attr & ROTATE_270) <> 0) Then
				attr = (0 | 6)
				
				If ((tmp_attr & FLIP_X) <> 0) Then
					attr ~= 1
				EndIf
				
				If ((tmp_attr & FLIP_Y) <> 0) Then
					attr ~= 2
				EndIf
			Else
				If ((tmp_attr & FLIP_X) <> 0) Then
					attr = (0 | 2)
				EndIf
				
				If ((tmp_attr & FLIP_Y) <> 0) Then
					attr |= 1
				EndIf
			EndIf
			
			MyAPI.drawImageWithoutZoom(g, img, 0, 0, cx, cy, attr, dx, dy, anchor)
		End
	
		Function DrawImage:Void(g:MFGraphics, dx:Int, dy:Int, img:MFImage, sx:Int, sy:Int, cx:Int, cy:Int, tmp_attr:Int)
			If (img <> Null) Then
				Local img_cx:= img.getWidth()
				Local img_cy:= img.getHeight()
				
				If (sx < img_cx And sy < img_cy) Then
					Local attr:= 0
					
					If ((tmp_attr & ROTATE_270) <> 0) Then
						attr = (0 | 6)
						
						If ((tmp_attr & FLIP_X) <> 0) Then
							attr ~= 1
						EndIf
						
						If ((tmp_attr & FLIP_Y) <> 0) Then
							attr ~= 2
						EndIf
					Else
						If ((tmp_attr & FLIP_X) <> 0) Then
							attr = (0 | 2)
						EndIf
						
						If ((tmp_attr & FLIP_Y) <> 0) Then
							attr |= 1
						EndIf
					EndIf
					
					If (sx + cx > img_cx) Then
						cx = img_cx - sx
					EndIf
					
					If (sy + cy > img_cy) Then
						cy = img_cy - sy
					EndIf
					
					MyAPI.drawImageWithoutZoom(g, img, sx, sy, cx, cy, attr, dx, dy, 0)
				EndIf
			EndIf
		End
		
		Method RectIntersect:Bool(rect1:Int[], rect2:Int[]) ' Short[], Short[]
			If (rect2[0] >= rect1[0] + rect1[2] Or rect2[0] + rect2[2] <= rect1[0] Or rect2[1] >= rect1[1] + rect1[3] Or rect2[1] + rect2[3] <= rect1[1]) Then
				Return False
			EndIf
			
			Return True
		End
End