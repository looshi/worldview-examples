Template.SourceView.onRendered ->
  sourceQuery = $.get(this.data.source).complete(=>
    Session.set(this.data.sessionVar, sourceQuery.responseText)
  )

Template.SourceView.helpers
  editorOptions : ->
    {lineNumbers: false, mode: "javascript"}
