# README
```
rails new rails_best_practice -d mysql --api
```

## devise_token_auth
```
$ rails g devise_token_auth:install Admin auth
$ rails g devise_token_auth:install User auth
```
js request
```
export const tokenHeader = () => {
  const authInfo = store.state.user.authInfo
  if (authInfo) {
    return {
      'access-token': authInfo['token'],
      client: authInfo['client'],
      uid: authInfo['uid']
    }
  }
  return {}
}
```
```
setAuthInfo (state, authInfo) {
  let authInfoTmp = {token: authInfo.token || authInfo['access-token'], client: authInfo.client || authInfo['client_id'], uid: authInfo.uid}
  localStorage.setItem('authInfo', JSON.stringify(authInfoTmp))
  state.authInfo = authInfoTmp
}
```
### 生成项目doc
```
sdoc projectdir
```