Template.SourceView.onRendered ->
  sourceQuery = $.get(this.data.source).complete(=>
    Session.set(this.data.reactiveVar, sourceQuery.responseText)
  )

Template.SourceView.helpers
  editorOptions : ->
    {lineNumbers: false, mode: "javascript"}
