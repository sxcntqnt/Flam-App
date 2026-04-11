package com.rideapp.dezole.repository;

import com.rideapp.dezole.model.entity.Route;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RouteRepository extends JpaRepository<Route, Long> {
    List<Route> findByCityFromIgnoreCase(String cityFrom);
    List<Route> findByCityToIgnoreCase(String cityTo);
    List<Route> findByCityFromIgnoreCaseAndCityToIgnoreCase(String cityFrom, String cityTo);
    List<Route> findByRouteNameContainingIgnoreCase(String routeName);
}
