# Release signing key

`master_maroc_release.jks` is the real signing key used for release builds
(`android/app/build.gradle` reads its credentials from `../key.properties`).

**Back this up somewhere outside this machine right now** (password manager,
encrypted cloud storage, etc.) — neither this file nor `key.properties` is
committed to git. If you lose this keystore after publishing to Google Play,
you **cannot** ship an update to the same app listing ever again; Google
would require creating a brand new app under a new package name.

Do not share `key.properties` or this `.jks` file with anyone you don't
want to be able to sign releases of this app.
