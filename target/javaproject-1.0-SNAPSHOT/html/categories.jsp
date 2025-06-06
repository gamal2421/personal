<%@ page import="javawork.personalexp.tools.Database" %>
<%@ page import="javawork.personalexp.models.User" %>
<%@ page import="javawork.personalexp.models.Category" %>
<%@ page import="java.util.List" %>
<%
    // Check if the user is logged in
    String userEmail = (String) session.getAttribute("userEmail");
    if (userEmail == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int userId = Database.getUserIdByEmail(userEmail);
    User user = Database.getUserInfo(userId);
    List<Category> categories = Database.getCategories(); // Changed to get all categories
    boolean isAdmin = Database.isAdmin(userId);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Personal Expenses Manager - Categories</title>

    <!-- Apple Touch Icon (iOS) -->
<link rel="apple-touch-icon" sizes="180x180" href="/icons/apple-touch-icon.png">
<!-- Android Chrome -->
<link rel="icon" type="image/png" sizes="192x192" href="/icons/android-chrome-192x192.png">
<link rel="icon" type="image/png" sizes="512x512" href="/icons/android-chrome-512x512.png">
<!-- Favicon -->
<link rel="icon" type="image/png" sizes="32x32" href="/icons/favicon-32x32.png">
<link rel="icon" type="image/png" sizes="16x16" href="/icons/favicon-16x16.png">
<!-- Optional: Web Manifest for PWA -->
<link rel="manifest" href="/icons/site.webmanifest">


   <link rel="stylesheet" href="../css/all.min.css"> <%-- Link to Font Awesome --%>
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link rel="stylesheet" href="../css/categories.css">
    <style>
        .admin-only {
            display: none;
        }
    </style>
    <% if (isAdmin) { %>
    <style>
        .admin-only {
            display: block !important; /* Use !important to ensure it overrides the 'display: none' */
        }
    </style>
    <% } %>
</head>
<body>
<div class="main-page">
    <!-- Sidebar -->
    <div id="sidebar">
        <div id="profile-section">
            <div class="profile-image">
                <img src="https://e7.pngegg.com/pngimages/442/16/png-clipart-computer-icons-man-icon-logo-silhouette.png" alt="Profile">
            </div>
            <h3><%= user.getUsername() %></h3>
            <p><%= user.getEmail() %></p>
            <% if (isAdmin) { %>
                <small>(Admin)</small>
            <% } %>
        </div>

        <ul class="nav-menu">
            <li class="nav-item"><a href="dashboard.jsp"><i class="icons fas fa-chart-pie"></i> Dashboard</a></li>
            <li class="nav-item"><a href="Financials goals.jsp"><i class="icons fas fa-wallet"></i> Financials</a></li>
            <li class="nav-item"><a href="reports.jsp"><i class="icons fas fa-file-alt"></i> Reports</a></li>
            <li class="nav-item"><a href="budget.jsp"><i class="icons fas fa-money-bill-wave"></i> Budget</a></li>
            <li class="nav-item"><a href="income.jsp"><i class="icons fas fa-hand-holding-usd"></i> Income</a></li>
            <li class="nav-item"><a href="categories.jsp"><i class="icons fas fa-tags"></i> Categories</a></li>
            <li class="nav-item"><a href="expenses.jsp"><i class="icons fas fa-shopping-cart"></i> Expenses</a></li>
            <li class="nav-item"><a href="ai_suggests.jsp"><i class="icons fas fa-lightbulb"></i> AI Suggests</a></li>
            <li class="nav-item"><a href="logout.jsp"><i class="icons fas fa-sign-out-alt"></i> Logout</a></li>
        </ul>
    </div>

    <!-- Main Content -->
    <div class="content-area">
        <!-- Top Bar -->
        <div class="top-bar">
            <div class="page-title">
                <h1>Categories</h1>
                <% if (isAdmin) { %>
                    <small class="admin-badge">Admin Mode</small>
                <% } %>
            </div>
            <div class="top-actions">
<%--                <div class="notification-btn">--%>
<%--                    <i class="fas fa-bell"></i>--%>
<%--                </div>--%>
<%--                <div class="settings-btn">--%>
<%--                    <i class="fas fa-cog"></i>--%>
<%--                </div>--%>
            </div>
        </div>

        <!-- Categories Content -->
        <div class="categories-content">
            <div class="filter-add-section">
                <input type="text" class="filter-input" placeholder="Filter categories..." id="filterInput">
                <% if (isAdmin) { %>
                    <button class="add-btn admin-only" id="addCategoryBtn">+ Add Category</button>
                <% } %>
            </div>

            <div class="categories-grid">
                <% for (Category category : categories) { %>
                    <div class="category-card">
                        <div class="category-header">
                            <span class="category-name"><%= category.getName() %></span>
                            <% if (isAdmin) { %>
                                <div class="category-actions admin-only">
                                    <button class="action-btn edit-btn" onclick="editCategory('<%= category.getId() %>', '<%= category.getName() %>')">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button class="action-btn delete-btn" onclick="deleteCategory('<%= category.getId() %>')">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </div>
                            <% } %>
                        </div>
                    </div>
                <% } %>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Profile click event
        document.getElementById('profile-section').addEventListener('click', function() {
            document.getElementById('profileOverlay').style.display = 'block';
            document.getElementById('profileCard').style.display = 'block';
        });

        // Close popups when clicking overlay
        document.getElementById('profileOverlay')?.addEventListener('click', function() {
            this.style.display = 'none';
            document.getElementById('profileCard').style.display = 'none';
        });

        // Settings button click
        document.querySelector('.settings-btn')?.addEventListener('click', function() {
            document.getElementById('settingsOverlay').style.display = 'block';
            document.getElementById('settingsCard').style.display = 'block';
        });

        // Filter categories
        const filterInput = document.getElementById('filterInput');
        if (filterInput) {
            filterInput.addEventListener('input', function() {
                const filterValue = this.value.toLowerCase();
                document.querySelectorAll('.category-card').forEach(card => {
                    const name = card.querySelector('.category-name').textContent.toLowerCase();
                    card.style.display = name.includes(filterValue) ? 'flex' : 'none';
                });
            });
        }

        // Add category button (only for admin)
        const addBtn = document.getElementById('addCategoryBtn');
        if (addBtn) {
            addBtn.addEventListener('click', addNewCategory);
        }
    });

    function deleteCategory(categoryId) {
        if (!confirm('Are you sure you want to delete this category?')) return;
        
        fetch('../deleteCategory', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: 'categoryId=' + categoryId
        })
        .then(response => {
            if (!response.ok) throw new Error('Network response was not ok');
            return response.text();
        })
        .then(data => {
            if (data === "Success") {
                alert("Category deleted successfully!");
                location.reload();
            } else {
                alert("Failed to delete category: " + data);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert("Error deleting category. Please check console for details.");
        });
    }

    function addNewCategory() {
        const newCategoryName = prompt('Enter new category name:');
        if (!newCategoryName || !newCategoryName.trim()) return;
        
        fetch('../addCategory', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: 'categoryName=' + encodeURIComponent(newCategoryName.trim())
        })
        .then(response => {
            if (!response.ok) throw new Error('Network response was not ok');
            return response.text();
        })
        .then(data => {
            if (data === "Success") {
                alert("Category added successfully!");
                location.reload();
            } else {
                alert("Failed to add category: " + data);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert("Error adding category. Please check console for details.");
        });
    }

    function editCategory(categoryId, oldName) {
        const newName = prompt('Edit category name:', oldName);
        if (!newName || !newName.trim() || newName === oldName) return;
        
        fetch('../editCategory', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: 'categoryId=' + categoryId + '&newName=' + encodeURIComponent(newName.trim())
        })
        .then(response => {
            if (!response.ok) throw new Error('Network response was not ok');
            return response.text();
        })
        .then(data => {
            if (data === "Success") {
                alert("Category updated successfully!");
                location.reload();
            } else {
                alert("Failed to update category: " + data);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert("Error updating category. Please check console for details.");
        });
    }
</script>
</body>
</html>