## 🗃️ What is Database Deadlock?

A **deadlock** happens when two or more transactions are **waiting for each other’s locked resources**, and **none can proceed**.

### 🔁 Example:

- **Transaction A** locks **Row 1**, wants **Row 2**.
- **Transaction B** locks **Row 2**, wants **Row 1**.
- Both are stuck waiting → **deadlock**.

### ✅ How to Prevent Deadlocks:

- 🔄 Lock resources in a **consistent order**.
- ⏱️ Keep transactions **short and fast**.
- 🔁 Use **retry logic** in your application to handle deadlock errors.
