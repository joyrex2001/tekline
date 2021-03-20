# tekton

In this folder the pipeline (and its dependencies, e.g. tasks) should be included. The delegate pipeline will create a new namespace, based on the name and branch of the repository. After that it will apply the kustomization file, and run all pipelines that have been created.