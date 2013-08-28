<- $

$.ajax do
    type: "GET"
    dataType: "jsonp"
    url: "http://moments.wow.is/api/entries/best/"
    success: (data) ->
        for entry in Entry.fromJSON(data)
            entry.save()

        entries.render(Entry.all())