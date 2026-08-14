package com.dinsaren.springbootjwtapi.models;

import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;
import org.hibernate.annotations.DynamicUpdate;

import java.util.Date;

@EqualsAndHashCode(callSuper = false)
@Entity
@Table(name = "tasks")
@DynamicUpdate
@Data
public class Task extends BaseEntity {
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    private String title;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Enumerated(EnumType.STRING)
    private Priority priority = Priority.MEDIUM;

    private String category;

    @Temporal(TemporalType.TIMESTAMP)
    private Date deadline;

    @Column(name = "is_completed")
    private boolean isCompleted = false;

    // ACT | DEL — mirrors Post's soft-delete convention
    private String status;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    public enum Priority {
        LOW, MEDIUM, HIGH
    }
}