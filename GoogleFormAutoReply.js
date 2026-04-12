function autoReply(e) {
  try {
    // Get respondent email
    var userEmail = e.response.getRespondentEmail();
    
    // Get the first name (assumes the first question in your form is 'First Name')
    var responses = e.response.getItemResponses();
    var firstName = responses.length > 0 ? responses[0].getResponse() : "Participant";
    
    var subject = "Confirmed: WUF13 Regional Webinar - Africa";
    
    // Using backticks (``) for the body allows for multi-line strings 
    // and prevents quote-nesting errors with the long URLs.
    var htmlBody = `
      Hi ${firstName},<br><br>
      Thank you for registering for the <b>WUF13 Regional Webinar</b> on April 12th.<br><br>
      
      <b>Event Details:</b><br>
      Time: 5:00 PM UTC (8:00 PM - 9:30 PM EAT)<br>
      Video Call Link: <a href="https://meet.google.com/cnn-rowz-nnr">https://meet.google.com/cnn-rowz-nnr</a><br><br>

      <b>Add to your calendar:</b><br>
      • <a href="https://calendar.google.com/calendar/render?action=TEMPLATE&dates=20260412T170000Z%2F20260412T183000Z&details=The%20Global%20Youth%20Coalition%20on%20Sustainable%20Urban%20Development%20is%20convening%20five%2060-minute%20Region%20specific%20webinars...&location=https%3A%2F%2Fmeet.google.com%2Fcnn-rowz-nnr&text=WUF13%20Regional%20Webinar%20Series%20-%20Africa">Add to Google Calendar</a><br>
      • <a href="https://outlook.live.com/calendar/0/action/compose?allday=false&enddt=2026-04-12T18%3A30%3A00Z&path=%2Fcalendar%2Faction%2Fcompose&rru=addevent&startdt=2026-04-12T17%3A00%3A00Z&subject=WUF13%20Regional%20Webinar%20Series%20-%20Africa">Add to Outlook</a><br><br>
      
      See you then!
    `;

    MailApp.sendEmail({
      to: userEmail,
      subject: subject,
      htmlBody: htmlBody
    });
    
  } catch (err) {
    Logger.log("Error sending email: " + err.toString());
  }
}
