<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@page session="false"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" type="text/css" href="css/style.css">
<script type="text/javascript" src="js/jquery-3.1.1.min.js"></script>
<script type="text/javascript" src="js/jquery.canvasjs.min.js"></script>
<link rel="stylesheet"
	href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/themes/smoothness/jquery-ui.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
<script
	src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/jquery-ui.min.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		$("#datepicker").datepicker();
	});
	
	$(document).ready(function() {

	    $('#main').change(function() {

	        if ($(this).is(':checked')) {
	        $('input[name="id"]:checkbox').prop('checked', true);        

	        } else {

	            $('input[name="id"]:checkbox').prop('checked', false);
	        }
	    });


	$('input[name="id"]:checkbox').change(function() {
	        var chkLength = $('input[name="id"]:checkbox').length;
	        var checkedLen = $('input[name="id"]:checkbox:checked').length;    
	        if (chkLength == checkedLen) {
	            $('#main').prop('checked', true);
	        } else {
	            $('#main').prop('checked', false);
	        }
	    });
	});
	</script>
	
<script type="text/javascript">
		window.onload = function () {
			var array = [];
			var obligations = ${user.obligationsJson};
			for (index in obligations) {
				var obligation = obligations[index];
				var remain = obligation.remainedAmount;
				array.push({y: obligation.amount, label: obligation.category });
				array.push({y: remain, label: "Remain" });
			}
			var chart = new CanvasJS.Chart("chartContainer", {
				title: {
					text: "Obligation amount and remain amount"
				},
				animationEnabled : true,
				data: [{
					type: "column",
					dataPoints: array
				}]
			});
			chart.render();
		}
	</script>

<title>My obligations</title>

</head>
<body>

	<jsp:include page="home.header.jsp"></jsp:include>

	<section class="">
	
	<c:choose>
		<c:when test="${not empty user.obligations }">
	<div id="chartContainer" style="height: 400px; width: 97%; margin-left: 20px;"></div>
	
	<div class="">
		<button id="myBtn">Add obligation</button>
		
		<div class="Tables">
			<table class="table" name="obligation_table" cellspacing="0"
				cellpadding="2" width="100%" border="1">
				<thead>
					<tr style="height: 35px;">
						<th><input name="selectALL" type="checkbox" value=""
							id="main" />&nbsp;Select all<br /></th>
						<th align="left">Category</th>
						<th align="right">Amount</th>
						<th>Paid</th>
						<th>Remain</th>
						<th>Date</th>
						<th>Installment</th>
						<th align="left">Description</th>
						<th align="center" colspan="2">Period</th>
					</tr>
				</thead>
				<tbody>
				<caption>
					<h2>Obligations</h2>
				</caption>
		<p>
			<form:form action="deleteObligation">
				
				<c:forEach items="${user.obligations}" var="obligation">
									
					<tr>
						<td align="center"><input type="checkbox" name="id"
									id="${obligation.id}" value="${obligation.id}" /></td>
						<td align="left"><spring:message code="${obligation.category}"></spring:message></td>
						<td align="right"><fmt:formatNumber type="number" minFractionDigits="2" 
								maxFractionDigits="2" value="${obligation.amount}" />&nbsp;$</td>
						<td align="right"><fmt:formatNumber type="number" minFractionDigits="2" 
								maxFractionDigits="2" value="${obligation.paidAmount}" />&nbsp;$</td>
						<td align="right"><fmt:formatNumber type="number" minFractionDigits="2" 
								maxFractionDigits="2" value="${obligation.remainedAmount}" />&nbsp;$</td>		
						<td align="center"><c:out value="${obligation.date}"></c:out></td>
						<td align="center"><c:out value="${obligation.repeating}"></c:out></td>
						<td align="left">(<c:out value="${obligation.description}"></c:out>)
						<td align="right" colspan="2"><c:out value="${obligation.periodQuantity}"></c:out> 
											<c:out value="${obligation.period}"></c:out></td>
						
					</tr>
				</c:forEach>
				<input type="submit" id="delete" name="commit" value="Delete selected">
			</form:form>
		</p>

		</tbody>
				<tfoot>
					<tr>
						<td align="right" colspan="2" style="padding-top: 14px"><strong>Total</strong></td>
						<td align="right" style="padding-top: 14px"><fmt:formatNumber type="number" minFractionDigits="2" 
								maxFractionDigits="2" value="${user.totalObligations}" />&nbsp;$</td>
						<td align="right" style="padding-top: 14px"><fmt:formatNumber type="number" minFractionDigits="2" 
								maxFractionDigits="2" value="${user.totalPaidObligations}" />&nbsp;$</td>
						<td align="right" style="padding-top: 14px"><fmt:formatNumber type="number" minFractionDigits="2" 
								maxFractionDigits="2" value="${user.totalRemainObligations}" />&nbsp;$</td>
						<td colspan="4" ></td>

					</tr>
				</tfoot>
			</table>
		</div>	
	</div>
	</c:when>
		<c:otherwise>
			<div id="welcome_text">
			<br>
			<h1><c:out value="${user.username}"></c:out>, here you can add obligations <br> </h1>
			<button id="myBtn" style="float: inherit; margin-left: 600px;">Add obligation</button>
			</div>
		</c:otherwise>
	</c:choose>
	<div id="myModal" class="modal">

			<div class="modal-content">
				<span class="close">close</span>

				<form:form commandName="obligation">

					<p>
						<form:label path="categoryId">Category:</form:label>
						<form:select id="categoryId" class="input" path="categoryId" >
							<form:option value="1">Credit</form:option>

							<form:option value="2">Loan</form:option>

							<form:option value="3">Fast Credit</form:option>

							<form:option value="4">Other</form:option>

						</form:select>
					</p>
					<p>
						<form:label path="amount">Sum:</form:label>
						<form:input type="number" min="0.01" step="0.01" value="1.00"
							max="1000000" id="amount" class="input" name="amount"
							path="amount" placeholder="Money" required="required" />
					</p>
					<p>
						<form:label path="repeatingId">Repeating:</form:label>
						<form:select id="repeatingId" class="input" name="repeatingId"
							path="repeatingId">

							<form:option value="1">Once</form:option>
							<form:option value="2">Daily</form:option>
							<form:option value="3">Weekly</form:option>
							<form:option value="4">Monthly</form:option>
							<form:option value="5">Year</form:option>

						</form:select>

					</p>
					<p>
						<form:label path="date">Date:</form:label>
						<form:input id="datepicker" class="input" name="date" path="date"
							placeholder="Date" required="required" />
					</p>
					
					<p>
						<form:label path="periodQuantity">For:</form:label>
						<form:input id="periodQuantity" class="input" name="periodQuantity" path="periodQuantity"
							placeholder="Quantity" required="required" type="number" min="1" max="365" step="1" style="margin-left: 68px;"/>
					</p>
					
					
					<p>
						<form:label path="periodId">Period of:</form:label>
						<form:select id="periodId" class="input" path="periodId">
							<form:option value="1">Days</form:option>

							<form:option value="2">Weeks</form:option>

							<form:option value="3">Months</form:option>

							<form:option value="4">Years</form:option>

						</form:select>
					</p>
					
					<p>
						<form:label path="description">Description:</form:label>
						<form:textarea id="description" class="input" name="description"
							path="description" placeholder="Description" required="required" />
					</p>

					<p class="submit">
						<input type="submit" name="commit" value="Add">
					</p>

				</form:form>

			</div>

		</div>
	<script type="text/javascript" src="<c:url value='js/modal.js'/>"></script>
	
	</section>

<jsp:include page="footer.jsp"></jsp:include>