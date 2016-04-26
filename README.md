# Firefox in Docker

## Launching the Firefox

```
alias firefox="docker-compose -f ~/docker/firefox/docker-compose.yml run --rm firefox"
```

# Troubleshooting

## Audio

Following are some useful commands which you can use for testing the audio

```
docker-compose run --rm --entrypoint /bin/bash firefox
apt-get update && apt-get install -y alsa-utils
aplay -L
pactl list
cat /dev/urandom | aplay -
arecord -D pulse -f cd | aplay -D pulse -B 10000 -

WebRTC online test for Microphone, Camera, Network, Connectivity and Throughput
https://test.webrtc.org/
https://webaudiodemos.appspot.com/AudioRecorder/index.html
```

## Video

Go to `about:support` in the Firefox to see whether everything is OK or not.


## Codecs and the HW acceleration

You may want to disable Google's VP8 & VP9 video codecs: "MSE & WebM VP9" and "WebM VP8"
as there is no hardware decoding for them.
To do this, install h264ify extension from
```
https://addons.mozilla.org/en-us/firefox/addon/h264ify/
```

Check the codecs

```
https://www.youtube.com/html5
```


# Extra

## Extensions

Here is the list of Firefox's extensions I am using

```
https://www.eff.org/privacybadger
https://adblockultimate.net/
```
