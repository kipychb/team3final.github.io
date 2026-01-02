
function openTab(evt, tabName) {
    var i, tabContent, tabBtn;
    tabContent = document.getElementsByClassName("tab-content");
    for (i = 0; i < tabContent.length; i++) {
        tabContent[i].classList.remove("active");
    }
    tabBtn = document.getElementsByClassName("tab-btn");
    for (i = 0; i < tabBtn.length; i++) {
        tabBtn[i].classList.remove("active");
    }
    document.getElementById(tabName).classList.add("active");
    evt.currentTarget.classList.add("active");
}

/**
 * 調整數量的通用函數
 * @param {Event} event - 點擊事件
 * @param {number} change - 增減數值 (1 或 -1)
 */
function modifyQuantity(event, change) {
    // 1. 先找到點擊按鈕所在的父層容器 (例如 .quantity-row 或 .selector)
    // 使用 closest 可以確保不論 HTML 結構怎麼微調，都能精準鎖定範圍
    const container = event.target.closest('.quantity-row');

    // 2. 在這個特定的範圍內尋找 input 元素
    const input = container.querySelector('.input');

    if (input) {
        // 3. 取得目前數值並計算新數值
        let currentVal = parseInt(input.value) || 0;
        let newVal = currentVal + change;

        // 4. 設定最小值限制（通常數量不小於 1）
        if (newVal < 1) {
            newVal = 1;
        }

        // 5. 更新數值到 input 中
        input.value = newVal;
    }
}