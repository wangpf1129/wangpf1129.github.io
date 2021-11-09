---
title: 捉摸不清的“this”
index_img: /img/JavaScript高级.png
date: 2021-11-09 17:38:00
tags: [JavaScript高级]
categories: [JavaScript高级]
---

## “独特”的 this

### 为什么需要 this？

在常见的编程语言中，几乎都有 this 这个关键字（Objective-C 中使用的是 self），但是 JavaScript 中的 this 和常见的面向对象语 言中的 this 不太一样

- 常见面向对象的编程语言中，比如 Java、C++、Swift、Dart 等等一系列语言中，this 通常只会出现在类的方法中
- 也就是你需要有一个类，类中的方法（特别是实例方法）中，this 代表的是当前调用对象
- 但是 JavaScript 中的 this 更加灵活，无论是它出现的位置还是它代表的含义

### this 到底指向什么？

> 我们都知道，如果在浏览器环境下，this 在全局指向的是 window 如果在 node 环境下，this 在全局指向的是 { } （空对象）

定义一个函数，我采用三种不同的方式在浏览器上对它调用，它将会产生了三种不同的结果：

```js
function foo() {
  console.log(this)
}

foo() // 指向 window

var obj = {
  name: 'wpf',
  foo: foo,
}

obj.foo() // 指向 obj

foo.apply('abc') // 指向 'abc'
```

结果如图：

![this.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/0b6f736fe10f4b2db1440388057491b2~tplv-k3u1fbpfcp-watermark.image?)

第一个就是 window 调用了 foo 函数 foo() 可转换为 **window.foo()** , 所以 this 指向 window

第二个是 obj 调用了 foo 函数， **obj.foo()** 所以 this 指向 obj

第三个是 用 apply 将 this 指向了 'abc'， 这个就很明确了， 是显式绑定 ，明显 this 指向的就是 'abc'

根据上述分析，由此可以得出结论：

1.  this 的指向，跟函数所处的位置是没有关系的
2.  跟函数的调用方式有关系

**即： 当为隐式绑定时，谁调用了 foo 这个函数，那么 this 就指向谁。（排除箭头函数）**

又比如这个较为刁钻的题：

```js
var obj = {
  name: 'wpf',
  foo: function () {
    console.log(this)
  },
}
var bar = obj.foo
bar()
```

请问 bar 调用后， this 指向哪里呢？

**首先要记住 谁调用了该函数，那么该函数内的 this 就指向谁（排除箭头函数）**

那么 bar 是谁调用的呢？ 当然是 **window** 呀， 因为 bar 是在全局定义的嘛。

### 细说 this 绑定规则

#### 默认绑定

什么情况下使用默认绑定呢？独立函数调用。

独立的函数调用我们可以理解成函数没有被绑定到某个对象上进行调用

我们通过几个案例来看一下，常见的默认绑定

```js
// 案例一
function foo() {
  console.log(this)
}

foo()
```

```js
// 案例二
function foo() {
  console.log(this)
}

function bar() {
  foo()
}
function baz() {
  bar()
}

baz()
```

```js
// 案例三
function foo(Fn) {
  Fn()
}

var obj = {
  name: 'tao',
  bar: function () {
    console.log(this)
  },
}
foo(obj.bar)
```

```js
// 案例四
function foo() {
  return function () {
    console.log(this)
  }
}
var fn = foo()
fn()
```

这上面所有的案例 this 的打印结果都是 window，

也可根据 函数的调用方式来判断， 由于都是定义在全局的方法，即 window.xxx() ， 所以可以理解为 window 调用的，即 this 都指向了 window

#### 隐式绑定

另外一种比较常见的调用方式是通过某个对象进行调用的

也就是它的调用位置中，是通过某个对象发起的函数调用

obj 对象会被 js 引擎绑定到 fn 函数中的 this 里面

我们通过几个案例来看一下，常见的隐式绑定

```js
// 案例一
function foo() {
  console.log(this)
}

var obj = {
  name: 'tao',
  foo: foo,
}

obj.foo() // obj
```

```js
// 案例二
function foo() {
  console.log(this)
}

var bar = {
  name: 'bar',
  foo: foo,
}

var bar = bar.foo
bar() // window
```

案例一： 因为是 obj 调用的 ，所以 this 指向 obj

案例二：因为 bar 是定义在全局的， 所以 bar() 相当于 window.bar() ，所以 this 指向 window

#### 显式绑定

显式绑定其实就是用到了 JavaScript 函数原型链上的 call 、 apply 、 bind 方法

这三个方法的具体用法就不细说了，可以去看 mdn

```js
function foo(num1, num2) {
  console.log(num1 + num2, this)
}

foo.apply('aaa') // 指向 'aaa'
foo.call('aaa') // 指向 'aaa'
var fn = foo.bind('aaa')
fn() // 指向 'aaa'
```

### 规则优先级

学习了以上四条规则，接下来开发中我们只需要去查找函数的调用应用了哪条规则即可，但是如果一个函数调用位置应用了多条规则，优先级谁更高呢？

默认规则的优先级最低（毫无疑问，默认规则的优先级是最低的，因为存在其他规则时，就会通过其他规则的方式来绑定 this）

**显式绑定优先级高于隐式绑定**

```js
function foo() {
  console.log(this)
}

var obj = {
  name: 'wpf',
  foo: foo.bind('aaa'),
}

obj.foo() // 指向 "aaa"
```

**new 绑定优先级高于隐式绑定**

```js
function foo() {
  console.log(this)
}

var obj = {
  name: 'wpf',
  foo: foo,
}

var o = new obj.foo() //  指向 foo
```

**new 绑定优先级高于 bind**

- new 绑定和 call、apply 是不允许同时使用的，所以不存在谁的优先级更高
- new 绑定可以和 bind 一起使用，new 绑定优先级更高

```js
function foo() {
  console.log(this)
}

var bar = foo.bind('aaa')
var baz = new bar()

baz() // 指向 foo
```

**总结**

new 绑定 > 显式绑定(bind/call/apply) > 隐式绑定 > 默认绑定

### 关于 this 和箭头函数

箭头函数是不绑定 this 的， 而是根据外层作用域来决定 this，这里就不细说了。

### 经典面试题

**Q1:**

```js
// 案例一
var name = 'window'
var person = {
  name: 'person',
  sayName: function () {
    console.log(this.name)
  },
}
function sayName() {
  var sss = person.sayName
  sss()
  person.sayName()
  person.sayName()
  ;(b = person.sayName)()
}
sayName()
```

**A1:**

window 、 person 、 persopn 、 window

**Q2:**

```JS
var name = 'window'
var person1 = {
  name: 'person1',
  foo1: function () {
    console.log(this.name)
  },
  foo2: () => console.log(this.name),
  foo3: function () {
    return function () {
      console.log(this.name)
    }
  },
  foo4: function () {
    return () => {
      console.log(this.name)
    }
  }
}

var person2 = { name: 'person2' }

person1.foo1();
person1.foo1.call(person2);

person1.foo2();
person1.foo2.call(person2);

person1.foo3()();
person1.foo3.call(person2)();
person1.foo3().call(person2);

person1.foo4()();
person1.foo4.call(person2)();
person1.foo4().call(person2);
```

**A2:**

```js
person1.foo1() // person1  隐式绑定
person1.foo1.call(person2) //  person2 显式绑定

person1.foo2() //  window  foo2 是个箭头函数,this指向上层作用域即全局
person1.foo2.call(person2) // window   箭头函数不适用于显式绑定

person1.foo3()() // window   调用位置在全局作用域下，
person1.foo3.call(person2)() // window  返回的函数依然是在全局下调用的
person1.foo3().call(person2) //  person2   显式绑定

person1.foo4()() //person1  箭头函数， this指向上层作用域即 person1对象
person1.foo4.call(person2)() // person2 显式绑定后，返回的箭头函数指向上层作用域即 person2对象
person1.foo4().call(person2) // person1  箭头函数只看上层作用域即 person1对象
```

**Q3:**

```js
var name = 'window'
function Person(name) {
  this.name = name
  ;(this.foo1 = function () {
    console.log(this.name)
  }),
    (this.foo2 = () => console.log(this.name)),
    (this.foo3 = function () {
      return function () {
        console.log(this.name)
      }
    }),
    (this.foo4 = function () {
      return () => {
        console.log(this.name)
      }
    })
}
var person1 = new Person('person1')
var person2 = new Person('person2')

person1.foo1()
person1.foo1.call(person2)

person1.foo2()
person1.foo2.call(person2)

person1.foo3()()
person1.foo3.call(person2)()
person1.foo3().call(person2)

person1.foo4()()
person1.foo4.call(person2)()
person1.foo4().call(person2)
```

**A2:**

```JS
person1.foo1() // peron1  隐式绑定
person1.foo1.call(person2) // person2  显式绑定

person1.foo2() // person1  箭头函数找上一层
person1.foo2.call(person2) // person1 箭头函数找上一层

person1.foo3()() // window 调用位置是全局直接调用
person1.foo3.call(person2)() // window  调用位置是全局直接调用
person1.foo3().call(person2) // person2   显式绑定

person1.foo4()() // person1 箭头函数找上一层
person1.foo4.call(person2)() // person2  调用时，找到了上层绑定的person2
person1.foo4().call(person2) // person1 箭头函数找上一层
```

**Q3:**

```JS
var name = 'window'
function Person(name) {
  this.name = name
  this.obj = {
    name: 'obj',
    foo1: function () {
      return function () {
        console.log(this.name)
      }
    },
    foo2: function () {
      return () => {
        console.log(this.name)
      }
    },
  }
}
var person1 = new Person('person1')
var person2 = new Person('person2')

person1.obj.foo1()() //  window
person1.obj.foo1.call(person2)() // window
person1.obj.foo1().call(person2) // person2

person1.obj.foo2()() // obj
person1.obj.foo2.call(person2)() // person2
person1.obj.foo2().call(person2) // obj
```
