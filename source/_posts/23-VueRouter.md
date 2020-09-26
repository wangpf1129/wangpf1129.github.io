---
title: VueRouter--前端路由
date: 2020-09-26 15:13:54
index_img: /img/vue-router.jpg
tags: vue
categories: vue
---
#  Vue-router  前端路由⭐

> 前端路由核心： 改变URL，但是页面不进行整体的刷新。

## 1 单页面导航路径  

> URL.hash 和 HTML5 history



### URL.hash

> URL的hash也就是锚点(#), 本质上是改变window.location的href属性.
> 我们可以通过直接赋值location.hash来改变href, 但是页面不发生刷新

- **路径**  （使用 url.hash）
  - 一般使用描点来表示路径，也就是 hash 作为页面导航的路径标识
  - 为什么？ 因为**正常的url地址会发请求，而hash描点不会发送请求刷新页面**

- **VueRouter 内部监视了 hash的改变  -------  window.onhashchange**

- 然后根据 hash 的改变去展示路由规则中的配置组件

- VueRouter 默认要求 hash 导航路径都以 #/开头
  - 为什么？
  - 主要是为了和正常的hash锚点（网页内部定位、id）做区别
  - 例如我们使用锚点内部定位的时候，需要给元素起id，我们几乎不会给id起名为 /xxx
  - 如果 VueRouter 没有 #/ 的规则 ，例如直接 #foo 就可能会你锚点的那个 id foo 冲突



**因为有 url.hash 这样的设置使得 url 不美观， 那么我们可以使用HTML5新增属性 history 的方法**

- VueRouter  默认是 hash 路径模式
- 它页支持传统的 url 模式（HTML history）



### history 

- 优点  --- 优雅、同构应用友好
- hash模式
  - 兼容性更好，不需要后端处理任何配置
  - file  协议或是http协议都可以运行
  - 比较丑，不能用于服务端渲染同构开发
- history 模式
  - 相比 hash 浏览器 兼容不太好，需要后端特殊配置
  - 必须运行在 http|https 服务中
  - url 简洁美观，如果需要做服务端渲染同构开发，则必须使用 history模式
  - 注意： 使用了history模式之后，不要在模板中直接使用普通的 a 链接去跳转，一定要使用 router-link 或者  router.push 进行导航



**history 有五种模式改变URL而不刷新页面.**

- **history.pushState()**
- **history.replaceState()**       和 pushState 的区别是 不能返回
- **history.go()**   
- **history.back() **         等价于 history.go(-1)
- **history.forward()**    则等价于 history.go(1)





## 2 vue-router 安装和使用

- vue-router是基于路由和组件的
  - 路由用于设定访问路径, 将路径和组件映射起来.
  - 在vue-router的单页面应用中, 页面的路径的改变就是组件的切换.



- 步骤一: 安装vue-router

  - ```shell
    npm install vue-router --save
    ```

- 步骤二: 在模块化工程中使用它(因为是一个插件, 所以可以通过Vue.use()来安装路由功能)

  - 第一步：导入路由对象，并且调用 Vue.use(VueRouter)

    - ```javascript
      import Vue from 'vue' 
      import VueRouter from 'vue-router' 
      // 1. 调用插件
      Vue.use(VueRouter)
      ```

  - 第二步：创建路由实例，并且传入路由映射配置

  - 第三步：在Vue实例中挂载创建的路由实例



- 使用vue-router的步骤:
  - 第一步: 创建路由组件
  - 第二步: 配置路由映射: 组件和路径映射关系
  - 第三步: 使用路由: 通过<router-link>和<router-view>



### 2.1 创建Vue实例

![1](https://i.loli.net/2020/09/25/Rl9VBz1wrFqoIbg.png)

### 2.2 挂载到Vue实例中

![挂载到Vue实例中](https://img-blog.csdnimg.cn/2020092614545839.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3Bmenp6eno=,size_16,color_FFFFFF,t_70#pic_center)

### 2.3 步骤一：创建路由组件

![3](https://i.loli.net/2020/09/25/rTXEdiZAHeUvQ3P.png)

### 2.4 步骤二：配置组件和路径的映射关系

![配置组件和路径的映射关系](https://img-blog.csdnimg.cn/20200926145610781.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3Bmenp6eno=,size_16,color_FFFFFF,t_70#pic_center)

### 2.5 步骤三：使用路由.

![5](https://i.loli.net/2020/09/25/W9mfNcFsjC3Jy7e.png)

### 最终效果如下

![最终效果](https://img-blog.csdnimg.cn/20200926145610812.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3Bmenp6eno=,size_16,color_FFFFFF,t_70#pic_center)



### 2.6 路由的默认路径

- 我们这里还有一个不太好的实现:
  - 默认情况下, 进入网站的首页, 我们希望<router-view>渲染首页的内容.
  - 但是我们的实现中, 默认没有显示首页组件, 必须让用户点击才可以.

```javascript
const routes = [
  {
    path: '',
    redirect: '/home'
  },
  ]
```



- 配置解析:
  - 我们在routes中又配置了一个映射. 
  - path配置的是根路径: /
  - redirect是重定向, 也就是我们将根路径重定向到/home的路径下, 这样就可以得到我们想要的结果了.

### 2.7 使用 HTML5 history 模式

- 我们前面说过改变路径的方式有两种:
  - URL的hash
  - HTML5的history
  - 默认情况下, 路径的改变使用的URL的hash.

```javascript
//  2. 创建 Router 实例对象 并 导出它
const router = new Router({
  // 3.  routes 属性： 配置路由和组件之间的映射关系
  routes,
  mode: 'history' // 默认是 hash 模式， 
})
```



### 2.8 router-link 的补充

- **tag**: tag可以指定<router-link>之后渲染成什么组件, 比如上面的代码会被渲染成一个<li>元素, 而不是<a>
- **replace:** replace不会留下history记录, 所以指定replace的情况下, 后退键返回不能返回到上一个页面中
- **active-class**: 当<router-link>对应的路由匹配成功时, 会自动给当前元素设置一个router-link-active的class, 设置active-class可以修改默认的名称.

```html
<template>
  <div id="app">
    <!-- tag: tag可以指定<router-link>之后渲染成什么组件, 比如上面的代码会被渲染成一个<li>元素, 而不是<a> -->
    <!-- replace : replace不会留下history记录, 所以指定replace的情况下, 后退键返回不能返回到上一个页面中 -->
    <router-link to="/home" replace tag="button">首页</router-link>
    <router-link to="/login" replace tag="button">登录</router-link>
    <router-link :to="'/user/'+id" tag="button">用户</router-link>
    <router-link :to="{path:'/profile',query:{name:'wpf',age:'23',sex:'男'}}" tag="button">档案</router-link>

    <!-- <button @click="homeClick">首页</button>
    <button @click="loginClick">登录</button>-->

    <!-- inlcude（包含） -- 只有匹配的组件才会被缓存
    exclude（排除） -- 除了这些组件都会被缓存-->
    <keep-alive exclude="User,Profile">
      <router-view></router-view>
    </keep-alive>
  </div>
</template>

<script>
export default {
  name: "App",
  data() {
    return {
      id: "wpfzzz",
    };
  },
};
</script>

<style  scoped>
.router-link-active {
  color: #f00;
}
</style>


```



### 2.9 路由代码跳转

```html
    <button @click="homeClick">首页</button>
    <button @click="loginClick">登录</button>
```

```javascript
  methods: {
    homeClick() {
      // this.$router.push("/htmo");
      this.$router.replace("/htmo").catch((err) => err);;
      console.log("home");
    },
    loginClick() {
      // this.$router.push("/login");
      this.$router.replace("/login").catch((err) => err);;
      console.log("login");
    },
  },
```



### 2.10  动态路由  

- 在某些情况下，一个页面的path路径可能是不确定的，比如我们进入用户界面时，希望是如下的路径：
  - /user/aaaa或/user/bbbb
  - 除了有前面的/user之外，后面还跟上了用户的ID
  - 这种path和Component的匹配关系，我们称之为动态路由(也是路由传递数据的一种方式)。

```html
<router-link :to="'/user/'+id" tag="button">用户</router-link>
<router-link :to="{path:'/profile',query:{name:'wpf',age:'23',sex:'男'}}" tag="button">档案</router-link>
 // 注意： 要使用 v-bind 动态绑定 这样可以获取data中的数据， 否则是个字符串
```

```json
  {
    path: '/user/:userId',   // 这个 
    component: User,
    meta: {
      title: '用户'
    }
  },
```

```html
<p>{{$route.params.userId}}</p>
```

```html
<p>{{$route.query.name}}</p>
<p>{{$route.query.age}}</p>
<p>{{$route.query.sex}}</p>
```





## 3 路由懒加载

- 为什么要使用懒加载
  - 首先, 我们知道路由中通常会定义很多不同的页面.
  - 这个页面最后被打包在哪里呢? 一般情况下, 是放在一个js文件中.
  - 但是, 页面这么多放在一个js文件中, 必然会造成这个页面非常的大.
  - 如果我们一次性从服务器请求下来这个页面, 可能需要花费一定的时间, 甚至用户的电脑上还出现了短暂空白的情况.
  - 如何避免这种情况呢? 使用路由懒加载就可以了.



- 路由懒加载可以做什么？
  - **路由懒加载的主要作用就是将路由对应的组件打包成一个个的js代码块.**
  - **只有在这个路由被访问到的时候, 才加载对应的组件**





**路由懒加载后的效果**

![路由懒加载后的效果](https://img-blog.csdnimg.cn/20200926145610878.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3Bmenp6eno=,size_16,color_FFFFFF,t_70#pic_center)





### 3.1 懒加载的方式

- **方式一: 结合Vue的异步组件和Webpack的代码分析.**

  - ```javascript
    const Home = resolve => { require.ensure(['../components/Home.vue'], () => { resolve(require('../components/Home.vue')) })};
    ```

- **方式二: AMD写法**

  - ```javascript
    const About = resolve => require(['../components/About.vue'], resolve);
    ```

- **方式三: 在ES6中, 我们可以有更加简单的写法来组织Vue异步组件和Webpack的代码分割.**

  - ```javascript
    const Home = () => import('../components/Home.vue')
    ```





```javascript
// import Home from '../components/Home.vue'
// import Login from '../components/Login.vue'
// import User from '../components/User.vue';

// 使用路由懒加载
const Home = () => import('../components/Home.vue')
const HomeNews = () => import('../components/HomeNews.vue')
const HomeMessage = () => import('../components/HomeMessage.vue')
const Login = () => import('../components/Login.vue')
const User = () => import('../components/User.vue')
const Profile = () => import('../components/Profile.vue')
```





## 4 嵌套路由的使用

- 嵌套路由是一个很常见的功能
  - 比如在home页面中, 我们希望通过/home/news和/home/message访问一些内容.
  - 一个路径映射一个组件, 访问这两个路径也会分别渲染两个组件.
- 实现嵌套路由有两个步骤:
  - 创建对应的子组件, 并且在路由映射中配置对应的子路由.
  - 在组件内部使用<router-view>标签.





## 5  传递参数

### 5.1 传递参数的俩种方式 params 和 query

>  传递参数主要有两种类型: params和query

- params的类型:  **(参考 10.2.10 动态路由)**
  - 配置路由格式: **/router/:id**
  - 传递的方式: **在path后面跟上对应的值**
  - 传递后形成的路径: **/router/123, /router/abc**
- query的类型:
  - 配置路由格式: /router, 也就是普通配置
  - 传递的方式: 对象中使用query的key作为传递方式
  - 传递后形成的路径: /router?id=123, /router?id=abc



### 5.2   query 参数传递方式一：

```html
<router-link :to="{path:'/profile',query:{name:'wpf',age:'23',sex:'男'}}" tag="button">档案</router-link>
 // 注意： 要使用 v-bind 动态绑定 这样可以获取data中的数据， 否则是个字符串
```

```html
 <div>
    <h2>档案页面</h2>
    <p>{{$route.query.name}}</p>
    <p>{{$route.query.age}}</p>
    <p>{{$route.query.sex}}</p>
  </div>
```

### 5.3   query 参数传递方式二：

```html
<button @click="toProfile">登录</button>
```

```javascript
mehtods:{
    toProfile(){
        this.$router.push({
            path:'/proflie',
            query:{name:'wpf',age:23,sex:'男'}
        })
    }
}
```

```html
 <div>
    <h2>档案页面</h2>
    <p>{{$route.query.name}}</p>
    <p>{{$route.query.age}}</p>
    <p>{{$route.query.sex}}</p>
  </div>
```





## 6  router 和 route 的区别

- $route和$router是有区别的
  - $router为VueRouter实例，想要导航到不同URL，则使用$router.push方法
  - $route为当前router跳转对象里面可以获取name、path、query、params等 



### router

**router是VueRouter的一个对象**，通过Vue.use(VueRouter)和VueRouter构造函数得到一个router的实例对象，这个对象中是一个**全局的对象**，他包含了所有的路由包含了许多关键的对象和属性。

举例：history对象

`$router.push({path:'home'}); ` 本质是向history栈中添加一个路由，在我们看来是 切换路由，但本质是在添加一个history记录方法

`$router.replace({path:'home'});`  替换路由，没有历史记录



### route

**route是一个跳转的路由对象**，每一个路由都会有一个route对象，是一个**局部的对象，**可以获取对应的name,path,params,query等

`$route.path `
字符串，等于当前路由对象的路径，会被解析为绝对路径，如 `"/home/news"` 。

`$route.params `
对象，包含路由中的动态片段和全匹配片段的键值对

`$route.query `
对象，包含路由中查询参数的键值对。例如，对于 `/home/news/detail/01?favorite=yes` ，会得到`$route.query.favorite == 'yes'` 。

`$route.router `
路由规则所属的路由器（以及其所属的组件）。

`$route.matched `
数组，包含当前匹配的路径中所包含的所有片段所对应的配置参数对象。

`$route.name `
当前路径的名字，如果没有使用具名路径，则名字为空。

`$route.path, $route.params, $route.name, $route.query` 这几个属性很容易理解，主要用于接收路由传递的参数

 



## 7 导航守卫

> ### 什么是导航守卫？
>
> 笼统的说，导航守卫是控制用户能够进入哪些路由和不能进入哪些路由的控制器，也就是管理路由的
>
> 打比方，在你第一次进入csdn网站，想写博客时，你必须先登录，才能进入博客编写；登陆界面就好比你能进入的路由，而博客是你不能进入的路由，当你登陆后，控制器才会给你权限，才能进入博客路由，这就是**导航守卫**的用途



**全局路由 要在 main.js 文件下创建**

想用**导航守卫**先要有路由

```javascript
//main.js
const router= new VueRouter({
  routes:[
    {path:'/',name:'home',component:Home},
    {path:'/menu',name:'menu',component:Menu},
    {path:'/admin',name:'admin',component:Admin},
    {path:'/about',name:'about',component:About,redirect: {name:'contactLink'},children:[   //二级路由
        {path:'/about/contact',name:'contactLink',component:Contact},
        {path:'/history',name:'historyLink',component:History},
        {path:'/delivery',name:'deliveryLink',component:Delivery},
        {path:'/orderingGuide',name:'orderingGuideLink',component:OrderingGuide,redirect:{name:'phonelink'},children: [  //三级路由
            {path:'/phone',name:'phonelink',component:Phone},
            {path:'/name',name:'namelink',component:Name}
          ]},
      ]},
    {path:'/login',name:'login',component:Login},
    {path:'/register',name:'register',component:Register},
    {path:'*',redirect:'/'}
  ],
  mode:"history"
});
```



利用上面路由对象 router 的方法 beforeEach() 实现导航守卫

```javascript
//main.js
//to:跳转到的路由 from:从哪个路由离开  next:显示函数
router.beforeEach((to,from,next)=>{     
  if(to.path == '/login' || to.path == '/register'){
    next();
  }else{
    alert("请先登录");
    next('/login');
  }
});
```

‘/login’  '/register' 为自己定义的路由地址

to.path 为跳转到的路由地址

next() 为显示当前路由内容

next('/login') 跳转到指定路由并显示指定路由的内容

to 对象可获取的信息（console.log(to) 查看）

![img](https://img-blog.csdn.net/20180823114816241?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM0MDg5NTAz/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)



### 7.1  全局守卫



#### **前置守卫 :**

```javascript
router.beforeEach((to,from,next)=>{})
```

- **回调函数中的参数，**
  - **to：进入到哪个路由去**
  - **from：从哪个路由离开**
  - **next：函数，决定是否展示你要看到的路由页面。**



#### **后置钩子:**

```javascript
router.afterEach((to,from)=>{})
```

- **只有两个参数，**
  - **to：进入到哪个路由去，**
  - **from：从哪个路由离。**



### 7.2 组件守卫

> 在路由组件内直接定义以下路由导航守卫：

```javascript
beforeRouteEnter(to,from,next){
    // 在渲染该组件的对应路由被 confirm 前调用
    // 不能！！！ 获取组件实例中的 `this`
    // 因为当守卫执行前，组件实例还没被创建
},
beforeRouteUpdate(to,from,next){
    // 在当前路由改变，但是该组件被复用时调用
    // 可以访问组件实例 `this`
},
beforeRouteLeave(to,from,next){
    // 导航离开该组件的对应路由时调用
    // 可以访问组件实例 `this`
}
```





### 完整的导航解析流程

1. 导航被触发。
2. 在失活的组件里调用离开守卫。
3. 调用全局的 beforeEach 守卫。
4. 在重用的组件里调用 beforeRouteUpdate 守卫 (2.2+)。
5. 在路由配置里调用 beforeEnter。
6. 解析异步路由组件。
7. 在被激活的组件里调用 beforeRouteEnter。
8. 调用全局的 beforeResolve 守卫 (2.5+)。
9. 导航被确认。
10. 调用全局的 afterEach 钩子。
11. 触发 DOM 更新。
12. 用创建好的实例调用 beforeRouteEnter 守卫中传给 next 的回调函数。





### 7.3 keep-alive

> keep-alive 是 Vue 内置的一个组件，可以使被包含的组件保留状态，或避免重新渲染。



**props（ 属性）**：

- include - 字符串或正则表达式。只有名称匹配的组件会被缓存。
- exclude - 字符串或正则表达式。任何名称匹配的组件都不会被缓存。
- max - 数字。最多可以缓存多少组件实例。



**生命周期函数**

  **1. activated**

      在 keep-alive 组件激活时调用
      该钩子函数在服务器端渲染期间不被调用

  **2. deactivated**

      在 keep-alive 组件停用时调用
      该钩子在服务器端渲染期间不被调用

    被包含在 keep-alive 中创建的组件，会多出两个生命周期的钩子: activated 与 deactivated

    使用 keep-alive 会将数据保留在内存中，如果要在每次进入页面的时候获取最新的数据，需要在 activated 阶段获取数据，承担原来 created 钩子函数中获取数据的任务。

    **注意：** 只有组件被 keep-alive 包裹时，这两个生命周期函数才会被调用，如果作为正常组件使用，是不会被调用的，以及在 2.1.0 版本之后，使用 exclude 排除之后，就算被包裹在 keep-alive 中，这两个钩子函数依然不会被调用！另外，在服务端渲染时，此钩子函数也不会被调用。



**缓存所有页面**

```html
<template>
  <div id="app">
  	<keep-alive>
      <router-view/>
    </keep-alive>
  </div>
</template>

<script>
export default {
  name: 'App'
}
</script>
```



**根据条件缓存页面**

```html
<template>
  <div id="app">
  	// 1. 将缓存 name 为 test 的组件
  	<keep-alive include='test'>
      <router-view/>
    </keep-alive>
	
	// 2. 将缓存 name 为 a 或者 b 的组件，结合动态组件使用
	<keep-alive include='a,b'>
  	  <router-view/>
	</keep-alive>
	
	// 3. 使用正则表达式，需使用 v-bind
	<keep-alive :include='/a|b/'>
  	  <router-view/>
	</keep-alive>	
	
	// 5.动态判断
	<keep-alive :include='includedComponents'>
  	  <router-view/>
	</keep-alive>
	
	// 5. 将不缓存 name 为 test 的组件
	<keep-alive exclude='test'>
  	  <router-view/>
	</keep-alive>
  </div>
</template>

<script>
export default {
  name: 'App'
}
</script>
```


