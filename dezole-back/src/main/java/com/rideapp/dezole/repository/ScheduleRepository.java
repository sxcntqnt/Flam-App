package com.rideapp.dezole.repository;

import com.rideapp.dezole.model.entity.Schedule;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ScheduleRepository extends JpaRepository<Schedule, Long> {
    List<Schedule> findByBusId(Long busId);
    List<Schedule> findByRouteId(Long routeId);
    List<Schedule> findByActiveTrue();
    List<Schedule> findByRouteIdAndActiveTrue(Long routeId);
}
