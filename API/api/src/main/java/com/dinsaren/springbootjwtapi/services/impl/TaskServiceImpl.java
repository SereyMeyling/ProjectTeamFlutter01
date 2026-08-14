package com.dinsaren.springbootjwtapi.services.impl;

import com.dinsaren.springbootjwtapi.exception.AppException;
import com.dinsaren.springbootjwtapi.models.Task;
import com.dinsaren.springbootjwtapi.models.req.TaskCreateReq;
import com.dinsaren.springbootjwtapi.models.req.TaskUpdateReq;
import com.dinsaren.springbootjwtapi.models.res.PageRes;
import com.dinsaren.springbootjwtapi.repository.TaskRepository;
import com.dinsaren.springbootjwtapi.repository.UserRepository;
import com.dinsaren.springbootjwtapi.services.TaskService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class TaskServiceImpl implements TaskService {

    private final TaskRepository taskRepository;
    private final UserRepository userRepository;

    @Override
    public PageRes<Task> findAll(int page, int size, String status, Boolean isCompleted, Integer userId) throws AppException {
        Page<Task> result = taskRepository.findAllByStatusAndUser_IdOrderByIdDesc(
                status == null ? "ACT" : status, userId, PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "id")));

        if (isCompleted != null) {
            var filtered = result.getContent().stream()
                    .filter(t -> t.isCompleted() == isCompleted)
                    .toList();
            return PageRes.of(new org.springframework.data.domain.PageImpl<>(
                    filtered, result.getPageable(), filtered.size()));
        }
        return PageRes.of(result);
    }

    @Override
    public Task findById(Integer id, Integer userId) throws AppException {
        return taskRepository.findByIdAndUser_IdAndStatus(id, userId, "ACT")
                .orElseThrow(() -> new AppException(HttpStatus.NOT_FOUND, "ERR-404", "Task not found"));
    }

    @Override
    public Task create(TaskCreateReq req, Integer userId) throws AppException {
        if (req.getTitle() == null || req.getTitle().isBlank()) {
            throw new AppException(HttpStatus.BAD_REQUEST, "ERR-400", "Title is required");
        }

        var user = userRepository.findById(userId)
                .orElseThrow(() -> new AppException(HttpStatus.BAD_REQUEST, "ERR-400", "User not found"));

        Task task = new Task();
        task.setTitle(req.getTitle());
        task.setDescription(req.getDescription());
        task.setPriority(req.getPriority() == null ? Task.Priority.MEDIUM : req.getPriority());
        task.setCategory(req.getCategory());
        task.setDeadline(req.getDeadline());
        task.setStatus("ACT");
        task.setCompleted(false);
        task.setUser(user);

        return taskRepository.save(task);
    }

    @Override
    public Task update(Integer id, TaskUpdateReq req, Integer userId) throws AppException {
        Task task = findById(id, userId);

        if (req.getTitle() != null) task.setTitle(req.getTitle());
        if (req.getDescription() != null) task.setDescription(req.getDescription());
        if (req.getPriority() != null) task.setPriority(req.getPriority());
        if (req.getCategory() != null) task.setCategory(req.getCategory());
        if (req.getDeadline() != null) task.setDeadline(req.getDeadline());
        if (req.getIsCompleted() != null) task.setCompleted(req.getIsCompleted());

        return taskRepository.save(task);
    }

    @Override
    public void delete(Integer id, Integer userId) throws AppException {
        Task task = findById(id, userId);
        task.setStatus("DEL");
        taskRepository.save(task);
    }

    @Override
    public Task toggleComplete(Integer id, boolean isCompleted, Integer userId) throws AppException {
        Task task = findById(id, userId);
        task.setCompleted(isCompleted);
        return taskRepository.save(task);
    }
}