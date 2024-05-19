
import Cookie from './Cookie';
import CookiePersistor from './CookiePersistor';
import dataPreferences from '@ohos.data.preferences';

export default class KVCookiePersistor implements CookiePersistor {

  private context: Context
  private preferences?: dataPreferences.Preferences

  constructor(context: Context) {
    this.context = context
  }

  private async checkInit(): Promise<void> {
    if(!this.preferences) {
      this.preferences = await dataPreferences.getPreferences(this.context, 'earthgeeCookieKV')
    }
    return new Promise<void>((resolve, reject) => {
      resolve()
    })
  }

  clear() {
    this.checkInit().then((v) => {
      this.preferences?.clear()
      this.preferences?.flush()
    })
  }

  removeAll(cookies: Cookie[]) {
    this.checkInit().then((v) => {
      cookies.forEach((cookie) => {
        this.preferences?.delete(cookie.createCookieKey())
      })
      this.preferences?.flush()
    })
  }

  async loadAll(): Promise<Cookie[]> {
    await this.checkInit()
    let cookies: Array<Cookie> = []
    let all = await this.preferences?.getAll() as Array<string>
    for(let key of all) {
      let value = all[key]
      let cookie = new Cookie()
      Object.assign(cookie, JSON.parse(value))
      cookies.push(cookie)
    }
    return new Promise<Cookie[]>((resolve, reject) => {
      resolve(cookies)
    })
  }

  saveAll(cookies: Cookie[]) {
    this.checkInit().then((v) => {
      cookies.forEach((cookie) => {
        this.preferences?.put(cookie.createCookieKey(), JSON.stringify(cookie))
      })
      this.preferences?.flush()
    })
  }



}