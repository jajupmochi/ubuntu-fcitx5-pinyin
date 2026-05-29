#!/usr/bin/env python3
"""咪咪 v5 — smaller head; collar with perspective (only the near-facing arc visible,
far side hidden behind neck). Round face+cheek, rounded ears, natural neck, left-facing, 4 frames."""
from PIL import Image, ImageDraw, ImageFont
import os
OUT=os.path.expanduser("~/.local/share/gnome-shell/extensions/kimpanel@kde.org/dog")
os.makedirs(OUT,exist_ok=True)
SS=6; W,H=64,48
TAN=(214,158,80,255); TAN_D=(181,124,56,255); CREAM=(244,222,182,255)
INK=(54,42,30,255); RED=(215,38,61,255); RED_D=(176,28,48,255); WHITE=(255,255,255,255)
NAME=ImageFont.truetype("/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc", int(3.4*SS))

def S(v): return int(v*SS)
def draw(name,bdy,hdy,ear,tail,legs):
    im=Image.new("RGBA",(W*SS,H*SS),(0,0,0,0)); d=ImageDraw.Draw(im)
    def ell(x0,y0,x1,y1,f): d.ellipse([S(x0),S(y0),S(x1),S(y1)],fill=f)
    def stroke(p,w,f): d.line([(S(x),S(y)) for x,y in p],fill=f,width=int(w*SS),joint="curve")
    for (x0,y0,x1,y1) in legs[:2]: stroke([(x0,y0+bdy),(x1,y1)],3.8,TAN_D)   # back legs
    stroke([(48,24+bdy),(54,21+bdy),tail],4.4,TAN)                            # tail
    ell(22,18.5+bdy,50,33.5+bdy,TAN)                                          # body (no protruding rump)
    for (x0,y0,x1,y1) in legs[2:]: stroke([(x0,y0+bdy),(x1,y1)],3.8,TAN)      # front legs
    ell(14,15+(bdy+hdy)//2,28,32+bdy,TAN)                                     # neck/chest fill (connect)
    ell(6,11+hdy,21,27+hdy,TAN)                                               # SMALLER round head
    # rounded short ears
    d.polygon([(S(15),S(13+hdy)),(S(15.5+ear),S(7+hdy)),(S(18.5+ear),S(7+hdy)),(S(20),S(13+hdy))],fill=TAN_D)
    ell(15+ear,6+hdy,18.7+ear,9.5+hdy,TAN_D)
    d.polygon([(S(9),S(13+hdy)),(S(9+ear),S(7+hdy)),(S(12+ear),S(7+hdy)),(S(13),S(13+hdy))],fill=TAN)
    ell(8.5+ear,6+hdy,12.2+ear,9.5+hdy,TAN)
    ell(4.5,18+hdy,15,26+hdy,CREAM)                                           # round cream cheek/muzzle
    d.ellipse([S(3.6),S(20+hdy),S(6.8),S(23.2+hdy)],fill=INK)                 # nose
    d.ellipse([S(10.3),S(15.3+hdy),S(12.8),S(17.8+hdy)],fill=INK)             # eye
    ell(26,28+bdy,44,33.5+bdy,CREAM)                                          # belly
    # collar: only the NEAR side (front+underside) visible; far/top hidden behind neck
    d.arc([S(15.5),S(13.5+bdy),S(26),S(30+bdy)], start=18, end=212, fill=RED, width=int(2.7*SS))
    d.rounded_rectangle([S(16.5),S(26+bdy),S(22.5),S(30.5+bdy)],radius=S(1.1),fill=RED)  # small name tag
    d.text((S(16.8),S(26.0+bdy)),"咪咪",font=NAME,fill=WHITE)
    im=im.resize((W,H),Image.LANCZOS); im.save(f"{OUT}/{name}.png"); return im

F=[
 draw("d0",0, 0, 0,(60,12),[(44,31,49,42),(48,31,52,40),(28,31,25,42),(33,31,31,41)]),
 draw("d1",1, 0,-1,(61,16),[(44,31,47,43),(48,31,50,44),(28,31,31,43),(33,31,35,42)]),
 draw("d2",-1,-1,1,(59,11),[(44,31,42,40),(48,31,46,39),(28,31,26,40),(33,31,30,39)]),
 draw("d3",0, 0, 1,(61,15),[(44,31,40,43),(48,31,44,44),(28,31,33,43),(33,31,37,42)]),
]
prev=Image.new("RGB",(W*4*4+50,H*4+20),(246,242,236))
for i,im in enumerate(F):
    b=im.resize((W*4,H*4),Image.LANCZOS); prev.paste(b,(10+i*(W*4+10),10),b)
prev.save("/tmp/dog5_preview.png")
g=[]
for im in F:
    b=im.resize((W*5,H*5),Image.LANCZOS); cv=Image.new("RGB",(b.width+40,b.height+30),(246,242,236)); cv.paste(b,(20,15),b); g.append(cv)
g[0].save("/tmp/dog5_run.gif",save_all=True,append_images=g[1:],duration=140,loop=0)
print("v5 saved")
