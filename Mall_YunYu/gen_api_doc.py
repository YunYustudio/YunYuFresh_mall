# -*- coding: utf-8 -*-
# ============================================================================
#  项目版权声明 =================================================================
#  蕴宇 · 生鲜商城后端（Mall_YunYu / fresh-mall-server）
#  本源码支持【免费商用】；使用 / 二次开发时，必须保留作者标识与出处「蕴宇 / Mall_YunYu」。
#  本项目基于 MIT 协议开源许可发布，仅要求保留本版权声明，详见项目根目录 LICENSE 文件。
#  联系方式：微信同号 19870569575 · tearhacker@outlook.com
# ============================================================================
# ============================================================================
#  【工具作用 · 必读】本脚本用于【导出 Spring Doc 后端 API 接口文档清单】。
#  ---------------------------------------------------------------------------
#  前置条件：先在本机启动 Mall_YunYu 后端服务（默认端口 8080），
#  再以 Python3 运行本脚本（仅用标准库 json / urllib，无需 pip install）。
#  运行后，脚本会抓取后端的 Spring Doc / OpenAPI 文档
#  （http://localhost:8080/v3/api-docs），将其 JSON 解析后自动生成一份
#  "完整接口清单"文本文件（输出路径见下方 TARGET 常量），内容按模块(tag)
#  分组，收录每个接口的 [method] path、说明、鉴权方式，方便离线阅读整套 API。
#  ---------------------------------------------------------------------------
#  · 若不先启动后端，脚本会报"无法获取 OpenAPI JSON"。
#  ============================================================================
import json
import urllib.request
import urllib.error
import os
from datetime import datetime

# 输出文件与脚本同目录，方便开源读者直接运行
TARGET = os.path.join(os.path.dirname(os.path.abspath(__file__)), "接口清单_Mall_YunYu.txt")

# 尝试直接读取已下载的 JSON，否则在线抓取
raw = None
try:
    with open(r"/tmp/api_docs.json", "r", encoding="utf-8") as f:
        raw = f.read()
except Exception:
    pass
if not raw:
    try:
        with urllib.request.urlopen("http://localhost:8080/v3/api-docs", timeout=15) as resp:
            raw = resp.read().decode("utf-8")
    except urllib.error.URLError as e:
        raise SystemExit("无法获取 OpenAPI JSON: " + str(e))

doc = json.loads(raw)
info = doc.get("info", {})
paths = doc.get("paths", {})

# 路径前缀 -> 鉴权说明
def auth_of(path):
    if path.startswith("/api/publicly") or path == "/api/login" or path.startswith("/api/login"):
        return "免登录"
    if path.startswith("/admin"):
        return "管理员登录(StpAdminUtil)"
    if path.startswith("/api"):
        return "用户登录(StpUserUtil)"
    return "未知"

lines = []
lines.append("=" * 78)
lines.append("生鲜商城后端 Mall_YunYu — 完整接口清单")
lines.append("=" * 78)
lines.append("生成时间: " + datetime.now().strftime("%Y-%m-%d %H:%M:%S"))
lines.append("文档标题: " + info.get("title", ""))
lines.append("描述    : " + (info.get("description", "") or "").replace("\n", " "))
lines.append("总接口数: " + str(len(paths)))
lines.append("API 文档 : http://localhost:8080/doc.html")
lines.append("=" * 78)
lines.append("")

# 按 tag 分组
groups = {}
order = []
for path, methods in paths.items():
    for method, meta in methods.items():
        if method.lower() not in ("get", "post", "put", "delete", "patch"):
            continue
        tags = meta.get("tags") or ["未分组"]
        tag = tags[0]
        if tag not in groups:
            groups[tag] = []
            order.append(tag)
        summary = meta.get("summary") or meta.get("description") or ""
        groups[tag].append((method.upper(), path, summary, auth_of(path)))

for idx, tag in enumerate(order, 1):
    items = groups[tag]
    lines.append("")
    lines.append("#" * 78)
    lines.append(f"## {idx}. 模块: {tag}  (接口数: {len(items)})")
    lines.append("#" * 78)
    for i, (method, path, summary, auth) in enumerate(items, 1):
        lines.append("")
        lines.append(f"  {i:>2}. [{method}] {path}")
        if summary:
            lines.append(f"      说明: {summary}")
        lines.append(f"      鉴权: {auth}")

lines.append("")
lines.append("=" * 78)
lines.append("说明:")
lines.append("  - /api/**          用户端接口，需用户登录(StpUserUtil)")
lines.append("  - /admin/**        管理后台接口，需管理员登录(StpAdminUtil)")
lines.append("  - /api/publicly/** 公开接口，未登录也可访问(如首页轮播/公告/营业状态)")
lines.append("  - /api/login       登录接口本身免登录")
lines.append("  - 微信支付回调 /api/publicly/payment/callback/** 由微信服务器签名调用")
lines.append("=" * 78)

text = "\n".join(lines)
with open(TARGET, "w", encoding="utf-8") as f:
    f.write(text)

print("已生成:", TARGET)
print("接口总数:", len(paths), " 模块数:", len(order))
print("模块:", " / ".join(order))
