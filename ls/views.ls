class Entries extends Backbone.View
    el: '#content'

    ->
        super ...

        @viewport_with = @$el.width()
        @slider = @$el.find('.slider')
        @entry_width = null
        @entries = []

        @current = 0

    events:
        "click .entry": "click"
        "click .next": "next"
        "click .prev": "prev"
        "mouseleave": "mouseleave"
        "mouseenter": "mouseenter"

    calculate_slots: ->
        @entries_per_slot = Math.floor(@viewport_with / @entry_width)

        @slots_count = @entries.length / @entries_per_slot

        @max_pos = @slider.width() - @viewport_with

        return @entries_per_slot

    move: (slot, animate=true) ->
        if slot < 0 or slot + 1 > @slots_count
            return false

        @current = slot

        pos = (@current * @entries_per_slot * @entry_width)

        if pos > @max_pos
            pos = @max_pos

        @slider.stop().animate {margin-left: pos * -1}, ~>
            @lazyload()

        return true

    prev: ->
        @move(@current - 1)

    next: ->
        @move(@current + 1)

    render: (entries) ->
        @entries = entries

        dust.render "entries", {entries: entries}, (err, out) ~>
            @slider.html(out)

            @entry_width = @$el.find('.entry').outerWidth(true)

            @slider.width(@entry_width * entries.length)

            @calculate_slots()

            @interval = setInterval ~>
                if not @mouseover
                    @move(0) if not @move(@current + 1)
            , 4000

            @lazyload()

    mouseenter: ->
        @mouseover = true

    mouseleave: ->
        @mouseover = false

    click: (event) ->
        $entry = $(event.target).closest('.entry')
        entry_id = parseInt($entry.data().id)
        ga('send', 'event', 'entry', 'click', '', entry_id)
        return true

    lazyload: ->
        #@slider.find('.entry img[lazy-src]').each (index, img) ~>
        #    if (@current + 1) >= (index + 1 / @entries_per_slot)
        #        $(img).attr('src', $(img).attr('lazy-src'))
        #        $(img).removeAttr('lazy-src')

entries = new Entries()