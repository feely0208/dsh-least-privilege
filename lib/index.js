import { createPlugin, pkgRootFrom } from '@deepwhale-cn/dsh-guard-core/plugin';

export const { name, inject, apply } = createPlugin({
  name: 'least-privilege',
  pkgRoot: pkgRootFrom(import.meta.url),
  skillFile: 'skill/least-privilege.md',
  binFile: 'bin/cli.mjs',
  description: '查权限过宽：容器跑 root、IAM 通配、CORS 全开、令牌申请 admin —— 权限过宽是入侵的放大器',
  whenToUse: 'TODO：写清什么时候该用（用户会说的话也列上）',
});
