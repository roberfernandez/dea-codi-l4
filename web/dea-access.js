import {checkSession, SESSION_KEY} from '/tmb-agent/src/session.js';
import {createCodeTransport} from './dea-transport.mjs';

const status = document.querySelector('#dea-status');
const message = document.querySelector('#dea-message');
const retry = document.querySelector('#dea-retry');
let approved = false, started = false, epoch = 0, checkId = 0;
let snapshot = localStorage.getItem(SESSION_KEY);
function hide() {
  approved = false; ++epoch;
  window.deaClearCode?.();
  document.documentElement.classList.remove('dea-approved');
  status.hidden = false;
}
function unavailable() {
  hide();
  message.textContent = 'No s’ha pogut comprovar l’accés. No hi ha cap codi disponible.';
  retry.hidden = false;
}
async function verify() {
  const id = ++checkId;
  hide();
  message.textContent = 'Comprovant el teu accés…'; retry.hidden = true;
  try {
    const state = await checkSession();
    if (id !== checkId || document.hidden) return;
    if (state !== 'approved') {
      location.replace('/tmb-agent/auth/?returnTo=' + encodeURIComponent('/tmb-agent/#/dea'));
      return;
    }
    approved = true;
    if (!started) {
      const script = document.createElement('script'); script.src = 'flutter_bootstrap.js';
      script.onerror = unavailable; document.body.append(script); started = true;
    }
    document.documentElement.classList.add('dea-approved'); status.hidden = true;
  } catch { if (id === checkId) unavailable(); }
}
window.deaFetchCode = createCodeTransport({
  storage: localStorage, sessionKey: SESSION_KEY,
  allowed: () => approved && !document.hidden && navigator.onLine,
  epoch: () => epoch, deny: unavailable,
});
retry.addEventListener('click', () => location.reload());
window.addEventListener('offline', () => { ++checkId; unavailable(); });
window.addEventListener('pagehide', () => { ++checkId; hide(); });
window.addEventListener('pageshow', event => { if (event.persisted) verify(); });
document.addEventListener('visibilitychange', () => {
  if (document.hidden) { ++checkId; hide(); } else verify();
});
window.addEventListener('storage', event => {
  if (event.key === SESSION_KEY || event.key === null) verify();
});
setInterval(() => {
  if (document.hidden) return;
  const current = localStorage.getItem(SESSION_KEY);
  if (current !== snapshot) { snapshot = current; verify(); }
}, 1000);
setInterval(() => { if (!document.hidden) verify(); }, 60000);
verify();
