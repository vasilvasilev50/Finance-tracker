<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@page session="false" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" type="text/css" href="css/style.css">
<link rel="stylesheet" type="text/css" href="css/homepage.css">
<script src="//code.jquery.com/jquery-1.10.2.js"></script>
<script type="text/javascript" src="js/canvasjs.min.js"></script>
<script type="text/javascript" src="js/jquery.canvasjs.min.js"></script>
<script type="text/javascript" src="js/jquery-3.1.1.min.js"></script> 
<script type="text/javascript">
window.onload = function () {
	var incomes = ${user.incomesForMonth};
	var expenses = ${user.expensesForMonth};
	var balance = ${user.balanceForMonth};
	
	var chart = new CanvasJS.Chart("chartContainer2",
	{
		title:{
			text: "Monthly Overview"
		},
                animationEnabled: true,
		data: [
		{
			type: "doughnut",
			startAngle: 60,
			toolTipContent: "{legendText}: {y} - <strong>#percent% </strong>",
			showInLegend: true,
          explodeOnClick: true, 
			dataPoints: [
				{y: incomes, indexLabel: "Incomes #percent%", legendText: "Incomes" },
				{y: expenses, indexLabel: "Expenses #percent%", legendText: "Expenses" },
				{y: balance,  indexLabel: "Balance #percent%", legendText: "Balance" },
			]
		}
		]
	});
	chart.render();
	}
	</script>
	<script src="../../canvasjs.min.js"></script>
<title>Welcome in TYM!</title>

</head>
<body>
	
	<jsp:include page="home.header.jsp"></jsp:include> 
	
	<div id="chartContainer2" style="height: 400px; width: 100%;"></div>

	<section class="section_home">	
	
	<div class="table" style="width:300px">
		
		<p> Incomes: <c:out value="${user.incomesForMonth}"></c:out>&nbsp;$ </p>
		<p> Expenses: <c:out value="${user.expensesForMonth}"></c:out>&nbsp;$ </p>
		<p> Balance: <c:out value="${user.balanceForMonth}"></c:out>&nbsp;$ </p>

	</div>
	
	<div class="Tables">
		<table class="table" name="expense_table" cellspacing="0"
				cellpadding="2" width="100%">
			<thead>
				<tr style="height: 35px;">
					<th align="left">Category</th>
					<th align="right">Amount</th>
					<th>Repeat</th>
					<th>Date</th>	
					<th align="left">Description</th>
				</tr>
					</thead>
					<tbody>
					<caption>
						<h2>Upcoming payments</h2>
					</caption>
			<p>
			<c:forEach items="${user.upcomingPaymentsForMonth}" var="payment">
				<tr>
					<td align="left"><c:out value="${payment.category}"></c:out></td>
					<td align="right"><c:out value="${payment.amount}"></c:out>&nbsp;$</td>
					<td align="center"><c:out value="${payment.repeating}"></c:out></td>
					<td align="center"><c:out value="${payment.date}"></c:out></td>
					<td align="left">(<c:out value="${payment.description}"></c:out>)</td>		
				</tr>
			</c:forEach>
			<p/>
			</tbody>
		</table>	

	</div>
	</section>

	<div>
		<br />
		<hr>
	</div>
	<footer>
	<div id="footer">
		<p>Webpage made by Vasil and Katerina, IT Talents Training Camp,
			Java EE, 2016</p>
	</div>
	</footer>

</body>
</html>