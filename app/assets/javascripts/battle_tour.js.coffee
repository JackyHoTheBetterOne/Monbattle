$ ->
  tour = {
    id: "hello-hopscotch",
    steps: [
      {
        title: "My Header",
        content: "This is the header of my page.",
        target: "header",
        placement: "right"
      },
      {
        title: "My content",
        content: "Here is where I put my content.",
        target: document.querySelector("#content p"),
        placement: "bottom"
      }
    ]
  }