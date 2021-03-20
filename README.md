# tekline

This repository explores a delegated approach for running pipelines. This will allow projects to bring their own pipeline by adding a tekton folder containing the pipeline definition.

This repository contains the following folders:
* `kustomize` - the delegate pipeline that will install the actual pipeline that can be used in an event-listener
* `library` - an example setup for shared pipelines and shared tasks to be used by projects
* `tekton` - an example of a bring-your-own pipeline as it would be included in projects

The delegate-pipeline include tasks that require a container image that includes `kubectl`, `kustomize`, `tkn`, `git` and `jq`. A `Dockerfile` for such an image is also included in this repository.

To easily setup the delegate pipeline, you can use the `Makefile`. The command `make install run logs` will install the delegate pipeline in the `tekton-pipelines` namespace, start a pipeline run and will display the logs of the started delegate pipeline. Note that this asumes you kubectl, kustomize and tkn are available.

# Background

The delegate pipeline will create a new namespace in which the resources of the tekton folder will be applied (using kustomize). After that, it will start all installed pipelines. If the namespace already existed, the delegating pipeline will remove any obsolete objects that might be left in the namespace. This is to prevent orphaned pipelines from running.

## Parameters and workspaces

The pipelines are started by providing the below parameters, and should support these. An example can be found in the library folder (which is also used by the tekton example in this repository).

```yaml
spec:
  params:
    - name: git-url
    - name: git-revision
    - name: git-repository-name
    - name: git-push-user-email
  workspaces:
    - name: workspace
```

## Permissions

The delegating pipeline automatically creates a new namespace, including a service account with edit permissions on the newly created namespace. This service account is used when running the pipelines that were installed.

## Secret syncing

In case secrets are required in delegated pipelines, the suggested approach to support these is to have these secrets available in the tekton-pipelines namespace. The tekline implementation will copy over all secrets that have the `tekline.joyrex2001.com/sync-to-delegate=true` label. When copied over, it will remove all labels and annotations, except for annotations that start with tekton.
