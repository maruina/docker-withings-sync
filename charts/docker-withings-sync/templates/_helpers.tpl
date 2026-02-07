{{/*
Expand the name of the chart.
*/}}
{{- define "docker-withings-sync.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "docker-withings-sync.fullname" -}}
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
{{- define "docker-withings-sync.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels.
*/}}
{{- define "docker-withings-sync.labels" -}}
helm.sh/chart: {{ include "docker-withings-sync.chart" . }}
{{ include "docker-withings-sync.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels.
*/}}
{{- define "docker-withings-sync.selectorLabels" -}}
app.kubernetes.io/name: {{ include "docker-withings-sync.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Return the secret name to use for Garmin credentials.
*/}}
{{- define "docker-withings-sync.secretName" -}}
{{- if .Values.garmin.existingSecret }}
{{- .Values.garmin.existingSecret }}
{{- else }}
{{- include "docker-withings-sync.fullname" . }}
{{- end }}
{{- end }}

{{/*
Return the PVC name to use.
*/}}
{{- define "docker-withings-sync.pvcName" -}}
{{- if .Values.persistence.existingClaim }}
{{- .Values.persistence.existingClaim }}
{{- else }}
{{- include "docker-withings-sync.fullname" . }}
{{- end }}
{{- end }}
