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
 * 账单 HTTP 接口层：仅负责参数接收与转发，不含业务逻辑。
 * <p>所有接口需登录，userId 从 JWT 上下文获取，只操作当前用户数据。</p>
 *
 * @see docs/api/bill.md
 * @see docs/learn/06-mybatis-crud.md
 */
@RestController
@RequestMapping("/api/bills")
@RequiredArgsConstructor
public class BillController {

    private final BillService billService;

    /**
     * 分页查询账单，支持按类型、分类、日期范围筛选。
     *
     * @param page        页码，默认 1
     * @param size        每页条数，默认 20，最大 100（Service 层限制）
     * @param type        可选，1 收入 / 2 支出
     * @param categoryId  可选，分类 ID
     * @param startDate   可选，开始日期 yyyy-MM-dd
     * @param endDate     可选，结束日期 yyyy-MM-dd
     * @param keyword     可选，备注关键字（模糊匹配）
     */
    @GetMapping
    public Result<BillPageVO> page(
            @RequestParam(required = false, defaultValue = "1") Integer page,
            @RequestParam(required = false, defaultValue = "20") Integer size,
            @RequestParam(required = false) Integer type,
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate,
            @RequestParam(required = false) String keyword) {
        // Query 参数组装为 DTO，避免 Controller 层传递过多零散参数到 Service
        BillQueryDTO query = new BillQueryDTO();
        query.setPage(page);
        query.setSize(size);
        query.setType(type);
        query.setCategoryId(categoryId);
        query.setStartDate(startDate);
        query.setEndDate(endDate);
        query.setKeyword(keyword);
        return Result.ok(billService.page(requireUserId(), query));
    }

    /**
     * 新增账单。校验分类归属与类型一致，写入后清除当月统计缓存。
     *
     * @param dto 账单内容，{@code @Valid} 触发字段校验
     */
    @PostMapping
    public Result<BillVO> create(@Valid @RequestBody BillCreateDTO dto) {
        return Result.ok(billService.create(requireUserId(), dto));
    }

    /**
     * 更新账单（部分字段可选）。仅能修改自己的账单。
     *
     * @param id  账单 ID
     * @param dto 要更新的字段，未传字段保持原值
     */
    @PutMapping("/{id}")
    public Result<BillVO> update(@PathVariable Long id, @Valid @RequestBody BillUpdateDTO dto) {
        return Result.ok(billService.update(requireUserId(), id, dto));
    }

    /**
     * 删除账单。仅能删除自己的账单，删除后清除当月统计缓存。
     *
     * @param id 账单 ID
     */
    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        billService.delete(requireUserId(), id);
        return Result.ok();
    }

    /**
     * 从 Security 上下文取当前登录用户 ID。
     *
     * @throws BusinessException 未登录时抛 401（过滤器未设置登录态）
     */
    private Long requireUserId() {
        Long userId = SecurityUtils.getUserId();
        if (userId == null) {
            throw new BusinessException(ResultCode.UNAUTHORIZED);
        }
        return userId;
    }
}
