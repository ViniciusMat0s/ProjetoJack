Visão Geral
Este projeto implementa uma imagem nginx configurada pelo Helm e hospedada em Kubernetes. O HTML do projeto é configurado pelo ConfigMaps e a imagem, aplicada pelo Docker. Todos os objetos no cluster possuem a label desafio=jackexperts, como solicitado no desafio.

Adições
De acordo com os requisitos, estas foram as adições:

Uso de repositório git com Dockerfile e Helm;
A imagem deve ser construída por você e publicada no Docker Hub;
A imagem não deve rodar com usuário root;
A página web deve ser configurável via ConfigMap;
O Helm deverá definir todos os objetos da aplicação;
A aplicação deve possuir um domínio para acesso;
Todos os objetos no cluster instalados via Helm, devem possuir a label desafio=jackexperts;
Documentação;
Pipeline CI/CD para build e deploy da aplicação.
Execução
1. Construção e Publicação da Imagem Docker
Construímos e publicamos nossa imagem utilizando os comandos abaixo:

docker build -t viniciusbaratt0mat0s/projetojack:1.5 .
docker push viniciusbaratt0mat0s/projetojack:1.5
                
2. ConfigMap
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
                            
                
3. Deploy com Helm
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
                
3.2. Values
                    replicaCount: 3

                    image:
                      repository: nginx
                      tag: stable
                      pullPolicy: IfNotPresent
                    
                    service:
                      enabled: true
                      type: ClusterIP
                      port: 8888
                      targetPort: 80
                      name: nginx-service
                    
                    ingress:
                      enabled: true
                      name: nginx-ingress
                      hosts:
                        - host: projetojack-viniciusmatos.com
                          paths:
                            - /
                      tls:
                        - secretName: nginx-tls
                          hosts:
                            - projetojack-viniciusmatos.com
                    
                    resources:
                      limits:
                        cpu: "500m"
                        memory: "128Mi"
                      requests:
                        cpu: "250m"
                        memory: "64Mi"
                
4. Hospedando com o Ingress
O Ingress hospeda o projeto publicamente:

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
                
Conclusão
O projeto é hospeda um projeto configurado com Helm dentro de um cluster. Atendendo os requisitos do desafio, sendo seguro e personalizável