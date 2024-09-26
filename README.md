*Visão Geral*
<br>
Este projeto implementa uma imagem nginx configurada pelo Helm e hospedada em Kubernetes. O HTML do projeto é configurado pelo ConfigMaps e a imagem, aplicada pelo Docker. Todos os objetos no cluster possuem a label desafio=jackexperts, como solicitado no desafio.
<br>

*Adições*
De acordo com os requisitos, estas foram as adições:
<br>

Uso de repositório git com Dockerfile e Helm;<br>
A imagem deve ser construída por você e publicada no Docker Hub;<br>
A imagem não deve rodar com usuário root;<br>
A página web deve ser configurável via ConfigMap;<br>
O Helm deverá definir todos os objetos da aplicação;<br>
A aplicação deve possuir um domínio para acesso;<br>
Todos os objetos no cluster instalados via Helm, devem possuir a label desafio=jackexperts;<br>
Documentação;<br>
Pipeline CI/CD para build e deploy da aplicação.<br>
<br>

*Execução*

<br>

###1. Construção e Publicação da Imagem Docker
Construímos e publicamos nossa imagem utilizando os comandos abaixo:

docker build -t viniciusbaratt0mat0s/projetojack:1.5 .
docker push viniciusbaratt0mat0s/projetojack:1.5
<br>
###2. ConfigMap
O ConfigMap armazenando o HTML.

                    apiVersion: v1
                    kind: ConfigMap
                    metadata:
                      name: projetojack-nginx-config
                      labels:
                        app: nginx
                        desafio: jack-experts
                    data:
                      index.html: |
                            
<br>              
###3. Deploy com Helm
Deployment definindo os objetos do projeto.

                    apiVersion: apps/v1
                    kind: Deployment
                    metadata:
                      name: projetojack-nginx
                      labels:
                        app: nginx
                        desafio: jack-experts
                    spec:
                      replicas: 3
                      selector:
                        matchLabels:
                          app: nginx
                      template:
                        metadata:
                          labels:
                            app: nginx
                            desafio: jack-experts
                        spec:
                          containers:
                            - name: nginx
                              image: nginx:stable
                              ports:
                                - containerPort: 8888
                              volumeMounts:
                                - name: html-volume
                                  mountPath: /usr/share/nginx/html
                          volumes:
                            - name: html-volume
                              configMap:
                                name: projetojack-nginx-config
                
###3.2. Values
                    replicaCount: 1

                    image:
                    repository: viniciusbaratt0mat0s/projetojack
                    tag: "latesd"
                    pullPolicy: IfNotPresent

                    service:
                    type: ClusterIP
                    port: 8080

                    labels:
                    desafio: jackexperts

                    resources:
                    limits:
                        memory: "128Mi"
                        cpu: "500m"
                    requests:
                        memory: "64Mi"
                        cpu: "250m"

                    ingress:
                    enabled: true
                    hosts:
                        - host: 192.168.58.1 
                        paths:
                            - path: /
                            pathType: Prefix
                
<br>
##4. Hospedando com o Ingress
O Ingress hospeda o projeto localmente:

                    apiVersion: networking.k8s.io/v1
                    kind: Ingress
                    metadata:
                      name: projetojack-nginx
                      annotations:
                        nginx.ingress.kubernetes.io/rewrite-target: /
                    spec:
                      rules:
                        - host: 
                          http:
                            paths:
                              - path: /
                                pathType: Prefix
                                backend:
                                  service:
                                    name: projetojack-nginx
                                    port:
                                      number: 8080
                
##Conclusão:
O projeto é hospeda um projeto configurado com Helm dentro de um cluster. Atendendo os requisitos do desafio, sendo seguro e personalizável
Foi um projeto intrigante, porém estressante, talvez por falta de um conhecimento sólido envolvendo o fluxo real de desenvolvimento, 
houveram algumas coisas que não foram concluídas, por exemplo, a abertura de portas via Ingress, o projeto só é acessado via
comando kubectl port-forward service/projetojack-service 8080:80. O projeto foi feito "em conjunto" com os colegas Armando e Gustavo, dos quais nos ajudamos igualmente, resolvendo alguns problemas comuns para ambos os lados, também, recebendo uma ajudinha do ChatGPT, pois sem instruções concretas, não conseguiríamos concluir a aplicação.