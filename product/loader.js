/**
 * loader.js
 * 功能：產品頁面自動載入器 - 徹底修正變數重複宣告與 JSON 防護
 */

async function loadProductDetail() {
    const urlParams = new URLSearchParams(window.location.search);
    const productId = urlParams.get('id');

    if (!productId) {
        console.error("未找到產品 ID");
        return;
    }

    try {
        const response = await fetch(`get_product_detail.jsp?id=${productId}`);
        const textData = await response.text(); // 先以文字讀取，防止崩潰

        // 檢查是不是被吐了 HTML 網頁
        if (textData.trim().startsWith("<!DOCTYPE") || textData.trim().startsWith("<html")) {
            console.error("後端 JSP 噴錯了！吐回了網頁 HTML 而不是 JSON。請檢查 Tomcat 後台 Log。");
            return;
        }

        // 💡 關鍵修正：這裡只宣告一次 flower 變數
        const flower = JSON.parse(textData);

        // 💡 防禦機制：如果後端 Java 執行有抓到 Exception，直接在控制台攔截
        if (flower.error) {
            console.error("🚨 抓到了！後端 Java 執行報錯：", flower.error);
            return;
        }

        if (flower && flower.ProductID) {
            document.title = `${flower.ProductName} | 花予祝願所`;
            updateTextContent(flower);
            initImageCarousel(flower);

            const heartBtn = document.querySelector('.heart-btn');
            if (heartBtn) heartBtn.setAttribute('data-id', flower.ProductID);
            if (typeof syncHeartStatus === "function") syncHeartStatus(flower.ProductID);

            // 購物車按鈕綁定
            const addCartBtn = document.querySelector('.add-cart-btn');
            if (addCartBtn) {
                addCartBtn.onclick = function () {
                    const quantityInput = document.querySelector('.quantity-row .input');
                    const count = parseInt(quantityInput.value) || 1;
                    if (count > flower.Quantity) {
                        alert("庫存不足 ✿");
                    } else if (typeof addToCart === "function") {
                        addToCart(flower.ProductID, count);
                    }
                };
            }
        }
    } catch (error) {
        console.error("解析 JSON 失敗，錯誤內容為:", error);
    }
}

function initImageCarousel(flower) {
    const imgBox = document.querySelector('.main-img-box');
    const thumbList = document.querySelector('.thumbnail-list');
    if (!imgBox) return;

    let imgPath1 = "";
    let imgPath2 = "";
    const fallbackImg = "../image/flower/fresh/1-2.jpg"; // 安全保底圖

    if (flower.Image && flower.Image.trim() !== '' && flower.Image.trim() !== 'null') {
        let imgUrl = flower.Image.trim();
        
        if (imgUrl.indexOf('/') !== -1 || imgUrl.endsWith("-2.jpg")) {
            if (imgUrl.indexOf('image/') === 0) {
                imgPath1 = "../" + imgUrl.replace("-2.jpg", "-1.jpg");
                imgPath2 = "../" + imgUrl;
            } else {
                imgPath1 = "../image/" + imgUrl.replace("-2.jpg", "-1.jpg");
                imgPath2 = "../image/" + imgUrl;
            }
        } else {
            imgPath1 = `../image/images/${imgUrl}`;
            imgPath2 = `../image/images/${imgUrl}`;
        }
    } else {
        let idx = flower.relativeIndex || 1;
        let cat = flower.Category || "fresh";
        imgPath1 = `../image/flower/${cat}/${idx}-1.jpg`;
        imgPath2 = `../image/flower/${cat}/${idx}-2.jpg`;
    }

    imgBox.innerHTML = `
        <img class="carousel-img" src="${imgPath1}" alt="${flower.ProductName}-1" style="display: block; width: 100%; height: 100%; object-fit: cover;" onerror="this.onerror=null; this.src='${fallbackImg}';">
        <img class="carousel-img" src="${imgPath2}" alt="${flower.ProductName}-2" style="display: none; width: 100%; height: 100%; object-fit: cover;" onerror="this.onerror=null; this.src='${fallbackImg}';">
    `;

    if (thumbList) {
        thumbList.innerHTML = `
            <div class="thumb active" data-index="0" style="cursor: pointer;">
                <img src="${imgPath1}" alt="縮圖 1" onerror="this.onerror=null; this.src='${fallbackImg}';">
            </div>
            <div class="thumb" data-index="1" style="cursor: pointer;">
                <img src="${imgPath2}" alt="縮圖 2" onerror="this.onerror=null; this.src='${fallbackImg}';">
            </div>
        `;

        const images = imgBox.querySelectorAll('.carousel-img');
        const thumbs = thumbList.querySelectorAll('.thumb');

        thumbs.forEach((thumb, index) => {
            thumb.onclick = () => {
                images.forEach((img, i) => {
                    if (img) img.style.display = (i === index) ? 'block' : 'none';
                });
                thumbs.forEach(t => t.classList.remove('active'));
                thumb.classList.add('active');
            };
        });
    }
}

function updateTextContent(flower) {
    let container = document.querySelector('.product-info .info-group');
    if (container) {
        container.querySelector('.name').textContent = flower.ProductName;
        container.querySelector('.series').textContent = "【" + flower.Series + "系列】";
        container.querySelector('.price').textContent = "NT$ " + flower.Price.toLocaleString();
        const descEl = container.querySelector('.desc');
        if (descEl) {
            descEl.style.whiteSpace = "pre-line";
            descEl.textContent = "🕊️花語：" + flower.Language + "\n\n🕊️商品理念：" + flower.Idea;
        }
    }

    const invenEl = document.querySelector('.inventory');
    if (invenEl) invenEl.textContent = "僅剩 " + flower.Quantity + " 束";

    const leftBox = document.querySelector('.left-box');
    const rightBox = document.querySelector('.right-box');

    let methodsHtml = "";
    if (flower.SaveMethods && flower.SaveMethods.length > 0) {
        methodsHtml = flower.SaveMethods.map(m => `<li>${m}</li>`).join('');
    } else {
        methodsHtml = "<li>暫無保存與配送建議資訊。</li>";
    }

    if (leftBox) {
        leftBox.innerHTML = `
            <div><h3>▪️尺寸規格：</h3><p>${flower.Size || "通用規格"}</p></div>
            <div><h3>▪️使用花材：</h3><p>${flower.Material || "精選花材"}</p></div>
            <div><h3>▪️鑑賞期：</h3><p>${flower.AppreciationPeriod || "視保存狀況而定"}</p></div>
        `;
    }
    if (rightBox) {
        rightBox.innerHTML = `<h3>▪️配送與訂購建議：</h3><ul>${methodsHtml}</ul>`;
    }
}

window.addEventListener('load', () => {
    loadProductDetail();
});