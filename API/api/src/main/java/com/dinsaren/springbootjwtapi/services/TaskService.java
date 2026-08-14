package com.dinsaren.springbootjwtapi.services;

import com.dinsaren.springbootjwtapi.exception.AppException;
import com.dinsaren.springbootjwtapi.models.Task;
import com.dinsaren.springbootjwtapi.models.req.TaskCreateReq;
import com.dinsaren.springbootjwtapi.models.req.TaskUpdateReq;
import com.dinsaren.springbootjwtapi.models.res.PageRes;

public interface TaskService {

    PageRes<Task> findAll(int page, int size, String status, Boolean isCompleted, Integer userId) throws AppException;

    Task findById(Integer id, Integer userId) throws AppException;

    Task create(TaskCreateReq req, Integer userId) throws AppException;

    Task update(Integer id, TaskUpdateReq req, Integer userId) throws AppException;

    void delete(Integer id, Integer userId) throws AppException;

    Task toggleComplete(Integer id, boolean isCompleted, Integer userId) throws AppException;
}