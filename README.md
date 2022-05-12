#  Facivacy

**Facivacy** is an app you can use to hide the identity of people in images.

The app is built using SwiftUI. The app also uses the Vision framework to automatically detect people's faces. The face covering is achieved by using Core Image to apply a filter to protect the identity of the face and Core Graphics is used to render the image.

## Overview

<img width="231" alt="Simulator Screen Shot - iPhone 13 - 2022-05-12 at 17 35 04" src="https://user-images.githubusercontent.com/5818573/168126626-e817abec-c0d7-4958-aa7f-8ded94579ad6.png"> <img width="231" alt="Simulator Screen Shot - iPhone 13 - 2022-05-12 at 17 36 12" src="https://user-images.githubusercontent.com/5818573/168126802-95c2f7d7-6d5d-48a4-a985-b6e39e30c30d.png">

This is the screen you will see when you first startup the app. You can easily add an image from your Image Library by pressing "Add an image" button. You can also change the app settings in the Manage Menu by pressing the "Manage" button in the top-left hand corner.

<img width="500" alt="Simulator Screen Shot - iPhone 13 - 2022-05-12 at 21 41 13" src="https://user-images.githubusercontent.com/5818573/168164624-cdc180b5-55e0-4cde-9c56-e9b9330939da.png">
<img width="500" alt="Simulator Screen Shot - iPhone 13 - 2022-05-12 at 21 45 23" src="https://user-images.githubusercontent.com/5818573/168164999-8bc15873-57b2-45fe-9b37-179da9c8bea4.png">

Once you have an image, you can automatically cover faces by pressing the wand button in the top-right hand corner. This will find the faces in the images and will cover them. You can change the threshold that is required to detect a face and the method of covering the face in the Manage Menu.

<img width="500" alt="Simulator Screen Shot - iPhone 13 - 2022-05-12 at 21 41 25" src="https://user-images.githubusercontent.com/5818573/168164675-546af4d1-d72d-4471-9cbf-d71f268a3413.png">

If the face that you wish to cover is not automatically detected, you can manually cover a region of the image. You can do this by tapping anywhere in the image and a selection tool will show. You can drag the selection tool around or pinch it to change the size of the selection tool. Once you have the selection tool positioned as you wish you can tap conceal (or if you wish to cance, press the cancel button in the top-left hand corner).

<img width="231" alt="Simulator Screen Shot - iPhone 13 - 2022-05-12 at 21 44 16" src="https://user-images.githubusercontent.com/5818573/168165074-816bd21e-3c89-4d40-a99c-567998026cc9.png">

If at any time you wish to cover or uncover a face you can go to the Manage menu screen and tap the button next to their face.

When you are happy the image, click the share button at the top of the screen and this will present the standard system share sheet.

