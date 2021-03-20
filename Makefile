help:
	@echo "make install  --- install kustomize folder in tekton-pipelines"
	@echo "make run      --- example run of delegate pipeline"
	@echo "make logs     --- display logs of exxample pipelinerun"

install:
	kustomize build kustomize |kubectl apply -f - -n tekton-pipelines

run:
	kubectl delete -f kustomize/test/run.yaml -n tekton-pipelines || true
	kubectl apply -f kustomize/test/run.yaml -n tekton-pipelines

logs:
	tkn pr logs delegate-pipeline-run -n tekton-pipelines -f

.PHONY: help install run logs