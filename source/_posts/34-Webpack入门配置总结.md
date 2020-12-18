---
title: Webpack入门配置总结
index_img: /img/webpack2.jpg
date: 2020-12-18 16:42:45
tags: [webpack]
categories: [webpack]
---

 ## 前言 
 
 我的配置版本号如下:
 
 ```json
  "devDependencies": {
     "css-loader": "^3.2.0",
     "dart-sass": "^1.23.7",
     "file-loader": "^5.0.2",
     "html-webpack-plugin": "^3.2.0",
     "less": "^3.10.3",
     "less-loader": "^5.0.0",
     "mini-css-extract-plugin": "^0.8.0",
     "sass-loader": "^8.0.0",
     "style-loader": "^1.0.1",
     "webpack": "^4.41.2",
     "webpack-cli": "^3.3.10",
     "webpack-dev-server": "^3.9.0"
   },
 ```

 >  参考文档：webpack官方文档 , 在配置每一部分时候我会把链接发在里面
 
 ## package.json中配置build
 
 ```json
   "scripts": {
     "build": "rm -rf dist && webpack"
   },
 ```
 
 
 
 ## 初始化 webpack.config.js
 
 ### 模式的区别：
 
 ```js
 module.exports = {
   mode: 'development'  // 开发者模式  注意去观察 dist/main.js  会发现有许多注释并没有被压缩
 };
 ```
 
 ```js
 module.exports = {
   mode: 'production'  // 生产模式  去观察 dist/main.js  代码都被压缩了，
 };  
 ```
 
 
 
 ### 入口文件和出口文件配置：
 
 ```js
 var path = require('path');
 
 module.exports = {
   mode: 'development',   // 开发者模式
   entry: './src/index.js',  // 打包的入口文件
   output: {
     path: path.resolve(__dirname, 'dist'),  // 可用不用写，默认是dist文件
        filename: 'index.[contenthash].js'  // 打包出口文件名， 以 index.20位随机数/字母.js以文件名
 
   }
 };
 ```
 
 
 
 
 
 ## webpack插件自动生成HTML：
 
 >  webpack文档链接 ：https://webpack.js.org/plugins/html-webpack-plugin/   和 https://github.com/jantimon/html-webpack-plugin#options
 
 
 
  这样就会在 dist文件中生成一个 index.html
 
 ```bash
 npm install --save-dev html-webpack-plugin
 ```
 
 ```js
 var HtmlWebpackPlugin = require('html-webpack-plugin');
 
 module.exports = {
   plugins: [new HtmlWebpackPlugin()]  
 };
 ```
 
 
 
 配置内容：
 
 ```js
  plugins: [new HtmlWebpackPlugin({ 
     // 可以不写filename这个属性，也默认生成index.html
     // 在这里配置title 要在template中的html文件内的title标签配置 <%= htmlWebpackPlugin.options.title %>
     title: 'Wang-pf',
     template: 'src/assets/index.html' // 生成模板是哪个
   })]
 ```
 
 
 
 
 
 ## webpack引入CSS：
 
 ### 方法一： 用JS来生成style
 
 > webpack文档链接: https://webpack.docschina.org/loaders/css-loader/#getting-started
 
 
 
 先安装依赖插件， 必须要安装style-loader 。
 
 ```bash
 npm install --save-dev  style-loader css-loader 
 ```
 
 
 
 **原理是 webpack默认要把 以.css结尾的放到style标签中。**
 
 ```js
  module: {
     rules: [{
       test: /\.css$/i, // 以 .css 结尾的
       use: ["style-loader", "css-loader"], // 依赖插件
     
    }, ],
   }
 ```
 
 
 
 ### 方法二： 把CSS抽成文件
 
 先安装依赖，
 
 ```bash
 npm install --save-dev mini-css-extract-plugin
 ```
 
 
 
 配置
 
 ```js
 const MiniCssExtractPlugin = require('mini-css-extract-plugin');
 
 module.exports = {
   plugins: [
      new MiniCssExtractPlugin({
       // 类似于 webpackOptions.output 中的选项
       // 所有选项都是可选的
       filename: '[name].[contenthash].css',
       chunkFilename: '[id].[contenthash].css',
       ignoreOrder: false, // 忽略有关顺序冲突的警告
     }),
   ],
   module: {
     rules: [
       {
         test: /\.css$/,
        use: [{
           loader: MiniCssExtractPlugin.loader,
           options: {
             // 你可以在这里指定特定的 publicPath
             // 默认情况下使用 webpackOptions.output 中的 publicPath
             publicPath: '../',
           },
         },
         'css-loader',
       ],
       },
     ],
   },
 };
 
 ```
 
 
 
 
 
 
 
 ## webpack dev-server 的使用
 
 > webpack dev-server文档链接：https://www.webpackjs.com/guides/development/    
 
 
 
 
 
 1. 安装插件
 
 ```bash
 npm install --save-dev webpack-dev-server
 ```
 
 2. webpack.config.js 配置
 
   ```js
     devServer: {
     	contentBase: './dist'
     },
   ```
 3. 在package.json 配置以下 start
 
   ```bash
    "start": "webpack-dev-server --open",
   ```
 
 
 
 在 npm start 的时候发现 报错， 报错原因是：[Error: Cannot find module 'webpack-cli/bin/config-yargs'](https://stackoverflow.com/questions/59611597/error-cannot-find-module-webpack-cli-bin-config-yargs)
 
 解决方法是：把版本号改一下  如下：
 
 ```json
 "webpack": "^4.41.2",
 "webpack-cli": "^3.3.10",
 "webpack-dev-server": "^3.9.0"
 ```
 
 
 
 
 
 ##  不同模式使用不同的 webpack  config
 
 > 我们已经知道模式有 开发者模式(development) 和 生产模式(production)  ,那么我们应该在不同模式中选用不同的插件来使用。
 >
 > 比如： 在生产模式production中，引入CSS方法使用style， 因为这样不同生成一个CSS文件，使得效率变高。如果是开发者模式 ，那么我们就需要把CSS抽成文件。
 
 
 
 创建一个webpack配置文件：webpack.config.prod.js  用在生产模式时使用。
 
 创建一个webpack配置文件： webpack.config.base.js  用于开发和生产模式的共同属性
 
 并在package.json文件中重新配置build。
 
 ```json
  "build": "rm -rf dist && webpack --config webpack.config.prod.js"
 ```
 
 
 
 
 
 ## webpack loader   和 webpack  plugin 的区别
 
 - loader （加载器） ： 用于加载某些文件，比如加载JS文件，可以把JS转换为低版本支持的js, 又比如CSS,使用相应的loder加载，可以把CSS放到页面上style标签中或者其他处理。也可以用来加载图片，可以对图片进行优化。
 - plugin （插件）： 扩展webpack功能的，比如使用 HtmlWebpackPlugin 插件用来生成html文件， 使用 miniCssExtractPlugin 插件用来生成CSS文件等。
 
 
 
 
 
 ## 引入 sass 
 
 > 参考链接：https://webpack.docschina.org/loaders/sass-loader/
 
 
 
  这里使用 datr-sass  不使用node-sass（已过时）
 
 ```bash
 npm install sass-loader dart-sass --save-dev
 ```
 
 
 
 webpakc.config配置：
 
 ```js
  rules: [{
       test: /\.scss$/i,
       use: [
         "style-loader",
         "css-loader",
         {
           loader: "sass-loader",
           options: {
             // `dart-sass` 是首选
             implementation: require("dart-sass"),
           },
         },
       ],
  }, ],
 ```
 
 
 
 把css文件改为scss文件即可使用。
 
 
 
 ## 引入less
 
 > 文档链接：https://webpack.js.org/loaders/less-loader/
 
 
 
 安装loader
 
 ```bash
 npm install less less-loader --save-dev
 ```
 
 
 
 ```js
   {
       test: /\.less$/,
       loader: ["style-loader","css-loader","less-loader"], // compiles Less to CSS
     },
 ```
 
 
 
 stylus  和 引入less 方法一致，不再写了。
 
 
 
 
 
 ## 使用 file-loader 引入图片
 
 > 参考文档: https://webpack.js.org/loaders/file-loader/
 
 安装
 
 ```bash
  npm install file-loader --save-dev
 ```
 
 我的版本号：
 
 ```json
 "file-loader": "^5.0.2",
 ```
 
 
 
 webpack.config配置：
 
 ```js
 module.exports = {
   module: {
     rules: [
       {
         test: /\.(png|jpe?g|gif)$/i,
         use: [
           {
             loader: 'file-loader',
           },
         ],
       },
     ],
   },
 };
 ```
 
 
 
 然后在html页面中引入就可以了。
 
 ## webpack impor()  懒加载
 
 不多说看代码
 
 
 
 inedx.js
 
 ```js
 // index.js
 const btn = document.createElement('button')
 btn.innerText = '懒加载'
 btn.onclick = ()=>{
  const promise = import('./lazy.js')
   promise.then((module)=>{
     const fn = module.default
     fn()
   },()=>{
     console.log('懒加载模块加载失败')
   })
 }
 
 div.appendChild(btn)
 ```
 
 
 
 lazy.js
 
 ```js
 export  default function lazy() {
   console.log('我是懒加载陌客')
 }
 ```
 
 
 
 上面就是如何使用 import() 来实现懒加载
 
 用 import()  去加载文件 ，然后得到一个 promise  ， 在成功之后 使用 module.default() 调用 lazy.js 文件
 
