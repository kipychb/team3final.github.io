<%@page contentType="text/html;charset=utf-8" language="java" import="java.sql.*" %>
    <!DOCTYPE html>
    <html lang="zh-TW">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>關於我們 | 花予祝願所</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link
            href="https://fonts.googleapis.com/css2?family=Euphoria+Script&family=Fugaz+One&family=Homemade+Apple&family=Lavishly+Yours&family=Londrina+Sketch&family=Noto+Sans+TC:wght@100..900&family=Pinyon+Script&family=WindSong:wght@400;500&display=swap"
            rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Noto+Serif+TC:wght@500;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link rel="stylesheet" href="style.css">
    </head>

    <body>
        <header class="navbar">
            <a href="../index.jsp" class="back-home">
                <i class="fa-solid fa-arrow-left"></i> 返回首頁
            </a>
            <div class="nav-container">
                <div class="nav-logo">花予祝願所 <span class="nav-logo-e">Blooming Wish</span></div>
                <div class="nav-placeholder"></div>
            </div>
        </header>

        <main class="about-container">
            <section class="about-header">
                <div class="title-line"></div>
                <h2 class="section-title">ABOUT US</h2>
                <div class="title-line"></div>
            </section>

            <section class="brand-vision">
                <div class="brand-logo-main">
                    <img src="../image/logo.png" alt="花予祝願所 Logo">
                </div>
                <div class="vision-content">
                    <h3 class="vision-title">每一份真心，都值得被溫柔地傳遞</h3>
                    <p class="intro-text">
                        底部的花瓶，是由心臟與鳥所融合而成。
                        心臟象徵人的真心與情感，是每一份祝福的起點；
                        鳥，來自古代「傳遞訊息」的意象，代表將內心的情感與思念送達他人。
                        盛放在其上的花朵，以星星的形式呈現，象徵願望、希望與指引。<br>
                        願收到花的人，都能感受到這份溫暖 ☆
                    </p>
                </div>
            </section>

            <section class="team-garden">
                <div class="flower-member">
                    <div class="flower-info-box">
                        <div class="flower-box">
                            <img src="image/1.png" alt="賴又德" class="floating-flower">
                        </div>
                        <div class="name-tag">
                            <h4 class="member-name">賴又德</h4>
                            <p class="part">Layout / Animation Design</p>
                        </div>
                    </div>
                    <div class="member-detail">
                        <div class="member-thought">
                            <i class="fa-solid fa-quote-left thought-icon"></i>
                            <p>這次搞定這個花店電商網站，過程很麻煩，但也學到很多，在課堂上學 JSP、資料庫或是前端的 JavaScript，通常都是分開交作業，但這次要把全部的東西串在一起，才發現完全是另一個世界，這次自己親手下去做，才深刻體會到原來寫出能動的系統背後，有八成的時間都在跟 Bug 奮戰，這幾天最讓我印象深刻的就是除錯過程。好幾次畫面一片空白，或是圖片直接給我破圖變成 404，一開始真的超崩潰。後來慢慢去翻 F12 的報錯、看 Tomcat 伺服器後台噴的那一堆紅色錯誤訊息，才發現原來資料庫裡一個不起眼的空值，或是少過濾一個換行符號，就可以讓整個 JSON 格式壞掉，讓網頁直接死當。這次專案最大的收穫就是「解決問題的韌性」。把程式碼寫出來只是基本，怎麼防呆、怎麼讓網頁在遇到奇怪資料時不會崩潰，才是真正的考驗。看到最後購物車跟新舊商品圖片都能順利跑出來的那一刻，一切都值得了！

                        </div>
                    </div>
                </div>

                <div class="flower-member reverse">
                    <div class="flower-info-box">
                        <div class="flower-box">
                            <img src="image/2.png" alt="洪憲緯" class="floating-flower">
                        </div>
                        <div class="name-tag">
                            <h4 class="member-name">洪憲緯</h4>
                            <p class="part">JavaScript / Interactive Logic</p>
                        </div>
                    </div>
                    <div class="member-detail">
                        <div class="member-thought">
                            <i class="fa-solid fa-quote-left thought-icon"></i>
                            <p>這幾周真的搞JSP+後端連接很困苦，一方面是沒什麼經驗，二來是JSP這東西寫起來我覺得比JS還要混沌（甚至花了不少時間在處理相關的轉換），三來是SQL設定一弄就是一長串（為了搞資料隱碼注入攻擊的防禦），就像是在兩個不同的工作中交互切換，所以說效率肯定不如上學期單純搞HTML。此外，SQL在組員間交換也是意外的麻煩，畢竟Github肯定沒法幫你自動import .sql檔案，中間的溝通成本也是意外的高。但老實說還是很有趣的，看著當初只能用localStorage存的變數如今能直接連接到我電腦裡的SQL中永久保存，有種雨天時建好了水庫的安全感？

                        </div>
                    </div>
                </div>

                <div class="flower-member">
                    <div class="flower-info-box">
                        <div class="flower-box">
                            <img src="image/3.png" alt="卓恩多" class="floating-flower">
                        </div>
                        <div class="name-tag">
                            <h4 class="member-name">卓恩多</h4>
                            <p class="part">Picture / Content Structuring</p>
                        </div>
                    </div>
                    <div class="member-detail">
                        <div class="member-thought">
                            <i class="fa-solid fa-quote-left thought-icon"></i>
                            <p>恩多
                                這次我們小組選擇延續上學期的網站作為專案主題，在原有基礎上進一步優化與完善系統功能。與上學期相比，這次最大的收穫是加入了後端程式設計，讓網站不再只是靜態頁面，而是能夠與資料庫連接，實現資料新增、查詢、修改與刪除等功能，使整個網站架構更加完整。
                                在專案製作過程中，我深刻體會到完成一個完整網站所需要的能力遠比想像中更多。除了前端介面的設計與排版之外，還必須理解後端程式邏輯、資料庫管理、系統整合以及錯誤排除等技術。這讓我意識到自己還有許多需要學習與精進的地方。
                                此外，在團隊合作中我也學習到如何與組員分工協調、討論功能需求以及共同解決技術上的困難。
                                總體而言，這次專案讓我更了解軟體開發的完整流程。未來如果有機會，我希望能持續精進前後端技術，打造出更完善且具有實用價值的網站。
                            </p>
                        </div>
                    </div>
                </div>

                <div class="flower-member reverse">
                    <div class="flower-info-box">
                        <div class="flower-box">
                            <img src="image/4.png" alt="陳柏妤" class="floating-flower">
                        </div>
                        <div class="name-tag">
                            <h4 class="member-name">陳柏妤</h4>
                            <p class="part">Frontend UI / CSS Design</p>
                        </div>
                    </div>
                    <div class="member-detail">
                        <div class="member-thought">
                            <i class="fa-solid fa-quote-left thought-icon"></i>
                            <p>這次期末專題是我投入時間最多、收穫也最多的一次專案。相較於上學期以 HTML、CSS、JavaScript 製作的靜態網站，這次加入 JSP 與 MySQL 資料庫，讓網站具備會員系統、商品管理、購物車及訂單等功能，也讓我接觸到更完整的網站開發流程。
在專案中，我主要負責前端介面設計與版面規劃，包括首頁、商品頁面、會員中心及部分互動功能的優化。我花了許多時間調整配色、字體、版面與動畫效果，希望讓網站呈現出花店溫暖且具有情感的風格。
開發過程中，我學習到會員登入、資料庫串接及搜尋功能等實作，也遇到許多問題，例如路徑錯誤、資料傳遞異常與資料庫設定等，需要不斷測試與除錯。其中讓我印象最深刻的是搜尋功能的優化，從原本只能搜尋商品名稱，擴充到花材、花語及商品理念等內容，讓搜尋結果更符合使用者需求，也讓我體會到功能設計必須從使用者角度思考。
此外，由於專案採團隊合作方式進行，資料庫與程式修改都需要反覆整合與溝通，雖然過程中遇到不少挑戰，但最終仍順利完成網站。透過這次專題，我不僅提升了網頁設計與開發能力，也學習到團隊合作、問題解決及專案管理的重要性。


                            </p>
                        </div>
                    </div>
                </div>
            </section>
        </main>

        <footer class="footer-simple">
            <p>© 2025 花予祝願所. All Rights Reserved.</p>
        </footer>
    </body>

    </html>