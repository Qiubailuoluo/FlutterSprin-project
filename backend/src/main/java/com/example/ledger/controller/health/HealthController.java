package com.example.ledger.controller.health;

import com.example.ledger.common.result.Result;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

/**
 * 健康检查接口，用于验证服务是否启动。
 */
@RestController
@RequestMapping("/api/health")
public class HealthController {

    @GetMapping
    public Result<Map<String, String>> health() {
        return Result.ok(Map.of(
                "status", "UP",
                "app", "ledger"
        ));
    }
}
