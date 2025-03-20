{{/* vim: set filetype=mustache: */}}
{{/*
PATH full name definition
*/}}
{{- define "path.fullname" -}}
{{- printf "%s-%s" (include "path-stack.fullname" .) .Values.path.name | trunc 52 | trimSuffix "-" -}}
{{- end }}

{{/*
PATH name definition
*/}}
{{- define "path.name" -}}
{{- default .Chart.Name .Values.path.nameOverride | trunc 56 | trimSuffix "-" }}
{{- end }}

{{/*
GUARD full name definition
*/}}
{{- define "guard.fullname" -}}
{{- printf "%s-%s" (include "path-stack.fullname" .) .Values.guard.name | trunc 52 | trimSuffix "-" -}}
{{- end }}

{{/*
GUARD name definition
*/}}
{{- define "guard.name" -}}
{{- default .Chart.Name .Values.guard.nameOverride | trunc 56 | trimSuffix "-" }}
{{- end }}

{{/*
WATCH full name definition
*/}}
{{- define "watch.fullname" -}}
{{- printf "%s-%s" (include "path-stack.fullname" .) .Values.watch.name | trunc 52 | trimSuffix "-" -}}
{{- end }}

{{/*
WATCH name definition
*/}}
{{- define "watch.name" -}}
{{- default .Chart.Name .Values.watch.nameOverride | trunc 56 | trimSuffix "-" }}
{{- end }}