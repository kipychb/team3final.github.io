import json
import re
import os

def process_flower_data(file_path):
    """
    讀取 JSON 檔案，根據 is_fresh 欄位生成 image_path，
    並提取名稱中的英文部分作為 ID。
    """
    if not os.path.exists(file_path):
        print(f"錯誤：找不到檔案 {file_path}")
        return

    try:
        # 1. 讀取原始資料
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)

        new_data = []
        # 初始化計數器
        fresh_index = 0
        dried_index = 0

        # 2. 處理每一筆資料
        for item in data:
            # 取得名稱與新鮮狀態
            name = item.get("name", "")
            is_fresh = item.get("is_fresh", False)
            
            # --- 處理 ID (提取英文部分) ---
            matches = re.findall(r'[^\u4e00-\u9fa5]+', name)
            processed_id = "unknown"
            if matches:
                raw_id = matches[-1].strip()
                processed_id = re.sub(r'[ \-]+', '_', raw_id.lower())
            
            # --- 處理 image_path 索引邏輯 ---
            if is_fresh:
                fresh_index += 1
                image_path = f"fresh/{fresh_index}"
            else:
                dried_index += 1
                image_path = f"dried/{dried_index}"
            
            # --- 關鍵改動：重新排序欄位 ---
            # 建立一個新的字典，將最想看到的欄位排在最前面
            new_item = {
                "id": processed_id,
                "image_path": image_path
            }
            # 將原本 item 的其他欄位（如 name, is_fresh 等）補進去
            new_item.update(item)
            
            new_data.append(new_item)

        # 3. 寫回 JSON 檔案
        with open(file_path, 'w', encoding='utf-8') as f:
            json.dump(new_data, f, ensure_ascii=False, indent=4)
        
        print(f"處理完成！已更新 {file_path}")
        print(f"統計：新鮮共 {fresh_index} 筆，乾燥共 {dried_index} 筆。")

    except Exception as e:
        print(f"發生錯誤：{e}")

if __name__ == "__main__":
    # 請確保你的 flowerData.json 中已有 "is_fresh": true/false 欄位
    target_file = 'flowerData.json'
    process_flower_data(target_file)