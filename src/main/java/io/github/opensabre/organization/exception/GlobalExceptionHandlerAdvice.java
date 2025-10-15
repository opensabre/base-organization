package io.github.opensabre.organization.exception;

import io.github.opensabre.common.core.entity.vo.Result;
import io.github.opensabre.common.web.exception.DefaultGlobalExceptionHandlerAdvice;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandlerAdvice extends DefaultGlobalExceptionHandlerAdvice {

    @ExceptionHandler(value = {UserNotFoundException.class})
    public Result<?> userNotFound(UserNotFoundException ex) {
        log.warn(ex.getMessage());
        return Result.fail(ex.getErrorType());
    }

    @ExceptionHandler(value = {RoleNotFoundException.class})
    public Result<?> roleNotFound(RoleNotFoundException ex) {
        log.warn(ex.getMessage());
        return Result.fail(ex.getErrorType());
    }
}