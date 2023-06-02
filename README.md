App Initializer
===============

Simplify new project creation

Arguments or variables : 

| Argument | Variable  | Mandatory | Description  |
|---|---|---|---|
| `--name`  | `APP_INITIALIZER_PROJECT_NAME`  | yes  |  The project name |
| `--version`  | `APP_INITIALIZER_BASE_VERSION`  | no  | The version used  |
| `--module-name`  |  `APP_INITIALIZER_MODULE_NAME` | no  | If wanted a custom module, the name of that module  |


Run : 

```
wget -q -O - "https://raw.githubusercontent.com/pbe-axelor/app-initializer/main/init.sh" | bash -s - --name my-project
```

will create the given project name in the current working directory.