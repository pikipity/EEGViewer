# EEGViewer
A MATLAB program for EEG data visualization, including basic filters and a rectangular window.

## Screenshot
![Screenshot](https://github.com/pikipity/EEGViewer/blob/master/ScreenShot.PNG?raw=true)

## Installation Requirements

Now, this program is only tested in MATLAB R2015b. You are welcome to test it in other MATLAB versions.

It is only suitable for Windows. For other system, the GUI may not be able to display correctly. 

## Installation Steps

1. Download all files from <https://github.com/pikipity/EEGViewer/archive/master.zip>;
2. Unzip the downloaded file;
3. In MATLAB, run `Install_EEGViewer.m` file.

## Run This Program

After the installation, run `EEGViewer` in MATLAB.

You can use `example.mat` to test this program.

## Data Requirements

1. Data is stored in MATLAB file (`.mat` file).
2. In the `.mat` file, data is stored in a matrix called `y`.
3. In the matrix, the first row is the time sequence. The other rows are for different channels.
4. The data length is at least 20.
