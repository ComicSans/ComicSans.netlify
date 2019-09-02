---
layout: post
title: "Unsere erste Angular-Anwendung"
categories: [Angular]
lang: de_DE
---

Im [letzten Beispiel](/de{% post_url 2019-02-23-angular-8-unter-windows-installieren %}) haben wir alle Vorbereitungen getroffen, um Angular zu benutzen. Jetzt wollen wir die erste App schreiben.

<!--more-->

Ein paar Worte zur Nomenklatur... Angular unterscheidet zwischen _workspaces_ und _projects_. Ein Projekt ist eine Sammlung von zusammengehörigen Dateien (also eine Angular-App, eine Library oder Testdateien). Ein Workspace kann dabei mehrere Projekte enthalten.

Man entwickelt also immer in einem Workspace. So einen wollen wir uns erstellen. Das geht über die Kommandozeile so:

```bash
ng new my-app
```

Die ganzen Abfragen bestätigen wir am besten immer mit Enter, um die Standard-Konfiguration zu haben. Letztlich heißt das, dass wir nicht den Angular-Router benutzen und CSS als Format für Style Sheets. Der Router mappt die Anzeige auf den aktuellen Pfad im Browser. Aber das schauen wir uns später an.

_ng_ ist das Befehlszeilen-Tool von Angular. Was das alles kann, das sehen wir, wenn wir einmal nur ```ng``` eintippen:

```
Available Commands:
 add Adds support for an external library to your project.
 build (b) Compiles an Angular app into an output directory named dist/ at the given output path. Must be executed from within a workspace directory.
 config Retrieves or sets Angular configuration values in the angular.json file for the workspace.
 doc (d) Opens the official Angular documentation (angular.io) in a browser, and searches for a given keyword.
 e2e (e) Builds and serves an Angular app, then runs end-to-end tests using Protractor.
 generate (g) Generates and/or modifies files based on a schematic.
 help Lists available commands and their short descriptions.
 lint (l) Runs linting tools on Angular app code in a given project folder.
 new (n) Creates a new workspace and an initial Angular app.
 run Runs an Architect target with an optional custom builder configuration defined in your project.
 serve (s) Builds and serves your app, rebuilding on file changes.
 test (t) Runs unit tests in a project.
 update Updates your application and its dependencies. See https://update.angular.io/
 version (v) Outputs Angular CLI version.
 xi18n Extracts i18n messages from source code.

For more detailed help run "ng [command name] --help"
```

Wir haben uns aber für unser Beispiel erst einmal für _new_ entschieden. Und die neue App soll _my-app_ heißen.

Weiter geht es hiermit:

```bash
cd my-app
ng serve --open
```

Erst wechseln wir in den neuen Workspace und dann lassen wir uns die App anzeigen. Das dauert etwas, weil beim ersten Mal noch einiges heruntergeladen und gebaut werden muss. Danach geht der Browser auf und zeigt uns die lokale Angular-App unter _http://localhost:4200_ an:

{% picture default /images/angular-my-app.png alt="die erste app" %}

Schön ist zwar anders, aber wir haben schon Einiges geschafft. Schauen wir mal rein!

Dazu brauchen wir einen Editor. Einen Blick wert sind auf jeden Fall [Visual Studio Code](https://code.visualstudio.com) und [Atom](https://atom.io).

Erste Anlaufstelle ist _./src/app/app.component.ts_:

{% picture medium /images/angular-app-first-component.png alt="die erste component" %}

Hier sehen wir eine TypeScript-Klasse für die Hauptkomponente unserer App und einen Component-Decorator, der Angular noch ein paar Details mitgibt, was unsere Klasse braucht. Ein Template bzw. eine View zum Beispiel und ein paar Styles. Wichtig ist außerdem der Selector, den schauen wir uns an anderer Stelle einmal an.

## Was haben wir gelernt?

- Atom und VSCode sind einen Versuch wert
- Angular wird über die Kommandozeile gesteuert, das macht der ``ng``-Befehl
- ``ng serve`` baut die Webseite
- Angular-Anwendungen sind in Komponenten aufgeteilt
- TypeScript ist die Sprache der Wahl für moderne Angular-Anwendungen

Weiter geht es [hier](/de{% post_url 2019-02-26-eine-erste-blog-anwendung %}).
