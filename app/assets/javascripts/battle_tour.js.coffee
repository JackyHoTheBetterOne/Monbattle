$ ->
  window.first_battle_tour = {
    id: "first-battle",
    steps: [
      {
        title: "Controlling your monsters",
        content: "Mouseover this monster and select a move without reading what it does.",
        target: "1mon",
        placement: "bottom"
      },
      {
        title: "Using AP",
        content: "Your monsters share the same pool of AP, which will refill at the beginning of every turn.",
        target: "ap-meter",
        placement: "bottom"
      },
      {
        title: "Growing AP",
        content: "You spend half of your current total AP to gain 10 maximum. Sounds like a good deal, right? Totally.",
        target: "gain-ap",
        placement: "left"
      },
    ]
  }
  window.first_effect_tour = {
    id: "first-effect",
    steps: [
      {
        title: "Effect Icon",
        content: "The icons show the current effects on the monster. Mouseover to see more info."
        target: "0",
        placement: "bottom"
      }
    ]
  }
  window.first_replay_tour = {
    id: "first-replay",
    steps: [
      {
        title: "Replaying a battle",
        content: "When you replay a battle, there will be extra rewards but you have to complete it under certain turns to earn them. 
                  Mouseover for extra details."
        target: "battle-round-countdown",
        placement: "left"
      }
    ]
  }










