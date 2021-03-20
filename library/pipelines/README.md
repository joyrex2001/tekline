# pipelines

This folder contains ready-to-use pipelines. A pipeline that is started by the delegate-pipeline solution is expected to have the following parameters and workspaces, as the delegate-pipeline starts every available pipeline by populating these values.

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