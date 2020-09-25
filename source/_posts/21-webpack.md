---
title: webpack
date: 2020-09-25 16:13:47
index_img: /img/webpack.jpg
tags: vue
categories: vue
---
# webpack⭐

## 1 什么是webpack？

- 官方解释： At its core, webpack is a static module bundler for modern JavaScript applications.
- 翻译： 从本质上来讲，webpack 是一个现代的JavaScript应用的静态**模块打包**工具

![image-20200922165050262](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20200922165050262.png)







### 1.1 模块

- 前端模块化：
- 目前使用前端模块化的一些方案：AMD、CMD、CommonJS、ES6。
- 在ES6之前，我们要想进行模块化开发，就必须借助于其他的工具，让我们可以进行模块化开发。
- 并且在通过模块化开发完成了项目后，还需要处理模块间的各种依赖，并且将其进行整合打包。
- 而webpack其中一个**核心就是让我们可能进行模块化开发，并且会帮助我们处理模块间的依赖关系**。
- 而且不仅仅是JavaScript文件，我们的CSS、图片、json文件等等在webpack中都可以被当做模块来使用
- 这就是webpack中模块化的概念。





### 1.2 打包

- 就是将webpack中的各种资源模块进行打包合并成一个或多个包(Bundle)。
- 并且在打包的过程中，还可以对资源进行处理，比如压缩图片，将scss转成css，将ES6语法转成ES5语法，将TypeScript转成JavaScript等等操作。
- 但是打包的操作似乎grunt/gulp也可以帮助我们完成，它们有什么不同呢？





### 1.3 和grunt/gulp的对比

- grunt/gulp的核心是**Task**
  - 我们可以配置一系列的task，并且定义task要处理的事务（例如ES6、ts转化，图片压缩，scss转成css）
  - 之后让grunt/gulp来依次执行这些task，而且让整个流程自动化。
  - 所以grunt/gulp也被称为前端自动化任务管理工具。



- 什么时候用grunt/gulp呢？
  - 如果你的工程模块依赖非常简单，甚至是没有用到模块化的概念。
  - 只需要进行简单的合并、压缩，就使用grunt/gulp即可。
  - 但是如果整个项目使用了模块化管理，而且相互依赖非常强，我们就可以使用更加强大的webpack了。



- grunt/gulp和webpack有什么不同呢？
  - grunt/gulp更加强调的是前端流程的自动化，模块化不是它的核心。
  - webpack更加强调模块化开发管理，而文件压缩合并、预处理等功能，是他附带的功能。





## 2  webpack的安装

- 安装webpack首先需要安装Node.js，Node.js自带了软件包管理工具npm
  查看自己的node版本：

  ```shell
  node -v
  ```

  

- 全局安装webpack(这里我先指定版本号3.6.0，因为vue cli2依赖该版本)

  ```shell
  npm install webpack@3.6.0 -g
  ```

- 局部安装 webpack

```shell
## 在对应目录下执行该命令
npm install webpack@3.6.0  --save-dev
##  因为webpack我们项目打包后不需要使用 ， 所以它只是我们开发时的一个工具  --save-dev  是开发时依赖
```

- 全局安装和局部安装的区别

  - 在终端直接执行的webpack命令，使用的是全局安装的webpack
  - 当在packag.json中定义了scripts时，其中包含了webpack命令，那么使用的是局部webpack

  ```json
   "scripts": {
      "test": "echo \"Error: no test specified\" && exit 1",
      "bulid": "webpack"
    },
  ```



## 3 webpack的配置

### 3.1 入口和出口

- 如果每次使用webpack的命令都需要写上入口和出口作为参数，就很麻烦。
- 我们要创建一个 webpack.config.js文件

![image-20200922173645764](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20200922173645764.png)



### 3.2 如何使用局部安装的webpack

##### 方法一：

- 第一步：项目中需要安装自己局部的webpack
  - 这里我们让局部安装   webpack@3.6.0 （因为我们要使用 脚手架2版本来学习）
  - Vue CLI3中已经升级到webpack4，但是它将配置文件隐藏了起来，所以查看起来不是很方便。
- 第二步，通过node_modules/.bin/webpack启动webpack打包



##### 方法二：

- 但是，每次执行都敲这么一长串有没有觉得不方便呢？
  - OK，我们可以在package.json的scripts中定义自己的执行脚本。
- package.json中的scripts的脚本在执行时，会按照一定的顺序寻找命令对应的位置。
  - 首先，会寻找本地的node_modules/.bin路径中对应的命令。
  - 如果没有找到，会去全局的环境变量中寻找。
  - 如何执行我们的build指令呢？   `npm run bulid`
- ![image-20200922174156285](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20200922174156285.png)







## 4 webpack-loader加载器

> **loader是webpack中一个非常核心的概念。**

- webpack用来做什么呢？

  - 在我们之前的实例中，我们主要是用webpack来处理我们写的js代码，并且webpack会自动处理js之间相关的依赖。

  - 但是，在开发中我们不仅仅有基本的js代码处理，我们也需要加载css、图片，也包括一些高级的将ES6转成ES5代码，将

    TypeScript转成ES5代码，将scss、less转成css，将.jsx、.vue文件转成js文件等等。

  - 对于webpack本身的能力来说，对于这些转化是不支持的。

  - 那怎么办呢？给webpack扩展对应的loader就可以啦。

- loader使用过程：

  - 步骤一：通过npm安装需要使用的loader
  - 步骤二：在webpack.config.js中的modules关键字下进行配置

- 大部分loader我们都可以在webpack的官网中找到，并且学习对应的用法。



webpack.config.js 文件如下：  **如何配置 响应的 loader 在module内**

```JSON
const path = require('path')

module.exports = {
  entry: './src/main.js',
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'bundle.js',
    publicPath: 'dist/'
  },
  module: {
    rules: [{
        test: /\.css$/,
        // style-loader 负责将样式添加到DOM中
        // css-loader 负责将css文件进行加载
        // 注意：  使用多个 loader时， webpack是从右向左解析的
        use: ['style-loader', 'css-loader']
      },
      {
        test: /\.(png|jpg|gif)$/,
        use: [{
          loader: 'file-loader',
          options: {
            name: 'img/[name].[hash:8].[ext]'
          }
        }]
      },
      {
        test: /\.js$/,
        exclude: /(node_modules|bower_components)/,
        use: {
          loader: 'babel-loader',
          options: {
            presets: ['es2015']
          }
        }
      }
    ]
  }
}
```





## 5 webpack插件   plugin

- plugin是什么？
  - plugin是插件的意思，通常是用于对某个现有的架构进行扩展。
  - webpack中的插件，就是对webpack现有功能的各种扩展，比如打包优化，文件压缩等等。
- loader和plugin区别
  - loader主要用于转换某些类型的模块，它是一个转换器。
  - plugin是插件，它是对webpack本身的扩展，是一个扩展器。
- plugin的使用过程：
  - 步骤一：通过npm安装需要使用的plugins(某些webpack已经内置的插件不需要安装)
  - 步骤二：在webpack.config.js中的plugins中配置插件。



