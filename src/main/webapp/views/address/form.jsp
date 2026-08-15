<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Address"%>

<%
Address a = (Address) request.getAttribute("address");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Address Form</title>
</head>
<body>

<h1><%=a == null ? "Create Address" : "Update Address"%></h1>

<form action="${pageContext.request.contextPath}/profile/address" method="post">

    <input type="hidden" name="id"
           value="<%=a != null ? a.getAddressID() : ""%>">

    Customer ID:
    <input type="number" name="customerID" required
           value="<%=a != null ? a.getCustomerID() : 2%>">
    <br><br>

    Street:
    <input type="text" name="street" required
           value="<%=a != null ? a.getStreet() : ""%>">
    <br><br>

    District:
    <input type="text" name="district"
           value="<%=a != null ? a.getDistrict() : ""%>">
    <br><br>

    City:
    <input type="text" name="city"
           value="<%=a != null ? a.getCity() : ""%>">
    <br><br>

    Country:
    <input type="text" name="country"
           value="<%=a != null ? a.getCountry() : "Vietnam"%>">
    <br><br>

    Default:
    <input type="checkbox" name="isDefault"
           <%=a != null && a.isDefault() ? "checked" : ""%>>
    <br><br>

    <button type="submit">Save</button>
    <a href="address">Back</a>

</form>

</body>
</html>
