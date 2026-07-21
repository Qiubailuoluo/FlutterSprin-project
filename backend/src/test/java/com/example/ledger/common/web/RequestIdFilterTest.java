package com.example.ledger.common.web;

import jakarta.servlet.FilterChain;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.slf4j.MDC;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

class RequestIdFilterTest {

    private final RequestIdFilter filter = new RequestIdFilter();

    @AfterEach
    void clearMdc() {
        MDC.clear();
    }

    @Test
    void usesIncomingHeader_andEchoesResponse_andClearsMdc() throws Exception {
        MockHttpServletRequest request = new MockHttpServletRequest();
        request.addHeader(RequestIdFilter.HEADER_REQUEST_ID, "custom01");
        MockHttpServletResponse response = new MockHttpServletResponse();

        FilterChain chain = (req, res) -> {
            assertEquals("custom01", MDC.get(RequestIdFilter.MDC_REQUEST_ID));
        };

        filter.doFilter(request, response, chain);

        assertEquals("custom01", response.getHeader(RequestIdFilter.HEADER_REQUEST_ID));
        assertNull(MDC.get(RequestIdFilter.MDC_REQUEST_ID));
    }

    @Test
    void generatesId_whenHeaderMissing() throws Exception {
        MockHttpServletRequest request = new MockHttpServletRequest();
        MockHttpServletResponse response = new MockHttpServletResponse();

        final String[] seenInChain = {null};
        FilterChain chain = (req, res) -> {
            seenInChain[0] = MDC.get(RequestIdFilter.MDC_REQUEST_ID);
        };

        filter.doFilter(request, response, chain);

        assertNotNull(seenInChain[0]);
        assertTrue(seenInChain[0].matches("[0-9a-f]{8}"));
        assertEquals(seenInChain[0], response.getHeader(RequestIdFilter.HEADER_REQUEST_ID));
        assertNull(MDC.get(RequestIdFilter.MDC_REQUEST_ID));
    }
}
