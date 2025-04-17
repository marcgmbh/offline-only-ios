# Offline Only

iOS app that only works offline.

## Run it

git clone https://github.com/marcgmbh/offline-only-ios.git

cd offline-only-ios

open offline-only.xcodeproj

hit Run – that’s it.

first build error? open Targets ▸ Signing & Capabilities and drop in your own bundle id or just let xcode pick one.

## Add your own media

Drop images into Assets

Add an entry in media.json:

{
  "imageName": "new‑photo",
  "title": "AUTHOR\nNAME, 2025."
}

## License

MIT License
