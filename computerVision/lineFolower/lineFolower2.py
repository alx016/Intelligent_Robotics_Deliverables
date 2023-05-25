import cv2 as cv
import numpy as np

def searcher(data, height, width):
    # This function allows the user to search where the black line begins
    # and where it finishes 
    aux1 = 0
    aux2 = 0
    pt1 = 0
    pt2 = 0
    pt3 = 0
    pt4 = 0
    for j in range (width):
        if(data[0][j] == 0 and aux1 == 0):
            pt1 = j
            aux1 += 1
        if(data[0][j] == 0):
            if (data[0][j+1]>127):
                pt2 = j
        if (data[height-1][j] == 0 and aux2 == 0):
            pt3 = j
            aux2 += 1
        if (data[height-1][j] == 0):
            if (data[height-1][j+1] > 127):
                pt4 = j
    return pt1, pt2, pt3, pt4

def imageProcessing():
    img = cv.imread('linea.jpeg')
    cv.imshow('org',img)
    height, width = img.shape[:2]
    # print(f"{height} , {width}")

    #Initial and final desired height and width
    idh = int(height/4)*3
    idw = int(width/4)
    fdh = height
    fdw = int(idw*3)

    #Image cropping, first goes the height then the width
    img = img[idh:fdh, idw:fdw]

    # Obtaining new height and width
    height, width = img.shape[:2]
    # print(f"{height} , {width}")

    # Convert BGR to HSV
    gray = cv.cvtColor(img, cv.COLOR_BGR2GRAY)
    _ , bin = cv.threshold(gray, 50 ,255, cv.THRESH_BINARY)
    cv.imshow('bin',bin)
    data = list(bin)

    # Detection of where the black part starts & ends
    pt1, pt2, pt3, pt4 = searcher(data, height, width)
    img = cv.line(img, (int(pt1), 0), (int(pt3), height), (255,0,0),2) # BLUE LINE
    img = cv.line(img, (int(pt2), 0), (int(pt4), height), (255,0,0),2) # BLUE LINE
    aux1 = (pt1 + pt2)/2
    aux2 = (pt3 + pt4)/2
    img = cv.line(img, (int(aux1), 0), (int(aux2), height), (0,0,255),2) # RED
    img = cv.line(img, (int(width/2), 0), (int(width/2), height), (0,255,0),2) # GREEN

    # Calculating error
    error = ((aux1 + aux2)/2) - (width/2)
    print(error)

    # Show images
    cv.imshow('result',img)
    # Allows us to destroy the created windows with esc 
    k = cv.waitKey(0)
    if k == 27:      
        cv.destroyAllWindows()

def videoProcessing():
    cap = cv.VideoCapture(0)
    # Take each frame
    _, img = cap.read()
    height, width = img.shape[:2]
    print(f"{height} , {width}")

    #Initial and final desired height and width
    idh = int(height/4)*3
    idw = int(width/4)
    fdh = height
    fdw = int(idw*3)

    while(1):
        # Take each frame
        _, img = cap.read()
        cv.imshow('org',img)
        #Image cropping, first goes the height then the width
        img = img[idh:fdh, idw:fdw]
        # cv.imshow('result1',img)

        # Obtaining new values
        height, width = img.shape[:2]
        # print(f"{height} , {width}")

        # Convert BGR to HSV
        gray = cv.cvtColor(img, cv.COLOR_BGR2GRAY)
        _ , bin = cv.threshold(gray, 50 ,255, cv.THRESH_BINARY)
        data = list(bin)

        # Detection of where the black part starts & ends
        pt1, pt2, pt3, pt4 = searcher(data, height, width)
        img = cv.line(img, (int(pt1), 0), (int(pt3), height), (255,0,0),2) # BLUE LINE
        img = cv.line(img, (int(pt2), 0), (int(pt4), height), (255,0,0),2) # BLUE LINE
        aux1 = (pt1 + pt2)/2
        aux2 = (pt3 + pt4)/2
        img = cv.line(img, (int(aux1), 0), (int(aux2), height), (0,0,255),2) # RED
        img = cv.line(img, (int(width/2), 0), (int(width/2), height), (0,255,0),2) # GREEN

        # Calculating error
        error = ((aux1 + aux2)/2) - (width/2)
        print(error)
        
        # Show images
        cv.imshow('result',img)
        # Allows us to destroy the created windows with esc 
        k = cv.waitKey(5) & 0xFF
        if k == 27:   
            break   
    cv.destroyAllWindows()
    
choice = input("Image processing (1) or Video processing(2): ")
if (choice == '1'):
    imageProcessing()
elif (choice == '2'):
    videoProcessing()
