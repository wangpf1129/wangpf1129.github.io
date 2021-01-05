---
title: vue俩个版本：runtime-compiler和 runtime-only 的区别
index_img: /img/vuejs.jpg
date: 2020-12-20 15:48:28
tags: [vue]
categories: [vue]
---
> 参考vue文档链接： https://cn.vuejs.org/v2/guide/installation.html#%E5%BC%80%E5%8F%91%E7%89%88%E6%9C%AC
## runtime-Compiler 和 runtime-only在main.js文件的区别
```js
//（1） Runtime-Compiler
new Vue({
  el: '#app',
  components: { App },
  template: '<App/>'
})
 
// （2）Runtime-only
new Vue({
  el: '#app',
  render: h => h(App)
})
```

在上述代码块中可以看出最大的区别在于 ：

**runtime-Compiler 中的参数是 components 和  template** 。而**runtime-only版本中的参数是 render 函数**。

## runtime-only 版本 不能有 template
在这个vue不完整版，需要借助webpack的 **vue-loader**加载器 **把vue文件编译成js**。

webpack使用vue-loader将vuew文件编译js的过程中会**将组件的template模板编译位render函数**，所以我们得到的是render函数就如上图所示。

所以，该版本只会包含运行时的vue代码，对于template这种需要编译，只交给webpack即可。

这会使得该版本代码的体积小。

## runtime-complier版本 可以有template
如果写了template，那么就会在运行时直接编译成render函数， 而不是依靠webpack来帮助编译，这不仅仅使得该版本体积变大，而且在编译过程也会对性能有一定的损耗。


## runtime-complier 解析过程：
- 第一步：将template模板转换成抽象语法树（ast）;
- 第二步：通过render函数将抽象语法树转换成虚拟DOM（vdom）;
- 第三步：将虚拟DOM转换成真正的DOM；
**template => 抽象语法树(ast) => render() => 虚拟DOM(vdom) => 页面**
 
 ## runtime-only 解析过程：
- 第一步：vue-template-compiler插件直接将组件转换成 render函数；
- 第二步：将render函数返回的虚拟DOM转换成页面；
**render() => 虚拟DOM(vdom) => 页面；** 

## 总结



|	   | vue完整版（runtime-compiler） |vue非完整版（runtime-only） | 评价 |
|------|------------|------------| --- |
| 特点 	 |  有compiler       			 | 没有compiler   	   |  compiler 占40%体积
| 视图  	 | 写在HTML里或者写在template选项  | 写在render函数里用h来创建标签  |
| cdn引入  | vue.js       | vue.runtime.js   | 文件名不同
| webpack引入  | 需要额外配置alias  | 默认使用此版本 | 
| @vue/cli 引入  | 需要额外配置  | 默认使用此版本 | 


因此推荐使用 vue非完整版（**runtime-only**）。

**优点:**
- 保证用户体验，用户下载的JS文件体积更小，但支持h函数（render函数中的h）。
- 保证开发体验，开发者可以直接在vue文件里写html标签，而不写h函数
- 累活都让loader做，vue-loader把vue文件里的html转为h函数。