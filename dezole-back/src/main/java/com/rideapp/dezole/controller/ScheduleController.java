package com.rideapp.dezole.controller;

import com.rideapp.dezole.model.entity.Schedule;
import com.rideapp.dezole.service.ScheduleService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/schedules")
@RequiredArgsConstructor
public class ScheduleController {

    private final ScheduleService scheduleService;

    @GetMapping
    public ResponseEntity<List<Schedule>> getAllSchedules() {
        return ResponseEntity.ok(scheduleService.getActiveSchedules());
    }

    @PostMapping
    public ResponseEntity<Schedule> createSchedule(@RequestBody Schedule schedule) {
        return ResponseEntity.status(HttpStatus.CREATED).body(scheduleService.createSchedule(schedule));
    }

    @GetMapping("/route/{routeId}")
    public ResponseEntity<List<Schedule>> getSchedulesByRoute(@PathVariable Long routeId) {
        return ResponseEntity.ok(scheduleService.getSchedulesByRoute(routeId));
    }

    @GetMapping("/bus/{busId}")
    public ResponseEntity<List<Schedule>> getSchedulesByBus(@PathVariable Long busId) {
        return ResponseEntity.ok(scheduleService.getSchedulesByBus(busId));
    }
}