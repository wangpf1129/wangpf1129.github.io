---
title: JavaScript中的MVC
index_img: /img/mvc.png
date: 2020-12-17 12:48:28
tags: [JavaScript,MVC]
categories: [设计模式]
---
## MVC三类对象
MVC模式（Model-view-controller） 是一种设计模式（软件架构）。

MVC包括三类对象，将它们分离以提高灵活性和复用性。
- **模型（Model）** ： 同于数据管理， 一旦模型的数据发生改变，Model将通知有关的视图。
- **视图(View)** ： 负责用户界面，HTML渲染。 描绘的是Model的当前状态，当模型的数据发生改变，View就会刷新自己。
- **控制（Controller）** : 控制器， Controll 控制其他所有流程。 负责监听并处理视图(View)的事件。更新和调用Model。也负责监听Model的变化，并更新View。


## MVC for JAVASCRIPT

```js
//数据Model
const model = {
  // 数据
  data: {},
  // 对数据处理的一些方法
  create() {},
  delete() {},
  update() {},
  get() {}
}

//视图View
const view = {
  //1、一个空容器，以后就是装html的容器
  el: null,
  //2、要添加的html
  html: `<div>123</div>....`,
  //3、初始化容器函数，参数是我们给的要当容器的元素（应该是index.html里就有的元素）
  init(container) {v.el = $(container);},
  //4、渲染函数，参数将是数据。也就是视图全都是对数据渲染 view = render(data)
  render(x) {}
}

// 控制Controller  
// 处理数据的事件，并把结果渲染到视图View上
const c = {
  //1.总初始化函数。
  init(container) {},	
  // 事件
  events: {},
  //事件要执行的函数
  add() {},
  minus() {},
  mul() {},
  div() {},
}
```

## EventBus

**EventBus的实现方法：**
- 比如用vue， new一个新的vue，它是一个实例对象。
- 但是最重要的在于它原型上有我们用到的$on(监听)、$off（解绑）、$emit（触发）等API 。

**EventBus作用:**
- EventBus 主要用于对象间的通信，
- 使用 EventBus 可以满足最小知识原则，model和view互相不知道对方的细节，但是却可用调用对方的功能。

## 表驱动编程
当我们需要判断 3 种以上的情况，做出相应的事情，往往需要写很多很多的 if else，这样的代码可读性不强。

为了增强代码的可读性，我们可以用表驱动编程，把用来做 if 条件判断的值存进一个哈希表，然后从表里取值。


而这种做法的意义就在于： **逻辑和数据是分离的**


举个例子，比如国家简写转换，给一个国家全名，转换成国家简写，用if else语法来写:
```js
//  伪代码
function contry(国家名){
	if(中国){
    	return "CHN"
    }else if(日本){
    	return "JPN"
    }else if(美国){
    	return "USA"
    }else{
    	return "OTHER"
    }
}
```
用 if else语句这样做，如果我再增加一个国家，那么就要写一个if else语句。等于又增加了一条逻辑。

那么我们为何不用 表数据编程 把 数据和逻辑分离开实现呢。

毕竟，**数据**的添加是**简单，低成本和低风险**的。 而**逻辑**的添加是**负责，高成本和高风险**的。

表驱动编程做法：
```js
伪代码
function contry(国家名){
	const 国家列表 = [
    	"中国"  = "CHN"
    	"日本"  = "JPN"
    	"美国"  = "USA"
    ]
   国家简写转换：funciton(){
   	for(let 国家名 in 国家列表){
    	return 国家列表[国家名]  // 返回的就是 国家简写
    }
   }
}
```

你瞧这样做，如果你再添加一个国家名（数据），那么我们只需国家列表(数组)中添加一项即可。逻辑方面的我们一点都不需要更改，更别说去考虑逻辑了。

**这样，我们就脱离了数据与逻辑的关系了。**

参考文章:[用表驱动编程重构if-else的意义](https://www.zhihu.com/question/37943171/answer/119525120)



## 自我理解的模块化
将一个复杂的程序依据一定的规则（规范）封装成几个块（文件）并进行组合。

模块的内部数据的实现是私有的，只是向外部暴露一些接口（方法）与外部其他模块通信。这则就是模块化。

**模块化的好处：**
- 降低代码耦合度
- 减少重复代码
- 提高代码重用性
- 在项目结构上更加清晰，便于维护。