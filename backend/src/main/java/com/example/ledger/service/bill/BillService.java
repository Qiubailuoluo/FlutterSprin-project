package com.example.ledger.service.bill;

import com.example.ledger.dto.bill.BillCreateDTO;
import com.example.ledger.dto.bill.BillQueryDTO;
import com.example.ledger.dto.bill.BillUpdateDTO;
import com.example.ledger.vo.bill.BillPageVO;
import com.example.ledger.vo.bill.BillVO;

/**
 * 账单业务接口。
 */
public interface BillService {

    BillPageVO page(Long userId, BillQueryDTO query);

    BillVO create(Long userId, BillCreateDTO dto);

    BillVO update(Long userId, Long billId, BillUpdateDTO dto);

    void delete(Long userId, Long billId);
}
