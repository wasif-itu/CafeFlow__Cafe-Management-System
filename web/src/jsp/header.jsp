<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<nav id="sidebar" class="collapsed" aria-label="Sidebar">
    <div class="logo">
        <span class="logo-full">CafeFlow</span>
        <span class="logo-icon">☕</span>
        <button id="collapse-btn" aria-label="Collapse sidebar">⇤</button>
    </div>

    <button id="nav-toggle" aria-label="Toggle navigation menu" aria-expanded="false" aria-controls="sidebar">
        <span class="bar"></span>
        <span class="bar"></span>
        <span class="bar"></span>
    </button>

    <ul>
        <li><a href="${pageContext.request.contextPath}/src/veiws/landing.jsp"><span class="icon">🏠</span><span class="text">Home</span></a></li>
        <li><a href="${pageContext.request.contextPath}/src/veiws/menu_new.jsp"><span class="icon">📋</span><span class="text">Menu</span></a></li>
        <li><a href="${pageContext.request.contextPath}/src/veiws/cart_new.jsp"><span class="icon">🛒</span><span class="text">Cart</span></a></li>

        <!-- Show Dashboard only for Admin -->
        <c:if test="${sessionScope.role == 'admin'}">
            <li>
                <a href="${pageContext.request.contextPath}/src/veiws/admin_new.jsp">
                    <span class="icon">📊</span>
                    <span class="text">Dashboard</span>
                </a>
            </li>
        </c:if>

        <c:choose>
            <c:when test="${not empty sessionScope.username}">
                <li>
                    <a href="#" class="user-icon">
                        <span class="icon filled">👤</span>
                        <span class="text">${sessionScope.username}</span>
                    </a>
                </li>
                <li>
                    <form id="logoutForm" action="${pageContext.request.contextPath}/LogoutServlet" method="post" style="display:inline;">
                        <button type="submit" class="button" style="width: 100%; text-align: left; background: none; border: none; padding: 0.5em; font-size: 1em; cursor: pointer;">
                            <span class="icon">🚪</span>
                            <span class="text">Log Out</span>
                        </button>
                    </form>
                </li>
            </c:when>
            <c:otherwise>
                <li>
                    <a href="${pageContext.request.contextPath}/src/veiws/login_new.jsp" class="user-icon">
                        <span class="icon empty">👤</span>
                        <span class="text">Login</span>
                    </a>
                </li>
            </c:otherwise>
        </c:choose>
    </ul>
</nav>

<script src="${pageContext.request.contextPath}/src/js/script.js"></script>
<script>
    // Add event listener for logout form submission
    document.getElementById('logoutForm')?.addEventListener('submit', function(e) {
        // Clear local storage before submitting the form
        localStorage.clear();
        // The form will continue with its normal submission
    });
</script>