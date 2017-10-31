---
title: 安卓7.0内容提供者变化
tags:
  - Provider
abbrlink: 13409
date: 2017-10-26 20:19:04
categories: Android
---

{% cq %}
android.content.pm.ProviderInfo.loadXmlMetaData(android.content.pm.PackageManager, java.lang.String)' on a null object reference
{% endcq %}

<!-- more -->

### 背景
从 Android7.0 (N) 起，程序之间不允许通过 Intent 传文件(file://URI)，图片选取、裁剪类功能将受影响。

7.0以前调用相机拍照
``` java
File file = new File(Environment.getExternalStorageDirectory(), "/temp/photos/" + System.currentTimeMillis() + ".jpg");
if (!file.getParentFile().exists()) file.getParentFile().mkdirs();
Uri    imageUri = Uri.fromFile(file);
Intent intent   = new Intent();
intent.setAction(MediaStore.ACTION_IMAGE_CAPTURE);
intent.putExtra(MediaStore.EXTRA_OUTPUT, imageUri);
startActivityForResult(intent, 1127);
```
最近一个项目用到图片选择器，选择图片的时候显示相机，用的这个第三方库  [GalleryPick](https://github.com/YancyYe/GalleryPick/)  ，此库为了兼容7.0，需要配置 Provider ，如果没配置打开相机动作时就会报错，7.0以前及7.0错误如下
- 7.0 以前
![4.0](http://blog-1251260269.picsh.myqcloud.com/blog/android/error_n_file_uri_before_n.png)
- 7.0
![4.0](http://blog-1251260269.picsh.myqcloud.com/blog/android/error_n_file_uri_after_n.png)

### 解决方法

在清单文件配置内容提供者
```xml
 <provider
	android:name="android.support.v4.content.FileProvider"
	android:authorities="xxx.xxx.xxx.xxx"
	android:exported="false"
	android:grantUriPermissions="true">
	<meta-data
		android:name="android.support.FILE_PROVIDER_PATHS"
		android:resource="@xml/file_paths" />
</provider>
```

authorities 值为在 GalleryConfig Builder 配置 provider 值。

### 多个相同内容提供者

关于存储方面的有很多功能，例如下载文件、访问图片、上传图片等，兼容安卓7.0的话就需要设置内容提供者，所以这个问题也是比较常见的。

```gradle
Error:Execution failed for task ':app:processDebugManifest'.
> Manifest merger failed with multiple errors, see logs
```

当集成多个相同内容提供者时，比如小米自动更新、 GalleryPick ， Android Studio 构建时会提示清单文件合并错误。

小米自动更新 Provider authorities 是固定的，如下

DownloadInstallManager.java

```java
Uri installUri;
if (Client.isLaterThanN()) {
	File file = new File(apkFilePath);
	String authority = mContext.getPackageName() + ".selfupdate.fileprovider";
	installUri = FileProvider.getUriForFile(mContext, authority, file);
	mContext.grantUriPermission("com.google.android.packageinstaller",installUri,Intent.FLAG_GRANT_READ_URI_PERMISSION);
} else {
	installUri = Uri.parse("file://" + apkFilePath);
}
```

当然可以搞出源码改为传参形式，但是不能每次升级小米自动更新 SDK 版本的时候都改一次吧，当然也可以继承 FileProvider ，在清单文件提供者 name 写继承的 类名。

项目还集成了选择图片库，没办法先让它将就下也用小米自动更新的 authorities 吧，要不然就会造成上面清单文件冲突。

resource 可以只配置图片选择库的 @xml/file_paths ，不过要与小米自动更新的文件名一样。

当然也可以同时配置到一个文件里，如下

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <paths>
        <!--XiaoMi Update Path-->
        <paths>
            <external-files-path
                name="download"
                path="Download"/>
        </paths>
        <!--GalleryPick Path-->
        <external-path
            name="external"
            path=""/>
        <files-path
            name="files"
            path=""/>
        <cache-path
            name="cache"
            path=""/>
    </paths>
</resources>
```




