class Helpers
  @formatDateAgo : (date) ->  # '@' means this is a static function 
    if(date)
      ms = new Date().getTime() - date.getTime()
      minutes =  parseInt( ms/(1000*60))
      hours =  parseInt(ms/(1000*60*60)) 
      days  =  parseInt(hours/24)
    
    if(days>0&&days<2)
      return days + " day ago"
    else if(days>1)
      return days + " days ago"
    else if(hours>0&&hours<2)
      return hours + " hour ago"
    else if(hours>1)
      return hours + " hours ago"
    else
      return minutes + " minutes ago"

UI.registerHelper "formatDateAgo", Helpers.formatDateAgo