# EEGViewer
A MATLAB program for EEG data visualization.

## Screenshot
![Screenshot](https://github.com/pikipity/EEGViewer/blob/master/ScreenShot.PNG?raw=true)

## Installation 

1. Download all files from <https://github.com/pikipity/EEGViewer/archive/master.zip>;
2. Unzip the downloaded file;
3. In MATLAB, run `Install_EEGViewer.m` file.

## Run Program

After the installation, run `EEGViewer` in MATLAB.

## Data Requirements

1. Data is stored in MATLAB file (`.mat` file).
2. In the `.mat` file, data is stored in a matrix called `y`.
3. In the matrix, the first row is the time sequence. The other rows are for different channels.
4. The data length is at least 20.
