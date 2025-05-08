extends Control

var score: int = 0
var combo_count: int = 1

func _ready():
    Signals.IncrementScore.connect(IncrementScore)
    Signals.IncrementCombo.connect(IncrementCombo)
    Signals.ResetCombo.connect(ResetCombo)

    ResetCombo()

func IncrementScore(incr: int):
    score += incr
    %ScoreLabel.text = str(score)

func IncrementCombo(incr: int):
    combo_count += incr
    %ComboLabel.text = str(combo_count)
    if combo_count > 1:
        %ComboLabel.show()
        %ComboLabel.text = str(combo_count) + "x"
    else:
        %ComboLabel.hide()

func ResetCombo():
    combo_count = 1
    %ComboLabel.hide()

