# INFAKETION

## Motivation
***INFAKETION*** is an installation aimed at spreading awareness about misinformation.

During the last few years, the concept of ‘fake news’ has emerged as an important source of societal concern, being consequential in politics, and in other topics like public health like the numerous erroneous reports perpetuated during the COVID19 pandemic.

As such the concept of fake news has been used as a tool for manipulation of the outcomes of many democratic processes.

## Concept
The installation is composed of two separate canvases, one displaying a virtual world in real time, with agents roaming in a procedural generated environment, and the other displaying a news headline on a social media page.

The agents behave by the viral model that we have generated, influencing each other positively or negatively depending on if they're contributing to the spread of real news or fake news.


## User experience
The user interacts with the virtual city via using a website hosted at Github Pages. They are prompted with a social media server and a tweet associated with the news. Information regarding when it was sent, whom it was sent by and a picture related to the news is also presented. The user is tasked with reading the news and categorising them as real or fake, by choosing “like”, “share” or “report it” buttons, all of which sends a change signal to the “city” depending on whether the user response aligns with the accuracy of the news. After a button is selected the true answer is revealed  with an appropriate animation, water if the answer is right and fire if it is wrong. The user is informed whether they contributed to misinformation. The background and the design of the website is intentionally slightly distracting to simulate the real-life experience of an internet user prompted with advertisements, pop-ops and other distractions using a website.

When fake news is introduced to the virtual environment, some agents will start spreading the misinformation and influencing other agents contributing to the spread of misinformation.
Conversely, if real news is introduced to the world, agents will spread the information between their neighbours, which will help to “heal” the misinformation sickness of the others.

We had multiple ratings associated with user response from group-negative to group-positive with single-negative and single-positive in between . For example, sharing a fake-news is more harmful to the spread of misinformation than just liking it and it sends a group negative instead of single-negative. Similarly sharing a fact is more beneficial to the system than just liking it.

## How to run
The project is composed of different components

- Main Canvas (Processing Script)
- “Twirret” Social (Website)
- Bridge between website and Processing (Node script)
- Background Music (Supercollider Script)
- Hand Tracking software (Python Script)


The communication between the different components is displayed in the following picture.

![overall_diagram](https://user-images.githubusercontent.com/33195819/192827365-48565b16-8070-4177-a2ca-53e1b7167553.png)

To run the performance:
1. From root folder run the node bridge script as ```node Project/Website/bridge.js```
2. Head to https://umutus15.github.io/#.
3. From root folder run the hand tracking software as ```python3 Project/HandTracker/handTrackingModule.py```
4. Start the SuperCollider script at ```Project/Main/Ambient.scd```
5. Run the Processing script on a secondary screen

At this point, the black unpopulated canvas appears on the secondary screen, while the primary displays the website, and the camera output.
The user can now evaluate the news by pressing **Like**, **Share** or **Report**.

When liking reliable news, a random agent in the canvas starts spreading awareness and lights up in blue.

When liking unreliable news, a random agent starts spreading fake news and lights up in red.

The result is similar but opposite for the report button, that creates aware agents if reporting fake news and fake-news spreading agents when reporting reliable sources.

When pressing share, the user is prompted to share the news to the world. To do this the user must “grab” the news in front of the camera by presenting a closed hand. The news can be dragged over the canvas and a spotlight will appear and highlight the potentially affected agents. After having chosen the agents to affect, the user can open the fist to release the news to the world, affecting the highlighted agents.

# Technical details

## Website and node.js 

**Dependencies**
- ```jQuery-3.6.0``` library for reading/handling data and fade animations
- ```socket.io``` “node.osc” for OSC communication
- ```node.js``` to use npm to download the previous two libraries and to run bridge.js script

The website is created by HTML, CSS and Javascript. To replicate the general UI of a tweet, Tailwind CSS Library and a project guide(*)- now deprecated- has been used. The main message of the tweet is chosen at random from a Kaggle dataset called “Fake News” that hosts both fake and real newspaper headlines and bodies. To not overwhelm the user we left out the main body of the news and put the titles as the tweets. The entries that contain non-Ascii characters were filtered out by a Python script and a new json file “fake-news-filtered.json” was created from the original csv database for easier JS access.

The profile ID’s, names and surnames of people, usernames, and the profile pictures were taken from an open-source random person generator API called randomuser.me. Each time the user clicks a button, a new HTTP($.ajax) request to the website is made and the data is extracted. The dates associated with the tweets are generated randomly, omitting the year. Since fake-news do not have images associated with them on search engines, we extracted the images used from a database that hosts stock images with a politics tag. This ensured there was no bias between the fake-news and real-news visuals.  

Each time a button is pressed by the user, the reliability tag of that particular entry is searched and compared with the user's answer. Whether the user answer is accurate or not a different animation is played, fire for wrong answer and water for true answer, and an accompanying message that lets the user know if they decided correctly. In each case, a different OSC message is prepared with the tag “/website/news”.

The following is a screenshot illustrating an headline in the website

![website_example_img](https://user-images.githubusercontent.com/33195819/192831692-04024f2f-a18b-4224-af57-32fc7800ea28.png)


## Processing

**Dependencies**
- ```Box2D``` library for physics
- ```oscP5``` and ```netP5``` for OSC communication

The virtual world we created is a generative city where the streets are generated by N random walkers wandering on an NxN grid. The walls of the city are defined using the box2D physics engine to facilitate the boundary avoidance of the agents. The city is then populated with agents following some specific rules:

Agents fall into 3 categories based on their level of awareness:
- Unaware :    -1.0 < awareness < -0.5
- Neutral :    -0.5 < awareness < +0.5
- Aware:       +0.5 < awareness < +1.0
 
All agents must avoid boundaries and other agents.
Agents in the same category follow the alignment rule.
Aware and unaware agents infect neighbouring agents based on their awareness.

To make the world more appealing the walls are made invisible and the agents emit a slowly fading light which, depending on their awareness, paint the canvas with their ideology. We used a water texture to take the different colours of aware agents and a fire texture for unaware agents. Below is a figure showing the world and a debug mode where the structure is more clear.

![processingWorld](https://user-images.githubusercontent.com/33195819/192827564-6b8f810d-565e-4b56-9335-022c4485b746.png)

![processingDebug](https://user-images.githubusercontent.com/33195819/192828809-10b0bc9d-47b0-4c45-b87a-49ef5c65fbd2.png)

## SuperCollider

**Dependencies**
- ```sc3``` extension for some distortion and reverb effects

The background music to support the installation is made in SuperCollider following the structure shown in the diagram below:

![supercolliderDiagram](https://user-images.githubusercontent.com/33195819/192829382-00fce77e-d822-4522-8f33-e67c1410170a.png)

The AmbientSynth is an infinite generative song based on Eno's Music for Airports taken from “infinite_digits'' example on sccode.org. The instrument is modified with effects and its arguments are updated to react to the world’s state through OSC.

In fact, since misinformation can be thought of as increasing the signal to noise ratio of a harmonic sound, the awareness of the world defined as the ratio of aware agents to aware + unaware agents controls the amount of noise and distortion of the music through the effect bus.

The Global low Pass Filter is controlled by the activity of the world. The more active agents (aware and unaware) are present, the more the cutoff frequency increases and the sound opens resulting in a more lively world.

The bell and pinkNoise synths are instruments triggered when a user interacts with the news. The bell creates a pleasant harmonic sound that fades within the world with a large reverb and is triggered when the interaction results in a positive effect on the world.

The pink noise on the other hand is an inharmonic and distorted sound that shows the user has increased the world’s signal to noise ratio.
## Hand Tracking
**Dependencies**
- ```open-cv``` library, for camera input and processing
- ```mediapipe``` library for hand tracking
- ```pythonosc``` library for sending osc messages from Python

The Hand Tracking software takes the camera input exploiting open-cv,  and feeds the input image to a wrapper class to the MediaPipe library. The library exposes a simple interface to track hands and gather the position of the main joints. After retrieving the joints position we are able to send to Processing, via OSC, the position of the hand and the difference over the Y axis between the tip of the index finger and its knuckle. The hand is considered as closed while the difference is positive, and open when the difference is negative. Processing will later process this data, while in “Share State” to allow the user to drop the news in the canvas by opening his hand.

![openHand](https://user-images.githubusercontent.com/33195819/192829653-9eaad963-f976-4ae4-a5f8-01e06fb061e9.png)

![closedHand](https://user-images.githubusercontent.com/33195819/192829677-67b5cb7f-0784-40f5-9ed6-39949cb2faaa.png)


