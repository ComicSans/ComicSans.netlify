---
layout: post
title: "Zusammenfassung der Angular Building Blocks"
categories: [Angular, Architektur]
lang: de_DE
---

Es wird Zeit, einmal alles, was wir bislang gemacht haben, zusammenzufassen. Wir sprechen also wieder über TypeScript, Angular, Komponenten, Services, Module und so weiter. Zumindest die letzteren genannten sind die klassischen Building Blocks der Angular Plattform.

<!--more-->

So sieht eine neue Angular-Anwendung aus:
{% picture default /images/angular-summary-structure.png alt="Struktur der Anwendung" %}

Der Angular-Teil enthält dabei die Module, Routen, Komponenten und Services. Der Bootstrap-Teil kümmert sich um die Art der Anwendung und dafür, dass alles läuft.

Angular selbst lebt, grob zusammengefasst, in den Annotationen über Typescript-Klassen:
{% picture default /images/angular-summary-annotations.png alt="Angular in der Anwendung" %}

Weitere Annotationen neben ``@NgModule`` sind ``@Component`` oder auch ``@Pipe``, die wir alle aus vorherigen Beiträgen kennen. Ein wesentlichen Konzept ist die Dependency Injection, mittels derer Services über den Konstruktor in die Klassen gereicht werden:
{% picture default /images/angular-summary-component.png alt="Komponenten in der Anwendung" %}

Jetzt ist übrigens ein guter Moment, um einen Blick auf [die Architektur von Angular](https://angular.io/guide/architecture) zu werfen.

Die nächsten Themen sind dann Routing, HTTP-Services, RxJS und Tests.

Weiter geht es [hier](/de{% post_url 2019-03-19-forms-in-angular %}).
