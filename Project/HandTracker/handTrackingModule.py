import cv2
import mediapipe as mp
from pythonosc.udp_client import SimpleUDPClient

ip = "127.0.0.1"
port = 55000

client = SimpleUDPClient(ip, port)  # Create client

class handTracker():
    def __init__(self, mode=False, maxHands=2, detectionCon=0.5,modelComplexity=1,trackCon=0.5):
        self.mode = mode
        self.maxHands = maxHands
        self.detectionCon = detectionCon
        self.modelComplex = modelComplexity
        self.trackCon = trackCon
        self.mpHands = mp.solutions.hands
        self.hands = self.mpHands.Hands(self.mode, self.maxHands,self.modelComplex,
                                        self.detectionCon, self.trackCon)
        self.mpDraw = mp.solutions.drawing_utils

    def handsFinder(self,image,draw=True):
        imageRGB = cv2.cvtColor(image,cv2.COLOR_BGR2RGB)
        self.results = self.hands.process(imageRGB)

        if self.results.multi_hand_landmarks:
            for handLms in self.results.multi_hand_landmarks:

                if draw:
                    self.mpDraw.draw_landmarks(image, handLms, self.mpHands.HAND_CONNECTIONS)
        return image

    def positionFinder(self,image, handNo=0, draw=True):
        lmlist = []
        if self.results.multi_hand_landmarks:
            Hand = self.results.multi_hand_landmarks[handNo]
            for id, lm in enumerate(Hand.landmark):
                h,w,c = image.shape
                cx,cy = int(lm.x*w), int(lm.y*h)
                lmlist.append([id,cx,cy])
                if id ==8:
                    cv2.circle(image,(cx,cy), 15 , (255,0,255), cv2.FILLED)

        return lmlist

def main():
    cap = cv2.VideoCapture(0) 

    cap.set(cv2.CAP_PROP_FRAME_WIDTH, 1280)
    cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 720)
    tracker = handTracker()

    while True:
        success,image = cap.read()
        if(success):
            image = tracker.handsFinder(image)
            lmList = tracker.positionFinder(image)
            if len(lmList) != 0:
                openHand = lmList[8][2]-lmList[6][2]
                client.send_message("/python/handTracking", [lmList[13][1] / 1280, lmList[13][2] / 720, openHand])  # Send message with int, float and string
            
            image = cv2.flip(image,1)
            cv2.imshow("Video",image)

            cv2.waitKey(1)
        else:
            print("Can't read from camera!")


if __name__ == "__main__":
    main()