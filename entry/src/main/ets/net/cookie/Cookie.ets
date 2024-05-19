import { uri } from '@kit.ArkTS'

export default class Cookie {

  name: string = ""
  value: string = ""
  expiresAt: number = 0
  domain: string = ""
  path: string = ""
  httpOnly: boolean = false
  persistent: boolean = true

  createCookieKey(): string {
    return `https://${this.domain}${this.path}|${this.name}`;
  }

  isExpired(): boolean {
    let nowTime = Date.now() / 1000
    return this.expiresAt < nowTime
  }

  matches(url: uri.URI): boolean {
    let domainMatch = this.domainMatch(url.host, this.domain)
    if(!domainMatch) return false
    if(!this.pathMatch(url, this.path)) return false
    return true
  }

  private domainMatch(urlHost: string, domain: string): boolean {
    if(urlHost === domain) {
      return true
    }

    return urlHost.endsWith(domain) && urlHost[urlHost.length - domain.length - 1] === '.'
  }

  private pathMatch(url: uri.URI, path: string): boolean {
    let urlPath = url.path
    if(urlPath === path) {
      return true
    }

    if(urlPath.startsWith(path)) {
      if (path.endsWith("/")) return true; // As in '/' matching '/foo'.
      if (urlPath[path.length] === "/") return true; // As in '/foo' matching '/foo/bar'.
    }

    return false
  }

}







