{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "watch.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "watch.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "watch.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "watch.labels" -}}
helm.sh/chart: {{ include "watch.chart" . }}
{{ include "watch.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "watch.selectorLabels" -}}
app.kubernetes.io/name: {{ include "watch.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "watch.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "watch.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Get the namespace for a resource
*/}}
{{- define "watch.namespace" -}}
{{- $resourceType := index . 0 -}}
{{- $context := index . 1 -}}
{{- if eq $resourceType "dashboard" -}}
{{- default $context.Values.global.namespace $context.Values.dashboards.namespace | default $context.Release.Namespace -}}
{{- else if eq $resourceType "servicemonitor" -}}
{{- default $context.Values.global.namespace $context.Values.serviceMonitors.namespace | default $context.Release.Namespace -}}
{{- else -}}
{{- default $context.Values.global.namespace $context.Release.Namespace -}}
{{- end -}}
{{- end -}}

{{/*
Get Grafana dashboard folder for a component
*/}}
{{- define "watch.dashboardFolder" -}}
{{- $component := . -}}
{{- if eq $component "path" -}}
{{- $.Values.dashboards.path.folderName | default "PATH API" -}}
{{- else if eq $component "guard" -}}
{{- $.Values.dashboards.guard.folderName | default "GUARD API" -}}
{{- else -}}
{{- printf "%s" $component | title -}}
{{- end -}}
{{- end -}}
