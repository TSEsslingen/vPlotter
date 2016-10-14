# Start over with python again
#
# build the two arms and find the possible angle values for the v-plotter

# motor positions
M1 = PVector(160, 80)
M2 = PVector(480, 80)

alength = 100
z = 0

# left arm
Aleft = {'1': {'pos': M1, 'angle': PI, 'color': '0x64FF0000'}, '2': {'pos': PVector(10, 10), 'angle': PI, 'color': '0x6400FF00'}}
Aright = {'1': {'pos': M2, 'angle': PI, 'color': '#FF0000'}, '2': {'pos': PVector(10, 10), 'angle': PI, 'color': '#00FF00'}}

matrix = [[0 for x in range(360)] for y in range(640)]


def setup():
    size(640, 360)
    strokeWeight(10.0)
    stroke(255, 100)
    
    font = createFont("SourceCodePro-Regular.ttf", 12)
    textFont(font)


def draw():
    global z
    
    background(0)
    fill(255, 0, 0)
    text("Hello", 10, 20)
    stroke('0x64FFFF44')
    noFill()
    ellipse(M1.x, M1.y, 10 ,10)
    ellipse(M2.x, M2.y, 10 ,10)
    
    #dragSegment(Aleft['1'], mouseX, mouseY)
    Aleft['1']['angle'] = PI / 100 * z
    if z > 99:
        z = 0
    else:
        z = z + 1
    dragSegment(Aright['1'], mouseX, mouseY)
    adjustArm(Aleft)
    adjustArm(Aright)
    
    drawArm(Aleft)
    drawArm(Aright)
    #dragSegment(Aleft['2'], Aleft['1']['pos'].x, Aleft['1']['pos'].y)

    intersect, p1 = calcIntersect(Aleft['2']['pos'], Aright['2']['pos'], alength, alength)
    
    if(intersect):
        text("Schnitt", 10, 35)
        matrix[int(p1.x)][int(p1.y)] = 1
    
    drawMatrix()



def adjustArm(arm):
    arm['2']['pos'].x = arm['1']['pos'].x + cos(arm['1']['angle']) * alength
    arm['2']['pos'].y = arm['1']['pos'].y + sin(arm['1']['angle']) * alength


def calcIntersect(k1, k2, r1, r2):
    e2 = PVector()
    inter1 = PVector()
    schnitt = PVector()
    
    dist = PVector.dist(k1, k2)
    e1 = k2.copy()
    e1.sub(k1)
    e1.normalize()
    line(k1.x, k1.y, k1.x + e1.x * 20, k1.y + e1.y * 20)
  
    e2.set(-e1.y, e1.x)
    line(k1.x, k1.y, k1.x + e2.x * 20, k1.y + e2.y * 20)
  
    if( dist != 0 ):
        xx = (r1 * r1 + dist * dist - r2 * r2) / (2 * dist)
        if((r1 * r1) > (xx * xx)):
            yy = sqrt((r1 * r1) - (xx * xx))
            inter1 = PVector.add(k1, PVector.mult(e1, xx))
            PVector.add(inter1, PVector.mult(e2, yy), schnitt)
            
            fill(255, 0 ,0)
            ellipse(schnitt.x, schnitt.y, 5, 5)
            noFill()
            return True, schnitt
        else:
            yy = 0
            return False, None
    else:
        xx = 0
        yy = 0
        return False, None


def drawArm(arm):
    segment(arm['1'], True)
    segment(arm['2'], False)
    

def dragSegment(arm, x, y):
    dx = x - arm['pos'].x
    dy = y - arm['pos'].y
    arm['angle'] = atan2(dy, dx)
    #arm['pos'].x = x - cos(arm['angle']) * alength
    #arm['pos'].y = y - sin(arm['angle']) * alength
    #segment(arm)
    

def segment(arm, drawMode):
    pushMatrix()
    translate(arm['pos'].x, arm['pos'].y)
    rotate(arm['angle'])
    stroke(arm['color'])
    if( drawMode ):
        line(0, 0, alength, 0)
        ellipse(alength, 0, 10, 10)
    else:
        strokeWeight(1.0);
        noFill();
        ellipse(0, 0, alength * 2, alength * 2)
    popMatrix()


def drawMatrix():
    for xx in range(640):
        for yy in range(360):
            if(matrix[xx][yy] == 1):
                point(xx, yy)

'''
def segment(x, y, a, i, segl):
    pushMatrix()
    translate(x, y)
    rotate(a)
    if(i == 0):
        stroke(255, 0 , 0, 100)
    else:
        stroke(0, 255, 0, 100)
    
    line(0, 0, segl, 0)
    ellipse(0, 0, 10, 10)
    popMatrix()
'''