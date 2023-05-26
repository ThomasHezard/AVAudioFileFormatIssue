# AVAudioFile format issue

## [TL;DR]

#### Issue encountered
- `AVAudioFile` 
  - throws when opening WAV files and MPEG-DASH files with `.mp3` extension,
  - works fine with many other tested combinations of formats and extension (for example, an AIFF file with `.mp3` extension is read by `AVAudioFile` without error).
- The `Music` app, `AVAudioFile` and `ExtAudioFile` all fail on the same files.
- However, previewing an audio file in `Finder` (select the file and hit the space bar) works regardless of the file extension.

#### Why do I consider this an issue?
- `AVAudioFile` seems to rely on extension sometimes but not always to guess the audio format of the file, which leads to unexpected errors.
- I would expect `AVAudioFile` to deal properly with wrong extensions for all supported audio formats.
- ⚠️ _**This behaviour can cause real trouble in iOS and macOS applications using audio files coming from the user, which often have unreliable extensions.**_

## Illustration of the issue: `avaudiofile-format-issue.playground`

### Content of the playground

In this playground project, I simply try to open various audio files for reading with `AVAudioFile`. File have different combinations of file formats and extensions.
- All the files have been encoded from the same WAV audio file `marimba-wav.wav`:
  - in AIFF using the command `ffmpeg -i marimba-wav.wav marimba-aiff.aiff`
  - in CAF-AAC using the command `afconvert -f caff -d aac -q 127 -b 128000 marimba-wav.wav marimba-caf-aac.caf`
  - in M4A using the command `ffmpeg -i marimba-wav.wav marimba-m4a.m4a`
  - in MP3 using the command `ffmpeg -i marimba-wav.wav marimba-mp3.mp3`
  - in MPEG-DASH single file using the command `ffmpeg -i marimba-wav.wav -c:a libfdk_aac -f dash -single_file 1 marimba-dash.mp4`
- Each file has then been duplicated and renamed with the extensions [`aiff`, `caf`, `m4a`, `mp3`, `mp4`, `wav`] and with no extension at all.

### What happend when running the playground

`AVAudioFile` manages to open all files except
- `marimba-dash.mp3`: MPEG-DASH file with `mp3` extension,
- `marimba-wav.mp3`: WAV file with `mp3` extension.

## Additional investigations

- The same code has been run within an iOS app, the results are the same.
- I tested a few files, it seems that when `AVAudioFile` manages to open the file, the audio content is properly decoded, but I did not check all the files.
- The now depreceted `ExtAudioFile` API behaves exactly the same as `AVAudioFile`.
- The `Music` app also fails to read the files for which `AVAudiofile` throws errors.
- However, preview of the audio file in Finder seems to work regardless of the extension.
