
Copyright Daniel Peña Vazquez ( www.blackdtools.com )

Language: Visual Basic 6
Purpose: Read tibia.dat 8.6 or above (see changes in code comments)
' for tibia 8.6 and higher
Public Function LoadDatFile4() As Integer
  Dim res As Integer
  Dim i As Long
  Dim j As Long
  Dim fn As Integer
  Dim optByte As Byte
  Dim optbyte2 As Byte
  Dim b1 As Byte
  Dim b2 As Byte
  Dim a As String
  Dim lonNumber As Long
  Dim lWidth  As Long
  Dim lHeight As Long
  Dim lBlendframes As Long
  Dim lXdiv As Long
  Dim lYdiv As Long
  Dim lAnimcount As Long
  Dim lRare As Long
  Dim skipcount As Long
  Dim debugByte As Byte
  Dim tileLog As String
  Dim tileLog2 As String
  Dim tileOnDebug As Long
  Dim nextB As Byte
  Dim tibiadatHere As String
  Dim expI As Long
  Dim bTmp As Byte
  #If FinalMode Then
    On Error GoTo badErr
  #End If
  res = 0
  tileOnDebug = 20000

  ' init the array of tiles with default values
  For i = 0 To MAXDATTILES
    DatTiles(i).iscontainer = False
    DatTiles(i).RWInfo = 0
    DatTiles(i).fluidcontainer = False
    DatTiles(i).stackable = False
    DatTiles(i).multitype = False
    DatTiles(i).useable = False
    DatTiles(i).notMoveable = False
    DatTiles(i).alwaysOnTop = False
    DatTiles(i).groundtile = False
    DatTiles(i).blocking = False
    DatTiles(i).pickupable = False
    DatTiles(i).blockingProjectile = False
    DatTiles(i).canWalkThrough = False
    DatTiles(i).noFloorChange = False
    DatTiles(i).blockpickupable = True
    DatTiles(i).isDoor = False
    DatTiles(i).isDoorWithLock = False
    DatTiles(i).speed = 0
    DatTiles(i).canDecay = True
    DatTiles(i).haveExtraByte = False 'custom flag
    DatTiles(i).floorChangeUP = False 'custom flag
    DatTiles(i).floorChangeDOWN = False 'custom flag
    DatTiles(i).requireRightClick = False 'custom flag
    DatTiles(i).requireRope = False 'custom flag
    DatTiles(i).requireShovel = False 'custom flag
    DatTiles(i).isWater = False ' custom flag
    DatTiles(i).stackPriority = 1 ' custom flag, higher number, higher priority
    DatTiles(i).haveFish = False
    DatTiles(i).isFood = False
    DatTiles(i).isField = False
    DatTiles(i).isDepot = False
    DatTiles(i).moreAlwaysOnTop = False
    DatTiles(i).usable2 = False
    DatTiles(i).multiCharge = False
  Next i
  DatTiles(0).stackPriority = 0
  DatTiles(97).stackPriority = 2
  DatTiles(98).stackPriority = 2
  DatTiles(99).stackPriority = 2
  DatTiles(97).blocking = True
  DatTiles(98).blocking = True
  DatTiles(99).blocking = True
  i = 100 ' i = tileID
  
  #If TileDebug Then
    OverwriteOnFile "tibiadatdebug.txt", "Here is what Blackd Proxy could read in your tibia.dat file :"
  #End If
  
  
  fn = FreeFile
  ' Open the file tibia.dat for binary access
  ' it look for it in the same path than this program (App.Path)
  If configPath = "" Then
    tibiadatHere = App.Path & "\tibia.dat"
  Else
    tibiadatHere = App.Path & "\" & configPath & "\tibia.dat"
  End If
  Open tibiadatHere For Binary As fn
  Get fn, , b1
  Get fn, , b1
  Get fn, , b1
  Get fn, , b1
  Get fn, , b1
  Get fn, , b1
  Get fn, , b1
  Get fn, , b1
  Get fn, , b1

  If (TibiaVersionLong >= 860) Then ' check version byte
    If (b1 <> &H46) Then
      LoadDatFile4 = -2
      Exit Function
    End If
  Else
      LoadDatFile4 = -2
      Exit Function
  End If
  'a$ = Space$(3) ' descartado, podria dar problemas
  Get fn, , b1
  Get fn, , b1
  Get fn, , b1
  Do
    #If TileDebug Then
      tileLog = "tile #" & CStr(i) & ":"
    #End If
    Get fn, , optByte
    ' analyze all option Bytes until we read the byte &HFF
    ' note that some options are ignored
    ' and the meaning of some bytes are still unknown
    ' however this will get enough info for most purposes
    While (optByte <> &HFF) And Not EOF(fn)
'        If i = 2524 Then
'        Debug.Print "TEST"
'
'        End If
      #If TileDebug Then
        tileLog = tileLog & " " & GoodHex(optByte)
      #End If
      Select Case optByte
      Case &H0
        'is groundtile
        DatTiles(i).groundtile = True
        Get fn, , b1
        #If TileDebug Then
          tileLog = tileLog & " " & GoodHex(b1)
        #End If
        lonNumber = CLng(b1)
        DatTiles(i).speed = lonNumber
        If lonNumber = 0 Then
          DatTiles(i).blocking = True
        End If
        Get fn, , b2 'ignore next opt byte
        #If TileDebug Then
          tileLog = tileLog & " " & GoodHex(b2)
        #End If
      Case &H1 ' UNMODIFIED
        ' new property : alwaysOnTop of higher priority
        DatTiles(i).moreAlwaysOnTop = True
      Case &H2 ' UNMODIFIED
        'always on top
        DatTiles(i).alwaysOnTop = True
      Case &H3 ' UNMODIFIED
        ' can walk through (open doors, arces ...)
        DatTiles(i).canWalkThrough = True
        DatTiles(i).alwaysOnTop = True
      Case &H4 ' UNMODIFIED
        ' is container
        DatTiles(i).iscontainer = True
      Case &H5 ' UNMODIFIED
        ' is stackable
        DatTiles(i).stackable = True
      Case &H6 ' UNMODIFIED
        ' is useable
        DatTiles(i).useable = True
      Case &H7 ' UNMODIFIED
        DatTiles(i).usable2 = True ' deleted since tibia 8.6 ?
        'DatTiles(i).multiCharge = True ' deleted since tibia 8.6 ?

'      Case &H8 ' DELETED !!
'        DatTiles(i).multiCharge = True
        
      Case &H8 ' used to be &H9 ' NEW - OK
        ' writtable objects
        DatTiles(i).RWInfo = 3 ' can writen + can be read
        Get fn, , b1 ' max characters that can be written in it (0 unlimited)
        #If TileDebug Then
          tileLog = tileLog & " " & GoodHex(b1)
        #End If
        Get fn, , b2 ' max number of  newlines ? 0, 2, 4, 7
        #If TileDebug Then
          tileLog = tileLog & " " & GoodHex(b2)
        #End If
     Case &H9 ' used to be &HA ' NEW - OK
        ' writtable objects that can't be edited
        DatTiles(i).RWInfo = 1 ' can be read only
        Get fn, , b1 'always 0 max characters that can be written in it (0 unlimited)
        #If TileDebug Then
          tileLog = tileLog & " " & GoodHex(b1)
        #End If
        Get fn, , b2 ' always 4 max number of  newlines ?
        #If TileDebug Then
          tileLog = tileLog & " " & GoodHex(b2)
        #End If
      Case &HA ' used to be &HB ' NEW - OK
        ' is fluid container
       DatTiles(i).fluidcontainer = True
      Case &HB ' used to be &HC ' NEW - OK
        ' multitype
        DatTiles(i).multitype = True ' DELETED ON TIBIA 8.6
      Case &HC ' OK - used to be &HD ' NEW - OK
        ' is blocking
        DatTiles(i).blocking = True
        

        
        
      Case &HD ' OK - used to be &HE ' NEW - OK
        ' not moveable
        DatTiles(i).notMoveable = True
      Case &HE ' OK - used to be &HF ' NEW - OK
        ' block missiles
        DatTiles(i).blockingProjectile = True
      Case &HF 'used to be &H10 ' NEW - OK
        ' Slight obstacle (include fields and certain boxes)
        ' I prefer to don't consider a generic obstable and
        ' do special cases for fields and ignore the boxes
      Case &H10 ' used to be &H11 - ' NEW - OK
        ' pickupable / equipable
        DatTiles(i).pickupable = True
      Case &H15 ' used to be &H17 - ' NEW - OK
        ' makes light -- skip bytes
        Get fn, , b1 ' number of tiles around
        #If TileDebug Then
          tileLog = tileLog & " " & GoodHex(b1)
        #End If
        Get fn, , b2 ' 0
        #If TileDebug Then
          tileLog = tileLog & " " & GoodHex(b2)
        #End If
        Get fn, , b1 ' = 215 for items , =208 for non items
        #If TileDebug Then
          tileLog = tileLog & " " & GoodHex(b1)
        #End If
        Get fn, , b2 ' 0
        #If TileDebug Then
          tileLog = tileLog & " " & GoodHex(b2)
        #End If
      Case &H11 ' used to be &H12 - ' NEW - OK
        ' can see what is under (ladder holes, stairs holes etc)
      Case &H1E ' used to be &H1F - ' NEW - OK
        ' ground tiles that don't cause level change
        DatTiles(i).noFloorChange = True

      Case &H19 ' used to be &H1A ' NEW - OK
        ' mostly blocking items, but also items that can pile up in level (boxes, chairs etc)
        DatTiles(i).blockpickupable = False
        Get fn, , b1 ' always 8
        #If TileDebug Then
          tileLog = tileLog & " " & GoodHex(b1)
        #End If
        Get fn, , b2 ' always 0
        #If TileDebug Then
          tileLog = tileLog & " " & GoodHex(b2)
        #End If
      Case &H14 ' used to be &H15 ' NEW - OK
         ' unknown
      Case &H18 ' used to be &H19 ' NEW - OK
        ' unknown
        Get fn, , b1 ' 4 bytes of extra info
        #If TileDebug Then
          tileLog = tileLog & " " & GoodHex(b1)
        #End If
        Get fn, , b2
        #If TileDebug Then
          tileLog = tileLog & " " & GoodHex(b2)
        #End If
        Get fn, , b1
        #If TileDebug Then
          tileLog = tileLog & " " & GoodHex(b1)
        #End If
        Get fn, , b2
        #If TileDebug Then
          tileLog = tileLog & " " & GoodHex(b2)
        #End If
      Case &H1C 'used to be &H1D ' NEW - OK
        ' for minimap drawing
        Get fn, , b1 ' 2 bytes for colour
        #If TileDebug Then
          tileLog = tileLog & " " & GoodHex(b1)
        #End If
        Get fn, , b2
        #If TileDebug Then
          tileLog = tileLog & " " & GoodHex(b2)
        #End If
        
        ' xxxxxxxx
         Case &H17 ' used to be &H18 ' NEW - OK
        ' stairs to down
        DatTiles(i).floorChangeDOWN = True
      Case &H1A ' used to be &H1B ' NEW - OK
        ' corpses that don't decay
        DatTiles(i).canDecay = False
      Case &H1B ' used to be &H1C ' NEW - OK
        'wall items
      Case &H12 ' used to be &H13 ' NEW - OK
        ' action posible
      Case &H13 ' used to be &H14 ' NEW - OK
        'walls 2 types of them same material (total 4 pairs)
      Case &H1D ' used to be &H1E ' NEW - OK
        ' line spot ...
        Get fn, , optbyte2 '86 -> openable holes, 77-> can be used to go down, 76 can be used to go up, 82 -> stairs up, 79 switch,
        #If TileDebug Then
          tileLog = tileLog & " " & GoodHex(optbyte2)
        #End If
        Select Case optbyte2
        Case &H4C
          'ladders
          DatTiles(i).floorChangeUP = True
          DatTiles(i).requireRightClick = True
        Case &H4D
          'crate - trapdor?
          DatTiles(i).requireRightClick = True
        Case &H4E
          'rope spot?
          DatTiles(i).floorChangeUP = True
          DatTiles(i).requireRope = True
        Case &H4F
          'switch
        Case &H50
          'doors
          DatTiles(i).isDoor = True
        Case &H51
          'doors with locks
          DatTiles(i).isDoorWithLock = True
        Case &H52
          'stairs to up floor
          DatTiles(i).floorChangeUP = True
        Case &H53
          'mailbox
        Case &H54
          'depot
          DatTiles(i).isDepot = True
        Case &H55
          'trash
        Case &H56
         'hole
          DatTiles(i).floorChangeDOWN = True
          DatTiles(i).requireShovel = True
          DatTiles(i).alwaysOnTop = True
          DatTiles(i).multitype = False
        Case &H57
          'items with special description?
        Case &H58
          'writtable
          DatTiles(i).RWInfo = 1 ' read only
        Case Else
          ' should not happen
          debugByte = optByte
          #If TileDebug Then
            tileLog = tileLog & " " & GoodHex(b1) & "!"
          #End If
        End Select 'optbyte2
        Get fn, , b1 ' always value 4
        #If TileDebug Then
          tileLog = tileLog & " " & GoodHex(b1)
        #End If
      Case &H1F  ' used to be &H20 ' NEW - OK
        'new flag since tibia 8.57
  
      Case &H16 ' used to be &H17 ' NEW - OK
        'new flag since tibia 8.57

    
      Case Else
        ' should not happen
        debugByte = optByte
        #If TileDebug Then
          tileLog = tileLog & "?"
        #End If
      End Select 'optbyte
      Get fn, , nextB 'next optByte
      #If TileDebug Then
      If nextB <= optByte Then
        LogOnFile "tibiadatdebug.txt", "ERROR AT tileID #" & CStr(i) & " : " & GoodHex(nextB) & " <= " & GoodHex(optByte)
      End If
      #End If
      optByte = nextB
    Wend
endAnalyze:
    #If TileDebug Then
      tileLog = tileLog & " " & GoodHex(optByte) & " < "
      LogOnFile "tibiadatdebug.txt", tileLog
    #End If

    ' some flags can be made by a combination of existing flags
    If DatTiles(i).stackable = True Or DatTiles(i).multitype = True Or _
      DatTiles(i).fluidcontainer = True Then
      DatTiles(i).haveExtraByte = True
    End If
    
    If DatTiles(i).multiCharge = True Then
      DatTiles(i).haveExtraByte = True
    End If

    If DatTiles(i).alwaysOnTop = True Then
      DatTiles(i).stackPriority = 3 ' high priority
    End If
    
    If DatTiles(i).moreAlwaysOnTop = True Then
      DatTiles(i).alwaysOnTop = True
      DatTiles(i).stackPriority = 4 ' max priority
    End If
    
    ' add special cases of floor changers, for cavebot
    Select Case i
    ' ramps that change floor when you step in
    Case tileID_rampToNorth, tileID_rampToSouth, tileID_rampToRightCycMountain, _
     tileID_rampToLeftCycMountain, tileID_rampToNorth, tileID_desertRamptoUp, _
     tileID_jungleStairsToNorth, tileID_jungleStairsToLeft
      DatTiles(i).floorChangeUP = True
    Case tileID_grassCouldBeHole ' grass that will turn into a hole when you step in
      DatTiles(i).floorChangeDOWN = True
    End Select
    
    '[CUSTOM FLAGS FOR BLACKDPROXY]
    'water, for smart autofisher
    If i = tileID_waterWithFish Then
      DatTiles(i).isWater = True
      DatTiles(i).haveFish = True
    End If
    If i = tileID_waterEmpty Then
      DatTiles(i).isWater = True
    End If
    If TibiaVersionLong >= 781 Then
        If i = tileID_blockingBox Then
            DatTiles(i).blocking = True
        End If
    End If
    
    If TibiaVersionLong >= 760 Then

    If (i >= tileID_waterWithFish) And (i <= tileID_waterWithFishEnd) Then
      DatTiles(i).isWater = True
      DatTiles(i).haveFish = True
    End If
    If (i >= tileID_waterEmpty) And (i <= tileID_waterEmptyEnd) Then
      DatTiles(i).isWater = True
    End If

    End If
    ' food, for autoeater
    If i >= tileID_firstFoodTileID And i <= tileID_lastFoodTileID Then
      DatTiles(i).isFood = True
    End If
    If (i >= tileID_firstMushroomTileID) And (i <= tileID_lastMushroomTileID) Then
      DatTiles(i).isFood = True
    End If
    
    ' fields, for a* smart path
    If i >= tileID_firstFieldRangeStart And i <= tileID_firstFieldRangeEnd Then
      DatTiles(i).isField = True
    End If
    If (i >= tileID_secondFieldRangeStart) And (i <= tileID_secondFieldRangeEnd) Then
      DatTiles(i).isField = True
    End If
    Select Case i
    Case tileID_campFire1, tileID_campFire2
      DatTiles(i).isField = True
    Case tileID_walkableFire1, tileID_walkableFire2, tileID_walkableFire3
      DatTiles(i).isField = False 'dont consider fields that doesnt do any harm
    End Select
    If i = tileID_woodenStairstoUp Then 'special stairs
      DatTiles(i).floorChangeUP = True
    End If
    If i = tileID_WallBugItem Then 'bug on walls, cant pick it!
      DatTiles(i).pickupable = False
    End If
    '[/CUSTOM FLAGS FOR BLACKDPROXY]
    
    ' options zone done for this tile
    ' now we get info about the graph of the tile...
    ' but as we are not interested on it, just skip enough bytes
    Get fn, , b1
    #If TileDebug = 1 Then
   
      tileLog2 = GoodHex(b1)

    #End If
    
    lWidth = CLng(b1)
    Get fn, , b1
    #If TileDebug = 1 Then
      tileLog2 = tileLog2 & " " & GoodHex(b1)
    #End If
    lHeight = CLng(b1)
    If lWidth > 1 Or lHeight > 1 Then
      'skip 1 byte
      Get fn, , b1
      #If TileDebug = 1 Then
        tileLog2 = tileLog2 & " " & GoodHex(b1)
      #End If
    End If
    Get fn, , b1
    #If TileDebug = 1 Then
      tileLog2 = tileLog2 & " " & GoodHex(b1)
    #End If
    lBlendframes = CLng(b1)
    Get fn, , b1
    #If TileDebug = 1 Then
      tileLog2 = tileLog2 & " " & GoodHex(b1)
    #End If
    lXdiv = CLng(b1)
    Get fn, , b1
    #If TileDebug = 1 Then
      tileLog2 = tileLog2 & " " & GoodHex(b1)
    #End If
    lYdiv = CLng(b1)
    Get fn, , b1
    #If TileDebug = 1 Then
      tileLog2 = tileLog2 & " " & GoodHex(b1)
    #End If
    lAnimcount = CLng(b1)
    Get fn, , b1
    #If TileDebug = 1 Then
      tileLog2 = tileLog2 & " " & GoodHex(b1)
    #End If
    lRare = CLng(b1)
    
    skipcount = protectedMult(lWidth, lHeight, lBlendframes, lXdiv, lYdiv, lAnimcount, lRare, 2)
    If skipcount = -1 Then
      DBGtileError = "The function failed exactly because this overflow: " & vbCrLf & _
       CStr(lWidth) & " * " & CStr(lHeight) & " * " & CStr(lBlendframes) & " * " & CStr(lXdiv) & " * " & CStr(lYdiv) & " * " & CStr(lAnimcount) & " * " & CStr(lRare) & " * 2" & _
       vbCrLf & "tibia.dat path = tibiadatHere"
      LoadDatFile4 = -5 ' unexpected overflow
      Exit Function
    End If
    skipcount = (lWidth * lHeight * lBlendframes * lXdiv * lYdiv * lAnimcount * lRare * 2)  'size = old formulae x lRare
    #If TileDebug = 1 Then
    ' if you are curious about graphic data of certain tile, then just set tileOnDebug=your desired tileID
        If i = tileOnDebug Then
          tileLog2 = " Debug graphic part for tile # " & CStr(i) & " : " & tileLog2 & " : "
          For j = 1 To skipcount
            Get fn, , b1
            tileLog2 = tileLog2 & " " & GoodHex(b1)
          Next j
          LogOnFile "tibiadatdebug.txt", tileLog2
        Else
            For expI = 1 To skipcount
                Get fn, , bTmp
            Next expI
        End If
    #Else
        For expI = 1 To skipcount
            Get fn, , bTmp
        Next expI
    #End If

    i = i + 1
    If i > MAXDATTILES Then
      res = -3  ' need to increase const MAXDATTILES
      GoTo endF
    End If
  Loop Until EOF(fn)
  ' Close the file
  Close fn
  ' last one is not a valid tile id! -> i - 1
  highestDatTile = i - 1
  If highestDatTile < 1 Then
    LoadDatFile4 = -1
    Exit Function
  End If
endF:
  For i = 0 To MAXTILEIDLISTSIZE
    If (AditionalStairsToUpFloor(i) = 0) Then
      Exit For
    Else
      DatTiles(AditionalStairsToUpFloor(i)).floorChangeUP = True
    End If
  Next i
  For i = 0 To MAXTILEIDLISTSIZE
    If (AditionalRequireRope(i) = 0) Then
      Exit For
    Else
      DatTiles(AditionalRequireRope(i)).floorChangeUP = True
      DatTiles(AditionalRequireRope(i)).requireRope = True
    End If
  Next i
  
  For i = 0 To MAXTILEIDLISTSIZE
    If (AditionalRequireShovel(i) = 0) Then
      Exit For
    Else
      DatTiles(AditionalRequireShovel(i)).floorChangeDOWN = True
      DatTiles(AditionalRequireShovel(i)).requireShovel = True
      DatTiles(AditionalRequireShovel(i)).alwaysOnTop = True
      DatTiles(AditionalRequireShovel(i)).multitype = False
    End If
  Next i
  
  
  For i = 0 To MAXTILEIDLISTSIZE
    If (AditionalStairsToDownFloor(i) = 0) Then
      Exit For
    Else
      DatTiles(AditionalStairsToDownFloor(i)).floorChangeDOWN = True
    End If
  Next i
  LoadDatFile4 = res
  Exit Function
badErr:
  DBGtileError = "Error number = " & CStr(Err.Number) & vbCrLf & "Error description = " & Err.Description & vbCrLf & "Path = " & tibiadatHere
  LoadDatFile4 = -4 ' bad format or wrong version of given tibia.dat
End Function