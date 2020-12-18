---
title: 以jQuery的设计思想封装DOM(总结)
date: 2020-12-09 17:39
index_img: /img/jquery.jpg
tags: JavaScript
categories: jQuery
---
## 前言
实现了用JQuery的设计思想去封装DOM。

**源代码链接：** https://github.com/wwwpppfffzzz/jQuery-dom/blob/master/src/jquery.js


## jQuery的思想
jQuery的基本设计思想就是：`选择某个网页元素，对其进行某种操作。`

八个字可以概括：`选取元素，对其操作。`

## jQuery获取网页元素思想
使用jQuery的第一步，就是要得到你选中的元素，放在jQuery()（或者$()）里面。

**实现方法:** 使用重载设计模式获取对应的元素，利用闭包，在调用方法时使用到`elements`

**代码展示：**
```js
winddow.$ = window.jQuery = function (selectorOrArray) {
  let elements = null
  if (typeof selectorOrArray === 'string') {
    elements = document.querySelectorAll(selectorOrArray)
  } else if (selectorOrArray instanceof Array) {
    elements = selectorOrArray
  }

  let api = {
    find(selector) {
      let array = [];
      for (let i = 0; i < elements.length; i++) {
        const elements2 = Array.from(elements[i].querySelectorAll(selector));
        array.push(...elements2);
      }
      array.oldThis = this; 
      return jQuery(array);
    },
    addClass(className) {},
  };
  return api;
};
```

## jQuery的链式操作实现思想
**链式操作**: 选中网页元素以后，可以对它进行一系列操作，并且所有操作可以连接在一起，以链条的形式写出来.
```js
$('div').find('h3').eq(2).html('Hello');
```
**实现思想：** 原理在于于每一步的jQuery操作，返回的都是一个新的jQuery对象。

**代码展示（以find方法举例）：**
```js
  find(selector) {
    let array = []
    for (let i = 0; i < this.elements.length; i++) {
      const elements2 = Array.from(this.elements[i]
        .querySelectorAll(selector))
      array = array.concat(elements2)
    }
    //  将当前的对象存放在array里
    array.oldThis = this
    // 然后在返回一个新的jQuery对象， 防止污染
    // 如果直接把数组赋值给elements返回的话，会污染到addClass方法
    return jQuery(array)
  },
```

## 把方法放在原型上的实现思想
**优点：** 
- 把方法都移到jQuery原型身上，这样每次创建一个jQuery对象时，就不会再去开一块内存存放方法了。
- 所有创建的jQuery对象中的方法都放在原型上，这样省内存。

**代码展示：**
```js
window.$ = window.jQuery = function (selectorOrArray) {
  let elements = null
  if (typeof selectorOrArray === 'string') {
    elements = document.querySelectorAll(selectorOrArray)
  } else if (selectorOrArray instanceof Array) {
    elements = selectorOrArray
  }

  const api = Object.create(jQuery.prototype) // 创建一个对象，这个对象的__proto__为括号里的
  // Object.assign方法就是把{}中的对象都赋值给api
  // 相当于 api.elements = elements
  Object.assign(api, {
    elements: elements,
    // 把oldThis 存在这个对象里。 要不然别的方法访问不到
    // find中返回的是新的jQuery对象，而selectorOrArray是有oldThis这个属性的
    oldThis: selectorOrArray.oldThis,
  })
  return api
}

jQuery.prototype = {
  constructor: jQuery,
  addClass(className) {
    for (let i = 0; i < this.elements.length; i++) {
      this.elements[i].classList.add(className)
    }
    // 要求返回this 的原因是因为能够链式操作
    return this
  },
  find(selector) {},
  end() {},
  each(fn) {},
  print() {},
  parent() {},
  children() {},
  siblings() {},
  next() {,
  prev() {},
}
```


## 所以jQuery 是构造函数吗？

- 不是： 因为它没有 new jQuery() 来构造出一个对象。
- 是：   因为jQuery函数就是构造出了一个对象。

## 最后的总结
通过这次实现，了解了什么是设计模式。 

设计模式其实就是一套反复使用的通用代码取个专业性的名字。

我们不需要刻意的使用设计模式，而是在写完代码后知道这个是属于哪种设计模式。