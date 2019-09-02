---
layout: post
title: "Formulare in Angular"
categories: [Angular, Formulare]
lang: de_DE
---

Bevor es mit den komplexeren (und theoretischeren) Themen losgeht, reden wir über Formulare. Die trifft man immerhin häufig genug im Netz an, damit sie einen eigenen Beitrag wert sind. Und es ist ein schöner Übergang zum Thema HTTP-Services bzw. die Anbindung vom Server-Backend. Wir nehmen dazu wieder das Blog-Beispiel von [hier](/de{% post_url 2019-02-26-eine-erste-blog-anwendung %}) und erstellen ein Formular, um neue Beiträge zu erstellen.

<!--more-->

Angular bietet zwei Möglichkeiten, ein Formular zu erstellen:

- Reaktiv, die Erstellung erfolgt in TypeScript und ist an ein Model geknüpft
- Templatebasiert, die Erstellung erfolgt in HTML

_Reactive Forms_ sind flexibler, aber meist recht ein _template driven form_ aus. Daher schauen wir uns die jetzt zuerst an. Aber je dynamischer die Formulare werden müssen, je komplexer die Validierungsregeln, desto mehr lohnt sich der Einsatz von reaktiven Formularen.

Zuerst mus die Forms-API installiert werden. Das geht so:

```bash
npm install @angular/forms --save
```

Das stellt uns die Module ``FormsModule`` (für die Template-Driven-Geschmacksrichtung) und ``ReactiveFormsModule`` (sic) bereit.

```typescript
import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms'

import { AppComponent } from './app.component';

@NgModule({
  declarations: [
    AppComponent
  ],
  imports: [
    BrowserModule,
    FormsModule,
    ReactiveFormsModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
```

Unser Formular muss keine Schönheitspreise gewinnen, von daher reicht uns das hier aus:

```html
<form novalidate (ngSubmit)="saveBlogEntry(form.value)" #form="ngForm">
  <p>
    <label for="title">Titel:</label>
    <input id="title" type="text" name="title" [(ngModel)]="blogEntry.blogTitle" required minlength="3"/>
  </p>
  <p>
    <label for="content">Inhalt:</label>
    <input id="content" type="text" name="content" [(ngModel)]="blogEntry.blogText" required/>
  </p>
  <button type="submit" name="submit" [disabled]="!form.valid">Speichern</button>
</form>

```

``[(ngModel)]="blogEntry.blogTitle"`` ist die Schreibweise für ein _Two-Way-Data-Binding_, was bedeutet: die entsprechende Eigenschaft des ``blogEntry`` der View wird direkt an das Model im Controller-Code gebunden. Änderungen an der View verändern das Model dort und Änderungen im Controller verändern die Anzeige in der View automatisch.

Das Gegenstück ist das _One-Way-Data-Binding_ - also das gleiche, aber nur in eine Richtung. Nämlich vom Controller in die View. Das ist schneller und reicht z.B. aus, um die Anzeige zu initialisieren. Dafür müssten wir die Speichern-Methode etwas erweitern und die Eigenschaften zuweisen. Die Schreibweise hierfür wäre übrigens ``[ngModel]="blogEntry.blogTitle"``.

Der Komponente spendieren wir noch zugehörige Save-Methode und ein notdürftiges Model:

```typescript
import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-add-blog-entry',
  templateUrl: './add-blog-entry.component.html',
  styleUrls: ['./add-blog-entry.component.css']
})
export class AddBlogEntryComponent {

  blogEntry: any;

  constructor() {
    this.blogEntry = {
      blogTitle: "Neuer Titel",
      blogText: "Neuer Inhalt"
    };
  }

  saveBlogEntry(blogEntry: any) {
    console.log(this.blogEntry);
  }
}
```

Erwähnenswert sind hier folgende Dinge:

- ``#form="ngForm"`` bindet unsere #form-Variable an das dem Formular inherente Forms-Objekt. Das gibt es, weil wir das FormsModule importiert haben - alle Formulare der Anwendung sind nun automatisch ngForms-Formulare.
- ``[disabled]="!form.valid"`` nutzt diese Variable und setzt entsprechend das Disabled-Attribut des Submit-Buttons. Das Formular ist valide, wenn alle Validatoren erfüllt sind. Ein validator ist z.B. das ``required`` an den Inputs. Oder ``minlength="3"``. Über ``form.hasError()`` kann man auf verletzte Validierungsregeln prüfen.
- Ebenfalls an den Input sehen wir ``ngModel`` - das ist das Schlüsselwort, um ein Element dem Forms-Model zuzuweisen. Wir haben also in jedem Formular ein zugrunde liegendes ``ngForm``. Jedes mit ``ngModel`` ausgezeichnete Input wird diesem nun als weitere Eigenschaft hinzugefügt. Hierbei liefert der ``name``-Tag den Namen der Eigenschaft.

Weiter geht es [hier](/de{% post_url 2019-04-02-rxjs %}).
