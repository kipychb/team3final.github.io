import json
import re
import os

def process_flower_data(file_path):
    """
    讀取 JSON 檔案，提取名稱中的英文部分並轉換為 ID。
    確保 id 欄位出現在 JSON 的最上方。
    """
    if not os.path.exists(file_path):
        print(f"錯誤：找不到檔案 {file_path}")
        return

    try:
        # 1. 讀取原始資料
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)

        new_data = []

        # 2. 處理每一筆資料
        for item in data:
            name = item.get("name", "")
            
            # 使用正規表達式抓取「中文之後」的部分
            matches = re.findall(r'[^\u4e00-\u9fa5]+', name)
            
            processed_id = "unknown"
            if matches:
                raw_id = matches[-1].strip()
                processed_id = re.sub(r'[ \-]+', '_', raw_id.lower())
            
            # --- 關鍵改動：重新排序欄位 ---
            # 建立一個新的字典，先放 id，再放原本 item 的內容
            # **item 會展開原本所有的鍵值（例如 name 等）
            new_item = {"id": processed_id}
            new_item.update(item)
            
            new_data.append(new_item)

        # 3. 寫回 JSON 檔案
        with open(file_path, 'w', encoding='utf-8') as f:
            json.dump(new_data, f, ensure_ascii=False, indent=4)
        
        print(f"處理完成！已更新 {file_path}，id 現在位於最上方。")

    except Exception as e:
        print(f"發生錯誤：{e}")

if __name__ == "__main__":
    target_file = 'flowerData.json'
    process_flower_data(target_file)