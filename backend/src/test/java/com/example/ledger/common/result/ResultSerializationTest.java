package com.example.ledger.common.result;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

class ResultSerializationTest {

    private final ObjectMapper mapper = new ObjectMapper();

    @Test
    void success_omitsErrorIdInJson() throws Exception {
        String json = mapper.writeValueAsString(Result.ok("x"));
        assertFalse(json.contains("errorId"));
        assertTrue(json.contains("\"code\":200"));
    }

    @Test
    void businessFail_omitsErrorId() throws Exception {
        Result<Void> result = Result.fail(ResultCode.BAD_REQUEST, "用户名已存在");
        assertNull(result.getErrorId());
        String json = mapper.writeValueAsString(result);
        assertFalse(json.contains("errorId"));
        assertTrue(json.contains("用户名已存在"));
    }

    @Test
    void failWithErrorId_includesField() throws Exception {
        Result<Void> result = Result.fail(ResultCode.INTERNAL_ERROR, "服务器错误", "deadbeef");
        assertEquals("deadbeef", result.getErrorId());
        String json = mapper.writeValueAsString(result);
        assertTrue(json.contains("\"errorId\":\"deadbeef\""));
        assertFalse(json.contains("Exception"));
        assertFalse(json.contains("stack"));
    }
}
