---
layout: post
title: "Angular Standarddirektiven"
categories: [Angular, Direktiven]
lang: de_DE
---

[Hier](/de{% post_url 2019-03-07-das-tabs-modul %}) haben wir unser erstes etwas umfangreicheres Modul geschrieben. Jetzt schauen wir uns Direktiven an.

Direktiven sind Module ohne Template. Oder anders ausgedrückt: Module fügen unserer Anwendung Funktionalität hinzu. Und Angular bringt von Haus aus einige Direktiven mit. Wir sehen uns ein paar davon an.

<!--more-->

Standarddirektiven sind Teil des _CommonModule_-Moduls. Dieses muss explizit eingebunden werden, sofern man nicht bereits das _BrowserModule_ eingebunden hat (wie zum Beispiel im _AppModule_):

```typescript
import { CommonModule } from '@Angular/common';
@NgModule( {
  imports: [CommonModule],
})
```

Strukturelle Direktiven - also Direktiven, die den DOM ändern - werden mit einem vorangestellten * geschrieben.

## NgIf

NgIf blendet Elemente ein oder aus.

{% raw %}
```html
<div *ngIf="visible">
  Visible: {{visible}}
</div>
```
{% endraw %}

_Visible_ kann eine boolsche Variable sein, eine Bedingung oder eine Modulmethode.

Etwas umständlicher wird es beim _else_-Fall, also wenn in Abhängigkeit einer Bedingung ein Element ausgeblendet und ein anderes eingeblendet werden soll.

{% raw %}
```hmtl
<div *ngIf="visible;else default_template">
  Visible: {{visible}}
</div>

<ng-template #default_template>
  Visible: {{visible}}
</ng-template>
```
{% endraw %}

## NgSwitch

Wenn NgIf nicht ausreicht, dann gibt es alternativ NgSwitch (hier am gleichen Beispiel, aber natürlich gäbe es sinnvollere Anwendungsfälle):

{% raw %}
```html
<div [ngSwitch]="visible">
  <div *ngSwitchCase="visible === true">Visible: {{visible}}</div>
  <div *ngSwitchCase="visible === false">Visible: {{visible}}</div>
</div>
```
{% endraw %}

Ebenfalls möglich ist ein Default-Wert:

```html
<div *ngSwitchDefault></div>
```

## NgClass

Wenn NgIf ganze Elemente zur Seite hinzufügt, dann fügt NgClass Klassen zu Elementen hinzu. Oder entfernt dies respektive. Hier wird ``.warning`` gesezt, sobald ``hasWarning()`` _true_ liefert:

```html
<div [ngClass]="{ 'warning' : hasWarning() }">
```

Es ist auch möglich, mehrere _Classname : condition_-Blöcke mit Komma getrennt anzufügen. Vielleicht lohnt es sich in manchen Fällen auch, die NgStyle-Direktive zu verwenden.

## NgFor

Diese Direktive ist das Mittel der Wahl für die Darstellung von Listen. Angenommen wir haben eine Controller-Variable namens ``entries`` als Array von Strings, dann zeigen wir den Inhalt an wie folgt:

{% raw %}
```html
<ul>
  <li *ngFor="let entry of entries"> {{ entry }}</li>
</ul>
```
{% endraw %}

Es gibt noch ein paar nette Erweiterungen:

{% raw %}
```html
<ul>
  <li *ngFor="let entry of entries; let n = index"> Entry {{ n+1 }}: {{ entry }}</li>
</ul>
```
{% endraw %}

{% raw %}
```html
<ul>
  <li *ngFor="let entry of entries; let isEven=even; let isOdd=odd">
     <div [ngClass]="{ 'even': isEven, 'odd': isOdd}">{{ entry }}</div>
   </li>
</ul>
```
{% endraw %}

Und zuletzt:

{% raw %}
```html
<ul>
  <li *ngFor="let entry of entries; let isLast=last">
     <div [ngClass]="{ 'last-element': isLast }">{{ entry }}</div>
   </li>
</ul>
```
{% endraw %}

Weiter geht es [hier](/de{% post_url 2019-03-16-angular-pipes %}).
