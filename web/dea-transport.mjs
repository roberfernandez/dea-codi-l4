const API = 'https://hhenkvendzengggrgook.supabase.co';
const PUBLISHABLE = 'sb_publishable_QSPDTmh3fd0FH-VvAjH5KQ_Rfvzr2x_';
// No real codes, privileged credentials or persistent response storage.
export function createCodeTransport({storage, sessionKey, request = fetch, allowed, epoch, deny}) {
  return async station => {
    const start = epoch();
    try {
      if (!allowed() || typeof station !== 'string') throw Error('Unavailable');
      const session = JSON.parse(storage.getItem(sessionKey));
      if (!session?.access_token || !Number.isFinite(session.expires_at) || session.expires_at * 1000 <= Date.now()) throw Error('Unavailable');
      const response = await request(`${API}/rest/v1/rpc/dea_code_for_station`, {
        method: 'POST', cache: 'no-store', credentials: 'omit',
        headers: {apikey: PUBLISHABLE, Authorization: `Bearer ${session.access_token}`, 'Content-Type': 'application/json'},
        body: JSON.stringify({p_station: station}), signal: AbortSignal.timeout(15000),
      });
      if (!response.ok) throw Error('Unavailable');
      const code = await response.json();
      const latest = JSON.parse(storage.getItem(sessionKey));
      if (typeof code !== 'string' || !code || code.length > 80 ||
          start !== epoch() || !allowed() || latest?.access_token !== session.access_token) throw Error('Unavailable');
      return code;
    } catch {
      deny();
      throw Error('DEA code unavailable');
    }
  };
}
