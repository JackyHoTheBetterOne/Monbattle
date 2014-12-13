$ ->
  $(document).on "click", ".news-entry-click", ->
    i = 0
    while i < document.getElementsByClassName("news-entry").length
      document.getElementsByClassName("news-entry")[i].className =
                          document.getElementsByClassName("news-entry")[i].
                                   className.replace(" notice-selected", "")
      i++
    $(".news-detail").fadeOut(300)
    $(this).children(".news-entry").addClass("notice-selected")
    console.log($(this).children(".news-entry"))