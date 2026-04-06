// src/main/java/bean/Order.java
package bean;

import java.sql.Timestamp;

public class Order {
    private int id;
    private String customerName;
    private String contact;
    private String address;
    private String paymentMethod;
    private String items;
    private String status;
    private Timestamp orderDate;

    public Order() { }

    // ——— Getters & Setters ———

    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    public String getCustomerName() {
        return customerName;
    }
    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getContact() {
        return contact;
    }
    public void setContact(String contact) {
        this.contact = contact;
    }

    public String getAddress() {
        return address;
    }
    public void setAddress(String address) {
        this.address = address;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }
    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getItems() {
        return items;
    }
    public void setItems(String items) {
        this.items = items;
    }

    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getOrderDate() {
        return orderDate;
    }
    public void setOrderDate(Timestamp orderDate) {
        this.orderDate = orderDate;
    }

    @Override
    public String toString() {
        return "Order{" +
               "id=" + id +
               ", customerName='" + customerName + '\'' +
               ", contact='" + contact + '\'' +
               ", address='" + address + '\'' +
               ", paymentMethod='" + paymentMethod + '\'' +
               ", items='" + items + '\'' +
               ", status='" + status + '\'' +
               ", orderDate=" + orderDate +
               '}';
    }
}
