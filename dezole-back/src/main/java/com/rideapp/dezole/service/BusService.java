package com.rideapp.dezole.service;

import com.rideapp.dezole.model.entity.Bus;
import com.rideapp.dezole.repository.BusRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class BusService {

    private final BusRepository busRepository;

    @Transactional
    public Bus createBus(Bus bus) {
        return busRepository.save(bus);
    }

    public List<Bus> getAllBuses() {
        return busRepository.findAll();
    }

    public Bus getBusById(Long id) {
        return busRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Bus not found"));
    }

    @Transactional
    public Bus updateBus(Long id, Bus bus) {
        Bus existingBus = busRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Bus not found"));

        existingBus.setBusName(bus.getBusName());
        existingBus.setBusNumber(bus.getBusNumber());
        existingBus.setBusType(bus.getBusType());
        existingBus.setTotalSeats(bus.getTotalSeats());
        existingBus.setSeatLayout(bus.getSeatLayout());
        existingBus.setImageUrl(bus.getImageUrl());

        return busRepository.save(existingBus);
    }
}