package com.example.ledger.common.exception;

import com.example.ledger.common.result.Result;
import com.example.ledger.common.result.ResultCode;
import com.example.ledger.common.web.RequestIdFilter;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.slf4j.MDC;
import org.springframework.validation.BeanPropertyBindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.core.MethodParameter;
import org.springframework.web.servlet.resource.NoResourceFoundException;

import java.lang.reflect.Method;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

class GlobalExceptionHandlerTest {

    private final GlobalExceptionHandler handler = new GlobalExceptionHandler();

    @AfterEach
    void clearMdc() {
        MDC.clear();
    }

    @Test
    void businessException_returnsSafeMessage_withoutErrorId() {
        Result<Void> result = handler.handleBusinessException(
                new BusinessException(ResultCode.FORBIDDEN, "需要管理员权限"));

        assertEquals(403, result.getCode());
        assertEquals("需要管理员权限", result.getMessage());
        assertNull(result.getErrorId());
        assertNull(result.getData());
    }

    @Test
    void unexpectedException_usesMdcRequestId_asErrorId_andHidesCause() {
        MDC.put(RequestIdFilter.MDC_REQUEST_ID, "feedface");
        Result<Void> result = handler.handleException(
                new RuntimeException("SELECT * FROM secret_table WHERE password='x'"));

        assertEquals(500, result.getCode());
        assertEquals(ResultCode.INTERNAL_ERROR.getMessage(), result.getMessage());
        assertEquals("feedface", result.getErrorId());
        assertFalse(result.getMessage().contains("SELECT"));
        assertFalse(result.getMessage().contains("password"));
    }

    @Test
    void unexpectedException_generatesErrorId_whenMdcMissing() {
        Result<Void> result = handler.handleException(new IllegalStateException("boom"));

        assertEquals(500, result.getCode());
        assertEquals(ResultCode.INTERNAL_ERROR.getMessage(), result.getMessage());
        assertTrue(result.getErrorId() != null && result.getErrorId().matches("[0-9a-f]{8}"));
    }

    @Test
    void validationException_returnsFieldMessage_withoutErrorId() throws Exception {
        Method method = Sample.class.getDeclaredMethod("sample", String.class);
        MethodParameter parameter = new MethodParameter(method, 0);
        BeanPropertyBindingResult binding = new BeanPropertyBindingResult(new Sample(), "sample");
        binding.addError(new FieldError("sample", "name", "用户名不能为空"));
        MethodArgumentNotValidException ex =
                new MethodArgumentNotValidException(parameter, binding);

        Result<Void> result = handler.handleValidationException(ex);

        assertEquals(400, result.getCode());
        assertEquals("用户名不能为空", result.getMessage());
        assertNull(result.getErrorId());
    }

    @Test
    void noResourceFound_returnsFixedNotFound_withoutRawMessage() {
        NoResourceFoundException ex = new NoResourceFoundException(null, "/internal/debug");
        Result<Void> result = handler.handleNoResourceFound(ex);

        assertEquals(404, result.getCode());
        assertEquals(ResultCode.NOT_FOUND.getMessage(), result.getMessage());
        assertNull(result.getErrorId());
        assertFalse(result.getMessage().contains("/internal/debug"));
    }

    @SuppressWarnings("unused")
    static class Sample {
        void sample(String name) {
        }
    }
}
