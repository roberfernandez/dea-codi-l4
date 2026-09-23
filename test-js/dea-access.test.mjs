import test from 'node:test';
import assert from 'node:assert/strict';
import {createCodeTransport} from '../web/dea-transport.mjs';
function setup({session = {access_token:'test-token',expires_at:Date.now()/1000+300}, approved = true, request, epoch = () => 0} = {}) {
 let denied = 0, calls = 0;
 const fetchCode = createCodeTransport({storage:{getItem:()=>JSON.stringify(session)},sessionKey:'test',allowed:()=>approved,epoch,deny:()=>denied++,request:async (...args)=>{calls++;return request ? request(...args) : {ok:true,json:async()=> 'TEST_ONLY'};}});
 return {fetchCode,denied:()=>denied,calls:()=>calls};
}
test('missing session never calls backend',async()=>{const t=setup({session:null});await assert.rejects(t.fetchCode('Test'));assert.equal(t.calls(),0);});
test('unapproved user never calls backend',async()=>{const t=setup({approved:false});await assert.rejects(t.fetchCode('Test'));assert.equal(t.calls(),0);});
test('backend authorization denial fails closed',async()=>{const t=setup({request:async()=>({ok:false,status:403})});await assert.rejects(t.fetchCode('Test'));assert.equal(t.denied(),1);});
test('network error clears previous display',async()=>{const t=setup({request:async()=>{throw Error('offline')}});await assert.rejects(t.fetchCode('Test'));assert.equal(t.denied(),1);});
test('authorized result is returned verbatim with no-store POST',async()=>{const t=setup({request:async(url,options)=>{assert.equal(options.cache,'no-store');assert.equal(options.method,'POST');assert.equal(JSON.parse(options.body).p_station,'Test');return {ok:true,json:async()=> 'TEST_ONLY'};}});assert.equal(await t.fetchCode('Test'),'TEST_ONLY');});
test('response arriving after session invalidation is discarded',async()=>{let epoch=0;const t=setup({epoch:()=>epoch,request:async()=>{epoch++;return {ok:true,json:async()=> 'TEST_ONLY'}}});await assert.rejects(t.fetchCode('Test'));assert.equal(t.denied(),1);});
