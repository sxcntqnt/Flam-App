package com.rideapp.dezole.controller;

import com.rideapp.dezole.model.entity.Geofence;
import com.rideapp.dezole.service.GeofenceService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/geofences")
@RequiredArgsConstructor
public class GeofenceController {

    private final GeofenceService geofenceService;

    @GetMapping
    public ResponseEntity<List<Geofence>> getAllGeofences() {
        return ResponseEntity.ok(geofenceService.getAllGeofences());
    }

    @PostMapping
    public ResponseEntity<Geofence> createGeofence(@RequestBody Geofence geofence) {
        return ResponseEntity.ok(geofenceService.createGeofence(geofence));
    }

    @PutMapping("/{id}")
    public ResponseEntity<Geofence> updateGeofence(@PathVariable Long id, @RequestBody Geofence geofence) {
        return ResponseEntity.ok(geofenceService.updateGeofence(id, geofence));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteGeofence(@PathVariable Long id) {
        geofenceService.deleteGeofence(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/active")
    public ResponseEntity<List<Geofence>> getActiveGeofences() {
        return ResponseEntity.ok(geofenceService.getActiveGeofences());
    }
}
