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
        content: "Spend half of your current total AP to gain 10 more AP each turn. 
                  Make sure you click this button, or you’ll get owned pretty hard.",
        target: "gain-ap",
        placement: "left"
      },
      {
        title: "Fatigue level",
        content: "Your MonGuards do less damage, the more you attack with them. 
                  You can rest your MonGuards by not using them for the turn.",
        target: "fatigue1",
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
        content: "When you replay a battle, there will be extra rewards, 
                  but you have to complete it under a number of rounds in order to earn them."
        target: "battle-round-countdown",
        placement: "left"
      }
    ]
  }










