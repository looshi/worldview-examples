class @Helpers
  @formatDateAgo : (date) ->
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

  @randomColor : ->
    colors = [
      0xc0ff3e,
      0xdb7093,
      0xab82ff,
      0x2e8b57,
      0xff6a6a,
      0xf5deb3,
      0xee00ee,
      0xff8c69,
      0xee1289,
      0xff4500,
      0xcdc673,
      0xee6a50,
      0xffefdb,
      0xb2dfee,
      0xaeeeee,
      0x00ffff,
      0x9aff9a,
      0xeedc82,
      0x9acd32,
      0x32cd32,
      0x9bcd9b]

    return _.sample(colors)


UI.registerHelper "formatDateAgo", Helpers.formatDateAgo
UI.registerHelper "randomColor", Helpers.randomColor
