# Instructions for installing **R** and **RStudio** on a BC government computer


1. Install **R** from [this webpage](http://cran.rstudio.com) (Or click 
   [here](http://cran.r-project.org/bin/windows/base/release.htm) to download 
   the current version directly). Accept the defaults for all the installation 
   options.

    * *Complete this step if you are updating R:* Uninstall previous version of R, 
    and go to `C:/Program Files/R/[prev_R_version]` and delete all folders and files left over.

    
2. Install RStudio: Go to https://www.rstudio.com/products/rstudio/download/preview/, and 
   download and install the version for your system.  Accept all of the defaults 
   for the installation options.
   
3.  Open command prompt (Open Start Menu then type `cmd` and press [Enter]).
    Type the following line into the command prompt window exactly as shown:

    ```
    setx HOME "%USERPROFILE%"
    ```
    
    Press [Enter], you should see **SUCCESS: Specified value was saved**.
    Quit command prompt by typing `exit` then pressing [Enter]

5. Open **RStudio** and test installing and loading a couple of 
   packages by typing (or copying and pasting) the following at the command prompt (`>`):

    ```r
    .libPaths()
    ```
    
    The output should look like this:
    
    ```
    [1] "C:/Users/[your_username]/R/win-library/3.3/"     "C:/Program Files/R/[R-version]/library"
    ```

6. It's a good idea to test installing some packages. Try:

    ```r
    install.packages(c("dplyr", "ggplot2"))
    ```

   If you get no errors, and a message saying:
   **"Installing package into 'C:/Users/[your_username]/R/win-library/3.3/'"** 
   (plus more) you should be good to go!

## Other tips:

It is a good idea to try to do your R work on your hard (C:/) drive whenever possible as it is usually much faster than working over the network, especially reading and writing large data files or if you use [git](https://git-scm.com/) for version control. However, note that **C: drives are not backed up**, so make sure you have a strategy in place for making sure any work you do on your C: drive is backed up.

