# rename4AGPtek

Adds a sequential prefix to every mp3 file on the AGPtek or Ruizu player so that it plays them in the correct order.

My AGPtek M20 and RUIZU X02 mp3 players have an odd way of ordering the mp3 files saved on the device. While you can save mp3s sorted into different directories onto the player it will still sort the files alphabetically as if they were all in one directory. From comments I've read using fatsort (or a similar program) on the device will make the files appear in the correct order, but it didn't solve the problem for me; neither for the internal storage nor an sd card. This bash script will prefix all of your files with a unique number so that mp3s that share a directory will be listed/play next to each other by the player.
