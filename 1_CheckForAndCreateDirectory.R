## Checking for and creating directories
file.exists("directory name")   # check to see if the directory exists
dir.create("directory name")    # will create a directory if it doesn't exist

if(!file.exists("data")) {
        dir.create("data")
}