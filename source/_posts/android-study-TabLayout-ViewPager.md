---
title: TabLayout+ViewPager实现选项卡滑动
tags:
  - 选项卡
categories: Android
date: 2016-04-27 20:14:26
---

{% cq %}Google在2015的IO大会上，给我们带来了更加详细的`Material Design`设计规范，同时，给我们带来了全新的`Android Design Support Library`，在这个Support中，谷歌给我们提供了更加规范的MD设计风格的空间。最重要的是，`Android Design Support Library`的兼容性更广，直接可以向下兼容到`Android 2.2`。之前我也一直想做出一个选项卡实例，看到网上他们写的教程太难懂了，也可能是因为我没能力懂他们写的，所以我还是自己写一份这个吧，学习安卓的朋友也可以借鉴借鉴，废话就不多说了，上菜。{% endcq %}

<!--more-->
#### 第一步，当然是写layout文件
```java
<android.support.design.widget.TabLayout
    android:id="@+id/tab_FindFragment_title"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:background="#87CEEB"
    app:tabIndicatorColor="#ffffff"
    app:tabSelectedTextColor="@android:color/darker_gray"
    app:tabTextColor="#ffffff" />

<android.support.v4.view.ViewPager
    android:id="@+id/vp_FindFragment_pager"
   	android:layout_width="fill_parent"
    android:layout_height="0dp"
    android:layout_weight="1" />
```
其中`tabSelectedTextColor`是指Tab被选中的颜色，`tabTextColor`是指Tab未被选中的颜色，`tabIndicatorColor`是指指示器下标的颜色。
#### 第二步，声明变量并找到控件对象。
```java
private TabLayout tab;
private ViewPager viewPager;
```
```java
tab = (TabLayout) findViewById(R.id.tab_FindFragment_title);
viewPager = (ViewPager) findViewById(R.id.vp_FindFragment_pager);
```
#### 第三步，为viewPager设置适配器，并修改`getItem()`，`getCount()`方法的返回值,复写`getPageTitle()`方法。
```java
viewPager.setAdapter(new CustomAdapter(getSupportFragmentManager(), getApplicationContext()));
```
```java
private class CustomAdapter extends FragmentPagerAdapter {
        private String fragments[] = {"Fragment1", "Fragment2"};

        public CustomAdapter(FragmentManager supportFragmentManager, Context applicationContext) {
            super(supportFragmentManager);
        }

        @Override
        public Fragment getItem(int position) {
            switch (position) {
                case 0:
                    return new Fragment1();
                case 1:
                    return new Fragment2();
                default:
                    return null;
            }
        }

        @Override
        public int getCount() {
            return fragments.length;
        }

        @Override
        public CharSequence getPageTitle(int position) {
            return fragments[position];
        }
    }
```
#### 第四步，新建Fragment1、fragment2类继承Fragment,新建f1、f2布局文件，并实现`onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState)`方法。
```java
public class Fragment1 extends Fragment {
    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        return inflater.inflate(R.layout.f1, container, false);
    }
}
```
```java
public class Fragment2 extends Fragment {
    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        return inflater.inflate(R.layout.f2, container, false);
    }
}
```
#### 第五步，为tab绑定viewPager，并为tab设置setOnTabSelectedListener。
```
tab.setupWithViewPager(viewPager);
```
```java
 tab.setOnTabSelectedListener(new TabLayout.OnTabSelectedListener() {
            @Override
            public void onTabSelected(TabLayout.Tab tab) {
                viewPager.setCurrentItem(tab.getPosition());
            }

            @Override
            public void onTabUnselected(TabLayout.Tab tab) {
                viewPager.setCurrentItem(tab.getPosition());
            }

            @Override
            public void onTabReselected(TabLayout.Tab tab) {
                viewPager.setCurrentItem(tab.getPosition());
            }
        });
```
**注意**：
1.一定要注意`tab.setupWithViewPager(viewPager);`写在`viewPager.setAdapter(new CustomAdapter(getSupportFragmentManager(),getApplicationContext()))`之后，否则会报错`viewPager do not set`。
2.viewPager的width和height要设置合适，有时可能是显示了，但是由于设置宽度和高度的问题，可能会让你误以为设置错误。
参考资料：[ViewPager with TabLayout in Android - Sliding Tabs](https://www.youtube.com/watch?v=-a2jJ92bmzw)