# Project Overview

## Project Drivetrain (Computer Science NEA)

## Made in
 ![](RackMultipart20210326-4-1trlxn8_html_bf27407a3dbe8bda.png)

INTRODUCTION TO THE PROBLEM

Drivetrain is an all-in-one fitness tracker, with features such as advanced routine management, social engagement, route tracking and generation and stats management. It is the answer to the modern issue of the lack of free, open-source fitness apps, and the increasingly common business model of apps having some or all features hidden behind paywalls.

The objective of this project is to provide an enjoyable experience of fitness via the means of a powerful and robust mobile app, accessible to all. The value of an accessible fitness app is immeasurable in today&#39;s society - a place where obesity rates are on average just under 30% in the UK. Helping tackle obesity, not only nationally, but globally - and keeping the world fit - should be a priority this year, especially after the globe heals itself from the coronavirus pandemic. The best way to get people out on their feet or bike is to make it as easy as possible to do so. Having an enjoyable and free experience will help them continue the cycle of keeping fit.

Not to mention that the NHS, alongside many global health studies and institutions, have explicitly stated the importance of regular exercise. It can reduce your risk of heart disease, stroke, type 2 diabetes and cancer by up to 50% and lower your risk of early death by up to 30%. Not to mention that exercise can also boost your self-esteem, mood, sleep quality and energy, as well as reducing your risk of stress and depression.

**EXAMPLE ALGORITHMS IN USE**

HAVERSINE FORMULA

The below algorithm calculates the latitude and longitude of a destination point, given the distance and bearing from the start point. It uses a reverse implementation of the _Haversine Formula_. ![](RackMultipart20210326-4-1trlxn8_html_91b361584364e524.png)

The Haversine Formula states

Such that: for _ **d** _, the distance between two points on a sphere with radius _ **r** _. ![](RackMultipart20210326-4-1trlxn8_html_de33f573cd945e63.png)

As such, the latitude, φ and longitude, λ of the second point can be given as: ![](RackMultipart20210326-4-1trlxn8_html_e4ce2208992ba108.png)

![](RackMultipart20210326-4-1trlxn8_html_6f21fead8145a64d.png)

![](RackMultipart20210326-4-1trlxn8_html_3e5d9add618aeba3.png)

POWER OUTPUT FORMULA

![](RackMultipart20210326-4-1trlxn8_html_bec6d6c37be2d580.gif)Estimating how much effort a user outputs is extremely important for those training without pricey equipment, and is a fundamental part of getting better and fitter on the bike. The rider&#39;s output forces experience several reaction forces, as the diagram below demonstrates. As such, we can work out the power required to overcome the sum of the resistive forces based on the final velocity. As shown below.

![](RackMultipart20210326-4-1trlxn8_html_993831a5c59825bb.png)

All formulae are commented alongside for clarity.

SQL INSERTION

SQL is the database of choice for this project - more details are shown later, but here is how the insertion itself works.

![](RackMultipart20210326-4-1trlxn8_html_3cddcee5cf02fc0a.png)

A key point to note here is that an Activity Object is created from a class which is added here. The object is created after an activity is saved/added.

![](RackMultipart20210326-4-1trlxn8_html_3622592fc11ded1e.png) ![](RackMultipart20210326-4-1trlxn8_html_68263e60632ef9d.png)

XML PARSING

This function is used for importing previous activities through the .gpx standard, a form of XML. It parses the data from a file into the ActivityObject as shown above, then inserted into the database.

![](RackMultipart20210326-4-1trlxn8_html_875b19e3f9f11f62.png) ![](RackMultipart20210326-4-1trlxn8_html_ed281c556ecdb6b1.png) ![](RackMultipart20210326-4-1trlxn8_html_f021611f017d1328.png)

![](RackMultipart20210326-4-1trlxn8_html_ed281c556ecdb6b1.png)

Evidence of code running (could be link to a video of a screen record, screenshots etc.)

Evaluation (Where did you get up to? What were the main problems/challenges? What about your own performance?)
