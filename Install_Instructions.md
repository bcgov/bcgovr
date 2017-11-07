# Instructions for installing **R** and **RStudio** on a Windows 7 BC Government computer

\*Note that the B.C. Software Centre has **R** and **RStudio** packaged for installation. If you
install from the Software Centre, skip steps 1 and 2. If you have your supervisor's approval 
(following the [Appropriate Use Policy](http://www2.gov.bc.ca/gov/content?id=33A6DE0643E54676B21033E5DA8E03CF)), 
*follow steps 1 and 2 to get up-to-date versions of the software*.

1. Install **R** from [this webpage](http://cran.rstudio.com) (or click 
   [here](http://cran.r-project.org/bin/windows/base/release.htm) to download 
   the current version directly). Accept the defaults for all the installation 
   options.

    * *Complete this step if you are updating R:* Uninstall previous version of R, 
    and go to `C:/Program Files/R/[prev_R_version]` and delete all folders and files left over.

    
2. Install RStudio: Go to https://www.rstudio.com/products/rstudio/download/#download, and 
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
    
    The output should look something like this:
    
    ```
    [1] "C:/Users/[your_username]/R/win-library/[R-version]/"     "C:/Program Files/R/[R-version]/library"
    ```

6. It's a good idea to test installing some packages. Try:

    ```r
    install.packages(c("dplyr", "ggplot2"))
    ```

    If you get no errors, and a message saying:
    **"Installing package into 'C:/Users/[your_username]/R/win-library/[R-version]/'"** 
    (plus more) you should be good to go!
   
7. If you are updating R from a previous version, you will need to update your packages as well. Run:

    ```r
    update.packages(checkBuilt = TRUE)
    ```
    
    This will ensure your packages were built for the version of R that you are runnning.

## Other tips:

* **Work locally:** It is a good idea to try to do your R work on your hard (C:/) drive whenever possible as it is usually much faster than working over the network, especially reading and writing large data files or if you use [Git](https://git-scm.com/) for version control. However, note that **C: drives are not backed up**, so make sure you have a strategy in place for making sure any work you do on your C: drive is backed up.

* **Keep your packages up date:** Check for package updates every day by clicking Tools -> Check for Package Updates in RStudio. You'll get the latest bug fixes and features in your packages and it will make sharing code with other people easier if we all have up-to-date packages.

* **Use Git and GitHub for version control:** See the [BC Policy Framework](https://github.com/bcgov/BC-Policy-Framework-For-GitHub) for how to get started using GitHub in the BC Government. [Happy Git with R](http://happygitwithr.com/) is an excellent resource for best practices using Git and GitHub with R and Rstudio.

