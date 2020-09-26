---
title: Vue-Cli脚手架
date: 2020-09-26 15:11:02
index_img: /img/vue-cli.jpg
tags: vue
categories: vue
---
#  Vue-CLI  脚手架⭐

> [Vue CLI](https://cli.vuejs.org/zh/) 是 Vue 的脚手架工具，它可以帮助我们快速生成 Vue 基础项目代码，提供开箱即用的功能特性。

- 为什么需要使用 Vue-CLI
  - 使用Vue.js开发大型应用时，我们需要考虑代码目录结构、项目结构和部署、热加载、代码单元测试等事情。
  - 如果每个项目都要手动完成这些工作，那无以效率比较低效，所以通常我们会使用一些脚手架工具来帮助完成这些事情。



## 1 Vue-CLI 的使用

- 安装Vue脚手架

  - ```shell
    npm install -g @vue/cli@版本号
    ```

    

- Vue CLI2初始化项目

  - ```shell
    vue init webpack my-project
    ```

- Vue CLI3初始化项目

  - ```shell
    vue create my-project
    ```



## 2 Vue-CLI2 详解

### 2.1 步骤详解



![image-20200923112538728](https://i.loli.net/2020/09/25/gXfdbyo7erTmz19.png)





### 2.2 目录详解



![image-20200923112626821](https://i.loli.net/2020/09/25/9eP2bklLcqVTywp.png)





## 3 Runtime-Compiler和Runtime-only的区别 ⭐



- **1、Runtime-Compiler和Runtime-only的main.js文件的区别：**

```javascript
//（1） Runtime-Compiler
new Vue({
  el: '#app',
  router,
  components: { App },
  template: '<App/>'
})
 
// （2）Runtime-only
new Vue({
  el: '#app',
  router,
  render: h => h(App)
})
 
// Runtime-Complier 解析过程：
第一步：将template模板转换成抽象语法树（ast）;
第二步：通过render函数将抽象语法树转换成虚拟DOM（vdom）;
第三步：将虚拟DOM转换成真正的DOM；
template => 抽象语法树(ast) => render() => 虚拟DOM(vdom) => 页面
 
// Runtime-only 解析过程：
第一步：vue-template-compiler插件直接将组件转换成 render函数；
第二步：将render函数返回的虚拟DOM转换成页面；
render() => 虚拟DOM(vdom) => 页面；
```



- **2.render()函数**

```javascript
var render = function() {
  var _vm = this
  var _h = _vm.$createElement
  var _c = _vm._self._c || _h
  return _c(
    "div",
    { attrs: { id: "app" } },
    [
      _c("img", { attrs: { src: require("./assets/logo.png") } }),
      _vm._v(" "),
      _c("router-view")
    ],
    1
  )
}
// render函数返回的是虚拟DOM
```



- 3. 俩者的区别对比

```txt
（1）Runtime-only性能更高；
（2）Runtime-only代码量更少；
```



## 4 Vue-CLI3 详解

 **CLI2 和 CLI3 的区别**

- vue-cli 3 与 2 版本有很大区别
  - vue-cli 3 是基于 webpack 4 打造，vue-cli 2 还是 webapck 3
  - vue-cli 3 的设计原则是“**0配置”，移除的配置文件根目录下的，build和config等目录**
  - vue-cli 3 提供了 vue ui 命令，提供了可视化配置，更加人性化
  - **移除了static文件夹，新增了public文件夹，并且index.html移动到public中**



### 4.1  安装步骤详解

![image-20200923113522511](https://i.loli.net/2020/09/25/sXYTBZDdym5GiF4.png)

### 4.2 目录结构详解

![image-20200923113601396](https://i.loli.net/2020/09/25/F6ybPXaMpt8vSIh.png)



