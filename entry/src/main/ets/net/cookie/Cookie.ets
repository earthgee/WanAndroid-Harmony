
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

}