package com.example.ledger.common.util;

import java.util.UUID;

/**
 * 生成短关联编号（requestId / errorId），便于日志检索与用户报障。
 */
public final class ErrorIds {

    private ErrorIds() {
    }

    /** 8 位十六进制，足够本地/中小流量关联，避免 UUID 过长。 */
    public static String newId() {
        return UUID.randomUUID().toString().replace("-", "").substring(0, 8);
    }
}
