package com.rideapp.dezole.repository;

import com.rideapp.dezole.model.entity.Favorite;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FavoriteRepository extends JpaRepository<Favorite, Long> {
    List<Favorite> findByUserIdOrderByCreatedAtDesc(String userId);
    List<Favorite> findByUserId(String userId);
}
