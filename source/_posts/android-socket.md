---
title: 安卓Socket编程
tags:
  - Socket
categories: Android
abbrlink: 269bd368
date: 2017-03-23 17:31:37
---

{% cq %}Socke基础{% endcq %}

<!--more-->

### Socket常识
称为套接字，用于IP地址和端口。
端口号取值范围0-256*256-1（0-1024位系统保留端口）我们通常使用1024-256*256-1端口号
Socket分为两部分
一是服务器部分，一直监听服务器某个端口。
二是客户端部分，可以向服务器发送数据。

### Socket分为通常分为TCP、UDP
UDP协议
UDP协议是一个不怎么靠谱的协议，把数据打成数据包，数据包包含通讯地址，数据包是否发送到指定服务器是不会被保证的，数据包发送的数据包比较小，速度相对于TCP快些。

TCP协议
客户端与服务器建立连接需要进行三次握手，建立连接之后服务器与客户端就能随意发送数据。

客户端于服务器端要用同一种协议（UDP或TCP）。
客户端向服务器发送数据为OutputStream
客户端接受服务器发送的数据为InputStream

#### 服务器端（ServerSocket）
1.创建一个ServerSocket
2.调用accept()用来接收客户端发送请求
3.从接收到的socket对象得到客户端发送的数据

Android Socket通信原理，注意地方：
1、中间的管道连接是通过InputStream/OutputStream流实现的
2、一旦管理建立起来可以进行通信
3、关闭管道的同时意味着关闭Socket
4、当对同一个Socket创建重复管道时会异常
5、通信过程中顺序很重要：服务器端首先得到输入流，然后将输入流信息输出到其各个客户端；客户端先建立连接后先写入输出流，然后再获得输入流，不然会有EOFException的异常。

### 基于TCP协议
服务器端

```
ServerSocket serverSocket = null;
        try {
            // 创建一个ServerSocket对象，并让这个socket监听4567端口
            serverSocket = new ServerSocket(4567);
            // 接受客户端所发送的请求（阻塞式） 返回值为从客户端发送得到的
            Socket socket = serverSocket.accept();          
            
            // 读取客户端发送的InputStream
            InputStream inputStream = socket.getInputStream();
            byte[] buffer = new byte[1024];
            int tmp = 0;
            // 从ImputStream读取客户端发送的数据
            while ((tmp = inputStream.read(buffer)) != -1) {
                System.out.println("Client-->" + new String(buffer, 0, tmp));
                
                InetAddress address = socket.getInetAddress();
                String ip = address.getHostAddress();
                OutputStream outputStream = socket.getOutputStream();
                System.out.println(ip);
                outputStream.write(ip.getBytes());
                outputStream.flush();   
            }
            
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                serverSocket.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
```

客户端与服务器建立连接

```
        try {
                // 创建一个Socket对象 指定服务器ip地址和端口号
                socket = new Socket(String.valueOf(params[0]), (Integer) params[1]);
                // 从socket得到OutputStream
                OutputStream outputStream = socket.getOutputStream();
                outputStream.write("= = = = = = = = 建立连接= = = = = = = =".getBytes());
                outputStream.flush();
            } catch (IOException e) {
                e.printStackTrace();
            }

            客户端发送数据到服务器
            if (socket != null && !socket.isClosed() && socket.isConnected()) {
                    new Thread() {
                        @Override
                        public void run() {
                            try {
                                OutputStream outputStream = socket.getOutputStream();
                                String time = SocketActivity.this.format.format(new Date());
                                String out = "= = = = = = = = " + time + "= = = = = = = =";
                                outputStream.write(out.getBytes());
                                outputStream.flush();

                                InputStream inputStream = socket.getInputStream();
                                byte[] bb = new byte[1024];
                                int len = 0;
                                while ((len = inputStream.read(bb)) != -1) {
//                                    System.out.println("服务器返回的数据-->" + new String(bb, 0, len));
                                    Log.d(TAG, "run: " + "服务器返回的数据-->" + new String(bb, 0, len));
                                }
                            } catch (IOException e) {
                                e.printStackTrace();
                            }
                        }
                    }.start();
                }

```

### 基于UDP服务器端

```
 try {
         // 创建一个DatagramSocket对象，并指定监听端口号
         DatagramSocket socket = new DatagramSocket(4567);
         byte[] data = new byte[1024];
         // 创建一个空的DatagramPacket对象 用来接收客户端发送的数据包
         DatagramPacket packet = new DatagramPacket(data, data.length);
         // 使用receive方法接收客户端所发送的数据 同样是堵塞的方法 不会向下运行
         socket.receive(packet);
         System.out.println(new String(packet.getData()));
         } catch (SocketException e) {
         e.printStackTrace();
         } catch (IOException e) {
         e.printStackTrace();
         }


```


客户端

```
           Date date = new Date();
            String time = SocketActivity.this.format.format(date);
            DatagramSocket socket = null;
            try {
                if (socket != null) {
                    socket.close();
                }
                // 创建一个DatagramSocket对象
                socket = new DatagramSocket(4567);
                //创建一个InetAddree
                InetAddress address = InetAddress.getByName((String) params[0]);
                // 创建一个DatagramPacket对象，并指定服务器地址及端口号
                DatagramPacket packet = new DatagramPacket(time.getBytes(), time.getBytes().length, address, 4567);
                // 调用socket对象的send方法 发送数据到服务器
                socket.send(packet);
```