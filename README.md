- Rename all .MP3 files in audio directory to .mp3
- Rename all .JPG/.jpeg/.JPEG files in images directory to .jpg
- Rename all .PNG files in images directory to .png
- Rename all .conf files in main directory to .json
- Change all .JPG/.jpeg/.JPEG in .json files to .jpg
- Change all .PNG in .json files to .png
- Remove from all menu*.json files in main directory the following lines (if they exist):

“splash_screen”: {
…
},

- Create a file in main called “image_list.js”. It should contain all files in images directory
as follows:

const image_list = {
“file01.png”: require(‘./images/file01.png’),
“file02.jpg”: require(‘./images/file02.jpg’),
…
“file14.jpg”: require(‘./images/file14.jpg’)
}
export default image_list


- Create a file in main called “file_list.js”. It should contain all json files in main directory as
follows:
const file_list = {
“data01”: require(‘./data01.json’),
“data02”: require(‘./data02.json’),
“main”: require(‘./main.json’),
“menu01”: require(‘./menu01.json’),
…
“menu43”: require(‘/menu43.json’)
}


- Convert all stereo audio files in the audio directory to mono audio files.

find . -name '*.mp3' -exec ffmpeg -i '{}' -ac 1 'output/{}' \;
