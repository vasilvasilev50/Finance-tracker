package com.example.model;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;

import org.springframework.stereotype.Component;

import com.example.model.connections.DBConnection;
import com.example.model.exceptions.BudgetException;
import com.example.model.exceptions.PaymentException;

@Component
public class UserHasBudgetsDAO  {
	
	private static final String DELETE_BUDGET_SQL = "DELETE FROM users_has_budgets WHERE user_id = ? and expense_id = ?;";
	private static final String INSERT_BUDGET_SQL = "INSERT INTO users_has_budgets VALUES (?, ?, ?, ?, ?, ?)";
	private static final String CHECK_IF_EXPENSE_ID_EXISTS = "SELECT COUNT(expenses_id) FROM users_has_budgets WHERE expenses_id = ?;";
	private static final String CHECK_IF_REPEATING_ID_EXISTS = "SELECT COUNT(repeating_id) FROM users_has_budgets WHERE repeating_id = ?;";


	public boolean insertBudget(int userId, Budget budget) throws PaymentException {
		System.out.println(userId);
		Connection connection = DBConnection.getInstance().getConnection();

		try {

			PreparedStatement ps = connection.prepareStatement(INSERT_BUDGET_SQL);	
			ps.setInt(1, userId);
			ps.setInt(2, budget.getExpenseId());
			ps.setInt(3, budget.getRepeatingId());
			ps.setDouble(4, budget.getAmount());
			ps.setDate(5, Date.valueOf(budget.getDate()));
			ps.setString(6, budget.getDescription());

			int insert = ps.executeUpdate();
			
			return (insert >=1);

		} catch (SQLException e) {
			throw new PaymentException("Budget insert failed!",e);
		}
	}

	public void selectAndAddAllBudgetsOfUser(User user) throws PaymentException, BudgetException {
		Connection connection = DBConnection.getInstance().getConnection();

		try {
			Statement stmt = connection.createStatement();
			ResultSet rs = stmt.executeQuery("SELECT e.expenses_id, e.category, r.repeating_id, r.value, uhb.amount, "
					+ "uhb.date, uhb.description FROM users u "
					+ "JOIN users_has_budgets uhb ON (uhb.user_id = "+user.getUserId()+" AND u.user_id = "+user.getUserId()+") "
					+ "JOIN expenses e ON (uhb.expense_id = e.expenses_id) "
					+ "JOIN repeatings r ON (r.repeating_id = uhb.repeating_id) LIMIT 0, 1000");

			Budget budget = null;

			while (rs.next()) {
				int expenseId = rs.getInt(1);
				String expense = rs.getString(2);	
				int repeatingId = rs.getInt(3);
				String repeating = rs.getString(4);
				double amount = rs.getDouble(5);
				LocalDate date = rs.getDate(6).toLocalDate();
				String description = rs.getString(7);

				budget = new Budget(user.getUserId(), expenseId, expense, repeatingId, repeating, amount, date, description);
				user.addBudget(budget);

			}

		} catch (SQLException e) {
			throw new PaymentException("Budgets select failed!");
		}
	}

	public boolean deleteBudget(int userID, int expenseId) throws PaymentException {
		Connection connection = DBConnection.getInstance().getConnection();

		try {
			PreparedStatement ps = connection.prepareStatement(DELETE_BUDGET_SQL);

			ps.setInt(1, userID);
			ps.setInt(2, expenseId);
			
			int deletedRows = ps.executeUpdate(); 
			
			if (deletedRows == 0){
				throw new PaymentException("No such Budget!");
			}
			return true;

		} catch (SQLException e) {
			throw new PaymentException ("Someting went wrong!");
		}
	}

	public static boolean constainsExpense(int expenseId) {	
		
		Connection connection = DBConnection.getInstance().getConnection();
		
		try {
			Statement statement  = connection.createStatement();
			ResultSet rs = statement.executeQuery(CHECK_IF_EXPENSE_ID_EXISTS);
			rs.next();
			int result = rs.getInt(1);
			if(result == 0){
				return false;
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return true;
	}
	
	public static boolean containsRepeating(int repeatingId) {
		Connection connection = DBConnection.getInstance().getConnection();
		
		try {
			Statement statement  = connection.createStatement();
			ResultSet rs = statement.executeQuery(CHECK_IF_REPEATING_ID_EXISTS);
			rs.next();
			int result = rs.getInt(1);
			if(result == 0){
				return false;
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return true;
	}

}
