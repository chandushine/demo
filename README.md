# deploy gameoflife aplication
-------------------------------
# #building gameoflife image by using docker
  -for that we have to write 'Dockerfile' 
  ```Dockerfile
  FROM tomcat:8.5.84-jdk17-corretto-al2
ADD https://referenceapplicationskhaja.s3.us-west-2.amazonaws.com/gameoflife.war /usr/local/tomcat/webapps/gameoflife.war
EXPOSE 8080
CMD [ "catalina.sh", "run" ]
```


  - we can create image by using this command `docker image build -t gameoflife:11.123`
  - **change the tag** `docker image tag gameoflife:11.123 9848016515/gameoflife:11.123`
  - created image ![preview] (Screenshot 2022-12-24 222046.png)
  - **push image to registry**  == `docker push 9848016515/gameoflife:11.123` (before that we have to login `docker login`)
  - we can see here ![preview] (Screenshot 2022-12-24 223254.png)
# # # deploy pod
  ```yaml
  ---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: gol
spec:
  minReadySeconds: 5
  replicas: 1
  selector:
    matchLabels:
      app: gol
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 25
      maxUnavailable: 25 
  template:
    metadata:
      name: gol
      labels:
        app: gol
    spec:
      containers:
        - name: gol
          image: 9848016515/gameoflife:11.123
          command:
            - catalina.sh
            - run
            - 0.0.0.0/8080
          ports:
            - containerPort: 8080
              protocol: TCP
```

# # # # servise pod
 
 ```yml
 ---
apiVersion: v1
kind: Service
metadata:
  name: gol
  labels:
    app: gol
spec:
  type: NodePort
  selector:
      app: gol
  ports:
    - port: 35007
      targetPort: 8080
      nodePort: 32000
```

* ![preview] (Screenshot 2022-12-24 224516.png)
* ![preview] (Screenshot 2022-12-24 224846.png)




# deploy openmrs aplication
-------------------------------
# #building openmrs image by using docker
  -for that we have to write 'Dockerfile' 
  ```Dockerfile
FROM maven:3-jdk-8 as mvn
LABEL author='chandu'
RUN git clone https://github.com/openmrs/openmrs-core.git && cd openmrs-core && mvn clean package
FROM tomcat:8
LABEL author='chandu'
COPY --from=mvn /openmrs-core/webapp/target/openmrs.war /usr/local/tomcat/webapps/openmrs.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
```


  - we can create image by using this command `docker image build -t openmrs:1.123`
  - **change the tag** `docker image tag gameoflife:11.123 9848016515/openmrs:1.123`
  - created image ![preview] (Screenshot 2022-12-24 222046.png)
  - **push image to registry**  == `docker push 9848016515/openmrs:1.123` (before that we have to login `docker login`)
  - we can see here ![preview] (Screenshot 2022-12-24 223255.png)
# # # deploy pod
  ```yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: openmrs
spec:
  minReadySeconds: 5
  replicas: 1
  selector:
    matchLabels:
      app: openmrs
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 25
      maxUnavailable: 25 
  template:
    metadata:
      name: openmrs
      labels:
        app: openmrs
    spec:
      containers:
        - name: openmrs
          image: 9848016515/openmrs:1.123
          command:
            - catalina.sh
            - run
            - 0.0.0.0/8080
          ports:
            - containerPort: 8080
              protocol: TCP
```

# # # # servise pod
 
 ```yml
 ---
apiVersion: v1
kind: Service
metadata:
  name: openmrs
  labels:
    app: openmrs
spec:
  type: NodePort
  selector:
      app: openmrs
  ports:
    - port: 35003
      protocol: TCP
      targetPort: 8080
      nodePort: 32003
```

* ![preview] (Screenshot 2022-12-24 224517.png)
* ![preview] (Screenshot 2022-12-24 224847.png)

