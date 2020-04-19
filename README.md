# AppIconAssigner

Auto-assigns icon files for the App Icon using an existing example.

I use this to assign App Icons exported from a sketch plugin into the asset catalog without manually duplicating or assigning sizes.

### Input
- An existing app with all kinds of App Icons assigned in the asset catalog
- A new app without App Icon assets assigned
- A directory with the prepared App Icons of various sizes

### Output
- The new app gets the App Icons assigned in its asset catalog  

### Usage
```
make install

AppIconAssigner /MyExistingApp/Assets.xcassets/AppIcon.appiconset ~/Desktop/justnow-exported-icons  /MyNewApp/Assets.xcassets/AppIcon.appiconset
```
