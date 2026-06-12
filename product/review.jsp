<%@page contentType="text/html;charset=utf-8" language="java" import="java.sql.*" %>
<%@include file="../utils/config.jsp" %>
<%
    String productId = request.getParameter("id");
    if (productId == null || productId.trim().isEmpty()) productId = "0";

    double totalRating = 0;
    int reviewCount = 0;
    StringBuilder reviewItems = new StringBuilder();

    try {
        PreparedStatement ps = con.prepareStatement(
            "SELECT g.Rating, g.Contents, g.DateTime, m.MemberName " +
            "FROM `guestbook` g " +
            "JOIN `member` m ON g.MemberID = m.MemberID " +
            "WHERE g.ProductID = ? ORDER BY g.DateTime DESC"
        );
        ps.setString(1, productId);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            double r   = rs.getDouble("Rating");
            String txt = rs.getString("Contents");
            String dt  = rs.getString("DateTime");
            String nm  = rs.getString("MemberName");
            if (txt == null) txt = "";
            if (nm  == null) nm  = "匿名";
            totalRating += r;
            reviewCount++;

            // 星星 HTML
            StringBuilder stars = new StringBuilder();
            for (int i = 1; i <= 5; i++) {
                if (r >= i)         stars.append("<i class=\"fa-solid fa-star\"></i>");
                else if (r >= i-0.5) stars.append("<i class=\"fa-solid fa-star-half-stroke\"></i>");
                else                 stars.append("<i class=\"fa-regular fa-star\"></i>");
            }

            reviewItems.append("<div class=\"review-item\">")
                .append("<div class=\"review-header\">")
                .append("<div class=\"reviewer-info\">")
                .append("<span class=\"reviewer-name\">").append(nm).append("</span>")
                .append("<span class=\"review-date\">").append(dt).append("</span>")
                .append("</div>")
                .append("<div class=\"review-stars\">").append(stars).append("</div>")
                .append("</div>")
                .append("<p class=\"review-text\">").append(txt).append("</p>")
                .append("</div>");
        }
        rs.close();
        ps.close();
    } catch (Exception e) {
        // DB 失敗時靜默，顯示空列表
    }

    double average = reviewCount > 0 ? totalRating / reviewCount : 0.0;

    // 平均分的星星 HTML
    StringBuilder avgStars = new StringBuilder();
    for (int i = 1; i <= 5; i++) {
        if (average >= i)          avgStars.append("<i class=\"fa-solid fa-star\"></i>");
        else if (average >= i-0.5) avgStars.append("<i class=\"fa-solid fa-star-half-stroke\"></i>");
        else                       avgStars.append("<i class=\"fa-regular fa-star\"></i>");
    }
%>

<!-- 平均評分 -->
<div class="average-rating">
    <span id="rating-score"><%= String.format("%.1f", average) %></span>
    <div class="stars-display" id="main-stars">
        <%= avgStars.toString() %>
    </div>
</div>

<!-- 送出評論表單 -->
<div class="user-rate-box">
    <p>為這份祝願評分：</p>
    <form id="review-form" method="post" action="add_review.jsp">
        <input type="hidden" name="product_id" value="<%= productId %>">
        <input type="hidden" name="rating" id="rating-value" value="0">
        <div class="star-rating-input">
            <i class="fa-solid fa-star" data-value="5"></i>
            <i class="fa-solid fa-star" data-value="4"></i>
            <i class="fa-solid fa-star" data-value="3"></i>
            <i class="fa-solid fa-star" data-value="2"></i>
            <i class="fa-solid fa-star" data-value="1"></i>
        </div>
        <textarea name="contents" id="comment-input" placeholder="分享您的感受..."></textarea>
        <button type="button" class="submit-btn" onclick="handleReviewSubmit()">送出評論</button>
    </form>
</div>

<!-- 評論清單 -->
<div class="reviews-display-section">
    <div class="reviews-list" id="reviews-list">
        <%
            if (reviewCount == 0) {
        %>
        <p class="empty-msg" style="text-align:center;color:#999;padding:20px;">此商品目前還沒有評價，歡迎留下您的第一則評論 ✿</p>
        <%
            } else {
                out.print(reviewItems.toString());
            }
        %>
    </div>
</div>

<script>
(function () {
    let userScore = 0;
    const stars = document.querySelectorAll('.star-rating-input i');

    stars.forEach(star => {
        star.addEventListener('click', function () {
            userScore = parseInt(this.getAttribute('data-value'));
            document.getElementById('rating-value').value = userScore;
            stars.forEach(s => {
                s.classList.toggle('selected', parseInt(s.getAttribute('data-value')) <= userScore);
            });
        });
    });

    window.handleReviewSubmit = function () {
        if (userScore === 0) {
            if (typeof showToastMessage === 'function') showToastMessage('請先點選星等評分 ✿');
            return;
        }
        document.getElementById('review-form').submit();
    };
})();
</script>
