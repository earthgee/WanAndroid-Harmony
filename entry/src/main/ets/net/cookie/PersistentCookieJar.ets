import CookieJar from './CookieJar';
import uri from '@ohos.uri';
import Cookie from './Cookie';
import HashMap from '@ohos.util.HashMap';
import KVCookiePersistor from './KVCookiePersistor';
import CookiePersistor from './CookiePersistor';

export default class PersistentCookieJar implements CookieJar {

  private isInit = false
  private cache: HashMap<string, Cookie> = new HashMap()
  private persistor: CookiePersistor

  constructor(context: Context) {
    this.persistor = new KVCookiePersistor(context)
  }

  async init(): Promise<void> {
    if(!this.isInit) {
      let cookies = await this.persistor.loadAll()
      cookies.forEach((cookie) => {
        this.cache.set(cookie.createCookieKey(), cookie)
      })
      this.isInit = true
    }
    return new Promise<void>((resolve, reject) => {
      resolve()
    })
  }

  clear() {
throw new Error('Method not implemented.');
}

loadForRequest(url: uri.URI): Cookie[] {
throw new Error('Method not implemented.');
}

  saveFromResponse(url: uri.URI, cookies: Cookie[]) {
    cookies.forEach((cookie) => {
      this.cache.set(cookie.createCookieKey(), cookie)
    })
    this.persistor.saveAll(this.filterPersistentCookies(cookies))
  }

  private filterPersistentCookies(cookies: Array<Cookie>): Array<Cookie> {
    return cookies.filter((item) => {
      return item.persistent
    })
  }


}