---
layout: post
title: "Das Tabs-Modul für Angular"
categories: [Angular]
lang: de_DE
---

Wir haben unseren ersten Schritte in der Angular-Welt bereits zurückgelegt (siehe [unser Blog](/de{% post_url 2019-02-26-eine-erste-blog-anwendung %})).

Damit sind wir bereit für Module und Komponenten mit etwas mehr Komplexität: das Tabs-Modul.

{% picture default /images/angular-tabs-module-2.png alt="Preview der Tabs" %}

Den Quellcode zu diesem Beispiel findet Ihr [hier](https://github.com/ComicSans/Angular-Playground) auf GitHub.

<!--more-->

Wir brauchen einen neuen Workspace und erstellen darin zwei Komponenten (_tabs_ und _tabs-demo_) und ein Modul. Über das Warum reden wir gleich. Los geht's:

```bash
ng new AngularDemo
cd AngularDemo
ng generate component tabs
ng generate module tabs
ng generate component tabs-demo
```

Das ergibt folgende Verzeichnisstruktur:

{% picture medium /images/angular-tabs-module-1.png alt="Grundstruktur der Anwendung" %}

Mit ``ng serve --open`` können wir uns die App im Browser anzeigen lassen. Bei jedem Speichern einer Quellcode-Datei wird die Seite nun automatisch aktualisiert.

## Die Komponenten

Wir haben weiter oben zwei Komponenten erstellt. Diese wollen wir uns jetzt einmal im Detail ansehen.

### TabsDemo

Was machen die Komponenten? _tabs-demo_ zeigt die Funktionalität des Tabs-Moduls. Ich will in späteren Kapiteln weitere Module erstellen und nicht jedes mal einen neuen Angular-Workspace anlegen. Daher verweise ich aus der _AngularDemo_-App auf die jeweiligen Demo-Module. Das _Tabs_-Modul ist also nur das erste von mehreren.

Entsprechend ersetzen wir den  Inhalt der _src\app\app.component.html_ wie folgt:

{% raw %}
```html
<h1>Tabs</h1>
<app-tabs-demo></app-tabs-demo>
```
{% endraw %}

Das zeigt uns den Inhalt der Tabs-Demo-Komponente an, sobald wir auf die Startseite unserer Anwendung gehen.

Spannend ist sonst nur noch das Template unter _src\app\tabs-demo\tabs-demo.component.html_:

{% raw %}
```html
<angular-tabs>
  <angular-tab title="First Tab">
    This is the first tab!
  </angular-tab>
  <angular-tab title="Second Tab">
    This is the second tab!
  </angular-tab>
</angular-tabs>
```
{% endraw %}

Ziel ist es, zwei Tabs mit unterschiedlichen Inhalt anzuzeigen, welcher beim Klick auf den jeweiligen Header wechselt.

Wie wir sehen, nutzen wir hierfür einen Selektor namens _angular-tab_, umgeben von _angular-tabs_. Schauen wir uns einmal an, wo das herkommt.

### AngularTab und AngularTabs

Unser erster Weg führt uns auch hier in die TypeScript-Datei der Komponenten, _src\app\tabs\tabs.component.ts_:

{% raw %}
```typescript
import {Component, ContentChildren, Input, QueryList, AfterContentInit} from '@angular/core';

/**
 * Implementing a single tab
**/
@Component({
  selector: 'angular-tab',
  template: `<div *ngIf='active' class='tab-content'>
                 <ng-content></ng-content>
             </div>`
})
export class TabComponent {
  active: boolean;
  @Input() title;
  constructor() {
    this.active = false;
  }
}

/**
 * Implementing the tabs component to display one or more tabs
**/
@Component({
  selector: 'angular-tabs',
  styleUrls: ['tabs.component.css'],
  templateUrl: 'tabs.component.html'})
export class TabsComponent implements AfterContentInit {

  @ContentChildren(TabComponent)
  tabs: QueryList<TabComponent>;

  ngAfterContentInit() {
    this.tabs.first.active = true;
  }

}
```
{% endraw %}

Gehen wir das einmal der Reihe nach durch, die Imports zuerst.

Wir importieren ``Component, ContentChildren, Input, QueryList, AfterContentInit`` - im Detail:

- ``Component`` weil wir eine Komponenten sind.
- ``ContentChildren`` weil wir das HTML durchsuchen müssen, um alle Tabs zu finden (ContentChildren sind quasi alle Tags innerhalb unserer View).
- ``Input`` ist das Input-Binding. Was soviel heißt, dass wir "von außen" Werte an unsere Komponente mitgeben können. Das sehen wir in der TabsDemo: dort wird das _title_-Attribut gesetzt. Ohne _Input_ hätten wir auf diesen Wert keinen Zugriff.
- ``QueryList`` hängt mit den ContentChildren zusammen.
- ``AfterContentInit`` liefert uns das Event ``ngAfterContentInit()``, welches gefeuert wird, nachdem der Content geladen wurde. Das gehört zum Component-LifeCycle - und den schauen wir uns irgendwann später an. Wichtig ist jedenfalls, dass wir nun mitbekommen, wenn die Komponente geladen wurde. Wir setzen dann den ersten Tab auf "aktiv". Außerdem implementieren wir das ``AfterContentInit``-Interface. Schadet ja nix.

Die Component-Annotation sollte für uns mittlerweile verständlich sein. Wir registrieren uns die Selektoren ``angular-tabs`` und `` angular-tab``. Die Inline-View der tab-Komponente hat ein paar Angular-Details, die wir uns gleich näher ansehen werden. Interessant wird es zunächst aber in der View von angular-tabs unter _src\app\tabs\tabs.component.html_:

{% raw %}
```html
<div class="tabs">
  <ul>
    <li *ngFor="let tab of tabs" [class.active]="tab.active"
                                 (click)="activate(tab)"
                                  class="tab-link">
      <a class="tab-header">{{tab.title}}</a>
    </li>
  </ul>
  <div class="container">
    <ng-content></ng-content>
  </div>
</div>
```
{% endraw %}

Es gibt insgesamt drei Angular-Dinge, die in den Views auffallen:

- die Attribute ``*ngIf``...
- ... und ``*ngFor`` sowie
- der Tag ``ng-content``

``*ngIf`` zeigt den Tag nur an, wenn eine Bedingung erfüllt ist. Diese ist bei uns im Beispiel die Eigenschaft _active_ des Tabs. Ist das ``false``, dann soll der Inhalt des Tabs nicht angezeigt werden.

Den Inhalt selbst erhalten wir von ``ng-content``. Das ist das, was innerhalb des Selektors unserer Komponenten steht - das steht in der _src\app\tabs-demo\tabs-demo.component.html_.

``*ngFor`` durchläuft ein Array und klont den eigenen Tag bei jeder Iteration. Hat das Array _tabs_ also zwei Einträge, so werden zwei ``li``-Tags erzeugt. Das OnClick-Event eines jeden wird mit der ``activate(tab)``-Methode verknüpft. Die gibt es noch nicht, aber das lässt sich ändern:

```typescript
// src\app\tabs\tabs.component.ts
activate(tab_) {
  for (const tab of this.tabs.toArray()) {
    tab.active = false;
  }
  tab_.active = true;
}
```

Wir deaktivieren also alle Tabs und setzen den übergebenen als einzigen auf aktiv. Was dazu führt, dass dessen Inhalt im Tabs-Bereich angezeigt wird.

## Das Tabs-Modul

Das Tabs-Modul bündelt unsere beiden Komponenten. Das erleichtert die Verwendung und stellt außerdem sicher, dass alle direkten Abhängigkeiten zwischen AngularTab und AngularTabs erfüllt werden.

Das Modul sieht so aus:

```typescript
import { NgModule } from '@angular/core';
import { TabsComponent, TabComponent } from './tabs.component';
import { CommonModule } from '@angular/common';

@NgModule({
  declarations: [
    TabsComponent,
    TabComponent
  ],
  imports: [
    CommonModule
  ],
  exports: [
    TabsComponent,
    TabComponent
  ]
})
export class TabsModule { }
```

Über die Einbindung des Tabs-Modul müssen wir uns nicht kümmern, das hat der Befehlszeilenaufruf ganz am Anfang für uns bereits erledigt. Schauen wir zur Sicherheit noch in die _src\app\app,module.ts_:

```typescript
import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppComponent } from './app.component';
import { TabsModule } from './tabs/tabs.module';
import { TabsDemoComponent } from './tabs-demo/tabs-demo.component';

@NgModule({
  declarations: [
    AppComponent,
    TabsDemoComponent
  ],
  imports: [
    BrowserModule,
    TabsModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
```

Die ganzen fehlenden Details (CSS zum Beispiel) findet ihr auf [GitHub](https://github.com/ComicSans/Angular-Playground).

Weiter geht es [hier](/de{% post_url 2019-03-15-standard-direktiven %}).
