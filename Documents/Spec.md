# UFlow doc specification
## File format
YAML

## File Structure
UFlow document consists of the following sections:

- File info section
- User flow section

### File Info Section
File info section is a mapping of the following items:

- title
- project
- summary
- version
- tags
- date
- authors

The following table represents a detail of keys.

| Key name | Value type | Required | Description |
|:---------|:-----------|:---------|:------------|
| title    | string     | Yes      | Title of a user flow. |
| project  | string     | No       | Project name for a user flow. |
| summary  | string     | No       | Summary of a user flow. |
| version  | string     | No       | Version string |
| tags     | sequence of strings | No | List of tags |
| date     | string     | No       | Published date.  Date is written with `yyyy-mm-dd` format. |
| authors  | sequence of strings | No | List of authors |

### User Flow Section
Root element of user flow section is key 'screens'.
'screens' is mapped to list of mappings.
Each element of 'screens' contains the following items:

- id
- name
- summary
- components
- flows

The following table represents a detail of above keys.

| Key name | Value type | Required | Description |
|:---------|:-----------|:---------|:------------|
| id       | string     | Yes      | Identifier of a screen |
| name     | string     | Yes      | Name of a screen |
| summary  | string  | No       | Summary of a screen |
| components | sequence of mappings | No | List of components on a screen |
| flows | sequence of strings | No | List of user flow. |

#### Components
Each element of 'components' consists of UI component summary.
UI Component is described with the following items:

- type
- name

The following table represents a detail of above keys.

| Key name | Value type | Required | Description |
|:---------|:-----------|:---------|:------------|
| type     | string     | Yes      | Component type |
| name     | string     | Yes      | Name of a component |

##### Component Types
Available component type is listed below.

- `label`
- `textfield`
- `button`
- `view`
- `image`

#### Flows
Each element of 'flows' represents a user flow on a screen.
A user flow starts by opening the screen.
Then, user takes some actions, e.g., tap button, type some text, on the screen to perform a desired task.
User flow consists of a set of a user action and a target.

User flow statement is defined as follows.

- `UserFlow` = `Action` (`->` `Action`)
- `Action` = `UserAction` | `SystemAction`
- `UserAction` = `action` `target`
- `SystemAction` = `action` `target`

In `UserAction`, `action` represents a user action such as tap, type, or swipe.
In `SystemAction`, `action` represents an action triggered by the app such as opening a url.
In both `UserAction` and `SystemAction`, `target` represents a component described in 'components', url, or other screen.

In `UserAction`, the following terms is used as `action`

- `tap`
- `type`

In `SystemAction`, the following terms is used as `action`

- `show`
- `open`
- `close`

TODO: Add other actions for `UserAction` & `SystemAction`
