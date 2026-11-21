"""Project Godot world points to 1920x1080 screen pixels for the Drowned Rat camera + world bend (A10 layout aid).
Usage: python art-src/env/proj.py x,y,z [x,y,z ...]"""
import numpy as np, sys, math
R=13.0; pivot=np.array([0.5,0,-0.3]); fwd=np.array([0,0,-1.0])
def bend(w):
    w=np.array(w,float); rel=w-pivot; d=rel@fwd
    if d<=0: return w
    th=d/R; side=rel-fwd*d; side[1]=0; r=R+rel[1]
    return pivot+side+fwd*(r*math.sin(th))+np.array([0,r*math.cos(th)-R,0])
p=math.radians(52); t=np.array([0,0,-0.6]); cam=t+np.array([0,math.sin(p),math.cos(p)])*21
f=(t-cam)/np.linalg.norm(t-cam); r=np.cross(f,[0,1,0]); r/=np.linalg.norm(r); u=np.cross(r,f)
fy=1/math.tan(math.radians(13.5))
def scr(w,b=True):
    q=bend(w) if b else np.array(w,float); v=q-cam; z=v@f
    return (960+ (v@r)/z*fy*540, 540-(v@u)/z*fy*540, z)
for a in sys.argv[1:]:
    w=[float(x) for x in a.split(',')]; x,y,z=scr(w); print(a,'-> px(%.0f,%.0f) dist %.1f'%(x,y,z))
