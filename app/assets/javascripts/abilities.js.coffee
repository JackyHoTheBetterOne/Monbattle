# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  # $(".abil_form_check_all").click (event) ->
  #   if @checked
  #     $(".ability_job_check_boxes input").prop("checked", true)
  #   else
  #     $(".ability_job_check_boxes input").prop("checked", false)
  #   return

  $(document).on "click", ".abil-row", ->
    abil = $(this).attr("id")
    $("#" + abil + "-save").show()

  $(document).on "click", ".row-2-on, .add-rem-effects-on, .show-edit-effects-on, .change-jobs-on, .edit-images-on", ->
    targ = $(this).attr("id")
    $("." + targ).show()

  # $(document).on "click", ".abil-effects, .abil-desc, .abil-images, .abil-adds", ->
  #   $(".abil-boxes").hide()
  #   abil = $(this).attr("id")
  #   $("#" + abil + "-box").show("slide", { direction: "up" }, 300)

  # $(document).on "click", ".close-top-display", ->
  #   $(".abil-boxes").hide()