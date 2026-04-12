package com.rideapp.dezole.repository;

import com.rideapp.dezole.model.entity.Organization;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface OrganizationRepository extends JpaRepository<Organization, String> {
    Optional<Organization> findByAdminId(String adminId);
    List<Organization> findByIsActiveTrue();
    Optional<Organization> findByName(String name);
}