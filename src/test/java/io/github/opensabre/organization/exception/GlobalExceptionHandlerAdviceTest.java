package io.github.opensabre.organization.exception;

import io.github.opensabre.common.core.entity.vo.Result;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class GlobalExceptionHandlerAdviceTest {

    @Test
    void userNotFound() {
        GlobalExceptionHandlerAdvice globalExceptionHandlerAdvice = new GlobalExceptionHandlerAdvice();
        Result result = globalExceptionHandlerAdvice.userNotFound(new UserNotFoundException());
        assertEquals("030100", result.getCode());
        assertEquals("用户未找到！", result.getMesg());
    }

    @Test
    void userNotFoundWithMessage() {
        GlobalExceptionHandlerAdvice globalExceptionHandlerAdvice = new GlobalExceptionHandlerAdvice();
        Result result = globalExceptionHandlerAdvice.userNotFound(new UserNotFoundException("用户不存的"));
        assertEquals("030100", result.getCode());
        assertEquals("用户未找到！", result.getMesg());
    }

    @Test
    void roleNotFound() {
        GlobalExceptionHandlerAdvice globalExceptionHandlerAdvice = new GlobalExceptionHandlerAdvice();
        Result result = globalExceptionHandlerAdvice.roleNotFound(new RoleNotFoundException());
        assertEquals("030200", result.getCode());
        assertEquals("角色未找到！", result.getMesg());
    }

    @Test
    void roleNotFoundWithMessage() {
        GlobalExceptionHandlerAdvice globalExceptionHandlerAdvice = new GlobalExceptionHandlerAdvice();
        Result result = globalExceptionHandlerAdvice.roleNotFound(new RoleNotFoundException("角色没找到"));
        assertEquals("030200", result.getCode());
        assertEquals("角色未找到！", result.getMesg());
    }
}