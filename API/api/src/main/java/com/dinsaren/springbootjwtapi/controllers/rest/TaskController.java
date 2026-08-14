package com.dinsaren.springbootjwtapi.controllers.rest;

import com.dinsaren.springbootjwtapi.exception.AppException;
import com.dinsaren.springbootjwtapi.models.Task;
import com.dinsaren.springbootjwtapi.models.req.TaskCreateReq;
import com.dinsaren.springbootjwtapi.models.req.TaskUpdateReq;
import com.dinsaren.springbootjwtapi.models.res.MessageRes;
import com.dinsaren.springbootjwtapi.models.res.PageRes;
import com.dinsaren.springbootjwtapi.security.services.UserDetailsImpl;
import com.dinsaren.springbootjwtapi.services.TaskService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/app/task")
@Slf4j
@Tag(name = "Task", description = "Personal task management")
@RequiredArgsConstructor
public class TaskController {

    private final TaskService taskService;

    private Integer currentUserId() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        UserDetailsImpl userDetails = (UserDetailsImpl) auth.getPrincipal();
        return userDetails.getId();
    }

    @Operation(summary = "List my tasks", description = "Returns a paginated list of the logged-in user's tasks")
    @GetMapping
    public ResponseEntity<MessageRes> list(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "50") int size,
            @RequestParam(required = false, defaultValue = "ACT") String status,
            @Parameter(description = "Filter by completion status")
            @RequestParam(required = false) Boolean isCompleted
    ) {
        MessageRes res = new MessageRes();
        try {
            PageRes<Task> data = taskService.findAll(page, size, status, isCompleted, currentUserId());
            res.setSuccess(data);
            return ResponseEntity.ok(res);
        } catch (AppException e) {
            return ResponseEntity.status(e.getHttpStatus())
                    .body(new MessageRes(e.getErrorCode(), e.getMessage(), null));
        } catch (Exception e) {
            log.error("Error listing tasks", e);
            res.setInternalServer();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(res);
        }
    }

    @Operation(summary = "Get task by ID")
    @GetMapping("/{id}")
    public ResponseEntity<MessageRes> getById(@PathVariable Integer id) {
        MessageRes res = new MessageRes();
        try {
            Task task = taskService.findById(id, currentUserId());
            res.setSuccess(task);
            return ResponseEntity.ok(res);
        } catch (AppException e) {
            return ResponseEntity.status(e.getHttpStatus())
                    .body(new MessageRes(e.getErrorCode(), e.getMessage(), null));
        } catch (Exception e) {
            log.error("Error getting task {}", id, e);
            res.setInternalServer();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(res);
        }
    }

    @Operation(summary = "Create task")
    @PostMapping
    public ResponseEntity<MessageRes> create(@RequestBody TaskCreateReq req) {
        MessageRes res = new MessageRes();
        try {
            Task task = taskService.create(req, currentUserId());
            res.setCreateSuccess(task);
            return ResponseEntity.status(HttpStatus.CREATED).body(res);
        } catch (AppException e) {
            return ResponseEntity.status(e.getHttpStatus())
                    .body(new MessageRes(e.getErrorCode(), e.getMessage(), null));
        } catch (Exception e) {
            log.error("Error creating task", e);
            res.setInternalServer();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(res);
        }
    }

    @Operation(summary = "Update task")
    @PutMapping("/{id}")
    public ResponseEntity<MessageRes> update(@PathVariable Integer id, @RequestBody TaskUpdateReq req) {
        MessageRes res = new MessageRes();
        try {
            Task task = taskService.update(id, req, currentUserId());
            res.setUpdateSuccess(task);
            return ResponseEntity.ok(res);
        } catch (AppException e) {
            return ResponseEntity.status(e.getHttpStatus())
                    .body(new MessageRes(e.getErrorCode(), e.getMessage(), null));
        } catch (Exception e) {
            log.error("Error updating task {}", id, e);
            res.setInternalServer();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(res);
        }
    }

    @Operation(summary = "Delete task", description = "Soft-deletes the task")
    @DeleteMapping("/{id}")
    public ResponseEntity<MessageRes> delete(@PathVariable Integer id) {
        MessageRes res = new MessageRes();
        try {
            taskService.delete(id, currentUserId());
            res.setUpdateSuccess("Task deleted successfully");
            return ResponseEntity.ok(res);
        } catch (AppException e) {
            return ResponseEntity.status(e.getHttpStatus())
                    .body(new MessageRes(e.getErrorCode(), e.getMessage(), null));
        } catch (Exception e) {
            log.error("Error deleting task {}", id, e);
            res.setInternalServer();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(res);
        }
    }

    @Operation(summary = "Toggle task completion")
    @PatchMapping("/{id}/complete")
    public ResponseEntity<MessageRes> toggleComplete(@PathVariable Integer id, @RequestBody TaskCompleteReq req) {
        MessageRes res = new MessageRes();
        try {
            Task task = taskService.toggleComplete(id, req.isCompleted(), currentUserId());
            res.setUpdateSuccess(task);
            return ResponseEntity.ok(res);
        } catch (AppException e) {
            return ResponseEntity.status(e.getHttpStatus())
                    .body(new MessageRes(e.getErrorCode(), e.getMessage(), null));
        } catch (Exception e) {
            log.error("Error toggling task {}", id, e);
            res.setInternalServer();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(res);
        }
    }

    public static class TaskCompleteReq {
        private boolean isCompleted;
        public boolean isCompleted() { return isCompleted; }
        public void setCompleted(boolean completed) { isCompleted = completed; }
    }
}