// Open a CircuitJS URL on the local build, record element values on every time step.
// Usage: node run.js <url> <tSim> <out.json> <spec>
//   spec: comma list of idx:kind  (kind v = voltage diff, i = current, info = getInfo() strings)
const { chromium } = require('/opt/node-tools/node_modules/playwright');
const fs = require('fs');

(async () => {
  const [url, tSimS, out, spec] = process.argv.slice(2);
  const tSim = parseFloat(tSimS);
  const probes = spec.split(',').map(s => { const [i, k] = s.split(':'); return { i: +i, k }; });
  const browser = await chromium.launch({ executablePath: '/opt/pw-browsers/chromium', args: ['--no-sandbox'] });
  const page = await browser.newPage({ viewport: { width: 1400, height: 900 } });
  const errors = [];
  page.on('pageerror', e => errors.push(String(e)));
  await page.goto(url);
  await page.waitForFunction(() => window.CircuitJS1 && window.CircuitJS1.getElements, null, { timeout: 60000 });
  const meta = await page.evaluate((probes) => {
    const sim = window.CircuitJS1;
    const els = sim.getElements();
    window.__rec = { t: [], v: probes.map(() => []) };
    window.__probes = probes;
    sim.ontimestep = (s) => {
      const els = s.getElements();
      window.__rec.t.push(s.getTime());
      window.__probes.forEach((p, j) => {
        const e = els[p.i];
        let val;
        if (p.k === 'v') val = e.getVoltageDiff();
        else if (p.k === 'i') val = e.getCurrent();
        else val = Array.from(e.getInfo()).join(' | ');
        window.__rec.v[j].push(val);
      });
    };
    return { n: els.length, types: els.map(e => e.getType()) };
  }, probes);
  const t0 = Date.now();
  let running = true, simT = 0;
  while (Date.now() - t0 < 600000) {
    await page.waitForTimeout(1000);
    const st = await page.evaluate(() => ({ r: window.CircuitJS1.isRunning(), t: window.CircuitJS1.getTime() }));
    running = st.r; simT = st.t;
    if (!running || simT >= tSim) break;
  }
  await page.screenshot({ path: out.replace(/\.json$/, '.png') });
  const rec = await page.evaluate(() => { window.CircuitJS1.setSimRunning(false); return window.__rec; });
  fs.writeFileSync(out, JSON.stringify({ meta, running, simT, wall: (Date.now() - t0) / 1000, errors, probes, rec }));
  console.log(JSON.stringify({ n: meta.n, running, simT, wall: (Date.now() - t0) / 1000, errors: errors.slice(0, 3), samples: rec.t.length }));
  await browser.close();
})();
