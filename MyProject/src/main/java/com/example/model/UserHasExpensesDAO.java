package com.example.model;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;

import com.example.model.connections.DBConnection;
import com.example.model.exceptions.PaymentExpeption;

public class UserHasExpensesDAO implements UserHasDAO {

	private static final String DELETE_EXPENSE_SQL = "DELETE FROM `finance_track_test`.`users_has_expenses` WHERE `id`=?;";
	private static final String INSERT_EXPENSE_SQL = "insert into users_has_expenses values (?, ?, ?, ?, ?, ?, null)";

	public int insertPayment(int userId, Payment expense) throws PaymentExpeption {

		Connection connection = DBConnection.getInstance().getConnection();

		try {

			PreparedStatement ps = connection.prepareStatement(INSERT_EXPENSE_SQL,
					PreparedStatement.RETURN_GENERATED_KEYS);

			ps.setInt(1, userId);
			ps.setInt(2, expense.getCategoryId());
			ps.setInt(3, expense.getRepeatingId());
			ps.setDouble(4, expense.getAmount());
			ps.setDate(5, Date.valueOf(expense.getDate()));
			ps.setString(6, expense.getDescription());

			ps.executeUpdate();

			ResultSet rs = ps.getGeneratedKeys();

			rs.next();
			return rs.getInt(1);

		} catch (SQLException e) {
			throw new PaymentExpeption("Expense insert failed!");
		}
	}

	public void selectAndAddAllPaymentsOfUser(User user) throws PaymentExpeption {
		Connection connection = DBConnection.getInstance().getConnection();

		try {
			Statement stmt = connection.createStatement();
			ResultSet rs = stmt.executeQuery("select e.expenses_id, e.category, "
					+ "r.value, r.repeating_id, uhe.amount, uhe.date, uhe.description, uhe.id from users u "
					+ "join users_has_expenses uhe on (uhe.user_id = " + user.getUserId() + " and u.user_id = "
					+ user.getUserId() + ") "
					+ "join expenses e on (uhe.expenses_id = e.expenses_id) join repeatings r "
					+ "on (r.repeating_id = uhe.repeating_id) LIMIT 0, 1000");

			Expense expense = null;

			while (rs.next()) {
				int categoryId = rs.getInt(1);
				String category = rs.getString(2);
				String repeating = rs.getString(3);
				int reapeatingId = rs.getInt(4);
				double amount = rs.getDouble(5);
				LocalDate date = rs.getDate(6).toLocalDate();
				String description = rs.getString(7);
				int id = rs.getInt(8);

				expense = new Expense(categoryId, category, repeating, reapeatingId, amount, date, description, id);
				user.addExpense(expense);

			}

		} catch (SQLException e) {
			throw new PaymentExpeption("Expenses select failed!");
		}

	}

	public boolean deletePayment(int id) throws PaymentExpeption {
		Connection connection = DBConnection.getInstance().getConnection();

		try {
			PreparedStatement ps = connection.prepareStatement(DELETE_EXPENSE_SQL);

			ps.setInt(1, id);
			int deletedRows = ps.executeUpdate(); 
			if (deletedRows == 0){
				throw new PaymentExpeption("No such Expense!");
			}
			return true;

		} catch (SQLException e) {
			throw new PaymentExpeption ("Someting went wrong!");
		} 
	}

}