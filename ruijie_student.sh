#!/bin/sh

#If received parameters is less than 2, print usage
if [ "${#}" -lt "2" ]; then
  echo "Usage: ./ruijie_student.sh username password"
  echo "Example: ./ruijie_student.sh 0000000000 123456"
  exit 1
fi

#Exit the script when is already online, use www.google.cn/generate_204 to check the online status
captiveReturnCode=`curl -s -I -m 10 -o /dev/null -s -w %{http_code} http://www.google.cn/generate_204`
if [ "${captiveReturnCode}" = "204" ]; then
  echo "网络连接成功！"
  exit 0
fi

#If not online, begin Ruijie Auth

#Get Ruijie login page URL
loginPageURL=`curl -s "http://www.google.cn/generate_204" | awk -F \' '{print $2}'`

#Structure loginURL
loginURL=`echo ${loginPageURL} | awk -F \? '{print $1}'`
loginURL="${loginURL/index.jsp/InterFace.do?method=login}"

service="DianXin"
queryString="wlanuserip=94ca20c0fb0e777ea4972aaa297a8f3e&wlanacname=643d07a46528c937f09836d589740409&ssid=&nasip=cc5b64e516a1fa61d915e184b913e171&snmpagentip=&mac=e9610ea931d21016b0af5fed148bfe73&t=wireless-v2&url=418b8bb474ba4db13cc1f6dc4a2e7e2b147e5d21f7c9202b&apmac=&nasid=643d07a46528c937f09836d589740409&vid=e7e9ec1de0977a03&port=2dbe874bc250c5f9&nasportid=489ecc80e9f86aea0ba5dc4a08edd8a223dbed083ee5e03fe78d14a5ae3564de"
queryString="${queryString//&/%2526}"
queryString="${queryString//=/%253D}"

#Send Ruijie eportal auth request and output result
if [ -n "${loginURL}" ]; then
  authResult=`curl -s -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.91 Safari/537.36" -e "${loginPageURL}" -b "EPORTAL_COOKIE_USERNAME=; EPORTAL_COOKIE_PASSWORD=; EPORTAL_COOKIE_SERVER=; EPORTAL_COOKIE_SERVER_NAME=; EPORTAL_AUTO_LAND=; EPORTAL_USER_GROUP=; EPORTAL_COOKIE_OPERATORPWD=;" -d "userId=${1}&password=${2}&service=${service}&queryString=${queryString}&operatorPwd=&operatorUserId=&validcode=&passwordEncrypt=false" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" -H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" "${loginURL}"`
  echo $authResult
fi
