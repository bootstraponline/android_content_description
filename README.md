android_content_description
===========================

Automatically update android:contentDescription using android:text and falling back to android:hint.

`gem install nokogiri`

`ruby update.rb`

Change `dir` in `update.rb` to point to the XML layout folder.
After running update, format the XML files manually using Eclipse.
There's currently [no way](https://code.google.com/p/android/issues/detail?id=33869) to use Android's XML formatter from the commandline.
