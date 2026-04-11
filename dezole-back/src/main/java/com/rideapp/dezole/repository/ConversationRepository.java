package com.rideapp.dezole.repository;

import com.rideapp.dezole.model.entity.Conversation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ConversationRepository extends JpaRepository<Conversation, Long> {
    @Query("SELECT c FROM Conversation c WHERE (c.user1.id = :userId OR c.user2.id = :userId)")
    List<Conversation> findByUserId(@Param("userId") String userId);

    @Query("SELECT c FROM Conversation c WHERE (c.user1.id = :user1 AND c.user2.id = :user2) OR (c.user1.id = :user2 AND c.user2.id = :user1)")
    Optional<Conversation> findByUsers(@Param("user1") String user1Id, @Param("user2") String user2Id);
}
