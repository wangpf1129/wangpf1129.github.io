---
title: axios
date: 2020-09-26 15:17:06
index_img: /img/axios.jpg
tags: vue
categories: vue
---
#  axios ⭐

> axios: ajax i/o system.

- **功能特点** ：
  - 在浏览器中发送 XMLHttpRequests 请求
  - 在 node.js 中发送 http请求
  - 支持 Promise API
  - 拦截请求和响应
  - 转换请求和响应数据

- **支持多种请求方式**
  - axios(config)
  - axios.request(config)
  - axios.get(url[, config])
  - axios.delete(url[, config])
  - axios.head(url[, config])
  - axios.post(url[, data[, config]])
  - axios.put(url[, data[, config]])
  - axios.patch(url[, data[, config]])



## get 请求演示

![get 请求演示](https://img-blog.csdnimg.cn/20200926145610808.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3Bmenp6eno=,size_16,color_FFFFFF,t_70#pic_center)



## 发送并发请求

- 有时候, 我们可能需求同时发送两个请求
  - 使用**axios.all,** 可以放入多个请求的数组. res[0],res[1] 得出结果
  - **axios.all([]) 返回的结果是一个数组**，使用 axios.spread 可将数组 [res1,res2] 展开为 res1, res2





![发送并发请求](https://img-blog.csdnimg.cn/20200926145610347.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3Bmenp6eno=,size_16,color_FFFFFF,t_70#pic_center)

如果不使用  axios.spread 那就 用 最简单的数组方法得出结果：  res[0],res[1]



## 全局配置

> 在上面的示例中, 我们的BaseURL是固定的
> 事实上, 在开发中可能很多参数都是固定的.
> 这个时候我们可以进行一些抽取, 也可以利用axiox的全局配置



```javascript
axios.defaults.baseURL = ‘123.207.32.32:8000’axios.defaults.headers.
post[‘Content-Type’] = ‘application/x-www-form-urlencoded’;
```



![全局配置](https://img-blog.csdnimg.cn/20200926145610330.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3Bmenp6eno=,size_16,color_FFFFFF,t_70#pic_center)



## 创建 axios 实例

- 为什么要创建axios的实例呢?
  - 当我们从axios模块中导入对象时, 使用的实例是默认的实例.
  - 当给该实例设置一些默认配置时, 这些配置就被固定下来了.
  - 但是后续开发中, 某些配置可能会不太一样.
  - 比如某些请求需要使用特定的baseURL或者timeout或者content-Type等.
  - 这个时候, 我们就可以创建新的实例, 并且传入属于该实例的配置信息.  



![创建 axios 实例](https://img-blog.csdnimg.cn/20200926145610848.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3Bmenp6eno=,size_16,color_FFFFFF,t_70#pic_center)





## axios 模块化封装  ⭐

> 在实际开发过程中，需要对AJAX请求进行统一的封装，使其模块化，易于修改和操作。
>
> 所以，最好这样做，而不是直接在 组件内使用 axios 插件 ，那样后期修改整个 axios 时会及其麻烦

```javascript
import axios from "axios";


export function request(config) {
  //  1.配置基本信息   
  const instance = axios.create({
    baseURL: 'http://152.136.185.210:8000/api/z8',
    timeout: 5000
  })
  //  本身返回的就一个 Promise   不需要再次封装一个 Promise来使用
  // 3.发送真正的网络请求  ( 方式一)
  return instance(config)
}

 
//  使用 回调函数   ( 方式二)

// export function request(config, success, failure) {

//   const instance = axios.create({
//     baseURL: 'http://152.136.185.210:8000/api/z8',
//     timeout: 5000
//   })

//   instance(config)
//     .then(res => {
//       success(res)
//     })
//     .catch(err => {
//       failure(err)
//     })

// }


// 使用 Promise      ( 方式三 )
// export function request(config) {

//   return new Promise((resolve, reject) => {
//     const instance = axios.create({
//       baseURL: 'http://152.136.185.210:8000/api/z8',
//       timeout: 5000
//     })

//     instance(config)
//       .then(res => {
//         resolve(res)
//       })
//       .catch(err => {
//         reject(err)
//       })
//   })
// }

```

```javascript
//  在组件内 传入对象 进行网络请求

// 方式一和方式三（promise） ，
request({
    url:'/home/multidata'
}).then(res =>{
    console.log(res)
}).catch(err=>{
    console.log(err)
})

// 方式二 （使用的回调函数）:
request({
    url:'/home/multidata'
},res=>{
    console.log(res) 
},err=>{
    console.log(err) 
})
```





## axios 拦截器

> axios提供了拦截器，用于我们在发送每次请求或者得到相应后，进行对应的处理。



```javascript
import axios from "axios";


export function request(config) {
  //  1.配置基本信息   （创建实例， 这样不是全局的）
  const instance = axios.create({
    baseURL: 'http://152.136.185.210:8000/api/z8',
    timeout: 5000
  })
  // 2.axios 拦截器
  // 2.1请求拦截的作用： 
  instance.interceptors.request.use(config => {
    //  这里可以拦截一些：
    // 1. 比如config中的一些信息不符合服务器的要求  
    // 2. 比如每次发送网络请求时，都希望在页面中显示一个请求的图标
    // 3. 某些网络请求（比如登录需要的（token），必须携带一些特殊的信息）
    console.log(config);
    // 拦截后 要发出去  要不就收不到
    return config
  }, err => {
    console.log(err);
  })

  // 2.2 响应拦截 
  instance.interceptors.response.use(res => {
      // 响应的成功拦截中，主要是对数据进行过滤。
    return res.data // 真正有用的东西是 data中的数据
  }, err => {
    // 响应的失败拦截中，可以根据status判断报错的错误码，跳转到不同的错误提示页面。
    console.log(err);
  })

  //  本身返回的就一个 Promise   不需要再次封装一个 Promise来使用
  // 3.发送真正的网络请求
  return instance(config)
}
```



