package com.dinsaren.springbootjwtapi.models.req;

import com.dinsaren.springbootjwtapi.models.Task;
import lombok.Data;

import java.util.Date;

@Data
public class TaskCreateReq {
    private String title;
    private String description;
    private Task.Priority priority;
    private String category;
    private Date deadline;
}