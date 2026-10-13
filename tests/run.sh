#!/bin/bash
set -uo pipefail
cd "$(dirname "$0")/.."
PASS=0; FAIL=0
ok(){ echo "  ✅ $1"; PASS=$((PASS+1)); }
bad(){ echo "  ❌ $1"; FAIL=$((FAIL+1)); }
echo ""; echo "  @deepwhale-cn/dsh-least-privilege · 双向验证"
echo "  ────────────────────────────────────────────────"
J=$(node bin/cli.mjs --root tests/fixtures/fail/demo-project --json 2>&1)
for rid in LP-ROOT-CONTAINER LP-WILDCARD-PERM LP-CORS-ANY LP-ADMIN-SCOPE; do
  c=$(echo "$J" | python3 -c "
import json,sys; d=json.load(sys.stdin)
print(len([f for f in d['findings'] if f['ruleId']=='$rid']))" 2>/dev/null)
  [ "${c:-0}" -gt 0 ] && ok "$rid 报出" || bad "$rid 未报出"
done
M=$(node bin/cli.mjs --root tests/fixtures/pass/clean-project --quiet 2>&1 | grep -oE '^[0-9]+' | head -1)
[ "${M:-1}" = "0" ] && ok "合规样本 0 命中" || bad "误报 ${M} 条"
echo ""; echo "  【回归】Dockerfile（无扩展名）必须被当文本读"
D=$(node --input-type=module -e "
import { scan } from '@deepwhale-cn/dsh-guard-core';
const r = scan({root:'tests/fixtures/fail/demo-project', rules:[{id:'T',title:'t',severity:'high',source:'s',check:{type:'file-pattern',pattern:'USER\\\\s+root',paths:['Dockerfile']}}]});
console.log(r.findings.length);" 2>/dev/null)
[ "${D:-0}" -gt 0 ] && ok "Dockerfile 可被扫描（${D} 条）" || bad "Dockerfile 未被扫描 —— 无扩展名 bug 回归"
echo ""; echo "  【溯源】每条规则必须带 source"
python3 - <<'PY' && ok "全部规则均有 source" || bad "有规则缺 source"
import json,glob,sys
for f in glob.glob('rules/*.json'):
    r=json.load(open(f,encoding='utf-8'))
    if not r.get('source'): print('缺:',r.get('id'),file=sys.stderr); sys.exit(1)
PY
echo ""; echo "  ────────────────────────────────────────────────"
echo "  通过 $PASS · 失败 $FAIL"; echo ""
[ "$FAIL" -eq 0 ] || exit 1
