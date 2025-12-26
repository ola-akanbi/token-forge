;; TokenForge - Enhanced Trading Contract
;; A comprehensive token trading platform with advanced features

;; ============================================================
;; CONSTANTS & ERRORS
;; ============================================================
(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_INSUFFICIENT_BALANCE (err u1))
(define-constant ERR_INVALID_AMOUNT (err u2))
(define-constant ERR_UNAUTHORIZED (err u3))
(define-constant ERR_TRADING_PAUSED (err u4))
(define-constant ERR_TRANSFER_FAILED (err u5))
(define-constant ERR_INVALID_RECIPIENT (err u6))
(define-constant ERR_PRICE_TOO_LOW (err u7))

;; ============================================================
;; DATA VARIABLES
;; ============================================================
(define-data-var total-supply uint u0)
(define-data-var trading-paused bool false)
(define-data-var token-price uint u100) ;; Price per token in microSTX
(define-data-var minimum-trade uint u1) ;; Minimum trade amount
(define-data-var maximum-trade uint u1000000) ;; Maximum trade amount
(define-data-var total-transactions uint u0)

;; ============================================================
;; DATA MAPS
;; ============================================================

;; Store user balances
(define-map balances 
    principal 
    uint
)

;; Track user transaction history count
(define-map user-transaction-count
    principal
    uint
)