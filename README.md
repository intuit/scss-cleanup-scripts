# SCSS-Cleanup
<img src="/SCSS-Cleanup-logo.png" width="200">

These shell scripts will provide you a simple way to remove redundant Sass files, variables, mixins and images from your repository to clean up your stylesheets. 

Particularly in large code bases, it is easy to lose oversight over dead artifacts from removed functionalities. Running the scripts will give you a great starting point to remove redundant elements in your CSS and Sass files to keep your code base clean and up to date.  

The scripts target mainly [Sass files](https://sass-lang.com/) but with simple adjustments (see comments in code) they can be used to find other redundant files.


### 1 Unused Variables & Mixins
This script gives you a list of unused SCSS variables and unused or duplicate mixins. 
**Note**: This only works if you folder does not contain additional external dependencies!

* Copy unusedVars.sh to the root folder of your repository. 
* Make it executable with `chmod +x ./unusedVars.sh`  
* Run the script with `./unusedVars.sh`

The script will output the following information: 
* Unused variables
* Mixins with multiple declarations
* Mixins that are only used once
* Unused mixins

Sample Output:
```##### What folder do you want to scan for unused scss variables and mixins? (default: src/sass) src/
##### Indexing SCSS files...
##### Scanning files for scss variables & mixins... (this may take a while)

##### These scss variables are not used and can be deleted:
$blue03
$yellow98

##### These mixins are declared multiple times. Try to combine them to avoid overwriting of properties:
@mixin keyframe
@mixin buttonBackground

##### These mixins are only used once. Consider replacing them with their original value:
animation01
animation03

#### These mixins are not used and can be deleted:
ominous_mixin
```

### 2 Unused Images
This script gives you a list of all images that are not used in your codebase. 
It takes all the image files in `src/assets/images/` and looks for their strings in ` src/sass/`. It outputs all images files, that aren't referenced in the files of your directory and can thus be deleted.

* Copy unusedImages.sh to the root folder of your repository  
* Make it executable with `chmod +x ./unusedImages.sh`
* Run the script with `./unusedImages.sh`

Sample Output:
```##### What folder do you want to scan for images? (default: src/) 
##### Scanning image folder src/...
Unused image, safe to delete: image1.svg
Unused image, safe to delete: image2.png
```


### 3 Unused SCSS files
This script takes all filenames in the `src/sass` folder and looks for them in the whole `src/` folder in the form of [filename].scss as well as `@import [filename]`. It outputs all scss files that aren't used anywhere and can probably be deleted.

* Copy listImports.sh to the root folder of your repository  
* Make it executable with `chmod +x ./unusedSCSSfiles.sh`
* Run the script with `./unusedSCSSfiles.sh`

Sample Output:
```##### What folder do you want to scan for unused scss files? (default: src/) 
##### scanning src/ for unused scss files...
popup.scss not used
rainbow.scss not used
```


### 4 External file imports
This script gives you a list of all external imports for each SCSS file in the `src/sass` folder.
This might help you to get an overview and sort your dependencies.

* Copy unusedSCSSfiles.sh to the root folder of your repository  
* Make it executable with `chmod +x ./listImports.sh`
* Run the script with `./listImports.sh`

Sample Output:
```##### What folder do you want to scan for CSS dependencies? (default: src/sass) src
##### Scanning  folder src/sass...
##### Scanning files for imports...

in src/sass/unknown.scss
--- no imports

in src/sass/Live.scss
@import '~@design_system/design-data-source/dist/scss/_colors.scss';
```
## Contributors
Sonia May-Patlan

With amazing support from:
* Danilo Bangit
* Matt Ouille

## Issues & Contributions
Please open an issue here on GitHub if you have a problem, suggestion, or comments.
If you want to contribute, [read the guidelines](CONTRIBUTING.md)

Pull requests are welcome and encouraged!

## License
SCSS-Cleanup is provided under the MIT License (MIT)

