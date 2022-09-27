# INFAKETION


## Scenario and Motivation
Our project proposal is an installation aimed at spreading awareness about misinformation.
During the last few years, the concept of ‘fake news’ has emerged as an important source of societal concern, being consequential in politics, and in other topics like public health like the numerous erroneous reports perpetuated during the COVID19 pandemic. As such the concept of ‘fake news’ has been used as a tool for manipulation of the outcomes of many democratic processes.

**What is true?** This topic is highly controversial and there’s no easy solution to it.[1]

**How to stop it?** Experts have highlighted that stopping individual sources of fake news is not enough to solve the problem, and that what we need is to keep people educated in order them to discern which news might reflect reality what would not when confronted with information.[2]

**How to model it?** Numerous attempts have been made to find a model that accurately reflects the dispersion of misinformation. Some of these attempted to model it using statistical random processes, as such creating conceptual parallels with signal and noise in DSP[3], others have attempted to model it using viral contagion models. [4]

## Concept
Inspired by these models we aim at producing a virtual environment, in which the agents, which represents people, are free to roam around the environment, influencing each other and bringing to a spread of either misinformation or proper news.
The installation is composed of two separate canvases, one displaying the world in real time, with agents roaming in a procedural generated environment. The agents behave by the viral model that we have generated, influencing each other positively or negatively depending on if they're contributing to the spread of correct news or fake news.

## User experience
The second canvas is the heart of interaction with the user. The users will be prompted with a virtual newspaper column composed of a headline and a body. They will be tasked with reading the news and categorising them as real or fake, and thus they decides if the news is to be tossed or, if they think it is real, to be sent to the virtual environment.
When fake news is introduced to the virtual environment, some agents will start spreading the misinformation and influencing other agents contributing to the spread of misinformation.
Conversely, if real news is introduced to the world, agents will spread the information between their neighbours, which will help to “heal” the misinformation sickness of the others.

## Challenge
As stated before, people need to be actively educated in order to prevent the spread of misinformation, and not receiving any news from the outside will increase the overall misinformation level, so not sending any news to the environment for a long time is not a viable strategy to prevent spread of misinformation.
These three actions, receiving real news, receiving fake news, not receiving any news will be tuned in order to let the system behave in a complex way and with continuous evolution maintaining an equilibrium that slowly shifts with time and as a consequence of interaction of the choices of its users.

## References 
[1] - https://www.degruyter.com/document/doi/10.1515/krt-2021-0019/html?lang=en \
[2] - https://economics.mit.edu/files/23155 \
[3] - https://www.frontiersin.org/articles/10.3389/fpsyg.2022.797904/full \
[4] - https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0203958 \



## How to
- First of all: run  ```node bridge.js``` from inside the website folder
- Run the website locally from website folder, it should download socket.io from the node server
- If it downloaded socket.io correctly, the website should be sending the messages to the server and the server to the Processing script
