{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
Name is truncated at 56 characters since certain Kubernetes fields are capped at 56 characters.
Instead of truncating at max characters, trunc gives room in case any prefix/suffix is used.
*/}}
{{- define "path-stack.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 56 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
Chart is truncated at 56 characters since certain Kubernetes fields are capped at 56 characters.
Instead of truncating at max characters, trunc gives room in case any prefix/suffix is used.
*/}}
{{- define "path-stack.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 56 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 56 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
Instead of truncating at max characters, trunc gives room in case any prefix/suffix is used.
If release name contains chart name it will be used as a full name.
*/}}
{{- define "path-stack.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 56 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 56 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 56 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Default labels
*/}}
{{- define "path-stack.labels" -}}
helm.sh/chart: {{ include "path-stack.chart" . }}
{{ include "path-stack.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Default selector labels
*/}}
{{- define "path-stack.selectorLabels" -}}
{{- if .name -}}
app.kubernetes.io/name: {{ include "path-stack.name" .context }}-{{ .name }}
{{ end -}}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .component }}
app.kubernetes.io/component: {{ .component }}
{{- end }}
{{- end }}

{{/*
Create PATH name of the service account to use
*/}}
{{- define "path-stack.serviceAccountName" -}}
{{- if .Values.global.serviceAccount.create }}
{{- default (include "path-stack.fullname" .) .Values.global.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.global.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create WATCH name of the service account to use
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
{{- $.Values.dashboards.path.folderName | default "PATH" -}}
{{- else if eq $component "guard" -}}
{{- $.Values.dashboards.guard.folderName | default "GUARD" -}}
{{- else -}}
{{- printf "%s" $component | title -}}
{{- end -}}
{{- end -}}