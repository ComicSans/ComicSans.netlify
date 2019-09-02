---
layout: post
title: "Angular 7 unter Windows installieren"
categories: [Angular]
lang: de_DE
---

Angular ist ein JavaScript-Framework, mit dessen Hilfe schnell moderne Webanwendungen erstellt werden können. Zusammen mit [Vue.js](https://vuejs.org) und [React.js](https://reactjs.org) ist es eines der aktuell beliebtesten Frameworks.

Wir werden uns über mehrere Beiträge hinweg ansehen, wie man Angular (unter Windows) installiert und wie man sich in Angular-Projekten zurecht findet.

<!--more-->

Angular benötigt [Node.js](https://nodejs.org/de/). Node.js ist, kurz gesagt, JavaScript ohne Browser.

Die Installation erfolgt entweder per [Chocolatey](https://chocolatey.org):

```bash
choco install nodejs.install
npm install -g @angular/cli
```

...oder wir gehen den langen Weg und laden die im Moment aktuelle Version 10.15.1. LTS von [hier](https://nodejs.org/dist/v10.15.1/node-v10.15.1-x64.msi) herunterladen.

{% picture default /images/angular-install-node.png alt="install node" %}

Wichtig sind neben der _Node.js runtime_ der _npm package manager_ und _Add to PATH_:

{% picture default /images/angular-install-node2.png alt="install node 2" %}

Per npm kann man Module nachrüsten und Angular installieren. Wer einmal Linux und apt-get verwendet hat, der kennt das Prinzip. Die PATH-Anpassung erleichtert uns die Verwendung von Node.

Bei der händischen Installation taucht im Startmenü der Eintrag _Node.js Shell_ oder _Eingabeaufforderung mit Node.js_ auf. Sonst reicht die "normale" Eingabeaufforderung".

Mit folgendem Befehl sollten wir prüfen, ob alles geklappt hat:

```bash
node -v
```

Steht da die eben installierte Version von Node.js, dann ist alles gut. Kommt eine Fehlermeldung, dann wurde wahrscheinlich die Pfad-Variable nicht korrekt gesetzt - da hilft es, die Eingabeaufforderung neu zu starten oder eben besagte _Node.js shell_ zu benutzen.

Sofern noch nicht geschehen, installieren wir angular jetzt als globales Node-Modul:

```bash
npm install -g @angular/cli
```

## Was haben wir gelernt?

- Chocolatey ist ein nettes Tool
- Node.js ist schnell installiert
- Angular kommt als Node-Modul

Weiter geht es [hier](/de{% post_url 2019-02-23-die-erste-angular-app %}).
