package com.rideapp.dezole.service;

import com.rideapp.dezole.model.entity.Route;
import com.rideapp.dezole.repository.RouteRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class RouteService {

    private final RouteRepository routeRepository;

    @Transactional
    public Route createRoute(Route route) {
        return routeRepository.save(route);
    }

    public List<Route> getAllRoutes() {
        return routeRepository.findAll();
    }

    public List<Route> searchRoutes(String cityFrom, String cityTo) {
        return routeRepository.findByCityFromAndCityTo(cityFrom, cityTo);
    }
}