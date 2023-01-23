# CICD_Java_gradle_application

This application is java spring boot web application  

build tool is **gradle**

when we build the code using command ```./gradlew build``` it will generate war file. that war can be placed in tomcat server to see application web page

code is integrated with sonarqube plugin which help us in static code analysis

``` ./gradlew sonarqube ```

kubernetes login to nexus docker host

```
kubectl create secret docker-registry registry-secret --docker-server=34.27.20.45:8083 --docker-username=admin --docker-password=admin123 --docker-email=not-needed@gmai.com
```
