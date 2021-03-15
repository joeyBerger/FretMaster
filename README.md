# Fret Master

This project is the culmination of my experience teaching music at the university level and to advanced students to address some of the needs of myself as a teacher and those of my pupils. This app has the groundwork to be an effective teaching tool to students of the guitar. The app aims to turn learning scales and arpeggios into a game that progresses through levels of difficulty. This app can be used with the guitar as a reference, or away (would be great for long flights).

## Starting

Download the provided .zip, install and run `carthage update --platform iOS` and run in Xcode. This app was primarily tested on an iPhone 11.

## Using the application

* The main page of the app provides a menu of varying topics/challenges. Upon clicking on the 'Scales' button, the user is presented with a tutorial. Once the tutorial is completed, the 'Arpeggios' section will be unlocked.
* Both the 'Scales' and 'Arpeggios' behave similarly: a task is presented, and if completed, the level is advanced.
* Both the 'Scales' and 'Arpeggios' screens have a position of a fretboard that is interactible. Pressing a note will produce a tone with a fret-marker. In the top-left hand corner are tempo buttons to increase/decrease the playback tempo. If the middle button is tapped, the user can tap a tempo. 
* The top-right buttons behave in specific ways:
    * The top-most button starts or stops a test
    * The middle button presents the given scale/arpeggio by playing the associated sounds/fret markers
    * The lowest-most button toggles the fret-marker display of the given scale/arpeggio.
* To initiate a test, press the top-most button and correctly play the given scale/arpeggio. If played correctly, a white flash will indicate success and the level will advance. If played incorrectly, a red flash will indicate a user error, and the level will not advance.
* To access more information about the test, the user can initiate a presentation of the given scale/arpeggio by pressing the middle button or by pressing the lowest-most button to display available notes. Also, the user can press the center-screen button (above the fretboard) to display a popup that further explains the scale or what the user played wrong on the previous test.
* To assist with the test, each button that the user is supposed to click is enlarged to increase ease of playing accurately on a phone.
## Settings
* To customize the user experience, a settings menu is available in both the 'Scales' and 'Arpeggios' views. Once the user has navigated to the settings page, the user can control various aspects of the app:
  * Guitar Sound: Change the sound of the played in the 'Scales' and 'Arpeggios' views.
  * Fretboard Dot: Change the information displayed on the fretboard as a note is played.
  * Click Sound: Change the sound of the click when an exercise using a click is employed.
  * Background Picture: Change the appearance of either the Menu, Scales or Arpeggio views.
  * Volume: Change the overall, guitar and click volume to the user's specification.


