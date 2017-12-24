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

### doc Excel
```
path = Utils::Excel.export_excel(@users, User)
send_file(path)
```
api js get file download [axios]
```
uploadUsersExcel: (data) => instance.post('/users/upload_users_excel', data, { headers: { 'Content-Type': 'multipart/form-data' } })
downloadUsersExcel: (params) => instance.get('/users/users_excel', {params, responseType: 'arraybuffer'}),
```
fileDownload module
```
module.exports = function (data, filename, mime) {
  var blob = new Blob([data], {type: mime || 'application/octet-stream'})
  if (typeof window.navigator.msSaveBlob !== 'undefined') {
    window.navigator.msSaveBlob(blob, filename)
  } else {
    let blobURL = window.URL.createObjectURL(blob)
    let tempLink = document.createElement('a')
    tempLink.style.display = 'none'
    tempLink.href = blobURL
    tempLink.setAttribute('download', filename)
    tempLink.setAttribute('target', '_blank')
    document.body.appendChild(tempLink)
    tempLink.click()
    document.body.removeChild(tempLink)
    window.URL.revokeObjectURL(blobURL)
  }
}
```
使用
```
this.api.getUsersExcel(this.$route.query).then(res => {
  fileDownload(res.data, 'users.xlsx')
})
``` 