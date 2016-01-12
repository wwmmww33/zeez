This is a porting version of Zinnia(Version 0.05) in Actionscript which is open source for online handwriting recognition.

Zinnia is based on Support Vector Machines which has learning and recognizing features, I only ported recognition part. So you can training data using Zinnia for develop better results.

Engine quite fast and good but it requires good trained model.
Of course, you can use Zinnia-Tomoe model for Japanese and Chinese character recognition but model files are over 15 MB even if it's zipped so better use zinnia on server side for full character recognition.

[http://zinnia.sourceforge.net](http://zinnia.sourceforge.net)

I'm using lots of Vectors and Flash 10's features, so it only supports from the version 10 of flash player.

External library being used:
  * [Fzip](http://codeazur.com.br/lab/fzip/)
  * [as3flexunitlib](http://code.google.com/p/as3flexunitlib/)

**--------- updates 2009 09 28 ----------**

Now it uses the freeman chain algorithm to simplify strokes of a character.
It's useful for increase accuracy because users' stroke points are more similar to the studied model data.
Also I added Capital letter of English characters, although some of characters like B, W, require more training data.

[![](http://www.actionfigure.pe.kr/images/portfolio/zcaseThumbnail.jpg)](http://blog.spiderbutterfly.com/en/projects/online-handwriting-recognition-in-flash/)