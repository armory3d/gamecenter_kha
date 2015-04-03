# gamecenter_kha
Game Center library for Haxe [Kha](https://github.com/KTXSoftware/Kha)

## Usage
- Clone repository into 'your_project/Libraries'
- Sign into Game Center
``` hx
gamecenter.GameCenter.init();
```
- Use Game Center features
``` hx
gamecenter.GameCenter.reportScore("best_score", score);
gamecenter.GameCenter.showLeaderboard("best_score");
gamecenter.GameCenter.reportAchievement("my_achievement", percent);
```
