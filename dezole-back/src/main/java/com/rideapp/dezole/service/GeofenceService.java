package com.rideapp.dezole.service;

import com.rideapp.dezole.exception.ResourceNotFoundException;
import com.rideapp.dezole.model.entity.Geofence;
import com.rideapp.dezole.repository.GeofenceRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class GeofenceService {

    private final GeofenceRepository geofenceRepository;

    public List<Geofence> getAllGeofences() {
        return geofenceRepository.findAll();
    }

    @Transactional
    public Geofence createGeofence(Geofence geofence) {
        return geofenceRepository.save(geofence);
    }

    @Transactional
    public Geofence updateGeofence(Long id, Geofence geofence) {
        Geofence existing = geofenceRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Geofence not found"));

        existing.setName(geofence.getName());
        existing.setDescription(geofence.getDescription());
        existing.setLatitude(geofence.getLatitude());
        existing.setLongitude(geofence.getLongitude());
        existing.setRadius(geofence.getRadius());
        existing.setActive(geofence.isActive());
        existing.setVehicleCount(geofence.getVehicleCount());

        return geofenceRepository.save(existing);
    }

    public List<Geofence> getActiveGeofences() {
        return geofenceRepository.findByActiveTrue();
    }

    @Transactional
    public void deleteGeofence(Long id) {
        Geofence geofence = geofenceRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Geofence not found"));
        geofenceRepository.delete(geofence);
    }
}
