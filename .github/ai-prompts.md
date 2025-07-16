# PowerApps Canvas App Development Prompts

## Quick Canvas App Development Prompts

### Form Design Prompt
```
Create a PowerApps canvas app form for telehealth room booking with the following requirements:
- Room selection dropdown connected to SharePoint list
- Date/time picker for booking
- Duration selector (30min, 1hr, 2hr, 4hr)
- Purpose/description text field
- Contact information fields
- Submit button that creates SharePoint list entry
- Responsive design for mobile and desktop
- Hospital branding colors
```

### Gallery Display Prompt
```
Design a PowerApps gallery to display current room bookings with:
- Filter by building/location
- Search by date range
- Color-coded status (Available, Booked, Maintenance)
- Booking details on selection
- Quick actions (View, Edit, Cancel if authorized)
- Real-time refresh from SharePoint data source
```

### Power Automate Workflow Prompt
```
Create a Power Automate flow for telehealth room booking approval with:
- Trigger: New item in BookingRequests SharePoint list
- Condition: Check booking conflicts with existing approved bookings
- Approval: Send to assigned telehealth manager by building
- Actions: Update booking status, send notifications
- Escalation: If no response in 24 hours, notify supervisor
- Integration: Update both BookingRequests and ApprovedBookings lists
```

## SharePoint Integration Prompts

### List Schema Design
```
Design SharePoint list schema for telehealth room management:
- RoomMasterData: Room details, equipment, capacity, building
- BookingRequests: Pending approvals with all booking details
- ApprovedBookings: Confirmed bookings for calendar integration
- UserProfiles: Staff permissions and preferred notification methods
Include proper column types, validation, and relationships
```

### Calendar View Configuration
```
Configure SharePoint calendar view for room schedules:
- Multi-room overlay view
- Color coding by booking type/status
- Filtering by building/equipment needs
- Mobile-responsive calendar interface
- Integration with Outlook calendar
- Conflict detection and highlighting
```

## Development Workflow Prompts

### Code Review Checklist
```
Review PowerApps canvas app for telehealth booking system:
- Delegation warnings for SharePoint data sources
- Error handling for network connectivity issues
- User permission validation
- Mobile responsiveness testing
- Performance optimization for 50+ concurrent users
- Accessibility compliance (screen readers, keyboard navigation)
- Hospital security and compliance requirements
```

### Testing Scenarios
```
Create test scenarios for telehealth room booking system:
- Happy path: Successful booking creation and approval
- Conflict resolution: Double-booking prevention
- Permission testing: Staff vs manager access levels
- Mobile device testing: Various screen sizes and orientations
- Offline/online sync scenarios
- Load testing: Multiple simultaneous bookings
- Integration testing: SharePoint, Power Automate, email notifications
```
