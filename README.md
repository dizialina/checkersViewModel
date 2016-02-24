#Checkers view model
This is a play board for checkers with figures.

##Your opportunities in this app:
* turn your desk in any device orientation  
* use it on any IPhone or IPad
* move all figures on desk  
* figures can be placed only on black rects as in game  
* figures can't be placed out of desk or on rect with other figure  
* important! You can't remove figures from board or play checkers (it is not a game, just view realization without gameplay)  

##In this app I used:
1. Only code for drawing UIViews, storyboard i didn't use.  
2. Math calculations for determing size and coordinates of board, cells and figures using main view bounds.  
3. Analyzing distance to nearest free cells by using its center coordinates for putting there picked-up figure.  
4. CGAffineTransform and UIView animation block with duration to make animations for picked-up checkers and put them on board.
5. Methods of UIResponder that look after all touches for processing them (touchesBegan, touchesMoved, touchesEnded).
6. UITouch for determing point of your touch on screen and making actions with touched UIViews.

##Screenshots:
![Alt text](http://clip2net.com/clip/m496854/c59e2-clip-57kb.jpg "Optional title")
![Alt text](http://clip2net.com/clip/m496854/e89bf-clip-57kb.jpg "Optional title")
