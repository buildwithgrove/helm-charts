{{/*
Expand the name of the chart.
Name is truncated at 56 characters since certain Kubernetes fields are capped at 56 characters.
Instead of truncating at max characters, trunc gives room in case any prefix/suffix is used.
*/}}
{{- define "path.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 56 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
Chart is truncated at 56 characters since certain Kubernetes fields are capped at 56 characters.
Instead of truncating at max characters, trunc gives room in case any prefix/suffix is used.
*/}}
{{- define "path.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 56 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 56 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
Instead of truncating at max characters, trunc gives room in case any prefix/suffix is used.
If release name contains chart name it will be used as a full name.
*/}}
{{- define "path.fullname" -}}
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
{{- define "path.labels" -}}
helm.sh/chart: {{ include "path.chart" . }}
{{ include "path.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Default selector labels
*/}}
{{- define "path.selectorLabels" -}}
app.kubernetes.io/name: {{ include "path.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "path.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "path.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
