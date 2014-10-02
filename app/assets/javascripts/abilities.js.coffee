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

# $('.abil_form_check_all').click(function(event){ $('.ability_job_check_boxes input').prop("checked", true);  });

  # $('#abil_form_check_all').click(function(event){
  #     if(this.checked) {
  #       $(".ability_job_check_boxes input").prop("checked", true);
  #     }else {
  #       $(".ability_job_check_boxes input").prop("checked", false);
  #       }
  # });