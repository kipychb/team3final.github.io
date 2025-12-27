import json
import re

def parse_flower_data(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # 以「［」作為每朵花的開頭進行切割
    raw_sections = content.split('［')
    flower_list = []

    for section in raw_sections:
        # 確保區塊內包含基本標記，否則跳過
        if not section.strip() or '系列］' not in section:
            continue
        
        # 補回被切割掉的符號
        full_text = '［' + section

        # 定義輔助函式，增加 flags 參數來處理跨行匹配
        def get_field(pattern, text, default="", flags=0):
            match = re.search(pattern, text, flags)
            return match.group(1).strip() if match else default

        # 1. 解析基本欄位 (使用 Regex 增加容錯率)
        series = get_field(r"［(.*?)系列］", full_text)
        name = get_field(r"商品名稱[：:]\s*(.*?)\n", full_text)
        price_str = get_field(r"售價[：:]\s*\$(.*?)\n", full_text)
        inventory_str = get_field(r"庫存數量[：:]\s*(.*?)\s*束", full_text)
        
        # 2. 解析規格與詳細資訊
        size = get_field(r"尺寸規格[：:]\s*(.*?)\n", full_text)
        material = get_field(r"使用花材\s*[：:]\s*(.*?)\n", full_text)
        appreciation = get_field(r"鑑賞期\s*[：:]\s*(.*?)\n", full_text)
        
        # 3. 解析保存重點 (抓取「保存重點：」到下一個表情符號之間的內容)
        save_methods = []
        save_section = get_field(r"保存重點[：:]\n(.*?)(?=🕊️)", full_text, flags=re.DOTALL)
        if save_section:
            # 抓取有編號 (1. 2.) 的行
            save_methods = [line.split('.', 1)[1].strip() for line in save_section.strip().split('\n') if '.' in line]

        # 4. 解析花語與理念
        language = get_field(r"花語[：:]\s*(.*?)\n", full_text)
        
        # 理念可能叫「商品理念」或「設計理念」，抓到區塊結束或下一個花朵前
        idea = get_field(r"(?:商品理念|設計理念)[：:]\s*(.*?)(?=\n\s*\n|\Z)", full_text, flags=re.DOTALL)

        # 整理成字典
        flower_data = {
            "name": name,
            "series": series,
            "is_fresh": True,
            "inventory": int(price_str.replace(',', '')) if price_str.replace(',', '').isdigit() else 0, # 此處依你需求處理數字
            "inventory": int(inventory_str) if inventory_str.isdigit() else 0,
            "price": int(price_str.replace(',', '')) if price_str.replace(',', '').isdigit() else 0,
            "size": size,
            "material": material,
            "appreciation_period": appreciation,
            "save_methods": save_methods,
            "language": language,
            "idea": idea.strip()
        }
        flower_list.append(flower_data)

    return flower_list

# --- 主程式執行 ---
input_file = 'product_info.txt'
output_file = 'flowerData.json'

try:
    all_flowers = parse_flower_data(input_file)
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(all_flowers, f, ensure_ascii=False, indent=4)
    print(f"轉換成功！共計轉換 {len(all_flowers)} 朵花，已存至 {output_file}")
except Exception as e:
    print(f"發生錯誤: {e}")