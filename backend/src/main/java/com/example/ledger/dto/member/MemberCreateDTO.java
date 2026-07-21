package com.example.ledger.dto.member;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

/**
 * 新增家庭成员。
 */
@Data
public class MemberCreateDTO {

    @NotBlank(message = "成员姓名不能为空")
    @Size(max = 64, message = "成员姓名最长 64 字符")
    private String name;
}
