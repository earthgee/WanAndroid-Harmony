
import Cookie from './Cookie';
import CookiePersistor from './CookiePersistor';
import dataPreferences from '@ohos.data.preferences';

export default class KVCookiePersistor implements CookiePersistor {

  private context: Context
  private preferences: dataPreferences.Preferences

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
throw new Error('Method not implemented.');
}
removeAll(cookies: Cookie[]) {
throw new Error('Method not implemented.');
}

  async loadAll(): Promise<Cookie[]> {
    await this.checkInit()
    let cookies: Array<Cookie> = []

  }

  saveAll(cookies: Cookie[]) {
    this.checkInit().then((v) => {
      cookies.forEach((cookie) => {
        this.preferences.put(cookie.createCookieKey(), JSON.stringify(cookie))
      })
      this.preferences.flush()
    })
  }



}