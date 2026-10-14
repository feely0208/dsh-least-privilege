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

## License

MIT © 深鲸 DeepWhale
