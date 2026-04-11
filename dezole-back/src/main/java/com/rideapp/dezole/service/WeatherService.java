package com.rideapp.dezole.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class WeatherService {

    public Map<String, Object> getWeather(Double lat, Double lng) {
        Map<String, Object> weather = new HashMap<>();
        weather.put("temperature", 24.5);
        weather.put("condition", "Partly Cloudy");
        weather.put("humidity", 65);
        weather.put("windSpeed", 12.0);
        weather.put("location", "Nairobi, Kenya");
        weather.put("lat", lat);
        weather.put("lng", lng);
        return weather;
    }
}
