#!/usr/bin/env python3

import pygame
import sys
import re

pygame.init()

size = width, height = 800, 800
speed = [2, 2]
black = 0, 0, 0
white = (255,255,255)
red = 255,0,0
redvisited = 127,0,0
screen = pygame.display.set_mode(size)

clock = pygame.time.Clock()

#- Fill screen
maze = list()

with open("maze.txt","r") as fi:
    for line in fi:
        line = line.strip()
        slist = list()
        for s in line:
            slist.append(s)
        maze.append(slist)


M = len(slist)
N = len(maze)
if(M != N):
    raise Exception("Not a square %d %d" %(M,N))
screen.fill(white)

step = width/M

x = 0
y = 0
for l in maze:
    x=0
    for s in l:
        if(s == "1"):
            pygame.draw.rect(screen, black, pygame.Rect(x, y, step+1, step+1))
        x += step
    y += step


turtle = list()
with open("turtle.txt","r") as fi:
    for line in fi:
        xy = line.strip()
        sxy = re.split(",",line)
        x = (M - int(sxy[0]))*step - step
        y = int(sxy[1])*step
        turtle.append((x,y))

(x,y) = turtle[0]

i = 0
while 1:
    for event in pygame.event.get():
        if event.type == pygame.QUIT: sys.exit()

    if(i < len(turtle)):
        pygame.draw.rect(screen, redvisited,pygame.Rect(x,y,step+1,step+1))
        (x,y) = turtle[i]
        pygame.draw.rect(screen, red,pygame.Rect(x,y,step+1,step+1))
        i+=1

    pygame.display.flip()
    clock.tick(40)