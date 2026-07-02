package com.example.ledger.controller.bill;

import com.example.ledger.common.exception.BusinessException;
import com.example.ledger.common.result.Result;
import com.example.ledger.common.result.ResultCode;
import com.example.ledger.common.security.SecurityUtils;
import com.example.ledger.dto.bill.BillCreateDTO;
import com.example.ledger.dto.bill.BillQueryDTO;
import com.example.ledger.dto.bill.BillUpdateDTO;
import com.example.ledger.service.bill.BillService;
import com.example.ledger.vo.bill.BillPageVO;
import com.example.ledger.vo.bill.BillVO;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;

/**
 * 账单接口：增删改查与分页筛选。
 *
 * @see docs/api/bill.md
 */
@RestController
@RequestMapping("/api/bills")
@RequiredArgsConstructor
public class BillController {

    private final BillService billService;

    /**
     * 分页查询账单
     */
    @GetMapping
    public Result<BillPageVO> page(
            @RequestParam(required = false, defaultValue = "1") Integer page,
            @RequestParam(required = false, defaultValue = "20") Integer size,
            @RequestParam(required = false) Integer type,
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate) {
        BillQueryDTO query = new BillQueryDTO();
        query.setPage(page);
        query.setSize(size);
        query.setType(type);
        query.setCategoryId(categoryId);
        query.setStartDate(startDate);
        query.setEndDate(endDate);
        return Result.ok(billService.page(requireUserId(), query));
    }

    /** 新增账单 */
    @PostMapping
    public Result<BillVO> create(@Valid @RequestBody BillCreateDTO dto) {
        return Result.ok(billService.create(requireUserId(), dto));
    }

    /** 更新账单 */
    @PutMapping("/{id}")
    public Result<BillVO> update(@PathVariable Long id, @Valid @RequestBody BillUpdateDTO dto) {
        return Result.ok(billService.update(requireUserId(), id, dto));
    }

    /** 删除账单 */
    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        billService.delete(requireUserId(), id);
        return Result.ok();
    }

    private Long requireUserId() {
        Long userId = SecurityUtils.getUserId();
        if (userId == null) {
            throw new BusinessException(ResultCode.UNAUTHORIZED);
        }
        return userId;
    }
}
