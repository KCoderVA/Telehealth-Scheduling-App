Option Explicit

' Main subroutine to process conference room scheduling
Sub ProcessConferenceRoomScheduling()
    Dim masterWs As Worksheet
    Dim buildingTabs As Variant
    Dim dayColumns As Variant
    Dim currentRow As Long
    Dim i As Integer
    Dim buildingName As String  ' Add this variable to fix the ByRef issue

    ' Create or get reference to the output worksheet
    On Error Resume Next
    Set masterWs = ThisWorkbook.Worksheets("Output_VBAMacro")
    On Error GoTo 0

    ' If the output sheet doesn't exist, create it
    If masterWs Is Nothing Then
        Set masterWs = ThisWorkbook.Worksheets.Add
        masterWs.Name = "Output_VBAMacro"

        ' Add headers to the new sheet
        masterWs.Cells(1, 1).Value = "Room & Time Slot"
        masterWs.Cells(1, 2).Value = "Monday"
        masterWs.Cells(1, 3).Value = "Tuesday"
        masterWs.Cells(1, 4).Value = "Wednesday"
        masterWs.Cells(1, 5).Value = "Thursday"
        masterWs.Cells(1, 6).Value = "Friday"
        masterWs.Cells(1, 7).Value = "Saturday"
        masterWs.Cells(1, 8).Value = "Sunday"

        ' Format headers
        With masterWs.Range("A1:H1")
            .Font.Bold = True
            .Interior.Color = RGB(200, 200, 200)
        End With
    End If

    ' Define the building tabs to process (using actual tab names)
    buildingTabs = Array("OakLawn", "HoffmanEstates", "LaSalle", "Kankakee", "Joliet", "Aurora")

    ' Define the day columns (B through H for Mon-Sun)
    dayColumns = Array("B", "C", "D", "E", "F", "G", "H")

    ' Clear existing data in the output sheet (starting from row 2 to preserve headers)
    masterWs.Range("A2:H1000").ClearContents

    ' Initialize the current row counter
    currentRow = 2

    ' Process each building
    For i = LBound(buildingTabs) To UBound(buildingTabs)
        buildingName = buildingTabs(i)  ' Assign to a variable first
        currentRow = ProcessSpecificBuilding(buildingName, masterWs, currentRow, dayColumns)
    Next i

    ' Auto-fit columns for better visibility
    masterWs.Columns("A:H").AutoFit

    ' Activate the output sheet to show results
    masterWs.Activate

    MsgBox "Conference room scheduling processing complete!" & vbCrLf & _
           "Results saved to 'Output_VBAMacro' tab."
End Sub

' Function to process a specific building (fixed parameter types)
Function ProcessSpecificBuilding(buildingName As String, masterWs As Worksheet, startRow As Long, dayColumns As Variant) As Long
    Dim buildingWs As Worksheet
    Dim currentRow As Long

    currentRow = startRow

    ' Check if the building worksheet exists
    On Error Resume Next
    Set buildingWs = ThisWorkbook.Worksheets(buildingName)
    On Error GoTo 0

    If buildingWs Is Nothing Then
        ' If worksheet doesn't exist, skip this building
        ProcessSpecificBuilding = currentRow
        Exit Function
    End If

    ' Process based on the specific building
    Select Case buildingName
        Case "OakLawn"
            currentRow = ProcessOakLawnBuilding(buildingWs, masterWs, currentRow, dayColumns)
        Case "HoffmanEstates"
            currentRow = ProcessHoffmanEstatesBuilding(buildingWs, masterWs, currentRow, dayColumns)
        Case "LaSalle"
            currentRow = ProcessLaSalleBuilding(buildingWs, masterWs, currentRow, dayColumns)
        Case "Kankakee"
            currentRow = ProcessKankakeeBuilding(buildingWs, masterWs, currentRow, dayColumns)
        Case "Joliet"
            currentRow = ProcessJolietBuilding(buildingWs, masterWs, currentRow, dayColumns)
        Case "Aurora"
            currentRow = ProcessAuroraBuilding(buildingWs, masterWs, currentRow, dayColumns)
        Case Else
            ' Unknown building, skip
    End Select

    ProcessSpecificBuilding = currentRow
End Function

' Oak Lawn Building processing (your detailed specification)
Function ProcessOakLawnBuilding(buildingWs As Worksheet, masterWs As Worksheet, startRow As Long, dayColumns As Variant) As Long
    Dim roomConfigs As Variant
    Dim currentRow As Long
    Dim i As Integer, j As Integer
    Dim roomName As String
    Dim cellValue As String
    Dim timeSlot As Integer  ' Add missing variable declaration

    currentRow = startRow

    ' Define Oak Lawn conference rooms with their cell mappings
    ' Format: Room Name, Row Range Start, Row Range End
    roomConfigs = Array( _
        Array("OakLawn Room A", 3, 14), _
        Array("OakLawn Room B", 16, 27), _
        Array("OakLawn Room C", 29, 40), _
        Array("OakLawn Room D", 42, 53), _
        Array("OakLawn Room E", 55, 66), _
        Array("OakLawn Room F", 68, 79), _
        Array("OakLawn Room G", 81, 92) _
    )

    ' Process each conference room
    For i = LBound(roomConfigs) To UBound(roomConfigs)
        roomName = roomConfigs(i)(0)

        ' Process each time slot for this room
        For timeSlot = roomConfigs(i)(1) To roomConfigs(i)(2)
            ' Always add this time slot to the output (regardless of content)
            masterWs.Cells(currentRow, 1).Value = roomName & " - Slot " & (timeSlot - roomConfigs(i)(1) + 1)

            ' Copy the day values, using "AVAILABLE" for empty cells
            For j = LBound(dayColumns) To UBound(dayColumns)
                cellValue = Trim(buildingWs.Cells(timeSlot, dayColumns(j)).Value)
                If cellValue = "" Then
                    masterWs.Cells(currentRow, j + 2).Value = "AVAILABLE"
                Else
                    masterWs.Cells(currentRow, j + 2).Value = cellValue
                End If
            Next j

            currentRow = currentRow + 1
        Next timeSlot
    Next i

    ProcessOakLawnBuilding = currentRow
End Function

' Placeholder functions for other buildings
Function ProcessHoffmanEstatesBuilding(buildingWs As Worksheet, masterWs As Worksheet, startRow As Long, dayColumns As Variant) As Long
    ' HoffmanEstates has same layout as Oak Lawn (7 rooms)
    Dim roomConfigs As Variant
    Dim currentRow As Long
    Dim i As Integer, j As Integer
    Dim roomName As String
    Dim cellValue As String
    Dim timeSlot As Integer

    currentRow = startRow

    ' Same room configuration as Oak Lawn
    roomConfigs = Array( _
        Array("HoffmanEstates Room A", 3, 14), _
        Array("HoffmanEstates Room B", 16, 27), _
        Array("HoffmanEstates Room C", 29, 40), _
        Array("HoffmanEstates Room D", 42, 53), _
        Array("HoffmanEstates Room E", 55, 66), _
        Array("HoffmanEstates Room F", 68, 79), _
        Array("HoffmanEstates Room G", 81, 92) _
    )

    ' Process each conference room (same logic as Oak Lawn)
    For i = LBound(roomConfigs) To UBound(roomConfigs)
        roomName = roomConfigs(i)(0)

        For timeSlot = roomConfigs(i)(1) To roomConfigs(i)(2)
            ' Always add this time slot to the output (regardless of content)
            masterWs.Cells(currentRow, 1).Value = roomName & " - Slot " & (timeSlot - roomConfigs(i)(1) + 1)

            ' Copy the day values, using "AVAILABLE" for empty cells
            For j = LBound(dayColumns) To UBound(dayColumns)
                cellValue = Trim(buildingWs.Cells(timeSlot, dayColumns(j)).Value)
                If cellValue = "" Then
                    masterWs.Cells(currentRow, j + 2).Value = "AVAILABLE"
                Else
                    masterWs.Cells(currentRow, j + 2).Value = cellValue
                End If
            Next j

            currentRow = currentRow + 1
        Next timeSlot
    Next i

    ProcessHoffmanEstatesBuilding = currentRow
End Function

Function ProcessLaSalleBuilding(buildingWs As Worksheet, masterWs As Worksheet, startRow As Long, dayColumns As Variant) As Long
    ' LaSalle has same layout as Oak Lawn (7 rooms)
    Dim roomConfigs As Variant
    Dim currentRow As Long
    Dim i As Integer, j As Integer
    Dim roomName As String
    Dim cellValue As String
    Dim timeSlot As Integer

    currentRow = startRow

    ' Same room configuration as Oak Lawn
    roomConfigs = Array( _
        Array("LaSalle Room A", 3, 14), _
        Array("LaSalle Room B", 16, 27), _
        Array("LaSalle Room C", 29, 40), _
        Array("LaSalle Room D", 42, 53), _
        Array("LaSalle Room E", 55, 66), _
        Array("LaSalle Room F", 68, 79), _
        Array("LaSalle Room G", 81, 92) _
    )

    ' Process each conference room (same logic as Oak Lawn)
    For i = LBound(roomConfigs) To UBound(roomConfigs)
        roomName = roomConfigs(i)(0)

        For timeSlot = roomConfigs(i)(1) To roomConfigs(i)(2)
            ' Always add this time slot to the output (regardless of content)
            masterWs.Cells(currentRow, 1).Value = roomName & " - Slot " & (timeSlot - roomConfigs(i)(1) + 1)

            ' Copy the day values, using "AVAILABLE" for empty cells
            For j = LBound(dayColumns) To UBound(dayColumns)
                cellValue = Trim(buildingWs.Cells(timeSlot, dayColumns(j)).Value)
                If cellValue = "" Then
                    masterWs.Cells(currentRow, j + 2).Value = "AVAILABLE"
                Else
                    masterWs.Cells(currentRow, j + 2).Value = cellValue
                End If
            Next j

            currentRow = currentRow + 1
        Next timeSlot
    Next i

    ProcessLaSalleBuilding = currentRow
End Function

Function ProcessKankakeeBuilding(buildingWs As Worksheet, masterWs As Worksheet, startRow As Long, dayColumns As Variant) As Long
    ' Kankakee has 10 rooms total (7 standard + 3 additional)
    Dim roomConfigs As Variant
    Dim currentRow As Long
    Dim i As Integer, j As Integer
    Dim roomName As String
    Dim cellValue As String
    Dim timeSlot As Integer

    currentRow = startRow

    ' Kankakee room configuration (10 rooms total)
    ' Standard 7 rooms + 3 additional at different locations
    roomConfigs = Array( _
        Array("Kankakee Room A", 3, 14, "B"), _
        Array("Kankakee Room B", 16, 27, "B"), _
        Array("Kankakee Room C", 29, 40, "B"), _
        Array("Kankakee Room D", 42, 53, "B"), _
        Array("Kankakee Room E", 55, 66, "B"), _
        Array("Kankakee Room F", 68, 79, "B"), _
        Array("Kankakee Room G", 81, 92, "B"), _
        Array("Kankakee Room H", 5, 22, "AC"), _
        Array("Kankakee Room I", 55, 72, "H"), _
        Array("Kankakee Room J", 55, 72, "O") _
    )

    ' Process each conference room
    For i = LBound(roomConfigs) To UBound(roomConfigs)
        roomName = roomConfigs(i)(0)
        Dim roomStartRow As Integer, roomEndRow As Integer, startCol As String
        roomStartRow = roomConfigs(i)(1)
        roomEndRow = roomConfigs(i)(2)
        startCol = roomConfigs(i)(3)

        For timeSlot = roomStartRow To roomEndRow
            ' Always add this time slot to the output (regardless of content)
            masterWs.Cells(currentRow, 1).Value = roomName & " - Slot " & (timeSlot - roomStartRow + 1)

            ' Copy the day values, using "AVAILABLE" for empty cells
            For j = 0 To 6
                colIndex = Range(startCol & "1").Column + j
                cellValue = Trim(buildingWs.Cells(timeSlot, colIndex).Value)
                If cellValue = "" Then
                    masterWs.Cells(currentRow, j + 2).Value = "AVAILABLE"
                Else
                    masterWs.Cells(currentRow, j + 2).Value = cellValue
                End If
            Next j

            currentRow = currentRow + 1
        Next timeSlot
    Next i

    ProcessKankakeeBuilding = currentRow
End Function

Function ProcessJolietBuilding(buildingWs As Worksheet, masterWs As Worksheet, startRow As Long, dayColumns As Variant) As Long
    ' Joliet has 12 rooms total (7 standard + 5 additional)
    Dim roomConfigs As Variant
    Dim currentRow As Long
    Dim i As Integer, j As Integer
    Dim roomName As String
    Dim cellValue As String
    Dim timeSlot As Integer

    currentRow = startRow

    ' Joliet room configuration (12 rooms total)
    roomConfigs = Array( _
        Array("Joliet Room A", 3, 14, "B"), _
        Array("Joliet Room B", 16, 27, "B"), _
        Array("Joliet Room C", 29, 40, "B"), _
        Array("Joliet Room D", 42, 53, "B"), _
        Array("Joliet Room E", 55, 66, "B"), _
        Array("Joliet Room F", 68, 79, "B"), _
        Array("Joliet Room G", 81, 92, "B"), _
        Array("Joliet Room H", 5, 22, "AC"), _
        Array("Joliet Room I", 5, 22, "AJ"), _
        Array("Joliet Room J", 55, 72, "H"), _
        Array("Joliet Room K", 5, 22, "AQ"), _
        Array("Joliet Room L", 26, 43, "O"), _
        Array("Joliet Room M", 26, 43, "V") _
    )

    ' Process each conference room (same logic as Kankakee)
    For i = LBound(roomConfigs) To UBound(roomConfigs)
        roomName = roomConfigs(i)(0)
        Dim roomStartRow As Integer, roomEndRow As Integer, startCol As String
        roomStartRow = roomConfigs(i)(1)
        roomEndRow = roomConfigs(i)(2)
        startCol = roomConfigs(i)(3)

        For timeSlot = roomStartRow To roomEndRow
            ' Always add this time slot to the output (regardless of content)
            masterWs.Cells(currentRow, 1).Value = roomName & " - Slot " & (timeSlot - roomStartRow + 1)

            ' Copy the day values, using "AVAILABLE" for empty cells
            For j = 0 To 6
                Dim colIndex As Integer
                colIndex = Range(startCol & "1").Column + j
                cellValue = Trim(buildingWs.Cells(timeSlot, colIndex).Value)
                If cellValue = "" Then
                    masterWs.Cells(currentRow, j + 2).Value = "AVAILABLE"
                Else
                    masterWs.Cells(currentRow, j + 2).Value = cellValue
                End If
            Next j

            currentRow = currentRow + 1
        Next timeSlot
    Next i

    ProcessJolietBuilding = currentRow
End Function

Function ProcessAuroraBuilding(buildingWs As Worksheet, masterWs As Worksheet, startRow As Long, dayColumns As Variant) As Long
    ' Aurora has only 4 rooms total
    Dim roomConfigs As Variant
    Dim currentRow As Long
    Dim i As Integer, j As Integer
    Dim roomName As String
    Dim cellValue As String
    Dim timeSlot As Integer

    currentRow = startRow

    ' Aurora room configuration (4 rooms only)
    roomConfigs = Array( _
        Array("Aurora Room A", 5, 22, "A"), _
        Array("Aurora Room B", 5, 22, "H"), _
        Array("Aurora Room C", 26, 43, "A"), _
        Array("Aurora Room D", 48, 65, "A") _
    )

    ' Process each conference room
    For i = LBound(roomConfigs) To UBound(roomConfigs)
        roomName = roomConfigs(i)(0)
        Dim roomStartRow As Integer, roomEndRow As Integer, startCol As String
        roomStartRow = roomConfigs(i)(1)
        roomEndRow = roomConfigs(i)(2)
        startCol = roomConfigs(i)(3)

        For timeSlot = roomStartRow To roomEndRow
            ' Always add this time slot to the output (regardless of content)
            masterWs.Cells(currentRow, 1).Value = roomName & " - Slot " & (timeSlot - roomStartRow + 1)

            ' Copy the day values, using "AVAILABLE" for empty cells
            For j = 0 To 6
                Dim colIndex As Integer
                colIndex = Range(startCol & "1").Column + j
                cellValue = Trim(buildingWs.Cells(timeSlot, colIndex).Value)
                If cellValue = "" Then
                    masterWs.Cells(currentRow, j + 2).Value = "AVAILABLE"
                Else
                    masterWs.Cells(currentRow, j + 2).Value = cellValue
                End If
            Next j

            currentRow = currentRow + 1
        Next timeSlot
    Next i

    ProcessAuroraBuilding = currentRow
End Function

' Legacy placeholder functions (can be removed)
Function ProcessBuilding2(buildingWs As Worksheet, masterWs As Worksheet, startRow As Long, dayColumns As Variant) As Long
    ' TODO: Implement Building 2 specific room processing
    ' You'll need to provide the cell mappings for Building 2 conference rooms
    ProcessBuilding2 = startRow
End Function

Function ProcessBuilding3(buildingWs As Worksheet, masterWs As Worksheet, startRow As Long, dayColumns As Variant) As Long
    ' TODO: Implement Building 3 specific room processing
    ProcessBuilding3 = startRow
End Function

Function ProcessBuilding4(buildingWs As Worksheet, masterWs As Worksheet, startRow As Long, dayColumns As Variant) As Long
    ' TODO: Implement Building 4 specific room processing
    ProcessBuilding4 = startRow
End Function

Function ProcessBuilding5(buildingWs As Worksheet, masterWs As Worksheet, startRow As Long, dayColumns As Variant) As Long
    ' TODO: Implement Building 5 specific room processing
    ProcessBuilding5 = startRow
End Function

Function ProcessBuilding6(buildingWs As Worksheet, masterWs As Worksheet, startRow As Long, dayColumns As Variant) As Long
    ' TODO: Implement Building 6 specific room processing
    ProcessBuilding6 = startRow
End Function
