package model;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class CheckoutResult {

    public enum Status {
        VALID,
        REVIEW_REQUIRED,
        BLOCKED,
        ERROR
    }

    private final Status status;
    private final int orderID;
    private final CheckoutSnapshot snapshot;
    private final List<CheckoutIssue> issues;

    public CheckoutResult(Status status, int orderID, CheckoutSnapshot snapshot,
            List<CheckoutIssue> issues) {
        this.status = status;
        this.orderID = orderID;
        this.snapshot = snapshot;
        this.issues = Collections.unmodifiableList(new ArrayList<>(issues));
    }

    public static CheckoutResult valid(int orderID, CheckoutSnapshot snapshot) {
        return new CheckoutResult(Status.VALID, orderID, snapshot, Collections.emptyList());
    }

    public static CheckoutResult changed(Status status, CheckoutSnapshot snapshot,
            List<CheckoutIssue> issues) {
        return new CheckoutResult(status, -1, snapshot, issues);
    }

    public static CheckoutResult error() {
        return new CheckoutResult(Status.ERROR, -1, null, Collections.emptyList());
    }

    public Status getStatus() {
        return status;
    }

    public int getOrderID() {
        return orderID;
    }

    public CheckoutSnapshot getSnapshot() {
        return snapshot;
    }

    public List<CheckoutIssue> getIssues() {
        return issues;
    }
}
