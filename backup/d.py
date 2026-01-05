import json
import re
import os
import random

def process_flower_data(file_path):
    """
    讀取 JSON 檔案，根據 is_fresh 欄位生成 image_path，
    提取名稱中的英文部分作為 ID，
    並隨機生成 inventory (40~60)，覆蓋舊值。
    """
    if not os.path.exists(file_path):
        print(f"錯誤：找不到檔案 {file_path}")
        return

    try:
        # 1. 讀取原始資料
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)

        new_data = []
        fresh_index = 0
        dried_index = 0

        # 2. 處理每一筆資料
        for item in data:
            name = item.get("name", "")
            is_fresh = item.get("is_fresh", False)
            
            # --- 處理 ID ---
            matches = re.findall(r'[^\u4e00-\u9fa5]+', name)
            processed_id = "unknown"
            if matches:
                raw_id = matches[-1].strip()
                processed_id = re.sub(r'[ \-]+', '_', raw_id.lower())
            
            # --- 處理 image_path ---
            if is_fresh:
                fresh_index += 1
                image_path = f"fresh/{fresh_index}"
            else:
                dried_index += 1
                image_path = f"dried/{dried_index}"
            
            # --- 隨機生成 inventory (覆蓋舊值) ---
            inventory = random.randint(40, 60)
            
            # --- 建立新字典 ---
            new_item = {
                "id": processed_id,
                "image_path": image_path,
                "inventory": inventory
            }
            new_item.update(item)  # 保留原本其他欄位
            
            new_data.append(new_item)

        # 3. 寫回 JSON 檔案
        with open(file_path, 'w', encoding='utf-8') as f:
            json.dump(new_data, f, ensure_ascii=False, indent=4)
        
        print(f"處理完成！已更新 {file_path}")
        print(f"統計：新鮮共 {fresh_index} 筆，乾燥共 {dried_index} 筆。")

    except Exception as e:
        print(f"發生錯誤：{e}")

if __name__ == "__main__":
    target_file = 'flowerData.json'
    process_flower_data(target_file)