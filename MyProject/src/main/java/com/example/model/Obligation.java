package com.example.model;

import java.time.LocalDate;

public class Obligation extends Payment {
	
	private int periodId;
	private String period;
	private int periodQuantity;

	public Obligation(int categoryId, String category, String repeating, int reapeatingId, double amount,
			LocalDate date, String description, int id, String period, int periodId, int periodQuantity) {
		super(categoryId, category, repeating, reapeatingId, amount, date, description, id);
		this.period = period;
		this.periodId = periodId;
		this.periodQuantity = periodQuantity;
	}

	public int getPeriodId() {
		return periodId;
	}

	public String getPeriod() {
		return period;
	}

	public int getPeriodQuantity() {
		return periodQuantity;
	}

}
