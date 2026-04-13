package com.rideapp.dezole.security;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

@Component
public class RateLimitFilter implements Filter {

    private static final int MAX_REQUESTS_PER_MINUTE = 60;
    private static final int MAX_REQUESTS_PER_SECOND = 10;
    private static final int LOGIN_MAX_ATTEMPTS = 5;
    private static final int LOGIN_LOCKOUT_MINUTES = 15;

    private final Map<String, AtomicInteger> requestCounts = new ConcurrentHashMap<>();
    private final Map<String, AtomicInteger> loginAttempts = new ConcurrentHashMap<>();
    private final Map<String, Long> lockedAccounts = new ConcurrentHashMap<>();

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String clientIP = getClientIP(httpRequest);
        String endpoint = httpRequest.getRequestURI();

        if (isAccountLocked(clientIP)) {
            httpResponse.setStatus(429);
            httpResponse.setContentType("application/json");
            httpResponse.getWriter().write("{\"success\":false,\"message\":\"Too many login attempts. Try again later.\"}");
            return;
        }

        if (!checkRateLimit(clientIP, endpoint)) {
            httpResponse.setStatus(429);
            httpResponse.setContentType("application/json");
            httpResponse.getWriter().write("{\"success\":false,\"message\":\"Rate limit exceeded\"}");
            return;
        }

        if (endpoint.contains("/login") || endpoint.contains("/auth/")) {
            handleLoginAttempt(clientIP, httpRequest);
        }

        chain.doFilter(request, response);
    }

    private boolean checkRateLimit(String clientIP, String endpoint) {
        String key = clientIP + ":" + endpoint;
        
        requestCounts.computeIfAbsent(key, k -> new AtomicInteger(0));
        AtomicInteger count = requestCounts.get(key);
        
        int currentCount = count.incrementAndGet();
        
        if (currentCount > MAX_REQUESTS_PER_MINUTE) {
            return false;
        }
        
        return true;
    }

    private void handleLoginAttempt(String clientIP, HttpServletRequest request) {
        String email = request.getParameter("email");
        if (email != null) {
            String key = clientIP + ":" + email;
            
            loginAttempts.computeIfAbsent(key, k -> new AtomicInteger(0));
            AtomicInteger attempts = loginAttempts.get(key);
            
            int currentAttempts = attempts.incrementAndGet();
            
            if (currentAttempts > LOGIN_MAX_ATTEMPTS) {
                lockedAccounts.put(clientIP, System.currentTimeMillis() + (LOGIN_LOCKOUT_MINUTES * 60 * 1000));
            }
        }
    }

    private boolean isAccountLocked(String clientIP) {
        Long lockTime = lockedAccounts.get(clientIP);
        if (lockTime == null) {
            return false;
        }
        
        if (System.currentTimeMillis() > lockTime) {
            lockedAccounts.remove(clientIP);
            loginAttempts.remove(clientIP);
            requestCounts.remove(clientIP);
            return false;
        }
        
        return true;
    }

    private String getClientIP(HttpServletRequest request) {
        String xForwardedFor = request.getHeader("X-Forwarded-For");
        if (xForwardedFor != null && !xForwardedFor.isEmpty()) {
            return xForwardedFor.split(",")[0].trim();
        }
        return request.getRemoteAddr();
    }
}