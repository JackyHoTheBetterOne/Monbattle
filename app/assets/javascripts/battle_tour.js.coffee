$ ->
  window.first_battle_tour = {
    id: "first-battle",
    steps: [
      {
        title: "Controlling your monsters",
        content: "Mouseover this monster and select an action.",
        target: "1mon",
        placement: "bottom"
      },
      {
        title: "Using AP",
        content: "Your monguards share the same pool of action points, which refill each turn.",
        target: "ap-meter",
        placement: "bottom"
      },
    ]
  }
  window.oracle_skill_tour = {
    id: "oracle-skill",
    steps: [
      {
        title: "Oracle Skill",
        content: "One of 3 skills available your oracle can use. Each skill has a 2-turn cooldown.",
        target: "oracle-skin-icon",
        placement: "left"
      }
    ]
  }
  window.ap_gain_tour = {
    id: "ap-gain",
    steps: [
      {
        title: "Growing AP",
        content: "Spend half of your current AP to gain 10 more AP each turn. Click me or die.",
        target: "gain-ap",
        placement: "left"
      },
    ]
  }
  window.fatigue_tour = {
    id: "fatigue-system",
    steps: [
      {
        title: "Fatigue",
        content: "Your MonGuards do less damage, the more you attack with them. 
                  You can recover fatigue by not using that unit for a turn.",
        target: "fatigue1",
        placement: "bottom" 
      },
    ]
  }
  window.first_effect_tour = {
    id: "first-effect",
    steps: [
      {
        title: "Effect Icon",
        content: "The icons show the current effect on the monster. Mouseover to see more info."
        target: "1",
        placement: "left"
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










