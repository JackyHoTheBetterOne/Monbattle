$ ->
  $(".gem-listing .listing").on "click.listing", ->
    quantity = $(this).data("quantity")
    price = $(this).data("price")
    store = document.getElementsByClassName("store-overlay")[0]
    confirmation = document.getElementsByClassName("confirmation")[0]
    payment = document.getElementsByClassName("payment-select")[0]
    message = document.getElementsByClassName("gem-store-message")[0]
    document.getElementsByClassName("amount-to-purchase")[0].innerHTML = quantity
    document.getElementsByClassName("yes")[0].setAttribute("data-quantity", quantity)
    $.ajax 
      url: "/track_currency_pick"
      method: "post"
      data: {
        pick: quantity,
      }
    store.style["z-index"] = "1000000"
    store.style["opacity"] = "1"
    confirmation.style["z-index"] = "10000"
    confirmation.style["opacity"] = "1"
    $(".oh.no").on "click.cancel", ->
      store.style["opacity"] = "0"
      setTimeout (->
        store.style["z-index"] = "-1"
      ), 350
    $(".oh.yes").on "click.proceed", ->
      confirmation.style["opacity"] = "0"
      setTimeout (->
        confirmation.style["z-index"] = "-1"
        payment.style["z-index"] = "1000"
        payment.style["opacity"] = "1"
      ), 350
      document.getElementsByClassName("money-to-buy")[0].innerHTML = price
      document.getElementsByClassName("payment-amount-to-purchase")[0].innerHTML = quantity
      $(".credit-button, .paypal-button").on "click.pay", ->
        $.ajax 
          url: "/track_currency_purchase"
          method: "post"
          data: {
            pick: quantity,
          }
        payment.style["opacity"] = "0"
        setTimeout (->
          payment.style["z-index"] = "-1"
          message.style["z-index"] = "1000"
        ), 350
        setTimeout (->  
          message.style["opacity"] = "1"
        ), 400  
        setTimeout (->
          message.style["z-index"] = "-1"
          message.style["opacity"] = "0"
          store.style["opacity"] = "0"
          setTimeout (->
            store.style["z-index"] = "-1"
          ), 350
        ), 4500

