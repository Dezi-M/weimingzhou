# 《未名舟》封面资产说明

本目录只保留可复用封面资产和生成脚本。旧实验稿、临时图、重复标题稿已清理。

## 当前推荐期封面

- `weimingzhou_cover_recommend_title_20260623.png`
  - 番茄推荐期优先测试稿，尺寸 1080x1440。
  - 视觉重点：主角与妹妹站船头、舰队聚拢、红色裂水、天上拆城，书名以无底色金字竖向错落压在左侧暗云区。
  - 标题为本地真实字体和代码合成，不使用 AI 绘图模型生成文字，避免乱码。
- `weimingzhou_cover_recommend_thumb_20260623.png`
  - 180x240 缩略图检查稿，用于判断推荐位小图是否还能读出书名和冲突。
- `weimingzhou_cover_recommend_base_20260623.png`
  - 无标题底图。需要换标题位置、字体或副标题时，从这张重新生成。
- `make_cover_floating_gold_title_20260623.swift`
  - 当前推荐期封面标题脚本，只绘制金色题名字层，不加木板、破帆、红条或半透明底。

## 旧版保留封面

- `weimingzhou_cover_final_arch_title_v1.png`
  - 旧版带标题宏大岸线稿，保留作备选和历史对照。
- `weimingzhou_cover_final_arch_base_v1.png`
  - 旧版无标题底图。
- `make_cover_title.swift`
  - 旧版标题叠加脚本。

## 当前封面判断

推荐期优先用新稿测试点击，因为它在小图里更快给出三个信号：金色竖向书名、末世舰队、地球被拆。旧稿更偏“舰队与未名岸已经成型”的中后期气质，可以留作后续换封或宣传物料。
