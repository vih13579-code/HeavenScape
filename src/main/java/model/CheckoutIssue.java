package model;

public class CheckoutIssue {

    public enum Severity {
        REVIEW_REQUIRED,
        BLOCKED
    }

    private final String code;
    private final Severity severity;
    private final String message;

    public CheckoutIssue(String code, Severity severity, String message) {
        this.code = code;
        this.severity = severity;
        this.message = message;
    }

    public String getCode() {
        return code;
    }

    public Severity getSeverity() {
        return severity;
    }

    public String getMessage() {
        return message;
    }
}
