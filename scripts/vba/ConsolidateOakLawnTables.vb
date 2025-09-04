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

'------------------------------------------------------------------------------
' MAIN CONSOLIDATION PROCEDURE
'------------------------------------------------------------------------------
' Purpose: Main entry point that orchestrates the entire consolidation process
' Input:   None (operates on "newOakLawn" worksheet)
' Output:  Consolidated table starting at row 25 on same worksheet
' Notes:   Preserves existing data above row 25, clears previous consolidation
'------------------------------------------------------------------------------
Sub ConsolidateOakLawnTables()
    ' Variable declarations for worksheet references and data structures
    Dim sourceWs As Worksheet      ' Reference to source worksheet containing room tables
    Dim outputWs As Worksheet      ' Reference to output worksheet (same as source)
    Dim tableRanges As Variant     ' Array containing cell ranges for each room table
    Dim tableNames As Variant      ' Array containing room names corresponding to each table
    Dim currentOutputRow As Long   ' Track current row position for consolidated output
    Dim i As Integer              ' Loop counter for processing multiple tables

    ' STEP 1: Initialize worksheet references
    ' Get reference to the source worksheet containing all room tables
    Set sourceWs = ThisWorkbook.Worksheets("newOakLawn")
    Set outputWs = sourceWs  ' Output consolidated data to the same sheet for simplicity

    ' STEP 2: Clear previous consolidation results
    ' Clear existing consolidated content starting from row 25 to preserve header data
    ' Uses large range (T1000) to ensure complete removal of old consolidated data
    sourceWs.Range("A25:T1000").Clear  ' Clear columns A-T from row 25 onwards

    ' STEP 3: Define source table locations and corresponding room identifiers
    ' Each OakLawn conference room has its own 6-column table (A-F, G-L, M-R, S-X)
    ' Tables span rows 5-21 containing time slots and daily scheduling data
    tableRanges = Array("A5:F21", "G5:L21", "M5:R21", "S5:X21")  ' Physical table locations
    tableNames = Array("OakLawn102", "OakLawn103", "OakLawn104", "OakLawn105")  ' Room identifiers

    ' STEP 4: Create standardized header row for consolidated output
    ' Establishes column structure for SharePoint list integration
    CreateConsolidatedHeaders outputWs

    ' STEP 5: Initialize output tracking
    ' Start consolidated data at row 26 (immediately after headers at row 25)
    currentOutputRow = 26

    ' STEP 6: Process each conference room table iteratively
    ' Loop through all four OakLawn conference rooms and consolidate their data
    ' Process each conference room table
    For i = LBound(tableRanges) To UBound(tableRanges)
        ' Call ProcessSingleTable to extract and normalize data from current room table
        ' Function returns next available output row for subsequent table processing
        currentOutputRow = ProcessSingleTable(sourceWs, outputWs, CStr(tableRanges(i)), CStr(tableNames(i)), currentOutputRow)
    Next i

    ' STEP 7: Apply professional formatting to consolidated table
    ' Format consolidated output for readability and SharePoint compatibility
    FormatConsolidatedTable outputWs, currentOutputRow - 1

    ' STEP 8: Position user view and provide completion feedback
    ' Navigate to consolidated data starting point for user review
    outputWs.Range("A25").Select

    ' Display completion message with location information
    MsgBox "OakLawn conference room tables successfully consolidated!" & vbCrLf & _
           "Results start at row 25 on the 'newOakLawn' tab."
End Sub

'------------------------------------------------------------------------------
' HEADER CREATION PROCEDURE
'------------------------------------------------------------------------------
' Purpose: Creates standardized column headers for consolidated telehealth data
' Input:   outputWs - Worksheet object where headers will be created
' Output:  Formatted header row at row 25 with professional styling
' Notes:   Headers designed for SharePoint list compatibility and hospital workflow
'------------------------------------------------------------------------------
Sub CreateConsolidatedHeaders(outputWs As Worksheet)
    ' ROOM IDENTIFICATION COLUMNS (1-4): Core room metadata for telehealth booking
    outputWs.Cells(25, 1).Value = "Room Name"        ' Primary room identifier (e.g., "OakLawn103")
    outputWs.Cells(25, 2).Value = "Room Alias"       ' Friendly room name for display
    outputWs.Cells(25, 3).Value = "Room Extension"   ' Phone extension for room coordination
    outputWs.Cells(25, 4).Value = "Room IP Address"  ' Network address for telehealth equipment

    ' SCHEDULING COLUMNS (5-10): Time slot and weekly availability matrix
    outputWs.Cells(25, 5).Value = "Time Slot"        ' Appointment time (8:00am-3:30pm format)
    outputWs.Cells(25, 6).Value = "Monday"          ' Monday scheduling status or patient info
    outputWs.Cells(25, 7).Value = "Tuesday"         ' Tuesday scheduling status or patient info
    outputWs.Cells(25, 8).Value = "Wednesday"       ' Wednesday scheduling status or patient info
    outputWs.Cells(25, 9).Value = "Thursday"        ' Thursday scheduling status or patient info
    outputWs.Cells(25, 10).Value = "Friday"         ' Friday scheduling status or patient info

    ' ORGANIZATIONAL CONTEXT COLUMNS (11): Hospital facility information
    outputWs.Cells(25, 11).Value = "CBOC Name"      ' Community Based Outpatient Clinic identifier

    ' TELEHEALTH COORDINATOR COLUMNS (12-14): Primary technical support contact
    outputWs.Cells(25, 12).Value = "TCT Name"       ' Telehealth Coordinator Technician name
    outputWs.Cells(25, 13).Value = "TCT Extension"  ' TCT office phone extension
    outputWs.Cells(25, 14).Value = "TCT Cell"       ' TCT mobile phone for urgent issues

    ' CLINICAL NURSE MANAGER COLUMNS (15-17): Clinical oversight contact
    outputWs.Cells(25, 15).Value = "CNM Name"       ' Clinical Nurse Manager name
    outputWs.Cells(25, 16).Value = "CNM Extension"  ' CNM office phone extension
    outputWs.Cells(25, 17).Value = "CNM Cell"       ' CNM mobile phone for clinical issues

    ' FACILITY TECHNICAL COORDINATOR COLUMNS (18-20): Facility-level support contact
    outputWs.Cells(25, 18).Value = "FTC Name"       ' Facility Technical Coordinator name
    outputWs.Cells(25, 19).Value = "FTC Extension"  ' FTC office phone extension
    outputWs.Cells(25, 20).Value = "FTC Cell"       ' FTC mobile phone for facility issues

    ' Apply professional header formatting for hospital environment
    With outputWs.Range("A25:T25")
        .Font.Bold = True                        ' Bold text for header prominence
        .Interior.Color = RGB(200, 220, 255)     ' Light blue background for VA branding
        .HorizontalAlignment = xlCenter          ' Center-aligned text for professional appearance
    End With
End Sub

'------------------------------------------------------------------------------
' SINGLE TABLE PROCESSING FUNCTION
'------------------------------------------------------------------------------
' Purpose: Extracts and normalizes data from one conference room table
' Input:   sourceWs - Source worksheet containing room tables
'          outputWs - Destination worksheet for consolidated data
'          tableRange - Cell range containing specific room table (e.g., "G5:L21")
'          roomName - Room identifier (e.g., "OakLawn103")
'          startOutputRow - Starting row number for this room's consolidated data
' Output:  Returns next available output row number for subsequent processing
' Notes:   Processes 16 time slots (8:00am-3:30pm) and 5 weekdays per room
'------------------------------------------------------------------------------
Function ProcessSingleTable(sourceWs As Worksheet, outputWs As Worksheet, tableRange As String, roomName As String, startOutputRow As Long) As Long
    ' Variable declarations for table processing and data extraction
    Dim tableRangeObj As Range         ' Object reference to specific room table range
    Dim currentRow As Long            ' Track current processing position
    Dim timeSlotRow As Integer        ' Iterator for time slot rows (2-17 within table)
    Dim dayCol As Integer            ' Iterator for weekday columns (2-6 within table)
    Dim timeSlot As String           ' Current time slot being processed (e.g., "8:00am")
    Dim cellValue As String          ' Content of current scheduling cell
    Dim outputRow As Long            ' Current output row in consolidated table

    ' Room-specific metadata extracted from source table
    Dim roomAlias As String          ' User-friendly room name
    Dim roomExtension As String      ' Room phone extension
    Dim roomIPAddress As String      ' Room telehealth equipment IP address
    Dim detailsRow As Range         ' Reference to row containing room metadata

    ' Hospital organizational structure - applies to all OakLawn facility rooms
    ' These values represent the healthcare staff responsible for telehealth operations
    Dim cbocName As String          ' Community Based Outpatient Clinic name
    Dim tctName As String           ' Telehealth Coordinator Technician
    Dim tctExtension As String      ' TCT contact extension
    Dim tctCell As String           ' TCT mobile contact
    Dim cnmName As String           ' Clinical Nurse Manager
    Dim cnmExtension As String      ' CNM contact extension
    Dim cnmCell As String           ' CNM mobile contact
    Dim ftcName As String           ' Facility Technical Coordinator
    Dim ftcExtension As String      ' FTC contact extension
    Dim ftcCell As String           ' FTC mobile contact

    ' STEP 1: Initialize table processing
    Set tableRangeObj = sourceWs.Range(tableRange)  ' Create range object for easier cell access
    outputRow = startOutputRow                       ' Set starting position for this room's data

    ' STEP 2: Extract room-specific metadata from row above table
    ' Room details are stored in row 4 (one row above table start at row 5)
    ' Calculate actual worksheet coordinates for metadata extraction
    Dim tableStartRow As Long
    Dim tableStartCol As Long
    tableStartRow = tableRangeObj.Row - 1  ' Row 4 contains room metadata
    tableStartCol = tableRangeObj.Column   ' Starting column varies by table position

    ' Extract room identification details from specific cells in metadata row
    roomAlias = Trim(sourceWs.Cells(tableStartRow, tableStartCol + 1).Value)      ' Column 2: Room display name
    roomExtension = Trim(sourceWs.Cells(tableStartRow, tableStartCol + 2).Value)   ' Column 3: Phone extension
    roomIPAddress = Trim(sourceWs.Cells(tableStartRow, tableStartCol + 3).Value)   ' Column 4: Equipment IP address

    ' STEP 3: Define hospital organizational context (constant for all OakLawn rooms)
    ' These values represent the healthcare staff structure at Oak Lawn CBOC
    cbocName = "Oak Lawn"              ' Facility designation
    tctName = "Candice Harris"         ' Current Telehealth Coordinator Technician
    tctExtension = "29940"             ' TCT office phone extension
    tctCell = "(708) 243-0448"         ' TCT mobile phone for urgent issues
    cnmName = "Gisele Steele"          ' Current Clinical Nurse Manager
    cnmExtension = "29941"             ' CNM office phone extension
    cnmCell = ""                       ' CNM mobile (currently not provided)
    ftcName = "Jessica Wilson"         ' Current Facility Technical Coordinator
    ftcExtension = ""                  ' FTC office extension (currently not provided)
    ftcCell = "(708) 932-7433"         ' FTC mobile phone for facility issues

    ' STEP 4: Process each time slot within the room table
    ' Time slots span rows 2-17 of each table, representing 8:00am-3:30pm scheduling
    For timeSlotRow = 2 To 17
    ' Process each time slot (rows 2-17 of the table, representing 8:00am-3:30pm)
    For timeSlotRow = 2 To 17
        ' Extract time slot identifier from first column of current table row
        timeSlot = Trim(tableRangeObj.Cells(timeSlotRow, 1).Value)

        ' Skip processing if time slot cell is empty (handles irregular table structures)
        If timeSlot <> "" Then
            ' STEP 4A: Populate room identification and scheduling metadata
            outputWs.Cells(outputRow, 1).Value = roomName        ' Room identifier (e.g., "OakLawn103")
            outputWs.Cells(outputRow, 2).Value = roomAlias       ' User-friendly room name
            outputWs.Cells(outputRow, 3).Value = roomExtension   ' Room phone extension
            outputWs.Cells(outputRow, 4).Value = roomIPAddress   ' Telehealth equipment IP
            outputWs.Cells(outputRow, 5).Value = timeSlot        ' Appointment time slot

            ' STEP 4B: Process weekly scheduling data (Monday-Friday)
            ' Columns 2-6 of each table represent Monday through Friday scheduling
            For dayCol = 2 To 6
                ' Extract scheduling information for current day
                cellValue = Trim(tableRangeObj.Cells(timeSlotRow, dayCol).Value)

                ' Apply business logic for availability vs. scheduled appointments
                If cellValue = "" Then
                    ' Empty cell indicates available time slot
                    outputWs.Cells(outputRow, dayCol + 4).Value = "AVAILABLE"
                Else
                    ' Non-empty cell contains patient/appointment information
                    outputWs.Cells(outputRow, dayCol + 4).Value = cellValue
                End If
            Next dayCol

            ' STEP 4C: Populate hospital organizational context (columns 11-20)
            ' Add consistent facility and staff contact information for all rooms
            outputWs.Cells(outputRow, 11).Value = cbocName        ' Facility name
            outputWs.Cells(outputRow, 12).Value = tctName         ' Telehealth Coordinator name
            outputWs.Cells(outputRow, 13).Value = tctExtension    ' TCT extension
            outputWs.Cells(outputRow, 14).Value = tctCell         ' TCT mobile phone
            outputWs.Cells(outputRow, 15).Value = cnmName         ' Clinical Nurse Manager name
            outputWs.Cells(outputRow, 16).Value = cnmExtension    ' CNM extension
            outputWs.Cells(outputRow, 17).Value = cnmCell         ' CNM mobile phone
            outputWs.Cells(outputRow, 18).Value = ftcName         ' Facility Technical Coordinator name
            outputWs.Cells(outputRow, 19).Value = ftcExtension    ' FTC extension
            outputWs.Cells(outputRow, 20).Value = ftcCell         ' FTC mobile phone

            ' Advance to next output row for subsequent time slot
            outputRow = outputRow + 1
        End If
    Next timeSlotRow

    ' Return next available output row for subsequent table processing
    ProcessSingleTable = outputRow
End Function

'------------------------------------------------------------------------------
' TABLE FORMATTING PROCEDURE
'------------------------------------------------------------------------------
' Purpose: Applies professional formatting to consolidated telehealth scheduling table
' Input:   outputWs - Worksheet containing consolidated data
'          lastRow - Final row number containing data (for range determination)
' Output:  Professionally formatted table with borders, colors, and frozen headers
' Notes:   Formatting optimized for hospital staff readability and SharePoint migration
'------------------------------------------------------------------------------
Sub FormatConsolidatedTable(outputWs As Worksheet, lastRow As Long)
    Dim tableRange As Range
    Dim i As Long  ' Loop counter for alternating row formatting

    ' STEP 1: Define complete table range for formatting operations
    ' Table spans columns A-T (20 columns) from header row 25 to final data row
    Set tableRange = outputWs.Range("A25:T" & lastRow)

    ' STEP 2: Apply professional table borders for medical document standards
    With tableRange.Borders
        .LineStyle = xlContinuous    ' Solid border lines for clarity
        .Weight = xlThin            ' Thin borders to avoid overwhelming data
        .ColorIndex = xlAutomatic   ' Standard black borders for professional appearance
    End With

    ' STEP 3: Optimize column widths for content readability
    ' Auto-fit all columns A-T to accommodate varying content lengths
    outputWs.Columns("A:T").AutoFit

    ' STEP 4: Apply alternating row colors for enhanced readability
    ' Critical for hospital staff who need to quickly scan scheduling information
    For i = 26 To lastRow  ' Start from row 26 (first data row after headers)
        ' Apply light gray background to even-numbered rows (relative to data start)
        If ((i - 25) Mod 2) = 0 Then  ' Calculate even rows relative to header row 25
            outputWs.Range("A" & i & ":T" & i).Interior.Color = RGB(248, 248, 248)  ' Very light gray
        End If
        ' Odd rows remain white (default background) for contrast
    Next i

    ' STEP 5: Implement frozen header row for large dataset navigation
    ' Essential for hospital staff reviewing extensive scheduling data
    outputWs.Range("A26").Select      ' Position cursor below header row
    ActiveWindow.FreezePanes = True   ' Freeze header row for scrolling reference
End Sub

'------------------------------------------------------------------------------
' TABLE VALIDATION PROCEDURE (OPTIONAL DIAGNOSTIC TOOL)
'------------------------------------------------------------------------------
' Purpose: Validates table ranges and displays diagnostic information
' Input:   None (operates on "newOakLawn" worksheet)
' Output:  Debug output showing table structure and content verification
' Notes:   Debugging tool for troubleshooting table range issues during development
'------------------------------------------------------------------------------
Sub ValidateTableRanges()
    ' Variable declarations for diagnostic operations
    Dim sourceWs As Worksheet     ' Reference to worksheet containing room tables
    Dim tableRanges As Variant    ' Array of table ranges for validation
    Dim i As Integer             ' Loop counter for range validation

    ' Initialize worksheet reference and table range definitions
    Set sourceWs = ThisWorkbook.Worksheets("newOakLawn")
    tableRanges = Array("A5:F21", "G5:L21", "M5:R21", "S5:X21")  ' OakLawn room table locations

    ' DIAGNOSTIC OUTPUT: Validate each table range and display structure information
    ' This procedure helps verify table ranges during development and troubleshooting
    For i = LBound(tableRanges) To UBound(tableRanges)
        ' Output table identification and location information to Debug window
        Debug.Print "Table " & (i + 1) & " Range: " & tableRanges(i)

        ' Extract and display room name from first cell of table range
        Debug.Print "Room Name: " & sourceWs.Range(tableRanges(i)).Cells(1, 1).Value

        ' Extract and display first time slot to verify table structure
        Debug.Print "First Time Slot: " & sourceWs.Range(tableRanges(i)).Cells(2, 1).Value

        ' Add separator for readability in debug output
        Debug.Print "---"
    Next i

    ' NOTE: This procedure is primarily for development and debugging purposes
    ' Run this macro to verify table ranges are correctly defined before consolidation
    ' Debug output appears in VBA Immediate Window (Ctrl+G to view)
End Sub
