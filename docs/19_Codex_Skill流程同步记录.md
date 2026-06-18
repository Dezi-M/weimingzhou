# Codex Skill 流程同步记录

本文件只解决一个复核问题：`.codex/skills` 里的 skill 文件不属于本小说仓库，不能直接随本仓库 commit/push。这里记录本项目相关 skill 的同步点，方便以后换机器、回看流程或审查“为什么 Codex 会这样写/审/续”。

它不是日常续写文档。普通“继续”仍优先看 `README_文档使用索引.md`、`14_当前故事状态账本.md`、当前阶段补纲和 `创作复盘_常见问题与改进.md`。

## 当前外部 Skill 位置

- `/Users/kuxiaole/.codex/skills/weimingzhou-novel-writer/SKILL.md`
- `/Users/kuxiaole/.codex/skills/weimingzhou-chapter-outliner/SKILL.md`
- `/Users/kuxiaole/.codex/skills/weimingzhou-chapter-auditor/SKILL.md`
- `/Users/kuxiaole/.codex/skills/weimingzhou-naming-scene-builder/SKILL.md`
- `/Users/kuxiaole/.codex/skills/weimingzhou-platform-publisher/SKILL.md`
- `/Users/kuxiaole/.codex/skills/weimingzhou-ten-chapter-reviewer/SKILL.md`
- `/Users/kuxiaole/.codex/skills/weimingzhou-volume-auditor/SKILL.md`

## 2026-06-18 同步点

### weimingzhou-novel-writer

- 普通“继续”默认不再只写正文，而是读上下文、检查节点、必要时路由到章纲/命名场景/单章审计/五章发布包。
- 当前阶段补纲不再固定旧的 `031-050`，而是通过 `README_文档使用索引.md` 找到当前阶段；当前为 `18_056-100过渡窗口_脑洞释放与旧账回收.md`。
- 若近期章节太硬、太疼、太密，写章时可参考 `16_温情与笑点锚点手册.md`，用破话、错话、小算盘、职业习惯或旧物尴尬给船上留一口气。
- 内置“全员智商在线”自检：主角、配角、普通人和敌人的选择要符合信息、压力、代价、欲望和限制；如果某个决定像为了剧情突然变蠢，要补约束或改决定。
- 节点检查改为“先验真 pending”：若最新章已经越过五章/十章节点，先看 `git log --oneline` 和暂存区。若已有清楚批次提交、发布包或节点记录，不重复阻塞；若没有证据，再回头处理旧批次。

### weimingzhou-chapter-outliner

- 章纲生成时读取 `14_当前故事状态账本.md`，必要时通过 README 找当前阶段补纲。
- 设计偏好加入“全员智商在线”：难点来自信息差、时间压力、身体代价、私心和取舍，不靠主角漏掉明摆着的方案、配角当提问机器、敌人放水。
- 若阶段连续严肃，可在章纲里轻放一个人味缓冲点，但不把场面写成段子。

### weimingzhou-chapter-auditor

- 审章时把“主角/配角/普通人/敌人是否按信息和代价做选择”列为读者信任风险。
- 敌人放水、配角工具化追问、角色为剧情突然变笨，优先作为影响追读的问题看。

## 后续维护口径

- 如果只改 docs，不必动本文件。
- 如果改了 `.codex/skills/weimingzhou-*` 的执行逻辑，尤其是续写、审计、章纲、发布、节点处理、Git 行为，就在这里补一条日期记录。
- 不要把完整 skill 全量复制进本仓库；这里记录“同步点”和“为什么改”，避免 docs 变重。
- 真正执行仍以 `.codex/skills` 下的 skill 文件为准，本文件负责让这些外部变化在小说仓库里可复核。
