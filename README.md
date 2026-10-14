# @deepwhale-cn/dsh-least-privilege

[![Listed on dsh-plugin.org](https://dsh-plugin.org/badges/listed.svg)](https://dsh-plugin.org/plugins/feely0208/dsh-least-privilege)


**关键词**：最小权限 · 权限过宽 · 权限管理 · 容器 root · IAM · CORS · 访问控制 · 权限最小化 · 特权容器
**Keywords**: least privilege · over-permission · container root · IAM wildcard · CORS · access control
**最小权限检查** —— 容器跑 root、IAM 通配、CORS 全开、令牌申请 admin。

## 不装它会怎样

你的部署里有这么一段：

```yaml
services:
  app:
    privileged: true
```

当时是为了让容器能访问某个设备，后来那个需求没了，**但这行留下了**。

哪天应用出了个漏洞，攻击者进到容器里 —— 而因为 `privileged`，
他拿到的几乎是**宿主机**。

**权限过宽是入侵的放大器**，而且它**没有任何症状** —— 系统照常跑，
直到出事那天你才发现那把钥匙能开所有的门。

## 它查什么

| 级别 | 内容 |
|---|---|
| 🔴 高 | 容器跑 root / `--privileged` · IAM `Action: *` |
| 🟡 中 | CORS 允许所有来源 · 令牌申请 admin/全量 scope |

## 安装

```bash
dsh plugin --profile web add @deepwhale-cn/dsh-least-privilege
# 或纯 CLI
npx @deepwhale-cn/dsh-least-privilege
```

## 用法

```bash
dsh-least-privilege --demo
dsh-least-privilege --list-rules
dsh-least-privilege --html r.html
```

![dsh-least-privilege 检查报告示例](https://www.deepwhale.org.cn/plugin-assets/dsh-least-privilege/report.png)

![dsh-least-privilege 演示模式输出](https://www.deepwhale.org.cn/plugin-assets/dsh-least-privilege/demo.png)

![dsh-least-privilege 规则与依据](https://www.deepwhale.org.cn/plugin-assets/dsh-least-privilege/rules.png)

## 边界

- **只查「明显过宽」的写法** —— 权限偏大但没用通配符的，需要人工评审。
- **不解析云厂商实际生效策略** —— IAM 有继承/条件/边界，只看仓库里字面写的。
- **Dockerfile 可能多阶段** —— builder 阶段的 `USER root` 通常无害，需你判断。
- 与 [dsh-data-scan](https://github.com/feely0208/dsh-data-scan) 分工：那个查数据，这个查**访问数据的权限**。

本插件是一个工具。使用者必须遵守所在地区法律法规，**对使用本项目造成的任何后果自行承担责任。**


---

## 深鲸网安守护系列（共 22 个）

> 一个插件做一件事。**安全问题是链式的** —— 配套用才完整。

**国内合规** ｜ [等保对照](https://github.com/feely0208/dsh-cn-mlps) · [日志留存](https://github.com/feely0208/dsh-cn-log-retention) · [备案公示](https://github.com/feely0208/dsh-cn-filing) · [用户同意](https://github.com/feely0208/dsh-consent-guard) · [个人信息权利](https://github.com/feely0208/dsh-data-rights) · [未成年人保护](https://github.com/feely0208/dsh-minor-guard) · [影响评估](https://github.com/feely0208/dsh-pipia) · [数据分类分级](https://github.com/feely0208/dsh-data-classify) · [算法备案](https://github.com/feely0208/dsh-algorithm-filing) · [数据出境](https://github.com/feely0208/dsh-cn-data-export)

**AI 与 Agent 治理** ｜ [AI 输出信任](https://github.com/feely0208/dsh-ai-output-trust) · [外部内容信任](https://github.com/feely0208/dsh-content-trust) · [MCP 安全](https://github.com/feely0208/dsh-mcp-audit) · [Agent 权限](https://github.com/feely0208/dsh-agent-scope)

**数据与凭据** ｜ [敏感数据](https://github.com/feely0208/dsh-data-scan) · [密钥轮换](https://github.com/feely0208/dsh-key-rotate)

**供应链与构建** ｜ [开源许可](https://github.com/feely0208/dsh-license-guard) · [依赖投毒](https://github.com/feely0208/dsh-dep-audit) · [CI 安全](https://github.com/feely0208/dsh-ci-guard)

**权限与应急** ｜ [**最小权限**](https://github.com/feely0208/dsh-least-privilege) · [告警外发](https://github.com/feely0208/dsh-alert-relay) · [应急证据包](https://github.com/feely0208/dsh-incident-package)

都在 DSH 插件市场（dsh-plugin.org）和 npm 上，`dsh plugin --profile web add <包名>` 即可安装。

## License

MIT © 深鲸 DeepWhale
