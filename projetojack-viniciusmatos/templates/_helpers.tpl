{{/*
Common helpers for nginx charts.
*/}}

{{- define "nginx.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels.
*/}}
{{- define "nginx.labels" -}}
app: {{ include "nginx.fullname" . }}
chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
release: {{ .Release.Name }}
heritage: {{ .Release.Service }}
{{- end -}}

{{/*
Default name for the service.
*/}}
{{- define "nginx.serviceName" -}}
{{ include "nginx.fullname" . }}
{{- end -}}

{{/*
Default ingress class name.
*/}}
{{- define "nginx.ingressClassName" -}}
nginx
{{- end -}}

