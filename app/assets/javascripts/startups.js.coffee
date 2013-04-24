# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->

	# Support Mobile Devices
	$(".ontouch").bind 'ontouchstart', ->
		$(this).toggleClass('hover')

	# Load page on click
	(startupClick = ->
		$(".startup").click ->
			top.location = $(this).data('url') if $(this).data('url') isnt false
	)(this)

	if $("header h1 span.search").length
		$("header h1 span.search").focus().bind 'keyup keydown', (e) ->
			
			if e.which == 13
				_text = $(this).text().replace(/[\r\n]/g, ' ')
				$(this).text(_text)

			#$(".progress-icon.disabled").removeClass 'disabled'
			$(".startups.results").empty()#.addClass 'disabled'
			
			$.getJSON '/search.json?' + $.param({ 'q': $(this).text() }), (out) ->

				#$(".progress-icon").addClass 'disabled'
				#$(".startups.results").removeClass 'disabled'

				if out.count == 0
					$(".startups.results").html("<p>Sorry, no results found.</p>")
					return false

				$(".startups.results").empty()

				for res in out.results
					entry = $("<div />").addClass('startup').addClass('ontouch').data('url', res.startup.url)
					$("<img />").attr('src', res.startup.logo).appendTo(entry)
					$("<span />").addClass('hiring').appendTo(entry) if res.startup.hiring.currently is true
					info = $("<div />").addClass('information')
					$("<h3>").text(res.startup.name).appendTo(info)
					$("<br>").appendTo(info)

					for tag in res.startup.tags
						$("<tag>").html($("<a>").attr('href', tag.url).text(tag.name)).appendTo(info)
						info.append("&nbsp;");


					info.appendTo(entry)
					entry.appendTo(".startups.results")
					startupClick()
				