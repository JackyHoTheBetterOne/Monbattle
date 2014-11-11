# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  # $(".abil_form_check_all").click (event) ->
  #   targ = $(this).attr("id")
  #   if @checked
  #     $("." + targ).prop("checked", true)
  #   else
  #     $("." + targ).prop("checked", false)
  #   return

  $(document).on "click", ".abil_form_check_all", ->
    targ = $(this).attr("id")
    if @checked
      $("." + targ).prop("checked", true)
    else
      $("." + targ).prop("checked", false)
    return

  $(document).on "click", ".abil-row", ->
    abil = $(this).attr("id")
    $("#" + abil + "-save").show()

  $(document).on "click", ".row-2-on, .add-rem-effects-on, .show-jobs-on, .show-edit-effects-on, .change-jobs-on, .edit-images-on", ->
    targ = $(this).attr("id")
    $("." + targ).show()
