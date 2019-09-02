---
layout: post
title: "Unsere erste ernsthafte Angular-Anwendung"
categories: [Angular]
lang: de_DE
---

Im [ersten Beispiel](/de{% post_url 2019-02-23-angular-8-unter-windows-installieren %}) haben wir alle Vorbereitungen getroffen, um Angular zu benutzen.
[Danach](/de{% post_url 2019-02-23-die-erste-angular-app %}) haben wir uns eine neue Anwendung angesehen.

Heute gehen wir mehr in die Tiefe und erstellen eine etwas umfangreichere Anwendung. Dank Ruby on Rails ist das _Hello World_ der Webframeworks mittlerweile ein Blog. Also los!

<!--more-->

Wir starten mit

```bash
ng new blog
cd blog
```

...und zweimal Enter für die Standardkonfiguration. Wir haben jetzt eine ziemlich leere Angular App namens "blog" und sind auch gleich in das entsprechende Verzeichnis gewechselt.

Weiter geht's, denn wir brauchen eine Möglichkeit, einen Blogeintrag zu schreiben und anzuzeigen.

## Components

Wir fangen mit der Anzeige an, wo wir doch gerade auf der Kommandozeile unterwegs sind. Also:

```bash
ng generate component blog-entry
```

Das erzeugt uns eine sogenannte Komponente. Den Begriff kennen wir schon aus den Annotationen vom letzten Beispiel, aber diesmal schreiben wir selbst eine. Eine Komponente bündelt zusammengehörigen Code. Wir wollen in der blog-entry-Komponente alles unterbringen, was wir zur Anzeige eines Blogeintrags brauchen.

Komponenten hängen immer mit einer View zusammen und verbinden Anwendungslogik, Services und View. Das unterscheidet sie von Modulen, denn bei Modulen handelt es sich um eine Sammlung von Komponenten. Module regeln, welche Komponenten miteinander sprechen können, steuern Dependency Injection und sorgen überhaupt dafür, dass die Anwendung modular aufgebaut werden kann.

Obiger Befehl hat uns ein paar Dateien erzeugt und unser Projekt schaut jetzt so aus:

{% picture medium /images/angular-first-blog-structure.png alt="struktur der bloganwendung" %}

Ein paar Worte zur Farbgebung im Screenshot: es gibt dunkelgraue Einträge, weiße, gelbe und grüne. Das liegt daran, dass Angular die Versionsverwaltung Git benutzt und bei dem ersten Befehl (``ng new blog``) ein neues Git-Repo angelegt hat und den Stand commited hat. Der nächste Befehl (``ng generate component``) hat neue Dateien angelegt (das sind die Grünen), diese aber nicht commited und außerdem eine Datei verändert (das ist die Gelbe). Was uns auch zur Frage bringt, warum da eine Datei verändert wurde...

Schauen wir mal in besagte Datei rein, die ``app.module.ts``:

```typescript
import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppComponent } from './app.component';
import { BlogEntryComponent } from './blog-entry/blog-entry.component';

@NgModule({
  declarations: [
    AppComponent,
    BlogEntryComponent
  ],
  imports: [
    BrowserModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
```

Hier sehen wir einen ``import``-Eintrag für die BlogEntryComponent, unsere neue Komponente. Dieser Eintrag macht die neue Komponente in der Angular-App namens "blog" bekannt, wir können sie also verwenden. Gleiches gilt für den ``declarations``-Teil etwas weiter unten.

Die eigentlichen Bestandteile der Komponente liegen im Ordner src\app\blog-entry und sind:
- eine CSS-Datei für das Styling
- eine HTML-Datei für die View
- eine SPEC-Datei für Tests
- und Component-Datei für den Controller

Aufmerksame Beobachter merken: uns fehlt noch ein Model für das M in MVC. Das erstellen wir per Hand und mit dem Editor in src\app\blog-entry, nennen es ``blog-entry.ts`` und füllen es mit folgendem, beeindruckenden Inhalt:

```typescript
export class BlogEntry {
  title: string;
  text: string;
}
```

Ein Blogbeitrag besteht also aus Titel und Text.

Die Model-Datei müssen wir an den relevanten Stellen importieren, damit wir sie benutzen können. "Relevant" bedeutet:

- src\app\app.component.ts, die Hauptkomponente unserer Angular-App
- src\app\blog-entry\blog-entry.component.ts, der Controller der neuen BlogEntry-Komponente

Die Dateien sehen dann aus wie folgt:

```typescript
// app.component.ts
import { Component } from '@angular/core';
import {BlogEntry} from './blog-entry/blog-entry';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css'],
})
export class AppComponent {
  title = 'blog';

  entries: Array<BlogEntry> = [];

  createBlogEntry(title: string, text: string) {
    const entry = new BlogEntry();
    entry.title = title;
    entry.text = text;
    this.entries.push(entry);
  }
}

```

Ich habe gleich eine ``createBlogEntry``-Methode eingefügt, die brauchen wir später.

Und bei der Komponente schaut es aus wie folgt:

```typescript
// blog-entry.component.ts
import { Component, Input } from '@angular/core';
import { BlogEntry } from './blog-entry';

@Component({
  selector: 'app-blog-entry',
  templateUrl: './blog-entry.component.html',
  styleUrls: ['./blog-entry.component.css']
})
export class BlogEntryComponent {
  @Input() entry: BlogEntry;
}
```

Sofern hier etwas von "OnInit" steht, das brauchen wir aktuell nicht, daher können wir das löschen. Und "Input", dazu kommen wir noch.

## Die View

Kümmern wir uns jetzt um die Anzeige. Wenn wir ``ng serve --open`` aufrufen, sehen wir unsere Blog-Anwendung im Browser. Will heißen: bis jetzt sehen wir eigentlich nix außer dem Angular-Logo, das da zu Demo-Zwecken angezeigt wird.

Diese Anzeige stammt aus der Datei ``src\app\app.component.html``, die uns freundlicherweise in der ersten Zeile direkt auf diesen Umstand hinweist.

Ersetzen wir den Inhalt doch einmal mit:

```html
<h1>Mein Blog</h1>

<app-blog-entry *ngFor="let entry of entries" [entry]="entry">
</app-blog-entry>
```

Nach einem Reload der Seite schaut es nicht viel besser aus. Das rote Logo macht einem "Mein Blog" Platz, aber viel ist da noch nicht gewonnen. Warum ist das so?

Schauen wir uns den Block mit ``app-blog-entry`` an. Das ist unsere Komponente! Folgender Eintrag macht das möglich:

```typescript
// blog-entry.component.ts
// ...
@Component({
  selector: 'app-blog-entry',
})
//...
```

Der Block ``app-blog-entry`` wird durch den Inhalt der View der Komponente ersetzt (``blog-entry.component.html``). Wir sehen aber nichts, fragt sich ...warum?

``NgFor`` iteriert über ein Array (in unserem Fall "entries") und zeigt für jeden Eintrag einmal die View der Komponente an. Wir haben nur ein Problem: wir haben keine Einträge im Array und daher sehen wir auch nichts.

Aber das lässt sich ändern, geben wir der App-Komponente doch einen Konstruktor und erstellen uns ein paar Dummy-Blogeinträge!

Damit sieht er so aus:

```typescript
// app.component.ts
import { Component } from '@angular/core';
import { BlogEntry } from './blog-entry/blog-entry';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css'],
})
export class AppComponent {
  title = 'blog';

  entries: Array<BlogEntry> = [];

  constructor() {
    this.createBlogEntry("Erster Eintrag", "Ich bin der Eintragstext des ersten Eintrags!");
    this.createBlogEntry("Zweiter Eintrag", "Einen zweiten Eintrag brauchen wir auch!");
  }

  createBlogEntry(title: string, text: string) {
    const entry = new BlogEntry();
    entry.title = title;
    entry.text = text;
    this.entries.push(entry);
  }
}
```

Die Seite neu laden und... es hat sich etwas getan!

{% picture medium /images/angular-first-blog-blog-entry-works.png alt="blog entry works" %}

Naja, immer noch Raum für Verbesserung. Aber immerhin wissen wir, dass das Blog-Entry funktioniert...

Woher kommt die Anzeige? Aus der View der Komponente natürlich. Schauen wir mal in src\app\blog-entry\blog-entry.component.html und wir haben den Schuldigen. Schreiben wir mal das hier rein:

{% raw %}
```html
<!-- src\app\blog-entry.component.html -->
<div class="blog-entry">
  <h2>{{entry.title}}</h2>
  <p>{{entry.text}}</p>
</div>
```
{% endraw %}

Reload... und? Gar nicht mal so schlecht.

## Was haben wir gelernt?

- Komponenten bündeln Code
- die ng-Cli hilft uns bei der Anlage einer Komponente
- Selectoren bestimmen das HTML-Element, in dem eine Komponente angezeigt wird
- NgFor iteriert über Array-Elementen


Weiter geht es [hier](/de{% post_url 2019-03-07-das-tabs-modul %}).
