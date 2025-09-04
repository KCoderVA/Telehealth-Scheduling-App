Option Explicit

' Main subroutine to consolidate OakLawn conference room tables into yearly schedule
Sub ConsolidateOakLawnYearlySchedule()
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
    sourceWs.Range("A25:U10000").Clear  ' Clear a large range to ensure all old data is removed

    ' Define the table ranges and room names for OakLawn tables
    tableRanges = Array("A5:F21", "G5:L21", "M5:R21", "S5:X21")
    tableNames = Array("OakLawn102", "OakLawn103", "OakLawn104", "OakLawn105")

    ' Create headers for the consolidated yearly schedule (starting at row 25)
    CreateYearlyScheduleHeaders outputWs

    ' Initialize output row counter (start at row 26, after headers at row 25)
    currentOutputRow = 26

    ' Process each conference room table for the entire year
    For i = LBound(tableRanges) To UBound(tableRanges)
        currentOutputRow = ProcessTableYearlySchedule(sourceWs, outputWs, CStr(tableRanges(i)), CStr(tableNames(i)), currentOutputRow)
    Next i

    ' Format the consolidated table
    FormatYearlyScheduleTable outputWs, currentOutputRow - 1

    ' Activate the output area to show results
    outputWs.Range("A25").Select

    MsgBox "OakLawn yearly conference room schedule successfully created!" & vbCrLf & _
           "Results start at row 25 on the 'newOakLawn' tab." & vbCrLf & _
           "Total rows generated: " & (currentOutputRow - 26)
End Sub

' Create headers for the yearly schedule table
Sub CreateYearlyScheduleHeaders(outputWs As Worksheet)
    outputWs.Cells(25, 1).Value = "Date"
    outputWs.Cells(25, 2).Value = "Day of Week"
    outputWs.Cells(25, 3).Value = "Room Name"
    outputWs.Cells(25, 4).Value = "Room Alias"
    outputWs.Cells(25, 5).Value = "Room Extension"
    outputWs.Cells(25, 6).Value = "Room IP Address"
    outputWs.Cells(25, 7).Value = "Time Slot"
    outputWs.Cells(25, 8).Value = "Meeting/Occupant"
    outputWs.Cells(25, 9).Value = "CBOC Name"
    outputWs.Cells(25, 10).Value = "TCT Name"
    outputWs.Cells(25, 11).Value = "TCT Extension"
    outputWs.Cells(25, 12).Value = "TCT Cell"
    outputWs.Cells(25, 13).Value = "CNM Name"
    outputWs.Cells(25, 14).Value = "CNM Extension"
    outputWs.Cells(25, 15).Value = "CNM Cell"
    outputWs.Cells(25, 16).Value = "FTC Name"
    outputWs.Cells(25, 17).Value = "FTC Extension"
    outputWs.Cells(25, 18).Value = "FTC Cell"

    ' Format headers
    With outputWs.Range("A25:R25")
        .Font.Bold = True
        .Interior.Color = RGB(200, 220, 255)
        .HorizontalAlignment = xlCenter
    End With
End Sub

' Process a single conference room table for yearly schedule
Function ProcessTableYearlySchedule(sourceWs As Worksheet, outputWs As Worksheet, tableRange As String, roomName As String, startOutputRow As Long) As Long
    Dim tableRangeObj As Range
    Dim timeSlotRow As Integer
    Dim dayCol As Integer
    Dim timeSlot As String
    Dim cellValue As String
    Dim outputRow As Long
    Dim roomAlias As String
    Dim roomExtension As String
    Dim roomIPAddress As String

    ' Building characteristics (applicable to all OakLawn rooms)
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

    ' Date variables
    Dim currentDate As Date
    Dim endDate As Date
    Dim dayOfWeek As Integer
    Dim dayNames As Variant

    Set tableRangeObj = sourceWs.Range(tableRange)
    outputRow = startOutputRow

    ' Initialize date range - from today through next year
    currentDate = Date ' Today (July 11, 2025)
    endDate = DateAdd("yyyy", 1, currentDate) ' One year from today

    ' Day names for reference
    dayNames = Array("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday")

    ' Extract room details from row 4
    Dim tableStartRow As Long
    Dim tableStartCol As Long
    tableStartRow = tableRangeObj.Row - 1  ' Row 4 (one above table start row 5)
    tableStartCol = tableRangeObj.Column   ' Starting column of the table

    ' Extract room details from the specific cells in row 4
    roomAlias = Trim(sourceWs.Cells(tableStartRow, tableStartCol + 1).Value)
    roomExtension = Trim(sourceWs.Cells(tableStartRow, tableStartCol + 2).Value)
    roomIPAddress = Trim(sourceWs.Cells(tableStartRow, tableStartCol + 3).Value)

    ' Set building characteristics
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

    ' Loop through each date in the year
    Do While currentDate <= endDate
        dayOfWeek = Weekday(currentDate) ' 1=Sunday, 2=Monday, ..., 7=Saturday

        ' Skip weekends (Sunday=1, Saturday=7)
        If dayOfWeek >= 2 And dayOfWeek <= 6 Then
            ' Process each time slot for this date
            For timeSlotRow = 2 To 17
                timeSlot = Trim(tableRangeObj.Cells(timeSlotRow, 1).Value)

                ' Skip if time slot is empty
                If timeSlot <> "" Then
                    ' Get the meeting/occupant for this day of week
                    ' dayCol: Monday=2, Tuesday=3, Wednesday=4, Thursday=5, Friday=6
                    dayCol = dayOfWeek
                    cellValue = Trim(tableRangeObj.Cells(timeSlotRow, dayCol).Value)

                    ' Create a row for this specific date/time/room combination
                    outputWs.Cells(outputRow, 1).Value = currentDate
                    outputWs.Cells(outputRow, 2).Value = dayNames(dayOfWeek - 1)
                    outputWs.Cells(outputRow, 3).Value = roomName
                    outputWs.Cells(outputRow, 4).Value = roomAlias
                    outputWs.Cells(outputRow, 5).Value = roomExtension
                    outputWs.Cells(outputRow, 6).Value = roomIPAddress
                    outputWs.Cells(outputRow, 7).Value = timeSlot

                    ' Set meeting/occupant or AVAILABLE
                    If cellValue = "" Then
                        outputWs.Cells(outputRow, 8).Value = "AVAILABLE"
                    Else
                        outputWs.Cells(outputRow, 8).Value = cellValue
                    End If

                    ' Add building characteristics
                    outputWs.Cells(outputRow, 9).Value = cbocName
                    outputWs.Cells(outputRow, 10).Value = tctName
                    outputWs.Cells(outputRow, 11).Value = tctExtension
                    outputWs.Cells(outputRow, 12).Value = tctCell
                    outputWs.Cells(outputRow, 13).Value = cnmName
                    outputWs.Cells(outputRow, 14).Value = cnmExtension
                    outputWs.Cells(outputRow, 15).Value = cnmCell
                    outputWs.Cells(outputRow, 16).Value = ftcName
                    outputWs.Cells(outputRow, 17).Value = ftcExtension
                    outputWs.Cells(outputRow, 18).Value = ftcCell

                    outputRow = outputRow + 1
                End If
            Next timeSlotRow
        End If

        ' Move to next day
        currentDate = DateAdd("d", 1, currentDate)
    Loop

    ProcessTableYearlySchedule = outputRow
End Function

' Format the yearly schedule table
Sub FormatYearlyScheduleTable(outputWs As Worksheet, lastRow As Long)
    Dim tableRange As Range

    ' Set the full table range (18 columns A-R, starting from row 25)
    Set tableRange = outputWs.Range("A25:R" & lastRow)

    ' Apply borders
    With tableRange.Borders
        .LineStyle = xlContinuous
        .Weight = xlThin
        .ColorIndex = xlAutomatic
    End With

    ' Auto-fit columns
    outputWs.Columns("A:R").AutoFit

    ' Format date column
    outputWs.Range("A26:A" & lastRow).NumberFormat = "mm/dd/yyyy"

    ' Apply alternating row colors for better readability
    Dim i As Long
    For i = 26 To lastRow
        If ((i - 25) Mod 2) = 0 Then
            outputWs.Range("A" & i & ":R" & i).Interior.Color = RGB(248, 248, 248)
        End If
    Next i

    ' Freeze the header row and date column
    outputWs.Range("B26").Select
    ActiveWindow.FreezePanes = True
End Sub

' Helper subroutine to validate yearly schedule generation (optional - for testing)
Sub ValidateYearlySchedule()
    Dim sourceWs As Worksheet
    Dim testDate As Date
    Dim testEndDate As Date
    Dim workdayCount As Long

    Set sourceWs = ThisWorkbook.Worksheets("newOakLawn")
    testDate = Date
    testEndDate = DateAdd("yyyy", 1, testDate)
    workdayCount = 0

    ' Count weekdays in the year
    Do While testDate <= testEndDate
        If Weekday(testDate) >= 2 And Weekday(testDate) <= 6 Then
            workdayCount = workdayCount + 1
        End If
        testDate = DateAdd("d", 1, testDate)
    Loop

    Debug.Print "Workdays in year: " & workdayCount
    Debug.Print "Expected rows per room: " & (workdayCount * 16) & " (16 time slots per day)"
    Debug.Print "Expected total rows for 4 rooms: " & (workdayCount * 16 * 4)
End Sub
