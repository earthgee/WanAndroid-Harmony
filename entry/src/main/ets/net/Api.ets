import { Article, ArticleList, HomeBannerData } from './module/Article'
import { Response } from './module/Response'
import http from '@ohos.net.http'
import uri from '@ohos.uri'
import hilog from '@ohos.hilog'
import { IndexTree } from './module/IndexTree'
import { WeChatAuthor } from './module/WeChat'
import { User } from '../service/UserService'
import PersistentCookieJar from './cookie/PersistentCookieJar'
import EntryContext from '../common/EntryContext'
import Cookie from './cookie/Cookie'
import CookieUtils from './cookie/CookieUtils'

let TAG = "Api"
let BASE_URL = "https://www.wanandroid.com"

let cookieJar = new PersistentCookieJar(EntryContext.getContext() as Context)

function parseUri(url: string): uri.URI {
  return new uri.URI(url)
}

async function requestSync<T>(path: string, method: http.RequestMethod,
                              extraData?: Object): Promise<Response<T>> {
  await cookieJar.init()
  return new Promise<Response<T>>((resolve, reject) => {
    let url = BASE_URL + path
    let uri = parseUri(url)
    let header = {}
    //cookie
    if(method === http.RequestMethod.POST) {
      header["Content-Type"] = "application/x-www-form-urlencoded"
      if(!extraData) {
        extraData = {}
      }
    }
    let httpRequest = http.createHttp()
    hilog.info(0, TAG, `start request, path: ${path}, method: ${method}, extraData: ${JSON.stringify(extraData)}`)
    httpRequest.request(
      url,
      {
        method: method,
        expectDataType: http.HttpDataType.OBJECT,
        header: header,
        extraData: extraData
      },
      (err, data) => {
        let res = new Response<T>()
        if(!err && data.responseCode === 200) {
          //cookie
          cookieJar.saveFromResponse(uri, CookieUtils.parseHttpRequestCookies(data.cookies))
          if(typeof data.result === 'string') {
            Object.assign(res, JSON.parse(data.result))
          } else {
            Object.assign(res, data.result)
          }
          hilog.info(0, TAG, `request success, path: ${path}, result: ${JSON.stringify(res)}`)
        } else {
          hilog.error(0, TAG, `request error, path: ${path}, error: ${JSON.stringify(err)}`)
          res.errorCode = data?.responseCode ?? -1
          res.errorMsg = err?.message ?? ""
        }
        resolve(res)
      }
    )
  })
}

export default class Api {
  private static instance: Api

  private constructor() {
  }

  static get(): Api {
    if(Api.instance === undefined) {
      Api.instance = new Api()
    }
    return Api.instance
  }

  async getHomeBanner(): Promise<Response<Array<HomeBannerData>>> {
    return requestSync("/banner/json", http.RequestMethod.GET)
  }

  async getTopArticle(): Promise<Response<Array<Article>>> {
    return requestSync("/article/top/json", http.RequestMethod.GET)
  }

  async getHomeArticleList(page: number): Promise<Response<ArticleList>> {
    return requestSync(`/article/list/${page}/json`, http.RequestMethod.GET)
  }

  async getSquareArticleList(page: number): Promise<Response<ArticleList>> {
    return requestSync(`/user_article/list/${page}/json`, http.RequestMethod.GET)
  }

  async getTree(): Promise<Response<Array<IndexTree>>> {
    return requestSync(`/tree/json`, http.RequestMethod.GET)
  }

  async getTreeArticleList(cid: number, page: number): Promise<Response<ArticleList>> {
    return requestSync(`/article/list/${page}/json?cid=${cid}`, http.RequestMethod.GET)
  }

  async getWeChatAuthorList(): Promise<Response<Array<WeChatAuthor>>> {
    return requestSync("/wxarticle/chapters/json", http.RequestMethod.GET)
  }

  async getWeChatArticleList(id: number, page: number): Promise<Response<ArticleList>> {
    return requestSync(`/wxarticle/list/${id}/${page}/json`, http.RequestMethod.GET);
  }

  async getUserInfo(): Promise<Response<User>> {
    return requestSync("/lg/coin/userinfo/json", http.RequestMethod.GET);
  }

  async login(username: string, password: string): Promise<Response<User>> {
    return requestSync("/user/login", http.RequestMethod.POST, `username=${username}&password=${password}`)
  }

  async register(username: string, password: string, repassword: string): Promise<Response<User>> {
    return requestSync("/user/register", http.RequestMethod.POST, `username=${username}&password=${password}&repassword=${repassword}`)
  }

}







