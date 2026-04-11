package com.rideapp.dezole.service;

import com.rideapp.dezole.model.entity.Schedule;
import com.rideapp.dezole.repository.ScheduleRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ScheduleService {

    private final ScheduleRepository scheduleRepository;

    @Transactional
    public Schedule createSchedule(Schedule schedule) {
        return scheduleRepository.save(schedule);
    }

    public List<Schedule> getSchedulesByRoute(Long routeId) {
        return scheduleRepository.findByRouteId(routeId);
    }

    public List<Schedule> getSchedulesByBus(Long busId) {
        return scheduleRepository.findByBusId(busId);
    }

    public List<Schedule> getActiveSchedules() {
        return scheduleRepository.findByActive(true);
    }
}