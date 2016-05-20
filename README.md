# Firefox in Docker

## Launching the Firefox

You can use the following shortcut function and place it to your `~/.bash_aliases` file

```
alias docker="sudo -E docker"
alias docker-compose="sudo -E docker-compose"

function docker_helper() { { pushd ~/docker/$1; docker-compose rm -fa "$1"; docker-compose run -d --name "$1" "$@"; popd; } }
function firefox() { { docker_helper $FUNCNAME $@; } }
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

Be careful playing with the following settings!

http://www.sitepoint.com/firefox-enable-webgl-blacklisted-graphics-card/

```
about:config
layers.acceleration.force-enabled;true
gl.require-hardware;true
webgl.force-enabled;true

about:support
```


# Extra

## Extensions

Here is the list of Firefox's extensions I am using

- [Privacy Badger](https://www.eff.org/privacybadger)

- [uBlock Origin](https://github.com/gorhill/uBlock)
