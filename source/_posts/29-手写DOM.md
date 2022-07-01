---
title: 手写DOM
date: 2020-12-06 20:09:00
index_img: /img/DOM.png
tags: JavaScript
categories: JavaScript
---

# 手写DOM库

因为DOM原生API太难用了
[源代码链接](https://github.com/wangpf1129/DOM-Library/blob/master/src/dom.js)
## 对象风格 

- window.dom  是我们提供的全局对象



##  增加节点

```js
  dom.append(parent,child)  // 用于新增儿子节点
```


```js
  dom.wrap(`<div></div>`)   // 用于新增爸爸节点
```



### dom.create 函数

```js
dom.create(`<div><span>hi</span></div>`) // 用于创建节点
```

- 一般我们创造节点的目的就是在别的节点中插入此节点，
- 那么我要封装一个 以输入 `html格式的`  的 create函数
- 能够在创造节点的同时在里面加一些其他节点
- 传入的字符串要是以有标签的 以html的形式来



**dom.create源代码**

```js
create(string) {
    // 创建容器    template标签可以容纳任意元素
    const container = document.createElement('template')
    // 要trim，防止拿到空字符
    container.innerHTML = string.trim()
    // 必须要 使用 .content  要不然拿不到
    return container.content.firstChild

    // 或者
    // container.innerHTML = string
    // return container.content.children[0]
  }
```



**示例**

```js
const div = dom.create('<div><span>hello</span></div>')
console.log(div);
```

![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/36537b52b1f34ae8a5b6fcbc0ef2b6c4~tplv-k3u1fbpfcp-watermark.image)

### dom.after 函数

>  由于dom中的api由于只有添加前面的节点的方法，如果想要往某个节点的后面插入节点非常的费劲

```js
dom.after(node,newNode)     // 用于新增下一个（弟弟）节点
```



**dom.after  源代码**

> 这里不比担心 如果 node 这个节点是最后一个节点怎么办。   即使为null，依然能插入的 

```js
 after(node, newNode) {
    // 找到此节点的爸爸然后调用insertBefore（插入某个节点的前面）方法，
    //把 newNode 插入到下一个节点的前面
    return node.parentNode.insertBefore(newNode, node.nextSibling)
  }
```

**示例**
![](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/fa16a738b5f34d46966261afd6b3dace~tplv-k3u1fbpfcp-watermark.image)



### dom.before 函数

> 这个方法和 dom.after 方法思路一致，

```js
dom.before(node,node2)   // 用于新增上一个(哥哥)节点
```


**dom.before 源代码**

```js
before(node, newNode) {
    // 正常的返回DOM原生的添加前面的节点的方法即可
    return node.parentNode.insertBefore(newNode, Node)
  }
```

### dom.append 函数

```js
dom.append(parent,child)  // 用于新增儿子节点
```



**dom.append 源代码**

```js
  append(parent, node) {
    return parent.appendChild(node)
  }
```

### dom.wrap函数

> 实现思路:     先把这个节点先从DOM树中移出来，把原来的位置插入新的(爸爸)节点，然后在这个爸爸节点中插入原来的节点

```js
dom.wrap(`<div></div>`)   // 用于添加在此节点外面套一个节点   (爸爸)节点
```



**dom.wrap 源代码**

```js
  wrap(node, newNode) {
    // 先把newNode放在node节点的前面   后面也行
    dom.before(node, newNode)
    // 然后把node节点放在newNode里面
    dom.append(newNode, node)
  }
```



**实现思路图：**
![dom.wrap思路图](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/60febc04d6834004ab09609d6786a3be~tplv-k3u1fbpfcp-watermark.image)


**示例：**
![示例](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/13007f4503b94595869b700d5781008a~tplv-k3u1fbpfcp-watermark.image)


## 删除节点

- ```js
  dom.remove(node) // 用于删除节点
  ```

- ```js
  dom.empty(parent)  // 用于删除后代
  ```



### dom.remove 函数

> 用法： 删除某一个节点，并返回这个节点
>
> 思路 ： 让他的爸爸删除他的儿子。  

**源代码**

```js
  remove(node) {
    node.parentNode.removeChild(node)
    //返回删除的节点
    return node
   }
```





### dom.empty 函数

> 用法： 删除这个节点的所有子代
>
> 思路:   遍历删除它的所有子节点，并返回 删除的节点



> 不能用for循环的原因：因为每次 dom.remove 删除的时候，它的长度就会随之改变， 而我们又在for循环它，因此我测试时候会出现bug，因此我们选择使用 while 循环 解决。





**源代码**

```js
  empty(node) {
    const firstChild = node.firstChild
    while (firstChild) { 
      array.push(dom.remove(node.firstChild))
    }
    // 返回删除的节点
    return array
  }
```

**示例**

![删除节点](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/018c6fbad15345c5bfb5a666d0f224ee~tplv-k3u1fbpfcp-watermark.image)





## 修改 

- ```js
  dom.attr(node,'title','hello')  //将node节点中的 title 属性值改为 hello    用于读写属性,,
  dom.attr(node,'title')  // 获取 node节点的title属性值
  ```

- ```js
  dom.text(node,'我是修改后的')  //将node节点中的文本修改为xxxxx    用于读写文本内容
  dom.text(node)   // 查看文本内容
  ```

- ```js
  dom.html(node,'<em>我是修改后的</em>')  //将node节点中的html元素内容修改为xxxx ,  用于读写html内容
  dom.html(node)  // 查看此节点中的html内容
  ```

- ```js
  dom.style(node,{color:'red'})   // 用于修改style样式
  ```

- ```js
  dom.class.add(node,'btn')  // 用于添加class类名
  ```

- ```js
  dom.class.remove(node,'btn')   // 用于删除class
  ```

- ```js
  dom.class.has(node,'btn')  // 查看是否拥有类名
  ```

- ```js
  dom.on(node,'click',fn) // 用于添加事件监听
  ```

- ```js
  dom.off(node,'click',fn)  // 用于删除事件监听
  ```





### dom.attr 函数

> 用法： 如果传入的是三个参数     设置/修改 该节点中的属性值和属性名 
>
> ```js
> dom.attr(node,'title','hello')		// 传入三个参数，就设置它的属性名和属性值
> dom.attr(node,'title')    // 如果传入的是俩个参数    获取属性名
> ```

**源代码**

```js
  attr(node, name, value) {
    if (arguments.length === 3) {
      // 设置该节点某个属性和属性值
      node.setAttribute(name, value)
    } else if (arguments.length === 2) {
      // 查看该节点某个属性的值
      return node.getAttribute(name)
    }
  }
```



**示例**

![示例](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/09d6fb8575c04d98bed9e14938761a80~tplv-k3u1fbpfcp-watermark.image)
![示例](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/d4e548da4e5c4ad9ba7180914f9c3892~tplv-k3u1fbpfcp-watermark.image)





### dom.text 函数

> 用法  和 `innerText `一致



**源代码**

```js
  text(node, string) {
    if (arguments.length === 2) {   // 重载
      if ('innerText' in node) {  // 适配 
        node.innerText = string
      } else {
        node.textContent = string
      }
    } else if (arguments.length === 1) {
      if ('innerText' in node) {
        return node.innerText
      } else {
        return node.textContent
      }
    }
  }
```



**示例**

![dom.text示例](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/52ce828d8a844f4e96acb44e565a8f87~tplv-k3u1fbpfcp-watermark.image)



### dom.html 函数

> 用法和 innerHTML 一致



**源代码**

```js
 html(node, string) {
    if (arguments.length === 2) {
      node.innerHTML = string
    } else if (arguments.length === 1) {
      return node.innerHTML
    }
  }
```







### dom.style 函数

> 原生DOM操作style的写法是： 
>
> ```js
> xxx.style.color = 'red'  或者  xxx.style['color']  = 'red'  
> ```
>
> 我封装的修饰style 的写法：
>
> ```js
> dom.style(xxx,'color','red')		// 使用字符串的形式 来修改样式
> dom.style(xxx,{color:'red'})        // 使用对象的形式   来修改样式
> 
> dom.style(xxx,'color')    // 查看样式的内容
> ```



> 思路: 我们可以引用原生的第二种写法 ，遍历属性值key‘，用xxx.style[key]实现  ， 此时的color 是一个变量需要从我们传入的对象中获取。 为什么不用  style.color='red' 的原因是因为 对象的属性值是字符串。



**源代码**

```js
  style(node, name, value) {
    if (arguments.length === 3) {
        // dom.style(xxx,'color','red')
      node.style[name] = value
    } else if (arguments.length === 2) {
      if (typeof name === 'string') {
        // dom.style(xxx,'color')
        return node.style[name]
      } else if (name instanceof Object) {
        // dom.style(xxx,{color:'red'})
        const object = name
        for (let key in object) {
          // 不能用 style.key 是因为 key是变量
          node.style[key] = object[key]
        }
      }
    }
  }
```



**示例**

**使用对象的形式来修改样式：**
![示例1](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/f2c571b3928e40159429a2bec14f2db4~tplv-k3u1fbpfcp-watermark.image)

**使字符串的形式来修改样式**

<img src="https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/0e2cc02b488642babab86bccdf505df1~tplv-k3u1fbpfcp-watermark.image" alt="示例2"  />







###  dom.class 函数

> 用法：
>
> ```js
> dom.class.add(test, 'red')   // 添加类名
> dom.class.remove(test, 'red')   //  删除类名
> console.log(dom.class.has(test, 'red'));   // 查看类名
> ```



> 思路：首先在class 对象中 创建三个不同功能的方法。 然后封装一下原生的DOM即可。



**源代码**

```js
  class: {
    add(node, className) {
      node.classList.add(className)
    },
    remove(node, className) {
      node.classList.remove(className)
    },
    has(node, className) {
      return node.classList.contains(className)
    }
  }
```



**示例**

![示例1](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/270cf57e749d4750bc25cee4c5e3e17f~tplv-k3u1fbpfcp-watermark.image)





### dom.on 函数 和  dom.off 函数

> 用法：
>
> ```js
> dom.on(test, 'click', fn)  // fn是函数，  添加了点击事件
> dom.off(test,'click',fn) // 移除点击事件
> ```



> 思路： 封装一下原生的DOM的addEventListener即可。



**源代码**

```js
 on(node, eventName, fn) {
    node.addEventListener(eventName,fn)
  },
  off(node, eventName, fn) { 
    node.removeEventListener(eventName,fn)
  }
```



**示例**

![示例1](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/7ab7686a5a6a4ca6877f2aca3fc353de~tplv-k3u1fbpfcp-watermark.image)







## 查  （获取元素）

- ```js
  dom.find('选择器')  // 用于获取标签或标签们
  ```

- ```js
  dom.parent(node)  // 用于获取父元素
  ```

- ```js
  dom.children(node)  // 用于获取子元素
  ```

- ```js
  dom.siblings(node)  //用于获取兄弟姐妹元素
  ```

- ```js
  dom.next(node)  // 用于获取弟弟
  ```

- ```js
  dom.previous(node)  // 用于获取哥哥
  ```

- ```js
  dom.each(nodes,fn)  // 用于遍历所有节点
  ```

- ```js
  dom.index(node)  // 用于获取索引值为x 的元素
  ```





### dom.find 函数

> 用法 和  document.querySelectorAll()  一致



**源代码**

```js
 find(selector,scope) {
    return (scope || document).querySelectorAll(selector)
  }
```



**示例：**

![dom.find()示例](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/cfe498f0772a40a88159dc2fbdda663d~tplv-k3u1fbpfcp-watermark.image)

![dom.find()示例2](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/5a7e2cd3859b43bdadb32899d209fd54~tplv-k3u1fbpfcp-watermark.image)



### dom.parent  函数 和 dom.children 函数

> 用法: 
>
> ```js
> dom.parent(node)  // 用于获取父元素
> dom.children(node)  // 用于获取子元素
> ```



**源代码**

```js
 parent(node) {
    return node.parentNode
  },
      
  children(node) {
    return node.children
   }
```



### dom.siblings 函数

> 用法：
>
> ```js
> dom.siblings(node)  //用于获取兄弟姐妹元素 (除了自己)
> ```



> 思路：  用 node.parentNode.children 获取所有子元素， 因为获取的伪数组， 转换为数组后过滤掉自己。



**源代码**

```js
  siblings(node) {
    return Array.from(node.parentNode.children)
      .filter(n => n !== node)
  },
```



**dom.parent  、dom.children  、 dom.siblings  示例**

![dom.parent  、dom.children  、 dom.siblings  示例](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/1928c301d97e404ba905ef2ac1e54807~tplv-k3u1fbpfcp-watermark.image)







### dom.next 函数  和 dom.previous 函数

> 用法：
>
> ```js
> dom.next(node)  // 用于获取下一个节点       （弟弟）节点
> dom.previous(node)   // 用于获取上一个节点      （哥哥）节点
> ```



> 思路： 我们使用 node.nextSibing 时 可以会返回 文本节点， 这时我们需要排除文本节点即可  (nodeType 为1是元素节点、为3 是文本节点)       、    dom.previous的思路也是一样的



**源代码**

```js
 next(node) {
    let x = node.nextSibling
    while (x && x.nodeType === 3) { //  1是元素节点， 3是文本节点
      x = x.nextSibling
    }
    return x
  },
  previous(node) {
    let x = node.previousSibling
    while (x && x.nodeType === 3) { //  1是元素节点， 3是文本节点
      x = x.previousSibling
    }
    return x
  }
```





**示例**

![dom.next示例](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/ff9f33b4913f4ddaa9aeabd6fb12736e~tplv-k3u1fbpfcp-watermark.image)

![dom.previous示例](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/c8b6507260124bbe84d8b542eaa30ef9~tplv-k3u1fbpfcp-watermark.image)





### dom.each 函数

> 用法： 遍历每个元素，使他做对应的事
>
> ```js
> dom.each(nodes,fn)  // 用于遍历所有节点
> ```



**源代码**

```js
  each(nodeList, fn) {
    for (let i = 0; i < nodeList.length; i++) {
      fn.call(null, nodeList[i])
    }
  }
```



**示例：**

![dom.each](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/308ff6e8cb4c4594a33b6dc8919ed0ac~tplv-k3u1fbpfcp-watermark.image)



### dom.index 函数

> 用法： 返当前节点在父节点内的索引值
>
> ```js
> dom.index(node)  // 返回当前节点在它父节点中的索引值
> ```



> 思路： 获取自己的父节点的所有子节点, 然后遍历， 如果遍历的子节点是自己，就返回 i



**源代码**

```js
  index(node) {
    const list = dom.children(node.parentNode)
    for (let i = 0; i < list.length; i++) {
      if (list[i] === node) {
        return i
      }
    }
  }
```



**示例：**

![dom.index ](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/550cdf330dc04fd8bdcd1b0e6edfd958~tplv-k3u1fbpfcp-watermark.image)



