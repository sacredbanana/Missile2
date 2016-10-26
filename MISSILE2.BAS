'MISSILE 2 by Cameron Armstrong
open window 640,512
window origin "lb"

level=1

energy=100
shield=100

label restart

slowmotion=0
stoptime=0
fastaim=0
meteorspeed=level/10
meteory=512

label setupmeteor
setrgb 1,0,255,0
text 230,256,"LOADING LEVEL"
setrgb 1,0,0,255
text 380,256,str$(level)
meteoranglecalc=ran(2*pi)
meteorangle=pi/2*sin(meteoranglecalc)
meteorx=ran(640)
wait 1

cursorx=320
cursory=256
cursortwox=320
cursortwoy=256
nostars=100

powerup=int(ran(13))
if twoplayers=1 powerup=int(ran(12))
powerupx=ran(640)
powerupy=ran(412)+100

dim starsx(nostars),starsy(nostars)
for a=1 to nostars
starsx(a)=ran(640)
starsy(a)=100+ran(412)
next a

label main
gosub setscreen
gosub stars
gosub moon
gosub land
gosub base
gosub movemeteor
gosub drawmeteor
gosub powerup
gosub controls
gosub cursor
gosub laser
gosub shoot
gosub laseroff
gosub energybarandshieldbar
gosub scoreandlevel
gosub recharge
gosub drawscreen
goto main

label setscreen
setdrawbuf dw
clear window
return

label stars
setrgb 1,255,255,255
for a=1 to nostars
dot starsx(a),starsy(a)
next a
return

label moon
setrgb 1,255,255,255
fill circle 500,450,16
setrgb 1,0,0,0
moonshadow=level/10
fill circle 500+32*sin(moonshadow),450,16
return

label land
setrgb 1,0,50,0
fill rectangle 0,0 to 640,100
return

label base
setrgb 1,120,0,0
fill triangle 300,120 to 310,120 to 305,140
fill triangle 340,120 to 330,120 to 335,140
setrgb 1,0,0,120
fill circle 320,120,14
setrgb 1,75,30,0
fill rectangle 300,90 to 340,120
return

label movemeteor
if slowmotion=0 and stoptime=0 meteorx=meteorx+meteorspeed*sin(meteorangle)
if slowmotion=0 and stoptime=0 meteory=meteory-meteorspeed
if slowmotion=1 meteorx=meteorx+meteorspeed*sin(meteorangle)/4
if slowmotion=1 meteory=meteory-meteorspeed/4
if meteorx<0 meteorangle=-meteorangle
if meteorx>640 meteorangle=-meteorangle
if meteory<=100 goto basedamage
return

label basedamage
gosub setscreen
gosub stars
gosub moon
gosub land
gosub base
gosub energybarandshieldbar
gosub scoreandlevel
gosub drawscreen
for a=1 to 100
beep
setrgb 1,255,0,0
line meteorx,meteory to ran(640),ran(512)
setrgb 1,255,150+ran(105),0
fill circle meteorx+5*a,100,ran(20)
setrgb 1,255,150+ran(105),0
fill circle meteorx-5*a,100,ran(20)
next a
shield=shield-20
if shield<0 shield=0
if shield=0 then
for a=0 to 100
beep
setrgb 1,255,150+ran(105),0
fill circle 300+ran(40),100+ran(40),ran(50)
setrgb 1,255,0,0
line 300+ran(40),100+ran(40) to ran(640),ran(512)
setrgb 1,ran(255),ran(255),ran(255)
text ran(640),ran(512),"GAMEOVER!!!"
next a
wait 5
clear window
setrgb 1,0,255,0
text 200,280,"You Scored:"
setrgb 1,0,0,255
text 320,280,str$(score)
wait 5
level=1
shield=100
energy=100
score=0
twoplayers=0
fi
clear window
goto restart

label drawmeteor
meteoreffect=meteoreffect+.2
setrgb 1,200+50*sin(meteoreffect),150+100*sin(meteoreffect),0
fill circle meteorx,meteory,20+5*sin(meteoreffect)
setrgb 1,255,0,0
fill circle meteorx,meteory,15
setrgb 1,0,0,0
circle meteorx,meteory,15
return

label powerup
'0 No powerup
'1 Fast Aim
'2 Slow Motion
'3 Mega Energy
'4 Bomb
'5 Max Energy
'6 Laser Sweep
'7 Extra Shield
'8 Max Shield
'9 Stop Time
'10 Score Bonus
'11 Warp 5 levels
'12 2-Player Helper
if powerup=1 then
setrgb 1,255,0,255
text powerupx-15,powerupy+35,"FAST AIM"
fi 
if powerup=2 then
setrgb 1,0,255,0
text powerupx-15,powerupy+35,"SLOW MOTION"
fi
if powerup=3 then
setrgb 1,255,150,0
text powerupx-15,powerupy+35,"MEGA ENERGY"
fi
if powerup=4 then
setrgb 1,0,0,255
text powerupx-15,powerupy+35,"BOMB"
fi
if powerup=5 then
setrgb 1,255,255,0
text powerupx-15,powerupy+35,"MAX ENERGY"
fi
if powerup=6 then
setrgb 1,255,0,0
text powerupx-15,powerupy+35,"LASER SWEEP"
fi
if powerup=7 then
setrgb 1,0,255,255
text powerupx-15,powerupy+35,"EXTRA SHIELD"
fi
if powerup=8 then
setrgb 1,255,0,150
text powerupx-15,powerupy+35,"MAX SHIELD"
fi
if powerup=9 then
setrgb 1,100,100,100
text powerupx-15,powerupy+35,"STOP TIME"
fi
if powerup=10 then
setrgb 1,150,0,255
text powerupx-15,powerupy+35,"SCORE BONUS"
fi
if powerup=11 then
setrgb 1,0,255,150
text powerupx-15,powerupy+35,"WARP 5 LEVELS"
fi
if powerup=12 then
setrgb 1,255,255,255
text powerupx-15,powerupy+35,"2-PLAYER HELPER"
fi
if powerup>0 fill circle powerupx,powerupy,15
return

label controls
if and(peek("port1"),16)>0 and cursory<512 cursory=cursory+4+2*fastaim
if and(peek("port1"),64)>0 and cursory>100 cursory=cursory-2-2*fastaim
if and(peek("port1"),32)>0 and cursorx<640 cursorx=cursorx+4+2*fastaim
if and(peek("port1"),128)>0 and cursorx>0 cursorx=cursorx-4-2*fastaim
if and(peek("port1"),16384)>0 and energy>1 laser=1
if twoplayers=1 then
if and(peek("port2"),16)>0 and cursortwoy<512 cursortwoy=cursortwoy+4+2*fastaim
if and(peek("port2"),64)>0 and cursortwoy>100 cursortwoy=cursortwoy-4-2*fastaim
if and(peek("port2"),32)>0 and cursortwox<640 cursortwox=cursortwox+4+2*fastaim
if and(peek("port2"),128)>0 and cursortwox>0 cursortwox=cursortwox-4-2*fastaim
if and(peek("port2"),16384)>0 and energy>1 lasertwo=1
fi
return

label cursor
setrgb 1,255,0,0
line cursorx-5,cursory to cursorx+5,cursory
line cursorx,cursory-5 to cursorx,cursory+5
circle cursorx,cursory,10
if twoplayers=1 then
setrgb 1,0,255,0
line cursortwox-5,cursortwoy to cursortwox+5,cursortwoy
line cursortwox,cursortwoy-5 to cursortwox,cursortwoy+5
circle cursortwox,cursortwoy,10
fi
return

label laser
if laser=1 then
setrgb 1,255,0,0
line 305,140 to cursorx,cursory
line 335,140 to cursorx,cursory
energy=energy-2
fi
if lasertwo=1 then
setrgb 1,0,255,0
line 305,140 to cursortwox,cursortwoy
line 335,140 to cursortwox,cursortwoy
energy=energy-2
fi
return

label shoot
if laser=1 and cursorx>meteorx-15 and cursorx<meteorx+15 and cursory>meteory-15 and cursory<meteory+15 goto meteordead
if laser=1 and cursorx>powerupx-15 and cursorx<powerupx+15 and cursory>powerupy-15 and cursory<powerupy+15 and powerup>0 gosub powerupgot
if lasertwo=1 and cursortwox>meteorx-15 and cursortwox<meteorx+15 and cursortwoy>meteory-15 and cursortwoy<meteory+15 goto meteordead
if lasertwo=1 and cursortwox>powerupx-15 and cursortwox<powerupx+15 and cursortwoy>powerupy-15 and cursortwoy<powerupy+15 and powerup>0 gosub powerupgot
return

label meteordead
gosub setscreen
gosub stars
gosub moon
gosub land
gosub base
gosub drawmeteor
gosub energybarandshieldbar
gosub scoreandlevel
gosub drawscreen
for a=1 to 50
beep
setrgb 1,255,150+ran(105),0
fill circle meteorx-15+ran(30),meteory-15+ran(30),ran(20)
setrgb 1,255,0,0
line meteorx,meteory to ran(640),ran(512)
next a
wait 2
level=level+1
clear window
laser=0
score=int(score+ran(150)*level)
goto restart

label powerupgot
beep
if powerup=1 fastaim=1
if powerup=2 slowmotion=1
if powerup=3 energy=150
if powerup=4 goto bomb
if powerup=5 energy=100
if powerup=6 goto lasersweep
if powerup=7 then 
shield=shield+25
if shield>100 shield=100
fi
if powerup=8 shield=100
if powerup=9 stoptime=1
if powerup=10 score=int(score+ran(2000))
if powerup=11 then
level=level+5
clear window
laser=0
goto restart
fi
if powerup=12 twoplayers=1
powerup=0
return

label laseroff
laser=0
lasertwo=0
return

label energybarandshieldbar
if energy<0 energy=0
if shield<0 shield=0
setrgb 1,255,150,0
text 25,70,"ENERGY"
setrgb 1,0,0,0
fill rectangle 5,40 to 105,60
setrgb 1,255,255-255+2.55*energy,0
fill rectangle 5,40 to 5+energy,60
setrgb 1,0,0,0
rectangle 5,40 to 105,60
setrgb 1,0,255,255
text 170,70,"SHIELD"
setrgb 1,0,0,0
fill rectangle 150,40 to 250,60
setrgb 1,0,2.55*shield,255-2.55*shield
fill rectangle 150,40 to 150+shield,60
setrgb 1,0,0,0
rectangle 150,40 to 250,60
return

label scoreandlevel
setrgb 1,255,0,255
text 340,70,"LEVEL"
setrgb 1,255,0,0
text 360,50,str$(level)
setrgb 1,0,0,255
text 500,70,"SCORE"
setrgb 1,255,255,255
text 500,50,str$(score)
return

label recharge
if energy<1 energy=energy+.003
if energy<100 and energy>=1 energy=energy+.03
if shield<100 and shield>0 shield=shield+.006 
return

label bomb
gosub setscreen
gosub stars
gosub moon
gosub land
gosub base
gosub drawmeteor
gosub energybarandshieldbar
gosub scoreandlevel
gosub drawscreen
for a=1 to 400 step 5 
beep
setrgb 1,255,ran(255),0
fill circle powerupx,powerupy,a
setrgb 1,255,0,0
line powerupx,powerupy to ran(640),ran(512)
next a
goto meteordead

label lasersweep
gosub setscreen
gosub stars
gosub moon
gosub land
gosub base
gosub drawmeteor
gosub energybarandshieldbar
gosub scoreandlevel
gosub drawscreen
for a=0 to 512 step 5
setrgb 1,255,0,0
line 305,140 to 1,a
line 335,140 to 1,a
beep
setrgb 1,255,ran(255),0
fill circle 1,a,ran(20)
next a
for a=0 to 640 step 5
setrgb 1,255,0,0
line 305,140 to a,512
line 335,140 to a,512
beep
setrgb 1,255,ran(255),0
fill circle a,512,ran(20)
next a
for a=512 to 0 step -5
setrgb 1,255,0,0
line 305,140 to 640,a
line 335,140 to 640,a
beep
setrgb 1,255,ran(255),0
fill circle 640,a,ran(20)
next a
energy=energy/2
goto meteordead

label drawscreen
setdispbuf dw
dw=1-dw
return




