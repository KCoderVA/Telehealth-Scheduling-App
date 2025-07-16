Option Explicit

' Main subroutine to consolidate OakLawn conference room tables
Sub ConsolidateOakLawnTables()
    Dim sourceWs As Worksheet
    Dim outputWs As Worksheet
    Dim tableRanges As Variant
    Dim tableNames As Variant
    Dim currentOutputRow As Long
    Dim i As Integer

    ' Get reference to the source worksheet (also used as output)
    Set sourceWs = ThisWorkbook.Worksheets("newOakLawn")
    Set outputWs = sourceWs  ' Output to the same sheet

    ' Clear existing content starting from row 25 (preserve existing data above)
    sourceWs.Range("A25:T1000").Clear  ' Clear a large range to ensure all old data is removed

    ' Define the table ranges and room names for OakLawn tables
    ' Based on your example: OakLawn103 is in G5:L21
    ' Assuming the other three are positioned similarly
    tableRanges = Array("A5:F21", "G5:L21", "M5:R21", "S5:X21")  ' Adjust these ranges as needed
    tableNames = Array("OakLawn102", "OakLawn103", "OakLawn104", "OakLawn105")

    ' Create headers for the consolidated table (starting at row 25)
    CreateConsolidatedHeaders outputWs

    ' Initialize output row counter (start at row 26, after headers at row 25)
    currentOutputRow = 26

    ' Process each conference room table
    For i = LBound(tableRanges) To UBound(tableRanges)
        currentOutputRow = ProcessSingleTable(sourceWs, outputWs, CStr(tableRanges(i)), CStr(tableNames(i)), currentOutputRow)
    Next i

    ' Format the consolidated table
    FormatConsolidatedTable outputWs, currentOutputRow - 1

    ' Activate the output area to show results
    outputWs.Range("A25").Select

    MsgBox "OakLawn conference room tables successfully consolidated!" & vbCrLf & _
           "Results start at row 25 on the 'newOakLawn' tab."
End Sub

' Create headers for the consolidated table
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

    ' Format headers
    With outputWs.Range("A25:T25")
        .Font.Bold = True
        .Interior.Color = RGB(200, 220, 255)
        .HorizontalAlignment = xlCenter
    End With
End Sub

' Process a single conference room table
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

    ' Building characteristics from row 1 (applicable to all OakLawn rooms)
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

    ' Extract room details from row 4 (one row above the table start)
    ' For table G5:L21, the details are in row 4 (G4:L4)
    ' Get the actual worksheet row number for row 4
    Dim tableStartRow As Long
    Dim tableStartCol As Long
    tableStartRow = tableRangeObj.Row - 1  ' Row 4 (one above table start row 5)
    tableStartCol = tableRangeObj.Column   ' Starting column of the table

    ' Extract room details from the specific cells in row 4
    roomAlias = Trim(sourceWs.Cells(tableStartRow, tableStartCol + 1).Value)      ' Second column of table area
    roomExtension = Trim(sourceWs.Cells(tableStartRow, tableStartCol + 2).Value)   ' Third column of table area
    roomIPAddress = Trim(sourceWs.Cells(tableStartRow, tableStartCol + 3).Value)   ' Fourth column of table area

    ' Extract building characteristics from row 1 (these apply to all OakLawn rooms)
    ' Based on the provided data structure in row 1
    cbocName = "Oak Lawn"
    tctName = "Candice Harris"
    tctExtension = "29940"
    tctCell = "(708) 243-0448"
    cnmName = "Gisele Steele"
    cnmExtension = "29941"
    cnmCell = ""  ' null value
    ftcName = "Jessica Wilson"
    ftcExtension = ""  ' null value
    ftcCell = "(708) 932-7433"

    ' Process each time slot (rows 2-17 of the table, which corresponds to 8:00am-3:30pm)
    For timeSlotRow = 2 To 17
        ' Get the time slot from the first column of the table
        timeSlot = Trim(tableRangeObj.Cells(timeSlotRow, 1).Value)

        ' Skip if time slot is empty
        If timeSlot <> "" Then
            ' Add room details and time slot to output
            outputWs.Cells(outputRow, 1).Value = roomName
            outputWs.Cells(outputRow, 2).Value = roomAlias
            outputWs.Cells(outputRow, 3).Value = roomExtension
            outputWs.Cells(outputRow, 4).Value = roomIPAddress
            outputWs.Cells(outputRow, 5).Value = timeSlot

            ' Process each day (columns 2-6 of the table for Mon-Fri)
            For dayCol = 2 To 6
                cellValue = Trim(tableRangeObj.Cells(timeSlotRow, dayCol).Value)
                If cellValue = "" Then
                    outputWs.Cells(outputRow, dayCol + 4).Value = "AVAILABLE"
                Else
                    outputWs.Cells(outputRow, dayCol + 4).Value = cellValue
                End If
            Next dayCol

            ' Add building characteristics (columns 11-20)
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

' Format the consolidated table
Sub FormatConsolidatedTable(outputWs As Worksheet, lastRow As Long)
    Dim tableRange As Range

    ' Set the full table range (now includes 20 columns A-T, starting from row 25)
    Set tableRange = outputWs.Range("A25:T" & lastRow)

    ' Apply borders
    With tableRange.Borders
        .LineStyle = xlContinuous
        .Weight = xlThin
        .ColorIndex = xlAutomatic
    End With

    ' Auto-fit columns
    outputWs.Columns("A:T").AutoFit

    ' Apply alternating row colors for better readability (starting from row 26)
    Dim i As Long
    For i = 26 To lastRow
        If ((i - 25) Mod 2) = 0 Then  ' Adjusted for starting at row 25
            outputWs.Range("A" & i & ":T" & i).Interior.Color = RGB(248, 248, 248)
        End If
    Next i

    ' Freeze the header row (row 25)
    outputWs.Range("A26").Select
    ActiveWindow.FreezePanes = True
End Sub

' Helper subroutine to validate table ranges (optional - for testing)
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
