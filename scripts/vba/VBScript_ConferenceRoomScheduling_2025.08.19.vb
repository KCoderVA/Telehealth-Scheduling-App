'==============================================================================
' TELEHEALTH CONFERENCE ROOM CONSOLIDATION MACRO
'==============================================================================
' Purpose: Consolidates multiple OakLawn conference room scheduling tables
'          into a single normalized table for Power Platform migration
' Author:  Kyle J. Coder
' Created: 2025
'
' Business Context:
' - Part of VA Healthcare telehealth room booking system migration
' - Transforms Excel-based scheduling into SharePoint-compatible format
' - Consolidates 4 separate room tables (OakLawn102-105) into unified structure
' - Prepares data for PowerApps canvas app and Power Automate workflows
'
' Technical Details:
' - Processes time slots from 8:00am-3:30pm for Monday-Friday scheduling
' - Extracts room metadata (alias, extension, IP address) from source tables
' - Applies hospital staff contact information (TCT, CNM, FTC roles)
' - Formats output for SharePoint list integration
'==============================================================================

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

Sub CreateConsolidatedHeaders(outputWs As Worksheet)
    outputWs.Cells(25, 1).Value = "Room Name"
    outputWs.Cells(25, 2).Value = "Room Alias"
    outputWs.Cells(25, 3).Value = "Room Extension"
    outputWs.Cells(25, 4).Value = "Room IP Address"
    outputWs.Cells(25, 5).Value = "Time Slot"
    outputWs.Cells(25, 6).Value = "Monday"
    outputWs.Cells(25, 7).Value = "Tuesday"
    outputWs.Cells(25, 8).Value = "Wednesday"
    outputWs.Cells(25, 9).Value = "Thursday"
    outputWs.Cells(25, 10).Value = "Friday"
    outputWs.Cells(25, 11).Value = "CBOC Name"
    outputWs.Cells(25, 12).Value = "TCT Name"
    outputWs.Cells(25, 13).Value = "TCT Extension"
    outputWs.Cells(25, 14).Value = "TCT Cell"
    outputWs.Cells(25, 15).Value = "CNM Name"
    outputWs.Cells(25, 16).Value = "CNM Extension"
    outputWs.Cells(25, 17).Value = "CNM Cell"
    outputWs.Cells(25, 18).Value = "FTC Name"
    outputWs.Cells(25, 19).Value = "FTC Extension"
    outputWs.Cells(25, 20).Value = "FTC Cell"

    With outputWs.Range("A25:T25")
        .Font.Bold = True
        .Interior.Color = RGB(200, 220, 255)
        .HorizontalAlignment = xlCenter
    End With
End Sub

Function ProcessSingleTable(sourceWs As Worksheet, outputWs As Worksheet, tableRange As String, roomName As String, startOutputRow As Long) As Long
    Dim tableRangeObj As Range
    Dim currentRow As Long
    Dim timeSlotRow As Integer
    Dim dayCol As Integer
    Dim timeSlot As String
    Dim cellValue As String
    Dim outputRow As Long
    Dim roomAlias As String
    Dim roomExtension As String
    Dim roomIPAddress As String
    Dim detailsRow As Range
    Dim cbocName As String
    Dim tctName As String
    Dim tctExtension As String
    Dim tctCell As String
    Dim cnmName As String
    Dim cnmExtension As String
    Dim cnmCell As String
    Dim ftcName As String
    Dim ftcExtension As String
    Dim ftcCell As String

    Set tableRangeObj = sourceWs.Range(tableRange)
    outputRow = startOutputRow

    Dim tableStartRow As Long
    Dim tableStartCol As Long
    tableStartRow = tableRangeObj.Row - 1
    tableStartCol = tableRangeObj.Column

    roomAlias = Trim(sourceWs.Cells(tableStartRow, tableStartCol + 1).Value)
    roomExtension = Trim(sourceWs.Cells(tableStartRow, tableStartCol + 2).Value)
    roomIPAddress = Trim(sourceWs.Cells(tableStartRow, tableStartCol + 3).Value)

    cbocName = "Oak Lawn"
    tctName = "Candice Harris"
    tctExtension = "29940"
    tctCell = "(708) 243-0448"
    cnmName = "Gisele Steele"
    cnmExtension = "29941"
    cnmCell = ""
    ftcName = "Jessica Wilson"
    ftcExtension = ""
    ftcCell = "(708) 932-7433"

    For timeSlotRow = 2 To 17
        timeSlot = Trim(tableRangeObj.Cells(timeSlotRow, 1).Value)

        If timeSlot <> "" Then
            outputWs.Cells(outputRow, 1).Value = roomName
            outputWs.Cells(outputRow, 2).Value = roomAlias
            outputWs.Cells(outputRow, 3).Value = roomExtension
            outputWs.Cells(outputRow, 4).Value = roomIPAddress
            outputWs.Cells(outputRow, 5).Value = timeSlot

            For dayCol = 2 To 6
                cellValue = Trim(tableRangeObj.Cells(timeSlotRow, dayCol).Value)
                If cellValue = "" Then
                    outputWs.Cells(outputRow, dayCol + 4).Value = "AVAILABLE"
                Else
                    outputWs.Cells(outputRow, dayCol + 4).Value = cellValue
                End If
            Next dayCol

            outputWs.Cells(outputRow, 11).Value = cbocName
            outputWs.Cells(outputRow, 12).Value = tctName
            outputWs.Cells(outputRow, 13).Value = tctExtension
            outputWs.Cells(outputRow, 14).Value = tctCell
            outputWs.Cells(outputRow, 15).Value = cnmName
            outputWs.Cells(outputRow, 16).Value = cnmExtension
            outputWs.Cells(outputRow, 17).Value = cnmCell
            outputWs.Cells(outputRow, 18).Value = ftcName
            outputWs.Cells(outputRow, 19).Value = ftcExtension
            outputWs.Cells(outputRow, 20).Value = ftcCell

            outputRow = outputRow + 1
        End If
    Next timeSlotRow

    ProcessSingleTable = outputRow
End Function


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

'==============================================================================
' SOFTWARE LICENSE
'==============================================================================
' Copyright 2025 Kyle J. Coder
'
' Licensed under the Apache License, Version 2.0 (the "License");
' you may not use this file except in compliance with the License.
' You may obtain a copy of the License at
'
'     http://www.apache.org/licenses/LICENSE-2.0
'
' Unless required by applicable law or agreed to in writing, software
' distributed under the License is distributed on an "AS IS" BASIS,
' WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
' See the License for the specific language governing permissions and
' limitations under the License.
'==============================================================================
