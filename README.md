# WaterBalance
Water balance tracking app with three screens: current balance, calendar tracker and notification center
An application for tracking water balance. In the code, I used several controllers and the delegation process between them. The application saves data to Core data. The application stores data in Core data and processes it differently for various controllers. The app keeps track of whether a new day has come and resets the progress every night. Sends notifications with flexible scheduling settings

💧 The first screen: an animated water level and a button for adding data with an additional view menu, in case of full filling, an alert is visible instead of the menu

https://user-images.githubusercontent.com/122267988/235625675-115eed9e-1464-4ee9-81ab-dfe7b3c2dea6.mov

![IMG_4818](https://user-images.githubusercontent.com/122267988/235623725-373962f3-6b60-4f85-874c-cdeb526b6d09.PNG)
💧 Second screen: a custom calendar view that collects all the dates from the database when we reached the goal and marks them
![IMG_4817](https://user-images.githubusercontent.com/122267988/235623954-5c237318-632c-4d5b-a1d2-8d40586032e1.PNG)
💧 Third screen: Provides start, finish and notification frequency settings. At startup, scheduled notifications are created for each day starting from the start time with the desired interval, until it gives up to the finish time
![IMG_4819](https://user-images.githubusercontent.com/122267988/235624174-c3e1d7af-fad2-46d9-8b5a-8197127b4f38.PNG)
![IMG_4813](https://user-images.githubusercontent.com/122267988/235624204-8b8ad2d2-31a6-4cc0-9634-9d467c1d8788.PNG)
