/* Run once on databases created before 22/08/2026. */
IF COL_LENGTH('dbo.Order', 'cancelled_by') IS NULL
BEGIN
    ALTER TABLE dbo.[Order] ADD cancelled_by nvarchar(20) NULL;
END;
GO

IF COL_LENGTH('dbo.Order', 'voucherID') IS NULL
BEGIN
    ALTER TABLE dbo.[Order] ADD voucherID int NULL;
END;
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys
    WHERE parent_object_id = OBJECT_ID('dbo.[Order]')
      AND referenced_object_id = OBJECT_ID('dbo.Voucher')
)
BEGIN
    ALTER TABLE dbo.[Order]
        ADD CONSTRAINT FK_Order_Voucher
        FOREIGN KEY (voucherID) REFERENCES dbo.Voucher(voucherID);
END;
GO

/*
 * Older checkout code stored the voucher only in CustomerVoucher. Backfill
 * Order.voucherID only when the association is unambiguous: the customer has
 * exactly one legacy used voucher and exactly one discounted Completed order.
 */
IF OBJECT_ID('dbo.CustomerVoucher', 'U') IS NOT NULL
BEGIN
    ;WITH DiscountedCompletedOrders AS (
        SELECT o.orderID, o.customerID
        FROM dbo.[Order] o
        INNER JOIN dbo.OrderDetail od ON od.orderID = o.orderID
        WHERE o.voucherID IS NULL
          AND LOWER(LTRIM(RTRIM(o.status))) = 'completed'
        GROUP BY o.orderID, o.customerID, o.total_price
        HAVING SUM(od.quantity * od.unit_price) > o.total_price
    ),
    UnambiguousOrder AS (
        SELECT orderID, customerID,
               COUNT(*) OVER (PARTITION BY customerID) AS discounted_order_count
        FROM DiscountedCompletedOrders
    ),
    UnambiguousVoucher AS (
        SELECT customerID, MIN(voucherID) AS voucherID, COUNT(*) AS voucher_count
        FROM dbo.CustomerVoucher
        WHERE is_used = 1
        GROUP BY customerID
    )
    UPDATE o
    SET voucherID = uv.voucherID
    FROM dbo.[Order] o
    INNER JOIN UnambiguousOrder uo ON uo.orderID = o.orderID
    INNER JOIN UnambiguousVoucher uv ON uv.customerID = uo.customerID
    WHERE uo.discounted_order_count = 1
      AND uv.voucher_count = 1;
END;
GO

/* Backfill existing cancelled orders using their processing data and known system reasons. */
UPDATE dbo.[Order]
SET cancelled_by = CASE
    WHEN processed_by IS NOT NULL THEN 'staff'
    WHEN cancel_reason IN (
        'Order was not approved within two days',
        'The product was out of stock when the order was reviewed'
    ) THEN 'system'
    ELSE 'user'
END
WHERE LOWER(LTRIM(RTRIM(status))) = 'cancelled'
  AND cancelled_by IS NULL;
GO
