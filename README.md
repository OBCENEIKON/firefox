Readme
======

Launching the firefox
```
docker-compose up -d
```

Extensions
==========

I have decided to add here a list of the Firefox's extensions I am using
```
https://www.eff.org/privacybadger
https://adblockultimate.net/
```

Extra
=====

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

To initialize the new Firefox profile
```
docker-compose run --rm firefox -P
```

Limitations
===========

X11 and PulseAudio
------------------

The user ID must match the ID of a user that runs the container,
otherwise X neither audio will work.

