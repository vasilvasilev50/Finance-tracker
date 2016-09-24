package trackYourMoney;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;

import connections.DBConnection;
import exceptions.PaymentExpeption;

public class UserHasIncomesDAO extends UserHasDAO {

	private static final String INSERT_INCOME_SQL = "insert into users_has_incomes values (?, ?, ?, ?, ?, ?, null)";
	private static final String DELETE_INCOME_SQL = "DELETE FROM `finance_track_test`.`users_has_incomes` WHERE `id`=?;";

	@Override
	public int insertPayment(int userId, Payment income) throws PaymentExpeption {
		Connection connection = DBConnection.getInstance().getConnection();

		try {
			
			PreparedStatement ps = connection.prepareStatement(INSERT_INCOME_SQL, PreparedStatement.RETURN_GENERATED_KEYS);
			
			ps.setInt(1, userId);
			ps.setInt(2,income.getCategoryId());
			ps.setInt(3, income.getReapeatingId());
			ps.setDouble(4, income.getAmount());
			ps.setDate(5, Date.valueOf(income.getDate()));
			ps.setString(6,income.getDescription());
			
			ps.executeUpdate();
			
			ResultSet rs = ps.getGeneratedKeys();

			rs.next();
			return rs.getInt(1);

		} catch (SQLException e) {
			throw new PaymentExpeption("Income insert failed!");
		}
		
	}

	@Override
	public void selectAndAddAllPaymentsOfUser(User user) throws PaymentExpeption {
		
		Connection connection = DBConnection.getInstance().getConnection();

		try {
			Statement stmt = connection.createStatement();
			ResultSet rs = stmt.executeQuery("select i.incomes_id, i.category,r.value, r.repeating_id, "
					+ "uhi.amount, uhi.date, uhi.description, uhi.id from users u "
					+ "join users_has_incomes uhi on (uhi.user_id = "+user.getUserId()+" and u.user_id = "+user.getUserId()+") "
					+ "join incomes i on (uhi.incomes_id = i.incomes_id) "
					+ "join repeatings r on (r.repeating_id = uhi.repeating_id) LIMIT 0, 1000");

			Income income = null;
			while (rs.next()) {
				int categoryId = rs.getInt(1);
				String category = rs.getString(2);
				String repeating = rs.getString(3);
				int reapeatingId = rs.getInt(4);
				double amount = rs.getDouble(5);
				LocalDate date = rs.getDate(6).toLocalDate();
				String description = rs.getString(7);
				int id = rs.getInt(8);
				
				income = new Income(categoryId, category, repeating, reapeatingId, amount, date, description, id);
				user.addIncome(income);
	
			}

		} catch (SQLException e) {
			throw new PaymentExpeption("Incomes select failed!");
		}
		
	}

	@Override
	public boolean deletePayment(int id) throws PaymentExpeption {
		Connection connection = DBConnection.getInstance().getConnection();

		try {
			PreparedStatement ps = connection.prepareStatement(DELETE_INCOME_SQL);

			ps.setInt(1, id);
			int deletedRows = ps.executeUpdate(); 
			if (deletedRows == 0){
				throw new PaymentExpeption("No such Income!");
			}
			return true;

		} catch (SQLException e) {
			throw new PaymentExpeption ("Someting went wrong!");
		} 
	}

	
	
}
