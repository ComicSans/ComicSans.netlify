---
layout: post
title: "Angular Pipes"
categories: [Angular, Pipes]
lang: de_DE
---

[Hier](/de{% post_url 2019-03-15-standard-direktiven %}) ging es um Direktiven, die das Angular Framework von Haus aus mitbringt. Wir erinnern uns: Direktiven sind Module ohne eigenes Template, die in der View eingebaut werden können. Heute reden wir über andere kleine Helfer für die View-Logik: Pipes.

<!--more-->

Pipes greifen in die Darstellungslogik ein, indem sie Werte vor dem Rendern (also dem Anzeigen auf der Seite) verändern. Man bearbeitet also nicht die Model- oder Controllervariablen direkt, sondern beeinflusst deren Darstellung.

Das beste Beispiel hierfür ist ein Datum. Im Modul-Code würde die zugehörige Variable wohl als Date-Objekt gespeichert werden. Stellt man dieses nun in der View dar, so greift die eigentlich toString-Methode des Objekts und das Datum wird angezeigt. Leider nicht in einem Format, das uns direkt weiterbringt:

_<script>document.write(Date.now())</script>_

Man könnte jetzt natürlich im Controller eine Methode definieren, die ein vorhandenes Date-Objekt als String richtig formatiert. Aber dann würde man reine View-Logik mit der Applikationslogik vermischen und das wollen wir vermeiden.

Also Pipes. Die hängen wir mit dem Pipe-Symbol an die entsprechende Variable an:

{% raw %}
```html
{{ Date.now() | date:'fullDate' }}
```
{% endraw %}

Dies führt zur korrekten Darstellung.

# Framework-Pipes

Angular liefert einige Pipes mit, ein paar davon wollen wir uns mal ansehen.

## Array-Funktionen

``expression | slice:start[:end]``

Nimmt Teile eines Arrays (beginnend mit _start_). Optional gibt es auch einen End-Index. Funktioniert super mit \*ngFor. Und klappt auch mit Strings (als Char-Array). Negative Startwerte zählen vom Ende des Arrays.

## Number-Formatierung

``expression | number:Format[:locale]`` - wobei _Format_ in der Form "{minIntegerDigits}.{minFractionDigits}-{maxFractionDigits}" erwartet wird. Ach: ``-2.5 | number:'1.0-0'`` liefert übrigens - anders als Math.round() - _-3_.

``expression | percent:Format`` zeigt Werte als Prozent an.

``expresison | currency:'EUR'`` verwendet man für Geldbeträge. Arbeitet gut mit einem Formatstring zusammen: ``2.99 | currency:'EUR':true:'1.2-2'`` liefert _2.99 €_.

## Stringtransformation

``expression | uppercase`` und ``expression | lowercase`` wandeln einen String in Groß- bzw. Kleinbuchstaben um.

## Objekttransformationen

``expression | json`` zeigt ein Objekt als JSON-String an. Damit verbunden ist die Pipe ``keyvalue`` nützlich, also:
``expression | keyvalue | json``. Hier iteriert man über die einzelnen Keys und zugehörigen Values (also die Membervariablen und ihren Wert).

``expression | async`` übernimmt die Anmeldung beim Promise, sofern Werte asynchron geladen werden. Das ist aber ein eigenes Kapitel irgendwann später.

# Eigene Pipes

Eigene Pipes sind schnell erstellt:

```typescript
import { Pipe, PipeTransform } from '@angular/core';
@Pipe({
  name: 'pipeName' // der Name der Pipe, analog z.B. "json" usw.
})
export class CustomPipe implements PipeTransform {
  transform(value: any) {
    //...
  }
}
```

Danach muss diese noch im Hauptmodul registriert werden und steht von da an allen Komponenten zur Verfügung. Kompliziert wird es, sobald die Pipe Arrays oder Objekte bearbeiten soll, aber Details überlasse ich der offiziellen Doku: [https://angular.io/guide/pipes#pure-and-impure-pipes](https://angular.io/guide/pipes#pure-and-impure-pipes).

Weiter geht es [hier](/de{% post_url 2019-03-17-services %}).
