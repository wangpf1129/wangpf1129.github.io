---
title: 运算符 typeof 与 instanceof 区别
index_img: /img/typeof.jpg
date: 2021-02-17 16:20:00
tags: [JavaScript]
categories: [JavaScript]
---

### typeof

type 中文翻译：“类型”

用于判断数据类型，返回值是6个不同的字符串：分别是：**string**  **number**   **boolean**  **undefined**  **function**  **object**




```js

console.log(typeof "1");   // string

console.log(typeof 1);  // number

console.log(typeof false);  // boolean

console.log(typeof undefined);  // undefined

console.log(typeof function fn() {});   // function

console.log(typeof {});   // object
```



除了以上之外，你会发现 typeof 判断 **null**  **Array**   **构造函数的实例**时， 会发现 永远得到是 **object**



因此可知道 typeof 运算符  适用于检测除null的基础数据类型和函数类型



### instanceof

instance 中文翻译：“实例”  因此可以通过他的翻译知道这个含义了，就是 判断该对象是属于谁的实例。由于是实例，所以不得不牵扯到了对象的继承，即原型的知识了。而 **instanceof**  就是根据原型链进行搜寻的。



所以 instanceof 是检测对象之间的关联性

```js
      console.log(new Number() instanceof Number);  // true
      console.log(new String() instanceof String);  // true
      console.log([1, 2, 3] instanceof Array);  // true
      console.log({ name: "foo" } instanceof Object);  // true
      
      console.log("1" instanceof String);  // false
      console.log(1 instanceof Number); // false
      console.log(false instanceof Boolean);   // false
```



### 总结

|            | typeof                                 | instanceof                         |
| ---------- | -------------------------------------- | ---------------------------------- |
| 作用       | 检测数据类型                           | 检测对象之间的关联性               |
| 返回值     | 小写的字母 字符串                      | 布尔值                             |
| 操作符     | 简单数据类型（没有null）、函数或者对象 | 左边必须是引用类型，右边必须是函数 |
| 操作数数量 | 1个                                    | 2个                                |



**typeof**   中的 type 是类型的意思，所以他是用来检测数据类型的， 可以检测除了null以外的数据类型加上function，返回字符串

**instanceof** 中的 instance是实例的意思， 所以他是用来检测这个实例是谁 **new** 出来的。返回布尔值

