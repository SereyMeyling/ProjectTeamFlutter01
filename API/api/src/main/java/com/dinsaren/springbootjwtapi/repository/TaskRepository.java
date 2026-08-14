package com.dinsaren.springbootjwtapi.repository;

import com.dinsaren.springbootjwtapi.models.Task;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface TaskRepository extends JpaRepository<Task, Integer> {

    Page<Task> findAllByStatusAndUser_IdOrderByIdDesc(String status, Integer userId, Pageable pageable);

    Optional<Task> findByIdAndUser_IdAndStatus(Integer id, Integer userId, String status);

    Optional<Task> findByIdAndUser_Id(Integer id, Integer userId);
}