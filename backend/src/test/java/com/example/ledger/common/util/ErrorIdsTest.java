package com.example.ledger.common.util;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

class ErrorIdsTest {

    @Test
    void newId_isEightHexChars() {
        String id = ErrorIds.newId();
        assertEquals(8, id.length());
        assertTrue(id.matches("[0-9a-f]{8}"));
    }

    @Test
    void newId_isUniqueAcrossCalls() {
        assertNotEquals(ErrorIds.newId(), ErrorIds.newId());
    }
}
