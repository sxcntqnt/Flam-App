package com.rideapp.dezole.service;

import com.rideapp.dezole.model.entity.Favorite;
import com.rideapp.dezole.model.entity.User;
import com.rideapp.dezole.repository.FavoriteRepository;
import com.rideapp.dezole.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class FavoriteService {

    private final FavoriteRepository favoriteRepository;
    private final UserRepository userRepository;

    @Transactional
    public Favorite addFavorite(String userId, Favorite favorite) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        
        favorite.setUser(user);
        
        return favoriteRepository.save(favorite);
    }

    public List<Favorite> getUserFavorites(String userId) {
        return favoriteRepository.findByUserId(userId);
    }

    @Transactional
    public void deleteFavorite(Long id) {
        favoriteRepository.deleteById(id);
    }
}