# Økonomisk Dashboard — Team Helse

Interaktivt personlig økonomidashboard for budsjett, lån og oppussingsregnskap.

![Dashboard](https://img.shields.io/badge/status-aktiv-brightgreen) ![HTML](https://img.shields.io/badge/tech-HTML%2FJS%2FChart.js-blue)

## Funksjoner

### Oversikt
- Samlekort med gjeld, inntekt, terminbeløp og oppussingsoverforbruk
- Månedlig budsjett vs. regnskap (alle 12 måneder)
- Månedlig saldo-graf
- Lånoversikt med nøkkeltall
- Oppussing akkumulert vs. budsjett

### Månedlig budsjett
- **12 måneder** med egne faner — klikk på måned for å redigere
- Budsjett og regnskap per person (Helene / Petter)
- Legg til / slett utgiftskategorier
- Kopier budsjett til alle måneder med ett klikk
- Automatisk beregning av differanse og saldo
- Årsoversikt med budsjett vs. regnskap-graf

### Oppussing
- Editerbar tabell med leverandører × 12 måneder
- Legg til / slett leverandører
- Topp-leverandør doughnut-chart
- Månedlig forbruksgraf
- Akkumulert vs. budsjett

### Lån
- **Alle parametere redigerbare**: saldo, rente, løpetid, terminbeløp, fars bidrag
- Tre alternativer beregnes i sanntid:
  - Alt 1: Lavere betaling
  - Alt 2: Kortere løpetid
  - Alt 2B: Med fars bidrag
- Nedbetalingskurver og rentekostnadssammenligning

## Lagring
- **Lagre**-knappen lagrer all data til nettleserens localStorage
- **Last inn** henter lagrede data tilbake
- Data lastes automatisk ved oppstart hvis tilgjengelig

## Kjøre lokalt

### Alternativ 1: Dobbeltklikk
Åpne `index.html` direkte i nettleseren.

### Alternativ 2: App-modus (anbefalt)
Bruk `start.bat` for å åpne i Chrome/Edge uten adressefelt:

```bat
start.bat
```

## Teknologi
- Standalone HTML — ingen bygg, ingen avhengigheter
- [Chart.js 4.4](https://www.chartjs.org/) for grafer
- [Outfit](https://fonts.google.com/specimen/Outfit) + [JetBrains Mono](https://fonts.google.com/specimen/JetBrains+Mono) fonter
- localStorage for persistens
- Responsivt design

## Lisens
Privat bruk.
