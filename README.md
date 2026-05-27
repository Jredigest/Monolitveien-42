<!DOCTYPE html>
<html lang="no">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Økonomisk Dashboard — Team Helse</title>
<link href="https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@400;500;700&family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.1/chart.umd.min.js"></script>
<style>
*{margin:0;padding:0;box-sizing:border-box}
:root{
  --bg:#0a0c10;--surface:#111419;--raised:#181c24;--border:#222838;--border-hi:#2e3650;
  --text:#dde0ea;--dim:#656b88;--muted:#3a3f58;
  --blue:#4a8df0;--green:#38c484;--red:#e04e4e;--amber:#df9438;--teal:#34b8b0;--purple:#8a6ae0;--pink:#d06090;
  --input-bg:#0d0f14;--input-border:#262d42;--focus:#4a8df0;
}
html{scroll-behavior:smooth}
body{font-family:'Outfit',sans-serif;background:var(--bg);color:var(--text);min-height:100vh}
.grain{position:fixed;inset:0;z-index:0;pointer-events:none;opacity:.02;
  background-image:url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='.8' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)'/%3E%3C/svg%3E");background-size:256px}
.app{position:relative;z-index:1;max-width:1480px;margin:0 auto;padding:24px 20px 80px}
@media(min-width:768px){.app{padding:28px 32px 80px}}

/* ── HEADER ── */
.hdr{display:flex;align-items:center;justify-content:space-between;margin-bottom:32px;padding-bottom:18px;border-bottom:1px solid var(--border)}
.hdr h1{font-family:'JetBrains Mono',monospace;font-size:20px;font-weight:700;letter-spacing:-.5px;
  background:linear-gradient(135deg,var(--blue),var(--teal));-webkit-background-clip:text;-webkit-text-fill-color:transparent}
.hdr-right{display:flex;gap:8px;align-items:center}
.hdr .tag{font-size:10px;color:var(--dim);border:1px solid var(--border);padding:2px 10px;border-radius:16px}
.save-btn{padding:7px 14px;border-radius:8px;font-size:11px;font-weight:600;cursor:pointer;
  border:1px solid var(--green);background:rgba(56,196,132,.1);color:var(--green);font-family:inherit;transition:all .2s}
.save-btn:hover{background:rgba(56,196,132,.2)}
.load-btn{padding:7px 14px;border-radius:8px;font-size:11px;font-weight:500;cursor:pointer;
  border:1px solid var(--border);background:var(--raised);color:var(--dim);font-family:inherit;transition:all .2s}
.load-btn:hover{color:var(--text);border-color:var(--blue)}
.toast{position:fixed;bottom:24px;right:24px;background:var(--green);color:#000;padding:10px 20px;
  border-radius:10px;font-size:12px;font-weight:600;z-index:99;transform:translateY(80px);opacity:0;transition:all .3s}
.toast.show{transform:translateY(0);opacity:1}

/* ── TABS ── */
.tabs{display:flex;gap:2px;margin-bottom:24px;background:var(--surface);border-radius:10px;padding:3px;width:fit-content}
.tab{padding:8px 16px;border-radius:8px;cursor:pointer;font-size:12px;font-weight:500;color:var(--dim);
  transition:all .2s;border:none;background:none;font-family:inherit;white-space:nowrap}
.tab:hover{color:var(--text)}.tab.active{background:var(--raised);color:var(--text);box-shadow:0 2px 10px rgba(0,0,0,.3)}

.panel{display:none;animation:up .3s ease}.panel.active{display:block}
@keyframes up{from{opacity:0;transform:translateY(6px)}to{opacity:1;transform:none}}

/* ── CARDS ── */
.cards{display:grid;grid-template-columns:repeat(auto-fit,minmax(190px,1fr));gap:12px;margin-bottom:20px}
.card{background:var(--surface);border:1px solid var(--border);border-radius:12px;padding:16px 18px;position:relative;overflow:hidden}
.card::before{content:'';position:absolute;top:0;left:0;right:0;height:2px}
.card.c-bl::before{background:var(--blue)}.card.c-gr::before{background:var(--green)}
.card.c-rd::before{background:var(--red)}.card.c-am::before{background:var(--amber)}
.card.c-te::before{background:var(--teal)}.card.c-pu::before{background:var(--purple)}
.card .lbl{font-size:9px;color:var(--dim);text-transform:uppercase;letter-spacing:.7px;margin-bottom:6px}
.card .val{font-family:'JetBrains Mono',monospace;font-size:20px;font-weight:700}
.card .sub{font-size:10px;color:var(--dim);margin-top:4px}
.pos{color:var(--green)}.neg{color:var(--red)}

/* ── CHARTS ── */
.cgrid{display:grid;grid-template-columns:1fr 1fr;gap:14px;margin-bottom:20px}
.cgrid.f1{grid-template-columns:1fr}.cgrid.f3{grid-template-columns:2fr 1fr}
@media(max-width:900px){.cgrid,.cgrid.f3{grid-template-columns:1fr}}
.cbox{background:var(--surface);border:1px solid var(--border);border-radius:12px;padding:18px}
.cbox h3{font-size:13px;font-weight:600;margin-bottom:2px}
.cbox .cs{font-size:10px;color:var(--dim);margin-bottom:12px}

/* ── INPUTS ── */
.isec{background:var(--surface);border:1px solid var(--border);border-radius:12px;padding:20px;margin-bottom:20px}
.isec h3{font-size:13px;font-weight:600;margin-bottom:2px}
.isec .cs{font-size:10px;color:var(--dim);margin-bottom:14px}
.igrid{display:grid;grid-template-columns:repeat(auto-fill,minmax(180px,1fr));gap:10px}
.fld{display:flex;flex-direction:column;gap:3px}
.fld label{font-size:9px;color:var(--dim);text-transform:uppercase;letter-spacing:.5px}
.fld input,.fld select{background:var(--input-bg);border:1px solid var(--input-border);border-radius:6px;
  padding:7px 10px;color:var(--text);font-family:'JetBrains Mono',monospace;font-size:12px;outline:none;transition:border .2s}
.fld input:focus{border-color:var(--focus)}

/* ── TABLES ── */
.tw{background:var(--surface);border:1px solid var(--border);border-radius:12px;padding:18px;margin-bottom:20px;overflow-x:auto}
.tw h3{font-size:13px;font-weight:600;margin-bottom:2px}
.tw .cs{font-size:10px;color:var(--dim);margin-bottom:12px}
table.e{width:100%;border-collapse:collapse;font-size:11px}
table.e th{text-align:left;padding:6px 8px;color:var(--dim);font-size:9px;text-transform:uppercase;
  letter-spacing:.5px;border-bottom:2px solid var(--border);white-space:nowrap;position:sticky;top:0;background:var(--surface)}
table.e th.n{text-align:right}
table.e td{padding:3px 4px;border-bottom:1px solid var(--border)}
table.e tr:hover td{background:var(--raised)}
table.e input{background:transparent;border:1px solid transparent;border-radius:4px;padding:4px 6px;
  color:var(--text);font-family:'JetBrains Mono',monospace;font-size:11px;width:100%;outline:none;transition:border .12s}
table.e input:focus{border-color:var(--focus);background:var(--input-bg)}
table.e input.ni{text-align:right}
table.e td.tot{font-family:'JetBrains Mono',monospace;font-weight:600;text-align:right;padding-right:12px;font-size:11px}
table.e tfoot td{border-top:2px solid var(--border);font-weight:600;background:var(--raised)}

.btn{display:inline-flex;align-items:center;gap:5px;padding:6px 14px;border-radius:6px;font-size:11px;
  font-weight:500;cursor:pointer;border:1px solid var(--border);background:var(--raised);color:var(--text);font-family:inherit;transition:all .15s}
.btn:hover{border-color:var(--blue);color:var(--blue)}
.brow{display:flex;gap:6px;margin-top:10px;flex-wrap:wrap}
.del{background:none;border:none;color:var(--muted);cursor:pointer;font-size:13px;padding:1px 5px;border-radius:3px;transition:color .12s}
.del:hover{color:var(--red)}

/* ── MONTH PILLS ── */
.mpills{display:flex;gap:3px;flex-wrap:wrap;margin-bottom:14px}
.mp{padding:5px 11px;border-radius:6px;cursor:pointer;font-size:11px;font-weight:500;color:var(--dim);
  border:1px solid var(--border);background:none;font-family:inherit;transition:all .12s}
.mp:hover{color:var(--text);border-color:var(--border-hi)}
.mp.active{background:var(--blue);color:#fff;border-color:var(--blue)}
.mp.has-data{border-color:var(--muted)}
.mp.has-data::after{content:'';display:inline-block;width:4px;height:4px;border-radius:50%;background:var(--green);margin-left:4px;vertical-align:middle}

/* ── LOAN ── */
.lgrid{display:grid;grid-template-columns:repeat(auto-fit,minmax(240px,1fr));gap:12px;margin-bottom:20px}
.lalt{background:var(--surface);border:1px solid var(--border);border-radius:12px;padding:18px;position:relative}
.lalt.best{border-color:var(--green)}
.lalt.best::after{content:'Anbefalt';position:absolute;top:10px;right:10px;background:var(--green);color:#000;
  font-size:8px;font-weight:700;padding:2px 7px;border-radius:10px;text-transform:uppercase;letter-spacing:.3px}
.lalt h4{font-size:12px;font-weight:600;margin-bottom:10px}
.lr{display:flex;justify-content:space-between;padding:4px 0;border-bottom:1px solid var(--border)}
.lr:last-child{border:none}
.lr .ll{color:var(--dim);font-size:10px}.lr .lv{font-family:'JetBrains Mono',monospace;font-size:11px}

/* ── OVERVIEW LOAN MINI ── */
.ov-loan{display:grid;grid-template-columns:repeat(auto-fit,minmax(200px,1fr));gap:12px;margin-bottom:20px}
.ov-lc{background:var(--surface);border:1px solid var(--border);border-radius:12px;padding:16px}
.ov-lc h4{font-size:11px;font-weight:600;color:var(--dim);margin-bottom:8px;text-transform:uppercase;letter-spacing:.5px}
.ov-lc .big{font-family:'JetBrains Mono',monospace;font-size:18px;font-weight:700;margin-bottom:4px}
.ov-lc .sm{font-size:10px;color:var(--dim)}
</style>
</head>
<body>
<div class="grain"></div>
<div class="app">
  <div class="hdr">
    <div><h1>ØKONOMI_DASHBOARD</h1></div>
    <div class="hdr-right">
      <span class="tag">Team Helse · 2025–2026</span>
      <button class="load-btn" onclick="importJSON()">Importer</button>
      <button class="load-btn" onclick="exportJSON()">Eksporter</button>
      <button class="load-btn" onclick="loadData()">Last inn</button>
      <button class="save-btn" onclick="saveData()">Lagre</button>
    </div>
  </div>
  <div id="toast" class="toast"></div>
  <input type="file" id="importFile" accept=".json" style="display:none" onchange="handleImport(event)">

  <div class="tabs">
    <button class="tab active" onclick="go('p_ov',this)">Oversikt</button>
    <button class="tab" onclick="go('p_reno',this)">Oppussing</button>
    <button class="tab" onclick="go('p_loan',this)">Lån</button>
    <button class="tab" onclick="go('p_bud',this)">Månedlig budsjett</button>
  </div>

  <!-- ════ OVERVIEW ════ -->
  <div id="p_ov" class="panel active">
    <div class="cards" id="ovCards"></div>
    <div class="cgrid f3">
      <div class="cbox"><h3>Månedlig budsjett vs. regnskap</h3><div class="cs">Totale utgifter per måned — budsjettert og faktisk</div><canvas id="ovMonthly"></canvas></div>
      <div class="cbox"><h3>Månedlig saldo</h3><div class="cs">Inntekt minus faktiske utgifter</div><canvas id="ovSaldo"></canvas></div>
    </div>
    <div id="ovLoan" class="ov-loan"></div>
    <div class="cgrid">
      <div class="cbox"><h3>Oppussing — akkumulert</h3><div class="cs">Forbruk vs. budsjett 150 000 kr</div><canvas id="ovReno"></canvas></div>
      <div class="cbox"><h3>Nedbetaling Lån 2</h3><div class="cs">Restsaldo over tid — valgt alternativ</div><canvas id="ovLoanChart"></canvas></div>
    </div>
  </div>

  <!-- ════ RENOVATION ════ -->
  <div id="p_reno" class="panel">
    <div class="cards" id="renoCards"></div>
    <div class="tw">
      <h3>Utgifter per leverandør og måned</h3>
      <div class="cs">Klikk i cellene for å redigere · + Legg til nye leverandører</div>
      <div style="overflow-x:auto;max-height:600px;overflow-y:auto"><table class="e" id="renoTbl">
        <thead><tr><th style="width:26px"></th><th style="min-width:150px">Leverandør</th>
          <th class="n">Jan</th><th class="n">Feb</th><th class="n">Mar</th><th class="n">Apr</th>
          <th class="n">Mai</th><th class="n">Jun</th><th class="n">Jul</th><th class="n">Aug</th>
          <th class="n">Sep</th><th class="n">Okt</th><th class="n">Nov</th><th class="n">Des</th>
          <th class="n" style="color:var(--text)">Totalt</th></tr></thead>
        <tbody id="renoB"></tbody><tfoot id="renoF"></tfoot>
      </table></div>
      <div class="brow"><button class="btn" onclick="addReno()">+ Legg til leverandør</button></div>
    </div>
    <div class="cgrid">
      <div class="cbox"><h3>Månedlig forbruk</h3><div class="cs">Oppussingsutgifter per måned</div><canvas id="renoMC"></canvas></div>
      <div class="cbox"><h3>Topp leverandører</h3><div class="cs">Andel av total</div><canvas id="renoPC"></canvas></div>
    </div>
  </div>

  <!-- ════ LOAN ════ -->
  <div id="p_loan" class="panel">
    <div class="isec">
      <h3>Låneparametere</h3><div class="cs">Endre for sanntidsoppdatering av alternativer og grafer</div>
      <div class="igrid">
        <div class="fld"><label>Lån 1 — saldo</label><input type="number" id="l1b" value="4594242" oninput="calcLoan()"></div>
        <div class="fld"><label>Lån 2 — oppr. saldo</label><input type="number" id="l2o" value="1600000" oninput="calcLoan()"></div>
        <div class="fld"><label>Ekstrainnbetaling</label><input type="number" id="l2x" value="440000" oninput="calcLoan()"></div>
        <div class="fld"><label>Nominell rente (%)</label><input type="number" id="lr" value="4.8" step="0.1" oninput="calcLoan()"></div>
        <div class="fld"><label>Løpetid (mnd)</label><input type="number" id="lt" value="348" oninput="calcLoan()"></div>
        <div class="fld"><label>Terminbeløp Lån 1</label><input type="number" id="l1p" value="23361" oninput="calcLoan()"></div>
        <div class="fld"><label>Terminbeløp Lån 2</label><input type="number" id="l2p" value="8165" oninput="calcLoan()"></div>
        <div class="fld"><label>Fars bidrag / mnd</label><input type="number" id="lf" value="3500" oninput="calcLoan()"></div>
      </div>
    </div>
    <div class="lgrid" id="loanAlts"></div>
    <div class="cgrid">
      <div class="cbox"><h3>Nedbetaling Lån 2</h3><div class="cs">Restsaldo over tid for alle alternativer</div><canvas id="loanPD"></canvas></div>
      <div class="cbox"><h3>Total rentekostnad</h3><div class="cs">Sammenligning av alternativer</div><canvas id="loanIC"></canvas></div>
    </div>
  </div>

  <!-- ════ MONTHLY BUDGET ════ -->
  <div id="p_bud" class="panel">
    <div class="isec">
      <h3>Inntekter</h3><div class="cs">Standard månedlige inntekter (kan overstyres per måned)</div>
      <div class="igrid">
        <div class="fld"><label>Inntekt Helene</label><input type="number" id="iH" value="30000" oninput="calcBud()"></div>
        <div class="fld"><label>Inntekt Petter</label><input type="number" id="iP" value="30000" oninput="calcBud()"></div>
      </div>
    </div>
    <div class="mpills" id="mPills"></div>
    <div class="cards" id="budCards"></div>
    <div class="tw">
      <h3 id="budTblTitle">Utgifter — Januar</h3>
      <div class="cs">Budsjett og regnskap per person · Klikk for å redigere</div>
      <div style="overflow-x:auto"><table class="e" id="budTbl">
        <thead><tr><th style="width:26px"></th><th style="min-width:160px">Kategori</th>
          <th class="n" style="color:var(--blue)">Bud. Helene</th><th class="n" style="color:var(--blue)">Bud. Petter</th>
          <th class="n" style="color:var(--green)">Regn. Helene</th><th class="n" style="color:var(--green)">Regn. Petter</th>
          <th class="n">Differanse</th></tr></thead>
        <tbody id="budB"></tbody><tfoot id="budF"></tfoot>
      </table></div>
      <div class="brow">
        <button class="btn" onclick="addBudRow()">+ Legg til utgift</button>
        <button class="btn" onclick="copyToAll()">Kopier budsjett til alle måneder</button>
      </div>
    </div>
    <div class="cgrid f1">
      <div class="cbox"><h3>Årsoverikt — budsjett vs. regnskap</h3><div class="cs">Totale utgifter alle 12 måneder</div><canvas id="budYr"></canvas></div>
    </div>
    <div class="cgrid">
      <div class="cbox"><h3>Saldo per måned</h3><div class="cs">Inntekt minus faktiske utgifter</div><canvas id="budSaldo"></canvas></div>
      <div class="cbox"><h3>Fordeling Helene / Petter</h3><div class="cs">Faktiske utgifter denne måneden</div><canvas id="budSplit"></canvas></div>
    </div>
  </div>
</div>

<script>
/* ═══ UTILS ═══ */
const $=id=>document.getElementById(id),pn=v=>parseFloat(v)||0;
const fmt=v=>{if(v==null||isNaN(v))return'–';return Math.round(v).toLocaleString('nb-NO')};
const MN=['Jan','Feb','Mar','Apr','Mai','Jun','Jul','Aug','Sep','Okt','Nov','Des'];
const MNF=['Januar','Februar','Mars','April','Mai','Juni','Juli','August','September','Oktober','November','Desember'];

Chart.defaults.color='#656b88';Chart.defaults.borderColor='#222838';
Chart.defaults.font.family="'Outfit',sans-serif";Chart.defaults.font.size=10;
Chart.defaults.plugins.legend.labels.boxWidth=8;Chart.defaults.plugins.legend.labels.padding=12;
Chart.defaults.elements.bar.borderRadius=3;
const GC={color:'#181d28'};

function go(id,el){
  document.querySelectorAll('.panel').forEach(p=>p.classList.remove('active'));
  document.querySelectorAll('.tab').forEach(t=>t.classList.remove('active'));
  $(id).classList.add('active');el.classList.add('active');
}
function toast(msg){const t=$('toast');t.textContent=msg;t.classList.add('show');setTimeout(()=>t.classList.remove('show'),2200)}

/* ═══ DATA MODEL ═══ */
const defaultBudgetRow=()=>[
  {cat:'Boliglån Skagerrak',bH:5770,bP:6450,aH:0,aP:0},
  {cat:'Felleskostnader Smestad',bH:0,bP:3690,aH:0,aP:0},
  {cat:'Strøm Elvia',bH:500,bP:500,aH:0,aP:0},
  {cat:'Drivstoff',bH:1000,bP:1000,aH:0,aP:0},
  {cat:'Forsikring bil',bH:0,bP:750,aH:0,aP:0},
  {cat:'Internett Telia',bH:300,bP:300,aH:0,aP:0},
  {cat:'Bom',bH:0,bP:2201,aH:0,aP:0},
  {cat:'Vedlikehold / rep.',bH:0,bP:500,aH:0,aP:0},
  {cat:'Studielån',bH:0,bP:4257,aH:0,aP:0},
  {cat:'Dagligvarer',bH:2000,bP:2000,aH:0,aP:0},
  {cat:'Spise ute',bH:500,bP:500,aH:0,aP:0},
  {cat:'Netflix',bH:0,bP:129,aH:0,aP:0},
  {cat:'HBO',bH:129,bP:0,aH:0,aP:0},
];

let STATE={
  income:{helene:30000,petter:30000},
  budgets:Array.from({length:12},()=>JSON.parse(JSON.stringify(defaultBudgetRow()))),
  reno:[
    {name:'EPOK kjøkken',m:[111249,0,0,0,0,0,0,0,0,0,0,0]},
    {name:'Rørlegger',m:[68875,0,0,0,0,0,0,0,0,0,0,0]},
    {name:'Kakkel og Peis',m:[60522,10200,0,0,0,0,0,0,0,0,0,0]},
    {name:'Maxbo',m:[4782,7580,2329,1242,29930,1692,297,6339,4965,3171,4099,0]},
    {name:'Elektriker',m:[55000,0,0,0,0,0,0,0,0,0,0,0]},
    {name:'Megaflis',m:[2653,1689,996,169,3390,162,13887,1833,6553,3135,0,0]},
    {name:'IKEA',m:[0,1995,0,0,0,0,2980,217,14449,2468,9716,0]},
    {name:'Håndverker / VL inst.',m:[3500,8000,0,0,0,0,0,0,0,0,0,0]},
    {name:'Drammen møbel',m:[9690,600,0,0,0,0,0,0,0,0,0,0]},
    {name:'Rusta',m:[2890,2630,0,0,0,0,768,1513,0,200,0,0]},
    {name:'Elkjøp',m:[3984,0,0,0,0,0,0,0,0,0,0,0]},
    {name:'Megaflis (vask)',m:[2890,0,0,0,0,0,0,0,0,0,0,0]},
    {name:'Coop Obs Bygg',m:[3224,0,0,0,0,0,0,0,0,0,0,0]},
    {name:'Lampehuset',m:[2421,0,0,0,0,0,0,0,0,0,0,0]},
    {name:'Jysk',m:[499,1254,0,0,0,0,0,0,524,0,0,0]},
    {name:'KID',m:[0,0,0,0,0,0,0,0,1545,0,629,0]},
    {name:'Fargerike',m:[1221,546,0,0,0,0,0,0,0,0,0,0]},
    {name:'Rema 1000',m:[1563,0,0,0,0,0,0,0,0,0,0,0]},
    {name:'Bohus',m:[0,0,0,0,0,0,0,0,537,0,533,0]},
    {name:'Henger',m:[538,0,0,0,0,0,0,0,0,0,0,0]},
    {name:'Europris',m:[184,0,0,0,0,0,0,0,0,0,0,0]},
    {name:'Princess',m:[125,0,0,0,0,0,0,0,0,0,0,0]},
  ],
  loan:{l1b:4594242,l2o:1600000,l2x:440000,lr:4.8,lt:348,l1p:23361,l2p:8165,lf:3500},
  curMonth:0
};

// Prefill actual data from spreadsheets for months we have
// June (index 5)
STATE.budgets[5]=[
  {cat:'Boliglån Skagerrak',bH:5770,bP:6450,aH:5770,aP:6450},
  {cat:'Felleskostnader Smestad',bH:0,bP:3690,aH:0,aP:3690},
  {cat:'Strøm Elvia',bH:500,bP:500,aH:500,aP:500},
  {cat:'Drivstoff',bH:1000,bP:1000,aH:1000,aP:1000},
  {cat:'Forsikring bil',bH:0,bP:750,aH:0,aP:750},
  {cat:'Internett Telia',bH:300,bP:300,aH:300,aP:300},
  {cat:'Bom',bH:0,bP:2201,aH:0,aP:2201},
  {cat:'Vedlikehold / rep.',bH:0,bP:500,aH:0,aP:500},
  {cat:'Netflix',bH:0,bP:129,aH:0,aP:129},
  {cat:'HBO',bH:129,bP:0,aH:129,aP:0},
];
// July (index 6)
STATE.budgets[6]=[
  {cat:'Boliglån Skagerrak',bH:5770,bP:6450,aH:10200,aP:10200},
  {cat:'Felleskostnader Smestad',bH:0,bP:3690,aH:0,aP:3690},
  {cat:'Strøm Elvia',bH:500,bP:500,aH:0,aP:500},
  {cat:'Drivstoff/forsikring',bH:1000,bP:1750,aH:2110,aP:2151},
  {cat:'Internett Telia',bH:300,bP:300,aH:300,aP:1617},
  {cat:'Bom',bH:0,bP:2201,aH:0,aP:1432},
  {cat:'Vedlikehold / rep.',bH:0,bP:500,aH:8351,aP:139},
  {cat:'Studielån',bH:0,bP:4000,aH:4000,aP:4000},
  {cat:'Annet',bH:0,bP:0,aH:2375,aP:2375},
  {cat:'Netflix',bH:0,bP:129,aH:0,aP:129},
  {cat:'HBO',bH:129,bP:0,aH:129,aP:0},
];
// February (index 1)
STATE.budgets[1]=[
  {cat:'Boliglån Skagerrak',bH:5770,bP:11000,aH:23360,aP:0},
  {cat:'Felleskostnader Smestad',bH:0,bP:3966,aH:0,aP:4422},
  {cat:'Strøm Elvia',bH:500,bP:1903,aH:0,aP:2161},
  {cat:'Drivstoff',bH:1000,bP:771,aH:0,aP:2700},
  {cat:'Internett Telia',bH:300,bP:600,aH:300,aP:700},
  {cat:'Bom',bH:0,bP:405,aH:0,aP:868},
  {cat:'Studielån',bH:0,bP:4257,aH:0,aP:0},
  {cat:'Utstyr',bH:0,bP:1050,aH:1100,aP:0},
  {cat:'Netflix',bH:0,bP:129,aH:0,aP:129},
  {cat:'HBO',bH:129,bP:0,aH:129,aP:0},
];
// March (index 2)
STATE.budgets[2]=[
  {cat:'Boliglån Skagerrak',bH:5770,bP:11000,aH:23360,aP:0},
  {cat:'Felleskostnader Smestad',bH:0,bP:3966,aH:0,aP:4422},
  {cat:'Strøm Elvia',bH:500,bP:1903,aH:0,aP:2145},
  {cat:'Drivstoff',bH:1000,bP:771,aH:0,aP:2700},
  {cat:'Internett Telia',bH:300,bP:600,aH:300,aP:700},
  {cat:'Bom',bH:0,bP:405,aH:0,aP:1488},
  {cat:'Studielån',bH:0,bP:4257,aH:0,aP:0},
  {cat:'IKEA',bH:0,bP:0,aH:0,aP:3291},
  {cat:'Annet',bH:0,bP:0,aH:0,aP:2939},
  {cat:'Netflix',bH:0,bP:129,aH:0,aP:129},
  {cat:'HBO',bH:129,bP:0,aH:129,aP:0},
];

/* ═══ SAVE / LOAD ═══ */
function saveData(){
  STATE.income={helene:pn($('iH').value),petter:pn($('iP').value)};
  STATE.loan={l1b:pn($('l1b').value),l2o:pn($('l2o').value),l2x:pn($('l2x').value),
    lr:pn($('lr').value),lt:pn($('lt').value),l1p:pn($('l1p').value),l2p:pn($('l2p').value),lf:pn($('lf').value)};
  localStorage.setItem('teamhelse_dashboard',JSON.stringify(STATE));
  toast('Lagret til nettleser');
}
function loadData(){
  const d=localStorage.getItem('teamhelse_dashboard');
  if(!d)return toast('Ingen lagrede data funnet');
  STATE=JSON.parse(d);
  $('iH').value=STATE.income.helene;$('iP').value=STATE.income.petter;
  const L=STATE.loan;
  $('l1b').value=L.l1b;$('l2o').value=L.l2o;$('l2x').value=L.l2x;$('lr').value=L.lr;
  $('lt').value=L.lt;$('l1p').value=L.l1p;$('l2p').value=L.l2p;$('lf').value=L.lf;
  renderAll();toast('Data lastet inn');
}
function exportJSON(){
  STATE.income={helene:pn($('iH').value),petter:pn($('iP').value)};
  STATE.loan={l1b:pn($('l1b').value),l2o:pn($('l2o').value),l2x:pn($('l2x').value),
    lr:pn($('lr').value),lt:pn($('lt').value),l1p:pn($('l1p').value),l2p:pn($('l2p').value),lf:pn($('lf').value)};
  const blob=new Blob([JSON.stringify(STATE,null,2)],{type:'application/json'});
  const a=document.createElement('a');
  a.href=URL.createObjectURL(blob);
  a.download='teamhelse_'+new Date().toISOString().slice(0,10)+'.json';
  a.click();URL.revokeObjectURL(a.href);
  toast('Eksportert som JSON');
}
function importJSON(){$('importFile').click()}
function handleImport(e){
  const f=e.target.files[0];if(!f)return;
  const r=new FileReader();
  r.onload=ev=>{
    try{
      STATE=JSON.parse(ev.target.result);
      $('iH').value=STATE.income.helene;$('iP').value=STATE.income.petter;
      const L=STATE.loan;
      $('l1b').value=L.l1b;$('l2o').value=L.l2o;$('l2x').value=L.l2x;$('lr').value=L.lr;
      $('lt').value=L.lt;$('l1p').value=L.l1p;$('l2p').value=L.l2p;$('lf').value=L.lf;
      renderAll();toast('Data importert fra fil');
    }catch(err){toast('Feil: ugyldig JSON-fil')}
  };
  r.readAsText(f);e.target.value='';
}

/* ═══ BUDGET TAB ═══ */
function renderPills(){
  const c=$('mPills');c.innerHTML='';
  MN.forEach((m,i)=>{
    const rows=STATE.budgets[i];
    const hasA=rows.some(r=>r.aH>0||r.aP>0);
    const cls='mp'+(i===STATE.curMonth?' active':'')+(hasA?' has-data':'');
    c.innerHTML+=`<button class="${cls}" onclick="switchMonth(${i})">${m}</button>`;
  });
}
function switchMonth(i){STATE.curMonth=i;renderPills();renderBudTable();calcBud()}

function renderBudTable(){
  const mi=STATE.curMonth;const rows=STATE.budgets[mi];
  $('budTblTitle').textContent='Utgifter — '+MNF[mi];
  const tb=$('budB');tb.innerHTML='';
  rows.forEach((r,ri)=>{
    const bt=r.bH+r.bP,at=r.aH+r.aP,d=bt-at;
    const tr=document.createElement('tr');
    tr.innerHTML=`<td><button class="del" onclick="delBud(${ri})">×</button></td>
      <td><input value="${r.cat}" onchange="STATE.budgets[${mi}][${ri}].cat=this.value"></td>
      <td><input class="ni" type="number" value="${r.bH||''}" placeholder="0" oninput="STATE.budgets[${mi}][${ri}].bH=pn(this.value);calcBud()"></td>
      <td><input class="ni" type="number" value="${r.bP||''}" placeholder="0" oninput="STATE.budgets[${mi}][${ri}].bP=pn(this.value);calcBud()"></td>
      <td><input class="ni" type="number" value="${r.aH||''}" placeholder="0" oninput="STATE.budgets[${mi}][${ri}].aH=pn(this.value);calcBud()" style="color:var(--green)"></td>
      <td><input class="ni" type="number" value="${r.aP||''}" placeholder="0" oninput="STATE.budgets[${mi}][${ri}].aP=pn(this.value);calcBud()" style="color:var(--green)"></td>
      <td class="tot" style="color:${d>=0?'var(--green)':'var(--red)'};">${d>=0?'+':''}${fmt(d)}</td>`;
    tb.appendChild(tr);
  });
  budFoot();
}
function budFoot(){
  const mi=STATE.curMonth;const rows=STATE.budgets[mi];
  const s={bH:0,bP:0,aH:0,aP:0};
  rows.forEach(r=>{s.bH+=r.bH;s.bP+=r.bP;s.aH+=r.aH;s.aP+=r.aP});
  const bt=s.bH+s.bP,at=s.aH+s.aP,d=bt-at;
  $('budF').innerHTML=`<tr><td></td><td style="font-weight:600">Sum</td>
    <td class="tot">${fmt(s.bH)}</td><td class="tot">${fmt(s.bP)}</td>
    <td class="tot" style="color:var(--green)">${fmt(s.aH)}</td><td class="tot" style="color:var(--green)">${fmt(s.aP)}</td>
    <td class="tot" style="color:${d>=0?'var(--green)':'var(--red)'};">${d>=0?'+':''}${fmt(d)}</td></tr>`;
}
function addBudRow(){STATE.budgets[STATE.curMonth].push({cat:'Ny utgift',bH:0,bP:0,aH:0,aP:0});renderBudTable();calcBud()}
function delBud(i){STATE.budgets[STATE.curMonth].splice(i,1);renderBudTable();calcBud()}
function copyToAll(){
  const src=JSON.parse(JSON.stringify(STATE.budgets[STATE.curMonth]));
  // Copy budget columns only, reset actuals
  for(let i=0;i<12;i++){
    if(i===STATE.curMonth)continue;
    STATE.budgets[i]=src.map(r=>({cat:r.cat,bH:r.bH,bP:r.bP,aH:STATE.budgets[i].find(x=>x.cat===r.cat)?.aH||0,aP:STATE.budgets[i].find(x=>x.cat===r.cat)?.aP||0}));
  }
  renderPills();toast('Budsjett kopiert til alle måneder');
}

let budYrC,budSaldoC,budSplitC;
function calcBud(){
  const inc=pn($('iH').value)+pn($('iP').value);
  const mi=STATE.curMonth;const rows=STATE.budgets[mi];
  const s={bH:0,bP:0,aH:0,aP:0};
  rows.forEach(r=>{s.bH+=r.bH;s.bP+=r.bP;s.aH+=r.aH;s.aP+=r.aP});
  const bt=s.bH+s.bP,at=s.aH+s.aP;
  const expSaldo=inc-bt,actSaldo=inc-at;

  $('budCards').innerHTML=`
    <div class="card c-bl"><div class="lbl">Inntekt</div><div class="val">${fmt(inc)}</div></div>
    <div class="card c-am"><div class="lbl">Budsjettert utgift</div><div class="val">${fmt(bt)}</div></div>
    <div class="card c-te"><div class="lbl">Faktisk utgift</div><div class="val">${fmt(at)}</div></div>
    <div class="card ${actSaldo>=0?'c-gr':'c-rd'}"><div class="lbl">Saldo ${MN[mi]}</div><div class="val ${actSaldo>=0?'pos':'neg'}">${fmt(actSaldo)}</div></div>`;

  budFoot();renderPills();

  // Year chart
  const yrBud=[],yrAct=[];
  for(let i=0;i<12;i++){
    let b=0,a=0;STATE.budgets[i].forEach(r=>{b+=r.bH+r.bP;a+=r.aH+r.aP});
    yrBud.push(b);yrAct.push(a);
  }
  if(budYrC)budYrC.destroy();
  budYrC=new Chart($('budYr'),{type:'bar',data:{labels:MN,datasets:[
    {label:'Budsjett',data:yrBud,backgroundColor:'rgba(74,141,240,.45)',borderRadius:4},
    {label:'Regnskap',data:yrAct,backgroundColor:'rgba(56,196,132,.45)',borderRadius:4}
  ]},options:{responsive:true,plugins:{legend:{position:'bottom'}},
    scales:{y:{ticks:{callback:v=>fmt(v)},grid:GC},x:{grid:{display:false}}}}});

  // Saldo chart
  const saldos=MN.map((_,i)=>{let a=0;STATE.budgets[i].forEach(r=>{a+=r.aH+r.aP});return inc-a});
  if(budSaldoC)budSaldoC.destroy();
  budSaldoC=new Chart($('budSaldo'),{type:'bar',data:{labels:MN,datasets:[{label:'Saldo',data:saldos,
    backgroundColor:saldos.map(v=>v>=0?'rgba(56,196,132,.55)':'rgba(224,78,78,.55)'),borderRadius:4}]},
    options:{responsive:true,plugins:{legend:{display:false}},
      scales:{y:{ticks:{callback:v=>fmt(v)},grid:GC},x:{grid:{display:false}}}}});

  // Split
  if(budSplitC)budSplitC.destroy();
  budSplitC=new Chart($('budSplit'),{type:'doughnut',data:{labels:['Helene','Petter'],
    datasets:[{data:[s.aH,s.aP],backgroundColor:['#8a6ae0','#4a8df0'],borderWidth:0,spacing:2}]},
    options:{responsive:true,cutout:'60%',plugins:{legend:{position:'bottom'},
      tooltip:{callbacks:{label:c=>c.label+': '+fmt(c.raw)+' kr'}}}}});

  updateOv();
}

/* ═══ RENOVATION ═══ */
function renderRenoTbl(){
  const tb=$('renoB');tb.innerHTML='';
  STATE.reno.forEach((r,i)=>{
    const t=r.m.reduce((a,b)=>a+b,0);
    const tr=document.createElement('tr');
    tr.innerHTML=`<td><button class="del" onclick="delReno(${i})">×</button></td>
      <td><input value="${r.name}" onchange="STATE.reno[${i}].name=this.value;calcReno()"></td>
      ${r.m.map((v,mi)=>`<td><input class="ni" type="number" value="${v||''}" placeholder="0" oninput="STATE.reno[${i}].m[${mi}]=pn(this.value);calcReno()"></td>`).join('')}
      <td class="tot">${fmt(t)}</td>`;
    tb.appendChild(tr);
  });
  renoFoot();
}
function renoFoot(){
  const mt=MN.map((_,mi)=>STATE.reno.reduce((s,r)=>s+r.m[mi],0));
  const g=mt.reduce((a,b)=>a+b,0);
  $('renoF').innerHTML=`<tr><td></td><td style="font-weight:600">Sum</td>
    ${mt.map(v=>`<td class="tot">${fmt(v)}</td>`).join('')}
    <td class="tot" style="color:var(--amber)">${fmt(g)}</td></tr>`;
}
function addReno(){STATE.reno.push({name:'Ny leverandør',m:Array(12).fill(0)});renderRenoTbl();calcReno()}
function delReno(i){STATE.reno.splice(i,1);renderRenoTbl();calcReno()}

let renoMC,renoPC;
function calcReno(){
  renoFoot();
  const bud=150000;
  const mt=MN.map((_,mi)=>STATE.reno.reduce((s,r)=>s+r.m[mi],0));
  const g=mt.reduce((a,b)=>a+b,0);

  $('renoCards').innerHTML=`
    <div class="card c-bl"><div class="lbl">Budsjett</div><div class="val">${fmt(bud)}</div></div>
    <div class="card c-rd"><div class="lbl">Faktisk</div><div class="val neg">${fmt(g)}</div></div>
    <div class="card c-am"><div class="lbl">Overforbruk</div><div class="val neg">−${fmt(Math.abs(g-bud))}</div>
      <div class="sub">${Math.round(g/bud*100)} % av budsjett</div></div>`;

  if(renoMC)renoMC.destroy();
  renoMC=new Chart($('renoMC'),{type:'bar',data:{labels:MN,datasets:[{data:mt,backgroundColor:'rgba(223,148,56,.55)',borderRadius:4}]},
    options:{responsive:true,plugins:{legend:{display:false}},scales:{y:{ticks:{callback:v=>fmt(v)},grid:GC},x:{grid:{display:false}}}}});

  const vt=STATE.reno.map(r=>({n:r.name,t:r.m.reduce((a,b)=>a+b,0)})).filter(v=>v.t>0).sort((a,b)=>b.t-a.t);
  const top=vt.slice(0,6),rest=vt.slice(6).reduce((s,v)=>s+v.t,0);
  const pl=[...top.map(v=>v.n),...(rest>0?['Andre']:[])];
  const pd=[...top.map(v=>v.t),...(rest>0?[rest]:[])];
  const pc=['#4a8df0','#38c484','#df9438','#8a6ae0','#e04e4e','#34b8b0','#656b88'];

  if(renoPC)renoPC.destroy();
  renoPC=new Chart($('renoPC'),{type:'doughnut',data:{labels:pl,datasets:[{data:pd,backgroundColor:pc.slice(0,pl.length),borderWidth:0,spacing:2}]},
    options:{responsive:true,cutout:'56%',plugins:{legend:{position:'right',labels:{font:{size:9}}},
      tooltip:{callbacks:{label:c=>c.label+': '+fmt(c.raw)+' kr'}}}}});

  updateOv();
}

/* ═══ LOAN ═══ */
function PMT(r,n,pv){if(r===0)return pv/n;return pv*r*Math.pow(1+r,n)/(Math.pow(1+r,n)-1)}
function amor(bal,pay,mr,mx){
  let ti=0;const pts=[bal];let mo=0;
  for(let i=0;i<mx&&bal>0.5;i++){
    const int=bal*mr;ti+=int;const pr=Math.min(pay-int,bal);if(pr<=0)break;
    bal=Math.max(0,bal-pr);mo++;if(i%6===5||bal<0.5)pts.push(Math.round(bal));
  }
  return{mo,ti:Math.round(ti),pts};
}

let loanPDC,loanICC;
function calcLoan(){
  const L={l1b:pn($('l1b').value),l2o:pn($('l2o').value),l2x:pn($('l2x').value),
    lr:pn($('lr').value),lt:pn($('lt').value),l1p:pn($('l1p').value),l2p:pn($('l2p').value),lf:pn($('lf').value)};
  STATE.loan=L;
  const l2b=L.l2o-L.l2x,mr=L.lr/100/12;

  const a1p=PMT(mr,L.lt,l2b);
  const a1=amor(l2b,a1p,mr,L.lt);
  const l1a=amor(L.l1b,L.l1p,mr,L.lt);
  const a2=amor(l2b,L.l2p,mr,600);
  const a2b=amor(l2b,L.l2p+L.lf,mr,600);

  const ti1=l1a.ti+a1.ti,ti2=l1a.ti+a2.ti,ti2b=l1a.ti+a2b.ti;

  $('loanAlts').innerHTML=`
    <div class="lalt"><h4>Alt 1 · Lavere betaling</h4>
      <div class="lr"><span class="ll">Terminbeløp Lån 2</span><span class="lv">${fmt(a1p)} kr</span></div>
      <div class="lr"><span class="ll">Totalt/mnd</span><span class="lv">${fmt(L.l1p+a1p)} kr</span></div>
      <div class="lr"><span class="ll">Løpetid Lån 2</span><span class="lv">${(a1.mo/12).toFixed(1)} år</span></div>
      <div class="lr"><span class="ll">Total rente</span><span class="lv">${fmt(ti1)} kr</span></div></div>
    <div class="lalt best"><h4>Alt 2 · Kortere løpetid</h4>
      <div class="lr"><span class="ll">Terminbeløp Lån 2</span><span class="lv">${fmt(L.l2p)} kr</span></div>
      <div class="lr"><span class="ll">Totalt/mnd</span><span class="lv">${fmt(L.l1p+L.l2p)} kr</span></div>
      <div class="lr"><span class="ll">Løpetid Lån 2</span><span class="lv">${(a2.mo/12).toFixed(1)} år</span></div>
      <div class="lr"><span class="ll">Spart vs Alt 1</span><span class="lv pos">${fmt(ti1-ti2)} kr</span></div></div>
    <div class="lalt"><h4>Alt 2B · Med far (${fmt(L.lf)} kr/mnd)</h4>
      <div class="lr"><span class="ll">Terminbeløp Lån 2</span><span class="lv">${fmt(L.l2p+L.lf)} kr</span></div>
      <div class="lr"><span class="ll">Løpetid Lån 2</span><span class="lv">${(a2b.mo/12).toFixed(1)} år</span></div>
      <div class="lr"><span class="ll">Total rente</span><span class="lv">${fmt(ti2b)} kr</span></div>
      <div class="lr"><span class="ll">Spart vs Alt 1</span><span class="lv pos">${fmt(ti1-ti2b)} kr</span></div></div>`;

  const mx=Math.max(a1.pts.length,a2.pts.length,a2b.pts.length);
  const lb=Array.from({length:mx},(_,i)=>{const y=i*.5;return y%5===0?y+' år':''});

  if(loanPDC)loanPDC.destroy();
  loanPDC=new Chart($('loanPD'),{type:'line',data:{labels:lb,datasets:[
    {label:'Alt 1',data:a1.pts,borderColor:'#4a8df0',borderWidth:2,tension:.2,pointRadius:0,fill:false},
    {label:'Alt 2',data:a2.pts,borderColor:'#38c484',borderWidth:2,tension:.2,pointRadius:0,fill:false},
    {label:'Alt 2B',data:a2b.pts,borderColor:'#df9438',borderWidth:2,tension:.2,pointRadius:0,fill:false}
  ]},options:{responsive:true,plugins:{legend:{position:'bottom'}},
    scales:{y:{ticks:{callback:v=>fmt(v)},grid:GC},x:{grid:{display:false},ticks:{maxTicksLimit:10}}}}});

  if(loanICC)loanICC.destroy();
  loanICC=new Chart($('loanIC'),{type:'bar',data:{labels:['Alt 1','Alt 2','Alt 2B'],datasets:[{
    data:[ti1,ti2,ti2b],backgroundColor:['rgba(74,141,240,.5)','rgba(56,196,132,.5)','rgba(223,148,56,.5)'],borderRadius:6}]},
    options:{responsive:true,plugins:{legend:{display:false},tooltip:{callbacks:{label:c=>fmt(c.raw)+' kr'}}},
      scales:{y:{ticks:{callback:v=>(v/1e6).toFixed(1)+'M'},grid:GC},x:{grid:{display:false}}}}});

  updateOv();
}

/* ═══ OVERVIEW ═══ */
let ovMC,ovSC,ovRC,ovLC;
function updateOv(){
  const inc=pn($('iH').value)+pn($('iP').value);
  const L=STATE.loan;const l2b=L.l2o-L.l2x;const mr=L.lr/100/12;

  // Budget totals per month
  const yrBud=[],yrAct=[],saldos=[];
  for(let i=0;i<12;i++){
    let b=0,a=0;STATE.budgets[i].forEach(r=>{b+=r.bH+r.bP;a+=r.aH+r.aP});
    yrBud.push(b);yrAct.push(a);saldos.push(inc-a);
  }
  const totalYrAct=yrAct.reduce((a,b)=>a+b,0);
  const totalYrBud=yrBud.reduce((a,b)=>a+b,0);

  // Reno
  const renoGrand=STATE.reno.reduce((s,r)=>s+r.m.reduce((a,b)=>a+b,0),0);
  const mt=MN.map((_,mi)=>STATE.reno.reduce((s,r)=>s+r.m[mi],0));
  let acc=0;const accumulated=mt.map(v=>{acc+=v;return acc});

  // Loan
  const a2=amor(l2b,L.l2p,mr,600);

  $('ovCards').innerHTML=`
    <div class="card c-bl"><div class="lbl">Total gjeld</div><div class="val">${fmt(L.l1b+l2b)}</div></div>
    <div class="card c-gr"><div class="lbl">Månedlig inntekt</div><div class="val pos">${fmt(inc)}</div></div>
    <div class="card c-am"><div class="lbl">Terminbeløp (Alt 2)</div><div class="val">${fmt(L.l1p+L.l2p)}</div><div class="sub">per måned</div></div>
    <div class="card c-rd"><div class="lbl">Oppussing overforbruk</div><div class="val neg">−${fmt(Math.abs(renoGrand-150000))}</div></div>
    <div class="card c-te"><div class="lbl">Årlig budsjett</div><div class="val">${fmt(totalYrBud)}</div></div>
    <div class="card c-pu"><div class="lbl">Årlig regnskap</div><div class="val">${fmt(totalYrAct)}</div></div>`;

  // Loan mini section
  $('ovLoan').innerHTML=`
    <div class="ov-lc"><h4>Lån 1</h4><div class="big">${fmt(L.l1b)}</div><div class="sm">Terminbeløp ${fmt(L.l1p)} kr/mnd · ${(L.lt/12).toFixed(0)} år</div></div>
    <div class="ov-lc"><h4>Lån 2 (etter innbet.)</h4><div class="big">${fmt(l2b)}</div><div class="sm">Terminbeløp ${fmt(L.l2p)} kr/mnd · ~${(a2.mo/12).toFixed(0)} år</div></div>
    <div class="ov-lc"><h4>Rente</h4><div class="big">${L.lr} %</div><div class="sm">Nominell · ${(L.lr*1.0389).toFixed(2)} % effektiv (ca.)</div></div>
    <div class="ov-lc"><h4>Fars bidrag</h4><div class="big pos">${fmt(L.lf)}</div><div class="sm">kr/mnd til Lån 2</div></div>`;

  // Monthly chart
  if(ovMC)ovMC.destroy();
  ovMC=new Chart($('ovMonthly'),{type:'bar',data:{labels:MN,datasets:[
    {label:'Budsjett',data:yrBud,backgroundColor:'rgba(74,141,240,.4)',borderRadius:3},
    {label:'Regnskap',data:yrAct,backgroundColor:'rgba(56,196,132,.4)',borderRadius:3}
  ]},options:{responsive:true,plugins:{legend:{position:'bottom'}},
    scales:{y:{ticks:{callback:v=>fmt(v)},grid:GC},x:{grid:{display:false}}}}});

  // Saldo
  if(ovSC)ovSC.destroy();
  ovSC=new Chart($('ovSaldo'),{type:'bar',data:{labels:MN,datasets:[{label:'Saldo',data:saldos,
    backgroundColor:saldos.map(v=>v>=inc?'rgba(101,107,136,.3)':v>=0?'rgba(56,196,132,.5)':'rgba(224,78,78,.5)'),borderRadius:3}]},
    options:{responsive:true,plugins:{legend:{display:false}},
      scales:{y:{ticks:{callback:v=>fmt(v)},grid:GC},x:{grid:{display:false}}}}});

  // Reno accumulation
  if(ovRC)ovRC.destroy();
  ovRC=new Chart($('ovReno'),{type:'line',data:{labels:MN,datasets:[
    {label:'Akkumulert',data:accumulated,borderColor:'#e04e4e',backgroundColor:'rgba(224,78,78,.06)',fill:true,tension:.3,pointRadius:2,borderWidth:2},
    {label:'Budsjett',data:Array(12).fill(150000),borderColor:'#4a8df0',borderDash:[5,3],borderWidth:1.5,pointRadius:0,fill:false}
  ]},options:{responsive:true,plugins:{legend:{position:'bottom'}},
    scales:{y:{ticks:{callback:v=>fmt(v)},grid:GC},x:{grid:{display:false}}}}});

  // Loan mini chart
  if(ovLC)ovLC.destroy();
  const a2b=amor(l2b,L.l2p+L.lf,mr,600);
  const mx2=Math.max(a2.pts.length,a2b.pts.length);
  const lb2=Array.from({length:mx2},(_,i)=>{const y=i*.5;return y%5===0?y+'':''});
  ovLC=new Chart($('ovLoanChart'),{type:'line',data:{labels:lb2,datasets:[
    {label:'Alt 2',data:a2.pts,borderColor:'#38c484',borderWidth:2,tension:.2,pointRadius:0,fill:false},
    {label:'Alt 2B (m/far)',data:a2b.pts,borderColor:'#df9438',borderWidth:2,tension:.2,pointRadius:0,fill:false}
  ]},options:{responsive:true,plugins:{legend:{position:'bottom'}},
    scales:{y:{ticks:{callback:v=>fmt(v)},grid:GC},x:{grid:{display:false},ticks:{maxTicksLimit:8}}}}});
}

/* ═══ INIT ═══ */
function renderAll(){renderRenoTbl();calcReno();calcLoan();renderPills();renderBudTable();calcBud()}

// Try auto-load
const saved=localStorage.getItem('teamhelse_dashboard');
if(saved){try{STATE=JSON.parse(saved);
  $('iH').value=STATE.income.helene;$('iP').value=STATE.income.petter;
  const L=STATE.loan;$('l1b').value=L.l1b;$('l2o').value=L.l2o;$('l2x').value=L.l2x;$('lr').value=L.lr;
  $('lt').value=L.lt;$('l1p').value=L.l1p;$('l2p').value=L.l2p;$('lf').value=L.lf;
}catch(e){}}
renderAll();
</script>
</body>
</html>
