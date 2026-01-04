function loginSubmit() {
    const accEl = document.getElementById('account');
    const passEl = document.getElementById('password');

    //抓取使用者「當下」輸入的文字
    const currentName = accEl.value.trim();
    const currentPass = passEl.value.trim();

    if (currentName !== "" && currentPass !== "") {
        localStorage.setItem('isLoggedIn', 'true');
        localStorage.setItem('member-name', currentName);

        
        alert(currentName + "，花予祝願所歡迎您的歸來" + "✿");

        setTimeout(() => {
            window.location.href = "../../index.html"; 
        }, 1200); 
    } else {
        alert("請填寫帳號與密碼!");
    }
}