Option Explicit

Sub ConsolidateOakLawnTables()
    Dim sourceWs As Worksheet
    Dim outputWs As Worksheet
    Dim tableRanges As Variant
    Dim tableNames As Variant
    Dim currentOutputRow As Long
    Dim i As Integer

    Set sourceWs = ThisWorkbook.Worksheets("newOakLawn")
    Set outputWs = sourceWs

    sourceWs.Range("A25:T1000").Clear

    tableRanges = Array("A5:F21", "G5:L21", "M5:R21", "S5:X21")
    tableNames = Array("OakLawn102", "OakLawn103", "OakLawn104", "OakLawn105")

    CreateConsolidatedHeaders outputWs
    currentOutputRow = 26

    For i = LBound(tableRanges) To UBound(tableRanges)
        currentOutputRow = ProcessSingleTable(sourceWs, outputWs, CStr(tableRanges(i)), CStr(tableNames(i)), currentOutputRow)
    Next i

    FormatConsolidatedTable outputWs, currentOutputRow - 1
    outputWs.Range("A25").Select

    MsgBox "OakLawn conference room tables successfully consolidated!" & vbCrLf & _
           "Results start at row 25 on the 'newOakLawn' tab."
End Sub

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

Sub FormatConsolidatedTable(outputWs As Worksheet, lastRow As Long)
    Dim tableRange As Range
    Dim i As Long

    Set tableRange = outputWs.Range("A25:T" & lastRow)

    With tableRange.Borders
        .LineStyle = xlContinuous
        .Weight = xlThin
        .ColorIndex = xlAutomatic
    End With

    outputWs.Columns("A:T").AutoFit

    For i = 26 To lastRow
        If ((i - 25) Mod 2) = 0 Then
            outputWs.Range("A" & i & ":T" & i).Interior.Color = RGB(248, 248, 248)
        End If
    Next i

    outputWs.Range("A26").Select
    ActiveWindow.FreezePanes = True
End Sub

Sub ValidateTableRanges()
    Dim sourceWs As Worksheet
    Dim tableRanges As Variant
    Dim i As Integer

    Set sourceWs = ThisWorkbook.Worksheets("newOakLawn")
    tableRanges = Array("A5:F21", "G5:L21", "M5:R21", "S5:X21")

    For i = LBound(tableRanges) To UBound(tableRanges)
        Debug.Print "Table " & (i + 1) & " Range: " & tableRanges(i)
        Debug.Print "Room Name: " & sourceWs.Range(tableRanges(i)).Cells(1, 1).Value
        Debug.Print "First Time Slot: " & sourceWs.Range(tableRanges(i)).Cells(2, 1).Value
        Debug.Print "---"
    Next i
End Sub

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
