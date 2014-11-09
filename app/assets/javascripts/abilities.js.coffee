# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(".abil_form_check_all").click (event) ->
    if @checked
      $(".ability_job_check_boxes input").prop("checked", true)
    else
      $(".ability_job_check_boxes input").prop("checked", false)
    return

  $(document).on "click", ".abil-row", ->
    abil = $(this).attr("id")
    $("#" + abil + "-save").show().effect('highlight')

  $(document).on "click", ".abil-effects, .abil-desc, .abil-images, .abil-adds", ->
    abil = $(this).attr("id")
    $("#" + abil + "-box").show("slide", { direction: "up" }, 300)
    # if any value within .abil-boxes has show, hide them.
    # else
      # show the one clicked

  $(document).on "click", ".abil-boxes", ->
    $(".abil-boxes").hide("slide", { direction: "up" }, 300)