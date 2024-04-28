import { Article, ArticleList, HomeBannerData } from './module/Article'
import { Response } from './module/Response'
import http from '@ohos.net.http'
import uri from '@ohos.uri'
import hilog from '@ohos.hilog'

let TAG = "Api"
let BASE_URL = "https://www.wanandroid.com"

//todo cookie
// let cookieJar: Cook

function parseUri(url: string): uri.URI {
  return new uri.URI(url)
}

async function requestSync<T>(path: string, method: http.RequestMethod,
                              extraData?: Object): Promise<Response<T>> {
  //cookie
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



}