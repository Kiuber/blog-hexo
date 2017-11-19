---
title: 提高安卓应用识别二维码准确率，zbar识别图片文件
tags:
  - android
  - 二维码
categories: Android
date: 2017-07-06 15:18:19
---

{% cq %}利用zbar提高二维码识别率{% endcq %}

<!-- more -->
#### 前言
相信用过微信的都知道微信的二维码识别识别特别快，无论是斜着手机还是怎样，几乎都能很快的识别出来，听说微信是开发了一套自用的二维码识别库，Qbar，这个算法应该是放到了微信服务器，因为在聊天界面长按包含二维码的图片，只有手机接入网络时才会有“识别图中二维码”这一选项，再就是扫一扫需要网络才能用，不过接入网络有可能是微信为了统计扫码次数。

对比了几个安卓二维码扫描的应用，小米自带的扫一扫、UC浏览器不需要网络就可以本地识别，支付宝、微信这两家需要网络才行。
#### zxing zbar

安卓二维码相关的基础库有两个，一个是google[zxing](https://github.com/zxing/zxing/)，另一个是[zbar](https://github.com/ZBar/ZBar)，zxing一直在维护，而zbar已经不维护多年了，不过zxing是用java写的、而zbar底层是用c写的，听网上说zbar常用于ios开发，貌似现在ios提供了自己的识别二维码接口，Android方面的文档几乎没有。

识别二维码一般分为两类，一是用相机来扫一扫，二是读取文件识别。不过两者有共同的地方，不论是扫一扫还是识别文件都可以转化为Bitmap（阅读Zbar源码可以发现）。

经过我手机（红米Note 4G双卡版、小米5S Plus 高配版）测试，zxing的扫一扫和识别文件效果一般般，对于稍微有点复杂的二维码表现的就更差了。于是寻求zbar的解决方案。阅读zbar关键源码，识别Bitmap时，

```java
public void onPreviewFrame(byte[] data, Camera camera) {
                Camera.Parameters parameters = camera.getParameters();
                Size size = parameters.getPreviewSize();

                Image barcode = new Image(size.width, size.height, "Y800");
                barcode.setData(data);

                int result = scanner.scanImage(barcode);
                
                if (result != 0) {
                    previewing = false;
                    mCamera.setPreviewCallback(null);
                    mCamera.stopPreview();
                    
                    SymbolSet syms = scanner.getResults();
                    for (Symbol sym : syms) {
                        scanText.setText("barcode result " + sym.getData());
                        barcodeScanned = true;
                    }
                }
            }
```

查其重载barcode.setData有两个，于是可以把图片文件转换成两个参数就能识别了，其实扫一扫的原理也是这样的，相机把捕捉的Bitmap data[]传过来然后识别。

```java
public native void setData(byte[] var1);

public native void setData(int[] var1);
```

#### 优化方案

下面就是指定图片识别代码，zbar的扫一扫很多，这里就不说了

```java
private String zbarDecode(String filePath) throws Exception {
        File   file       = new File(filePath);
        Bitmap barcodeBmp = BitmapFactory.decodeFile(file.getPath());
        int    width      = barcodeBmp.getWidth();
        int    height     = barcodeBmp.getHeight();
        int[]  pixels     = new int[width * height];
        barcodeBmp.getPixels(pixels, 0, width, 0, 0, width, height);
        Image barcode = new Image(width, height, "RGB4");
        barcode.setData(pixels);
        ImageScanner reader       = new ImageScanner();
        int          result       = reader.scanImage(barcode.convert("Y800"));
        String       qrCodeString = null;
        if (result != 0) {
            SymbolSet syms = reader.getResults();
            for (Symbol sym : syms) {
                qrCodeString = sym.getData();
                LogUtil.d("qrCodeString", qrCodeString);
            }
        }
        return qrCodeString;
    }
```
#### 参考链接

[https://github.com/ZBar/ZBar/blob/master/android/examples/CameraTest/src/net/sourceforge/zbar/android/CameraTest/CameraTestActivity.java](https://github.com/ZBar/ZBar/blob/master/android/examples/CameraTest/src/net/sourceforge/zbar/android/CameraTest/CameraTestActivity.java)
[https://stackoverflow.com/questions/17850942/zbar-android-scan-local-qr-or-bar-code-image](https://stackoverflow.com/questions/17850942/zbar-android-scan-local-qr-or-bar-code-image)